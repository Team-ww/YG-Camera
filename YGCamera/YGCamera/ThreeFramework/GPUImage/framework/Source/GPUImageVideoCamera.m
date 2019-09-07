#import "GPUImageVideoCamera.h"
#import "GPUImageMovieWriter.h"
#import "GPUImageFilter.h"

// Color Conversion Constants (YUV to RGB) including adjustment from 16-235/16-240 (video range)

// BT.601, which is the standard for SDTV.
const GLfloat kColorConversion601[] = {
    1.164,  1.164, 1.164,
    0.0, -0.392, 2.017,
    1.596, -0.813,   0.0,
};

// BT.709, which is the standard for HDTV.
const GLfloat kColorConversion709[] = {
    1.164,  1.164, 1.164,
    0.0, -0.213, 2.112,
    1.793, -0.533,   0.0,
};

// BT.601 full range (ref: http://www.equasys.de/colorconversion.html)
const GLfloat kColorConversion601FullRange[] = {
    1.0,    1.0,    1.0,
    0.0,    -0.343, 1.765,
    1.4,    -0.711, 0.0,
};

NSString *const kGPUImageYUVVideoRangeConversionForRGFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).rg - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1);
 }
 );

NSString *const kGPUImageYUVFullRangeConversionForLAFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ra - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1);
 }
 );

NSString *const kGPUImageYUVVideoRangeConversionForLAFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r - (16.0/255.0);
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ra - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1);
 }
 );


#pragma mark -
#pragma mark Private methods and instance variables

@interface GPUImageVideoCamera () 
{
	AVCaptureDeviceInput *audioInput;
	AVCaptureAudioDataOutput *audioOutput;
    NSDate *startingCaptureTime;
	
    dispatch_queue_t cameraProcessingQueue, audioProcessingQueue;
    
    GLProgram *yuvConversionProgram;
    GLint yuvConversionPositionAttribute, yuvConversionTextureCoordinateAttribute;
    GLint yuvConversionLuminanceTextureUniform, yuvConversionChrominanceTextureUniform;
    GLint yuvConversionMatrixUniform;
    const GLfloat *_preferredConversion;
    
    BOOL isFullYUVRange;
    
    int imageBufferWidth, imageBufferHeight;
    
    BOOL addedAudioInputsDueToEncodingTarget;
    
    NSInteger countDownTime;
    
    AVCaptureDeviceFormat *_defaultFormat;
    CMTime  _defaultMinFrameDuration;
    CMTime  _defaultMaxFrameDuration;
}

- (void)updateOrientationSendToTargets;
- (void)convertYUVToRGBOutput;

@end

@implementation GPUImageVideoCamera

@synthesize captureSessionPreset = _captureSessionPreset;
@synthesize captureSession = _captureSession;
@synthesize inputCamera = _inputCamera;
@synthesize runBenchmark = _runBenchmark;
@synthesize outputImageOrientation = _outputImageOrientation;
@synthesize delegate = _delegate;
@synthesize horizontallyMirrorFrontFacingCamera = _horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera = _horizontallyMirrorRearFacingCamera;
@synthesize frameRate = _frameRate;

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [self initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack]))
    {
		return nil;
    }
    
    return self;
}

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition; 
{
	if (!(self = [super init]))
    {
		return nil;
    }
    
    cameraProcessingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
	audioProcessingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0);

    frameRenderingSemaphore = dispatch_semaphore_create(1);

	_frameRate = 0; // This will not set frame rate unless this value gets set to 1 or above
    _runBenchmark = NO;
    capturePaused = NO;
    outputRotation = kGPUImageNoRotation;
    internalRotation = kGPUImageNoRotation;
    //captureAsYUV = YES;
    captureAsYUV = NO;
    _preferredConversion = kColorConversion709;
    
	// Grab the back-facing or front-facing camera
    _inputCamera = nil;
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) 
	{
		if ([device position] == cameraPosition)
		{
			_inputCamera = device;
		}
	}
    
    if (!_inputCamera) {
        return nil;
    }
    
	// Create the capture session
	_captureSession = [[AVCaptureSession alloc] init];
	
    [_captureSession beginConfiguration];
    
	// Add the video input	
	NSError *error = nil;
	videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_inputCamera error:&error];
	if ([_captureSession canAddInput:videoInput]) 
	{
		[_captureSession addInput:videoInput];
	}
	
	// Add the video frame output	
	videoOutput = [[AVCaptureVideoDataOutput alloc] init];
	[videoOutput setAlwaysDiscardsLateVideoFrames:NO];
    
//    if (captureAsYUV && [GPUImageContext deviceSupportsRedTextures])
    if (captureAsYUV && [GPUImageContext supportsFastTextureUpload])
    {
        BOOL supportsFullYUVRange = NO;
        NSArray *supportedPixelFormats = videoOutput.availableVideoCVPixelFormatTypes;
        for (NSNumber *currentPixelFormat in supportedPixelFormats)
        {
            if ([currentPixelFormat intValue] == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            {
                supportsFullYUVRange = YES;
            }
        }
        
        if (supportsFullYUVRange)
        {
            [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
            isFullYUVRange = YES;
        }
        else
        {
            [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
            isFullYUVRange = NO;
        }
    }
    else
    {
        [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    }
    
    runSynchronouslyOnVideoProcessingQueue(^{
        
        if (captureAsYUV)
        {
            [GPUImageContext useImageProcessingContext];
            //            if ([GPUImageContext deviceSupportsRedTextures])
            //            {
            //                yuvConversionProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImageYUVVideoRangeConversionForRGFragmentShaderString];
            //            }
            //            else
            //            {
            if (isFullYUVRange)
            {
                yuvConversionProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImageYUVFullRangeConversionForLAFragmentShaderString];
            }
            else
            {
                yuvConversionProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImageYUVVideoRangeConversionForLAFragmentShaderString];
            }

            //            }
            
            if (!yuvConversionProgram.initialized)
            {
                [yuvConversionProgram addAttribute:@"position"];
                [yuvConversionProgram addAttribute:@"inputTextureCoordinate"];
                
                if (![yuvConversionProgram link])
                {
                    NSString *progLog = [yuvConversionProgram programLog];
                    NSLog(@"Program link log: %@", progLog);
                    NSString *fragLog = [yuvConversionProgram fragmentShaderLog];
                    NSLog(@"Fragment shader compile log: %@", fragLog);
                    NSString *vertLog = [yuvConversionProgram vertexShaderLog];
                    NSLog(@"Vertex shader compile log: %@", vertLog);
                    yuvConversionProgram = nil;
                    NSAssert(NO, @"Filter shader link failed");
                }
            }
            
            yuvConversionPositionAttribute = [yuvConversionProgram attributeIndex:@"position"];
            yuvConversionTextureCoordinateAttribute = [yuvConversionProgram attributeIndex:@"inputTextureCoordinate"];
            yuvConversionLuminanceTextureUniform = [yuvConversionProgram uniformIndex:@"luminanceTexture"];
            yuvConversionChrominanceTextureUniform = [yuvConversionProgram uniformIndex:@"chrominanceTexture"];
            yuvConversionMatrixUniform = [yuvConversionProgram uniformIndex:@"colorConversionMatrix"];
            
            [GPUImageContext setActiveShaderProgram:yuvConversionProgram];
            
            glEnableVertexAttribArray(yuvConversionPositionAttribute);
            glEnableVertexAttribArray(yuvConversionTextureCoordinateAttribute);
        }
    });
    
    [videoOutput setSampleBufferDelegate:self queue:cameraProcessingQueue];
	if ([_captureSession canAddOutput:videoOutput])
	{
		[_captureSession addOutput:videoOutput];
	}
	else
	{
		NSLog(@"Couldn't add video output");
        return nil;
	}
    
	_captureSessionPreset = sessionPreset;
    [_captureSession setSessionPreset:_captureSessionPreset];

// This will let you get 60 FPS video from the 720p preset on an iPhone 4S, but only that device and that preset
//    AVCaptureConnection *conn = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
//    
//    if (conn.supportsVideoMinFrameDuration)
//        conn.videoMinFrameDuration = CMTimeMake(1,60);
//    if (conn.supportsVideoMaxFrameDuration)
//        conn.videoMaxFrameDuration = CMTimeMake(1,60);
    
    [_captureSession commitConfiguration];
    AVCaptureDevice * captureDevice =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    _defaultFormat = captureDevice.activeFormat;
    _defaultMinFrameDuration = captureDevice.activeVideoMinFrameDuration;
    _defaultMaxFrameDuration = captureDevice.activeVideoMaxFrameDuration;
    countDownTime = 0;
	return self;
}

- (GPUImageFramebuffer *)framebufferForOutput;
{
    return outputFramebuffer;
}

- (void)dealloc 
{
    [self stopCameraCapture];
    [videoOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
    [audioOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
    
    [self removeInputsAndOutputs];
    
// ARC forbids explicit message send of 'release'; since iOS 6 even for dispatch_release() calls: stripping it out in that case is required.
#if !OS_OBJECT_USE_OBJC
    if (frameRenderingSemaphore != NULL)
    {
        dispatch_release(frameRenderingSemaphore);
    }
#endif
}

- (BOOL)addAudioInputsAndOutputs
{
    if (audioOutput)
        return NO;
    
    [_captureSession beginConfiguration];
    
    _microphone = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    audioInput = [AVCaptureDeviceInput deviceInputWithDevice:_microphone error:nil];
    if ([_captureSession canAddInput:audioInput])
    {
        [_captureSession addInput:audioInput];
    }
    audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    
    if ([_captureSession canAddOutput:audioOutput])
    {
        [_captureSession addOutput:audioOutput];
    }
    else
    {
        NSLog(@"Couldn't add audio output");
    }
    [audioOutput setSampleBufferDelegate:self queue:audioProcessingQueue];
    
    [_captureSession commitConfiguration];
    return YES;
}

- (BOOL)removeAudioInputsAndOutputs
{
    if (!audioOutput)
        return NO;
    
    [_captureSession beginConfiguration];
    [_captureSession removeInput:audioInput];
    [_captureSession removeOutput:audioOutput];
    audioInput = nil;
    audioOutput = nil;
    _microphone = nil;
    [_captureSession commitConfiguration];
    return YES;
}

- (void)removeInputsAndOutputs;
{
    [_captureSession beginConfiguration];
    if (videoInput) {
        [_captureSession removeInput:videoInput];
        [_captureSession removeOutput:videoOutput];
        videoInput = nil;
        videoOutput = nil;
    }
    if (_microphone != nil)
    {
        [_captureSession removeInput:audioInput];
        [_captureSession removeOutput:audioOutput];
        audioInput = nil;
        audioOutput = nil;
        _microphone = nil;
    }
    [_captureSession commitConfiguration];
}

#pragma mark -
#pragma mark Managing targets

- (void)addTarget:(id<GPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;
{
    [super addTarget:newTarget atTextureLocation:textureLocation];
    
    [newTarget setInputRotation:outputRotation atIndex:textureLocation];
}

#pragma mark -
#pragma mark Manage the camera video stream

- (void)startCameraCapture;
{
    if (![_captureSession isRunning])
	{
        startingCaptureTime = [NSDate date];
		[_captureSession startRunning];
	};
}

- (void)stopCameraCapture;
{
    if ([_captureSession isRunning])
    {
        [_captureSession stopRunning];
    }
}

- (void)pauseCameraCapture;
{
    capturePaused = YES;
}

- (void)resumeCameraCapture;
{
    capturePaused = NO;
}

- (void)switchCameras
{
	if (self.frontFacingCameraPresent == NO)
		return;
	
    NSError *error;
    AVCaptureDeviceInput *newVideoInput;
    AVCaptureDevicePosition currentCameraPosition = [[videoInput device] position];
    
    if (currentCameraPosition == AVCaptureDevicePositionBack)
    {
        currentCameraPosition = AVCaptureDevicePositionFront;
    }
    else
    {
        currentCameraPosition = AVCaptureDevicePositionBack;
    }
    
    AVCaptureDevice *backFacingCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) 
	{
		if ([device position] == currentCameraPosition)
		{
			backFacingCamera = device;
		}
	}
    newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:&error];
    
    if (newVideoInput != nil)
    {
        [_captureSession beginConfiguration];
        
        [_captureSession removeInput:videoInput];
        if ([_captureSession canAddInput:newVideoInput])
        {
            [_captureSession addInput:newVideoInput];
            videoInput = newVideoInput;
        }
        else
        {
            [_captureSession addInput:videoInput];
        }
        //captureSession.sessionPreset = oriPreset;
        [_captureSession commitConfiguration];
    }
    
    _inputCamera = backFacingCamera;
    [self setOutputImageOrientation:_outputImageOrientation];
}

- (AVCaptureDevicePosition)cameraPosition 
{
    return [[videoInput device] position];
}

+ (BOOL)isBackFacingCameraPresent;
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == AVCaptureDevicePositionBack)
			return YES;
	}
	
	return NO;
}

- (BOOL)isBackFacingCameraPresent
{
    return [GPUImageVideoCamera isBackFacingCameraPresent];
}

+ (BOOL)isFrontFacingCameraPresent;
{
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == AVCaptureDevicePositionFront)
			return YES;
	}
	
	return NO;
}

- (BOOL)isFrontFacingCameraPresent
{
    return [GPUImageVideoCamera isFrontFacingCameraPresent];
}

- (void)setCaptureSessionPreset:(NSString *)captureSessionPreset;
{
	[_captureSession beginConfiguration];
	
	_captureSessionPreset = captureSessionPreset;
	[_captureSession setSessionPreset:_captureSessionPreset];
	
	[_captureSession commitConfiguration];
}

- (void)setFrameRate:(int32_t)frameRate;
{
	_frameRate = frameRate;
	
	if (_frameRate > 0)
	{
		if ([_inputCamera respondsToSelector:@selector(setActiveVideoMinFrameDuration:)] &&
            [_inputCamera respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)]) {
            
            NSError *error;
            [_inputCamera lockForConfiguration:&error];
            if (error == nil) {
#if defined(__IPHONE_7_0)
                [_inputCamera setActiveVideoMinFrameDuration:CMTimeMake(1, _frameRate)];
                [_inputCamera setActiveVideoMaxFrameDuration:CMTimeMake(1, _frameRate)];
#endif
            }
            [_inputCamera unlockForConfiguration];
            
        } else {
            
            for (AVCaptureConnection *connection in videoOutput.connections)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                if ([connection respondsToSelector:@selector(setVideoMinFrameDuration:)])
                    connection.videoMinFrameDuration = CMTimeMake(1, _frameRate);
                
                if ([connection respondsToSelector:@selector(setVideoMaxFrameDuration:)])
                    connection.videoMaxFrameDuration = CMTimeMake(1, _frameRate);
#pragma clang diagnostic pop
            }
        }
        
	}
	else
	{
		if ([_inputCamera respondsToSelector:@selector(setActiveVideoMinFrameDuration:)] &&
            [_inputCamera respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)]) {
            
            NSError *error;
            [_inputCamera lockForConfiguration:&error];
            if (error == nil) {
#if defined(__IPHONE_7_0)
                [_inputCamera setActiveVideoMinFrameDuration:kCMTimeInvalid];
                [_inputCamera setActiveVideoMaxFrameDuration:kCMTimeInvalid];
#endif
            }
            [_inputCamera unlockForConfiguration];
            
        } else {
            
            for (AVCaptureConnection *connection in videoOutput.connections)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                if ([connection respondsToSelector:@selector(setVideoMinFrameDuration:)])
                    connection.videoMinFrameDuration = kCMTimeInvalid; // This sets videoMinFrameDuration back to default
                
                if ([connection respondsToSelector:@selector(setVideoMaxFrameDuration:)])
                    connection.videoMaxFrameDuration = kCMTimeInvalid; // This sets videoMaxFrameDuration back to default
#pragma clang diagnostic pop
            }
        }
        
	}
}

- (int32_t)frameRate;
{
	return _frameRate;
}

- (AVCaptureConnection *)videoCaptureConnection {
    for (AVCaptureConnection *connection in [videoOutput connections] ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
				return connection;
			}
		}
	}
    
    return nil;
}

#define INITIALFRAMESTOIGNOREFORBENCHMARK 5

- (void)updateTargetsForVideoCameraUsingCacheTextureAtWidth:(int)bufferWidth height:(int)bufferHeight time:(CMTime)currentTime;
{
    // First, update all the framebuffers in the targets
    for (id<GPUImageInput> currentTarget in targets)
    {
        if ([currentTarget enabled])
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            if (currentTarget != self.targetToIgnoreForUpdates)
            {
                [currentTarget setInputRotation:outputRotation atIndex:textureIndexOfTarget];
                [currentTarget setInputSize:CGSizeMake(bufferWidth, bufferHeight) atIndex:textureIndexOfTarget];
                
                if ([currentTarget wantsMonochromeInput] && captureAsYUV)
                {
                    [currentTarget setCurrentlyReceivingMonochromeInput:YES];
                    // TODO: Replace optimization for monochrome output
                    [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
                }
                else
                {
                    [currentTarget setCurrentlyReceivingMonochromeInput:NO];
                    [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
                }
            }
            else
            {
                [currentTarget setInputRotation:outputRotation atIndex:textureIndexOfTarget];
                [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
            }
        }
    }
    
    // Then release our hold on the local framebuffer to send it back to the cache as soon as it's no longer needed
    [outputFramebuffer unlock];
    outputFramebuffer = nil;
    
    // Finally, trigger rendering as needed
    for (id<GPUImageInput> currentTarget in targets)
    {
        if ([currentTarget enabled])
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            if (currentTarget != self.targetToIgnoreForUpdates)
            {
                [currentTarget newFrameReadyAtTime:currentTime atIndex:textureIndexOfTarget];
            }
        }
    }
}

- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
{
    //陈华
    if (capturePaused)
    {
        return;
    }
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CVImageBufferRef cameraFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
    int bufferWidth = (int) CVPixelBufferGetWidth(cameraFrame);
    int bufferHeight = (int) CVPixelBufferGetHeight(cameraFrame);
    CFTypeRef colorAttachments = CVBufferGetAttachment(cameraFrame, kCVImageBufferYCbCrMatrixKey, NULL);
    if (colorAttachments != NULL)
    {
        if(CFStringCompare(colorAttachments, kCVImageBufferYCbCrMatrix_ITU_R_601_4, 0) == kCFCompareEqualTo)
        {
            if (isFullYUVRange)
            {
                _preferredConversion = kColorConversion601FullRange;
            }
            else
            {
                _preferredConversion = kColorConversion601;
            }
        }
        else
        {
            _preferredConversion = kColorConversion709;
        }
    }
    else
    {
        if (isFullYUVRange)
        {
            _preferredConversion = kColorConversion601FullRange;
        }
        else
        {
            _preferredConversion = kColorConversion601;
        }
    }

	CMTime currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

    [GPUImageContext useImageProcessingContext];

    if ([GPUImageContext supportsFastTextureUpload] && captureAsYUV)
    {
        CVOpenGLESTextureRef luminanceTextureRef = NULL;
        CVOpenGLESTextureRef chrominanceTextureRef = NULL;

//        if (captureAsYUV && [GPUImageContext deviceSupportsRedTextures])
        if (CVPixelBufferGetPlaneCount(cameraFrame) > 0) // Check for YUV planar inputs to do RGB conversion
        {
            CVPixelBufferLockBaseAddress(cameraFrame, 0);
            
            if ( (imageBufferWidth != bufferWidth) && (imageBufferHeight != bufferHeight) )
            {
                imageBufferWidth = bufferWidth;
                imageBufferHeight = bufferHeight;
            }
            
            CVReturn err;
            // Y-plane
            glActiveTexture(GL_TEXTURE4);
            if ([GPUImageContext deviceSupportsRedTextures])
            {
//                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, coreVideoTextureCache, cameraFrame, NULL, GL_TEXTURE_2D, GL_RED_EXT, bufferWidth, bufferHeight, GL_RED_EXT, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext] coreVideoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE, bufferWidth, bufferHeight, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
            }
            else
            {
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext] coreVideoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE, bufferWidth, bufferHeight, GL_LUMINANCE, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
            }
            if (err)
            {
                NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
            }
            
            luminanceTexture = CVOpenGLESTextureGetName(luminanceTextureRef);
            glBindTexture(GL_TEXTURE_2D, luminanceTexture);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            
            // UV-plane
            glActiveTexture(GL_TEXTURE5);
            if ([GPUImageContext deviceSupportsRedTextures])
            {
//                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, coreVideoTextureCache, cameraFrame, NULL, GL_TEXTURE_2D, GL_RG_EXT, bufferWidth/2, bufferHeight/2, GL_RG_EXT, GL_UNSIGNED_BYTE, 1, &chrominanceTextureRef);
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext] coreVideoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, bufferWidth/2, bufferHeight/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &chrominanceTextureRef);
            }
            else
            {
                err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext] coreVideoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_LUMINANCE_ALPHA, bufferWidth/2, bufferHeight/2, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, 1, &chrominanceTextureRef);
            }
            if (err)
            {
                NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
            }
            
            chrominanceTexture = CVOpenGLESTextureGetName(chrominanceTextureRef);
            glBindTexture(GL_TEXTURE_2D, chrominanceTexture);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            
//            if (!allTargetsWantMonochromeData)
//            {
                [self convertYUVToRGBOutput];
//            }

            int rotatedImageBufferWidth = bufferWidth, rotatedImageBufferHeight = bufferHeight;
            
            if (GPUImageRotationSwapsWidthAndHeight(internalRotation))
            {
                rotatedImageBufferWidth = bufferHeight;
                rotatedImageBufferHeight = bufferWidth;
            }
            
            [self updateTargetsForVideoCameraUsingCacheTextureAtWidth:rotatedImageBufferWidth height:rotatedImageBufferHeight time:currentTime];
            
            CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
            CFRelease(luminanceTextureRef);
            CFRelease(chrominanceTextureRef);
        }
        else
        {
            // TODO: Mesh this with the output framebuffer structure
            
//            CVPixelBufferLockBaseAddress(cameraFrame, 0);
//            
//            CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext] coreVideoTextureCache], cameraFrame, NULL, GL_TEXTURE_2D, GL_RGBA, bufferWidth, bufferHeight, GL_BGRA, GL_UNSIGNED_BYTE, 0, &texture);
//            
//            if (!texture || err) {
//                NSLog(@"Camera CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);
//                NSAssert(NO, @"Camera failure");
//                return;
//            }
//            
//            outputTexture = CVOpenGLESTextureGetName(texture);
//            //        glBindTexture(CVOpenGLESTextureGetTarget(texture), outputTexture);
//            glBindTexture(GL_TEXTURE_2D, outputTexture);
//            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//            
//            [self updateTargetsForVideoCameraUsingCacheTextureAtWidth:bufferWidth height:bufferHeight time:currentTime];
//
//            CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
//            CFRelease(texture);
//
//            outputTexture = 0;
        }
        
        
        if (_runBenchmark)
        {
            numberOfFramesCaptured++;
            if (numberOfFramesCaptured > INITIALFRAMESTOIGNOREFORBENCHMARK)
            {
                CFAbsoluteTime currentFrameTime = (CFAbsoluteTimeGetCurrent() - startTime);
                totalFrameTimeDuringCapture += currentFrameTime;
                NSLog(@"Average frame time : %f ms", [self averageFrameDurationDuringCapture]);
                NSLog(@"Current frame time : %f ms", 1000.0 * currentFrameTime);
            }
        }
    }
    else
    {
        CVPixelBufferLockBaseAddress(cameraFrame, 0);
        
        int bytesPerRow = (int) CVPixelBufferGetBytesPerRow(cameraFrame);
        outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(bytesPerRow / 4, bufferHeight) onlyTexture:YES];
        [outputFramebuffer activateFramebuffer];

        glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
        
        //        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(cameraFrame));
        
        // Using BGRA extension to pull in video frame data directly
        // The use of bytesPerRow / 4 accounts for a display glitch present in preview video frames when using the photo preset on the camera
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bytesPerRow / 4, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(cameraFrame));
        
        [self updateTargetsForVideoCameraUsingCacheTextureAtWidth:bytesPerRow / 4 height:bufferHeight time:currentTime];
        
        CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
        
        if (_runBenchmark)
        {
            numberOfFramesCaptured++;
            if (numberOfFramesCaptured > INITIALFRAMESTOIGNOREFORBENCHMARK)
            {
                CFAbsoluteTime currentFrameTime = (CFAbsoluteTimeGetCurrent() - startTime);
                totalFrameTimeDuringCapture += currentFrameTime;
            }
        }
    }  
}

- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
{
    [self.audioEncodingTarget processAudioBuffer:sampleBuffer]; 
}

- (void)convertYUVToRGBOutput;
{
    [GPUImageContext setActiveShaderProgram:yuvConversionProgram];

    int rotatedImageBufferWidth = imageBufferWidth, rotatedImageBufferHeight = imageBufferHeight;

    if (GPUImageRotationSwapsWidthAndHeight(internalRotation))
    {
        rotatedImageBufferWidth = imageBufferHeight;
        rotatedImageBufferHeight = imageBufferWidth;
    }

    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(rotatedImageBufferWidth, rotatedImageBufferHeight) textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];

    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
	glActiveTexture(GL_TEXTURE4);
	glBindTexture(GL_TEXTURE_2D, luminanceTexture);
	glUniform1i(yuvConversionLuminanceTextureUniform, 4);

    glActiveTexture(GL_TEXTURE5);
	glBindTexture(GL_TEXTURE_2D, chrominanceTexture);
	glUniform1i(yuvConversionChrominanceTextureUniform, 5);

    glUniformMatrix3fv(yuvConversionMatrixUniform, 1, GL_FALSE, _preferredConversion);

    glVertexAttribPointer(yuvConversionPositionAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
	glVertexAttribPointer(yuvConversionTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, [GPUImageFilter textureCoordinatesForRotation:internalRotation]);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark -
#pragma mark Benchmarking

- (CGFloat)averageFrameDurationDuringCapture;
{
    return (totalFrameTimeDuringCapture / (CGFloat)(numberOfFramesCaptured - INITIALFRAMESTOIGNOREFORBENCHMARK)) * 1000.0;
}

- (void)resetBenchmarkAverage;
{
    numberOfFramesCaptured = 0;
    totalFrameTimeDuringCapture = 0.0;
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (!self.captureSession.isRunning)
    {
        return;
    }
    else if (captureOutput == audioOutput)
    {
        [self processAudioSampleBuffer:sampleBuffer];
    }
    else
    {
        if (dispatch_semaphore_wait(frameRenderingSemaphore, DISPATCH_TIME_NOW) != 0)
        {
            return;
        }

        CFRetain(sampleBuffer);
        runAsynchronouslyOnVideoProcessingQueue(^{
            //Feature Detection Hook.
            if (self.delegate)
            {
                [self.delegate willOutputSampleBuffer:sampleBuffer];
            }
            
            [self processVideoSampleBuffer:sampleBuffer];

            CFRelease(sampleBuffer);
            dispatch_semaphore_signal(frameRenderingSemaphore);
        });
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setAudioEncodingTarget:(GPUImageMovieWriter *)newValue;
{
    if (newValue) {
        /* Add audio inputs and outputs, if necessary */
        addedAudioInputsDueToEncodingTarget |= [self addAudioInputsAndOutputs];
    } else if (addedAudioInputsDueToEncodingTarget) {
        /* Remove audio inputs and outputs, if they were added by previously setting the audio encoding target */
        [self removeAudioInputsAndOutputs];
        addedAudioInputsDueToEncodingTarget = NO;
    }
    
    [super setAudioEncodingTarget:newValue];
}

- (void)updateOrientationSendToTargets;
{
    runSynchronouslyOnVideoProcessingQueue(^{
        
        //    From the iOS 5.0 release notes:
        //    In previous iOS versions, the front-facing camera would always deliver buffers in AVCaptureVideoOrientationLandscapeLeft and the back-facing camera would always deliver buffers in AVCaptureVideoOrientationLandscapeRight.
        
        if (captureAsYUV && [GPUImageContext supportsFastTextureUpload])
        {
            outputRotation = kGPUImageNoRotation;
            if ([self cameraPosition] == AVCaptureDevicePositionBack)
            {
                if (_horizontallyMirrorRearFacingCamera)
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:internalRotation = kGPUImageRotateRightFlipVertical; break;
                        case UIInterfaceOrientationPortraitUpsideDown:internalRotation = kGPUImageRotate180; break;
                        case UIInterfaceOrientationLandscapeLeft:internalRotation = kGPUImageFlipHorizonal; break;
                        case UIInterfaceOrientationLandscapeRight:internalRotation = kGPUImageFlipVertical; break;
                        default:internalRotation = kGPUImageNoRotation;
                    }
                }
                else
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:internalRotation = kGPUImageRotateRight; break;
                        case UIInterfaceOrientationPortraitUpsideDown:internalRotation = kGPUImageRotateLeft; break;
                        case UIInterfaceOrientationLandscapeLeft:internalRotation = kGPUImageRotate180; break;
                        case UIInterfaceOrientationLandscapeRight:internalRotation = kGPUImageNoRotation; break;
                        default:internalRotation = kGPUImageNoRotation;
                    }
                }
            }
            else
            {
                if (_horizontallyMirrorFrontFacingCamera)
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:internalRotation = kGPUImageRotateRightFlipVertical; break;
                        case UIInterfaceOrientationPortraitUpsideDown:internalRotation = kGPUImageRotateRightFlipHorizontal; break;
                        case UIInterfaceOrientationLandscapeLeft:internalRotation = kGPUImageFlipHorizonal; break;
                        case UIInterfaceOrientationLandscapeRight:internalRotation = kGPUImageFlipVertical; break;
                        default:internalRotation = kGPUImageNoRotation;
                   }
                }
                else
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:internalRotation = kGPUImageRotateRight; break;
                        case UIInterfaceOrientationPortraitUpsideDown:internalRotation = kGPUImageRotateLeft; break;
                        case UIInterfaceOrientationLandscapeLeft:internalRotation = kGPUImageNoRotation; break;
                        case UIInterfaceOrientationLandscapeRight:internalRotation = kGPUImageRotate180; break;
                        default:internalRotation = kGPUImageNoRotation;
                    }
                }
            }
        }
        else
        {
            if ([self cameraPosition] == AVCaptureDevicePositionBack)
            {
                if (_horizontallyMirrorRearFacingCamera)
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:outputRotation = kGPUImageRotateRightFlipVertical; break;
                        case UIInterfaceOrientationPortraitUpsideDown:outputRotation = kGPUImageRotate180; break;
                        case UIInterfaceOrientationLandscapeLeft:outputRotation = kGPUImageFlipHorizonal; break;
                        case UIInterfaceOrientationLandscapeRight:outputRotation = kGPUImageFlipVertical; break;
                        default:outputRotation = kGPUImageNoRotation;
                    }
                }
                else
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:outputRotation = kGPUImageRotateRight; break;
                        case UIInterfaceOrientationPortraitUpsideDown:outputRotation = kGPUImageRotateLeft; break;
                        case UIInterfaceOrientationLandscapeLeft:outputRotation = kGPUImageRotate180; break;
                        case UIInterfaceOrientationLandscapeRight:outputRotation = kGPUImageNoRotation; break;
                        default:outputRotation = kGPUImageNoRotation;
                    }
                }
            }
            else
            {
                if (_horizontallyMirrorFrontFacingCamera)
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:outputRotation = kGPUImageRotateRightFlipVertical; break;
                        case UIInterfaceOrientationPortraitUpsideDown:outputRotation = kGPUImageRotateRightFlipHorizontal; break;
                        case UIInterfaceOrientationLandscapeLeft:outputRotation = kGPUImageFlipHorizonal; break;
                        case UIInterfaceOrientationLandscapeRight:outputRotation = kGPUImageFlipVertical; break;
                        default:outputRotation = kGPUImageNoRotation;
                    }
                }
                else
                {
                    switch(_outputImageOrientation)
                    {
                        case UIInterfaceOrientationPortrait:outputRotation = kGPUImageRotateRight; break;
                        case UIInterfaceOrientationPortraitUpsideDown:outputRotation = kGPUImageRotateLeft; break;
                        case UIInterfaceOrientationLandscapeLeft:outputRotation = kGPUImageNoRotation; break;
                        case UIInterfaceOrientationLandscapeRight:outputRotation = kGPUImageRotate180; break;
                        default:outputRotation = kGPUImageNoRotation;
                    }
                }
            }
        }
        
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            [currentTarget setInputRotation:outputRotation atIndex:[[targetTextureIndices objectAtIndex:indexOfObject] integerValue]];
        }
    });
}

- (void)setOutputImageOrientation:(UIInterfaceOrientation)newValue;
{
    _outputImageOrientation = newValue;
    [self updateOrientationSendToTargets];
}

- (void)setHorizontallyMirrorFrontFacingCamera:(BOOL)newValue
{
    _horizontallyMirrorFrontFacingCamera = newValue;
    [self updateOrientationSendToTargets];
}

- (void)setHorizontallyMirrorRearFacingCamera:(BOOL)newValue
{
    _horizontallyMirrorRearFacingCamera = newValue;
    [self updateOrientationSendToTargets];
}


//闪光灯  打开 、关闭、自动
- (void)setFlashState:(AVCaptureFlashMode)flashMode{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.hasFlash && device.flashMode != flashMode) {
        
        [device lockForConfiguration:nil];
        [device setFlashMode:flashMode];
        [device unlockForConfiguration];
        
    }
}

//闪光灯状态
- (AVCaptureFlashMode)getDeviceFlashState{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (captureDevice.flashMode == AVCaptureFlashModeOn) {
        return 0;
    }else if (captureDevice.flashMode == AVCaptureFlashModeOff){
        return 1;
    }else if (captureDevice.flashMode == AVCaptureFlashModeAuto){
        return 2;
    }
    return captureDevice.flashMode;
}

//HDR 开启关闭
- (void)cameraBackgroundDidChangeHDR:(BOOL)HDR{
    
   AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        NSLog(@"automaticallyAdjustsVideoHDREnabled >>>>>==%d",captureDevice.automaticallyAdjustsVideoHDREnabled);
        captureDevice.automaticallyAdjustsVideoHDREnabled = HDR;
        [captureDevice unlockForConfiguration];
        
    }else{
        NSLog(@"22222222222");
        // Handle the error appropriately.
    }
}

//HDR 状态
- (BOOL)isHDROpen{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return captureDevice.automaticallyAdjustsVideoHDREnabled;
}


//调解焦距 0.0-1.0
- (void)cameraBackgroundDidChangeFocus:(CGFloat)focus{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            [captureDevice setFocusModeLockedWithLensPosition:focus completionHandler:nil];
    }else{
        // Handle the error appropriately.
    }
}

//当前焦距
- (CGFloat)getDeviceFocus{
    
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return captureDevice.lensPosition;
}

//数码变焦  1-3倍
- (void)cameraBackgroundDidChangeZoom:(CGFloat)zoom{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        captureDevice.videoZoomFactor = zoom;
        // [captureDevice rampToVideoZoomFactor:1.0 withRate:zoom];//50
        [captureDevice unlockForConfiguration];
    }else{
        // Handle the error appropriately.
    }
}


- (CGFloat)maxVideoZoomFactor{
    
   return [self activeDevice].activeFormat.videoMaxZoomFactor;
}

//数码变焦缩放级别
- (CGFloat)getDeviceZoom{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return captureDevice.videoZoomFactor;
}

//设置分辨率  帧率
- (void)cameraBackgroundDidChangeVideoQuality:(AVCaptureSessionPreset)videoQuality desiredFPS:(CGFloat)desiredFPS{
    
    [self.captureSession stopRunning];
    self.captureSession.sessionPreset = videoQuality;
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        for (AVFrameRateRange *range  in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.minFrameRate) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    if (selectedFormat) {
        
        if ([videoDevice lockForConfiguration:nil]) {
            NSLog(@"selected format:%@",selectedFormat);
            videoDevice.activeFormat = selectedFormat;
            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}

//分辨率
- (AVCaptureSessionPreset)getVideoQuality{
    return self.captureSession.sessionPreset;
}


//拍照定时   3s 5s 10s   做法倒计时
-(void)cameraBackgroundDidChangeCountDownTimer:(int)time{
    
    countDownTime = time;
}

//获取拍照延时时长
- (int)getCaptureDuration{
    if (countDownTime == 0) {
        return 0;
    }else if (countDownTime == 3){
        return 1;
    }else if (countDownTime == 5){
        return 2;
    }else if (countDownTime == 10){
        return 3;
    }
    return 0;
    //return countDownTime;
}

- (int)captureTime{
    return  countDownTime;
}


//EV  设置   -8.0 - 8.0 曝光补偿
- (void)cameraBackgroundDidChangeEV:(CGFloat)EV{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        //NSLog(@"EV >>>>>%f",EV);
        [captureDevice setExposureTargetBias:EV completionHandler:nil];
        [captureDevice unlockForConfiguration];
        
    }else{
        // Handle the error appropriately.
    }
}

//EV值
- (CGFloat)getDeviceEV{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return captureDevice.exposureTargetBias;
}

//ISO 设置  0.0 - 1.0 光感度  46 -736
-(void)cameraBackgroundDidChangeISO:(CGFloat)iso{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        //        CGFloat minISO = captureDevice.activeFormat.minISO;
        //        CGFloat maxISO = captureDevice.activeFormat.maxISO;
        //
        //
        //        NSLog(@"%f------%f",minISO,maxISO);
        //        CGFloat currentISO = (maxISO - minISO) * iso +minISO;
        
        [captureDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent  ISO:iso completionHandler:nil];
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"handle the error appropriately");
    }
}

//ISO值
- (CGFloat)getDeviceISO{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //NSLog(@">>>>>>>>>>>>>+++%f",captureDevice.ISO);
    CGFloat minISO = captureDevice.activeFormat.minISO;//22
    CGFloat maxISO = captureDevice.activeFormat.maxISO;//880
    //NSLog(@"%f------%f",minISO,maxISO);
    //CGFloat currentISO = captureDevice.ISO +minISO;
    CGFloat currentISO = captureDevice.ISO ;
    
    return currentISO;
}

//WB  数值设置增加或降低色温
-(void)cameraBackgroundDidChangeWB:(CGFloat)WB{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        float maxWhiteBalance = WB;
        float redGain =  MIN(2.0, maxWhiteBalance);
        float greenGain = MIN(2.0, maxWhiteBalance);
        float blueGain = MIN(2.0, maxWhiteBalance);
        AVCaptureWhiteBalanceGains whiteBalanceGains = {
            redGain,
            greenGain,
            blueGain
        };
        [captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:whiteBalanceGains completionHandler:nil];
    }else{
        // Handle the error appropriately.
    }
}

////WB
//- (CGFloat)getDeviceWB{
//
//    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    NSLog(@">>>>>>>>>%f   deviceWhiteBalanceGains.blueGain= %f",captureDevice.maxWhiteBalanceGain,captureDevice.deviceWhiteBalanceGains.blueGain);
//    return captureDevice.deviceWhiteBalanceGains.blueGain;
//}

//SEC 设置 快门速度/间隔 1/2s  苹果上用曝光时间表示
- (void)cameraBackgroundDidChangeShutter_interval:(CGFloat)shutter_interval{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        
        NSLog(@"%d  ---%lld",captureDevice.exposureDuration.timescale,captureDevice.exposureDuration.value);
        NSLog(@">>>%f--->>>%f",CMTimeGetSeconds(captureDevice.activeFormat.minExposureDuration) ,CMTimeGetSeconds(captureDevice.activeFormat.maxExposureDuration) );
        CGFloat minExposureDuration = captureDevice.activeFormat.minExposureDuration.value;
        CGFloat maxExposureDuration = captureDevice.activeFormat.maxExposureDuration.value;
        NSLog(@"maxExposureDuration ==%.3f minExposureDuration = %3f",minExposureDuration,maxExposureDuration);
        NSLog(@"maxExposureDuration ==%.3d minExposureDuration = %3d",captureDevice.activeFormat.maxExposureDuration.timescale,captureDevice.activeFormat.minExposureDuration.timescale);
        //maxExposureDuration =1.000000 minExposureDuration =5.000000
       // NSLog(@"maxExposureDuration =%f minExposureDuration =%f  shutter_interval=%f",maxExposureDuration,minExposureDuration,shutter_interval);
        //        CGFloat currentDuration = (maxExposureDuration - minExposureDuration) * shutter_interval +minExposureDuration;
        CMTime  exposureDuration = CMTimeMake(shutter_interval ,10000 );//10000
        //CMTime  exposureDuration = CMTimeMakeWithSeconds(3, 1);
        [captureDevice setExposureModeCustomWithDuration:exposureDuration  ISO:AVCaptureISOCurrent completionHandler:nil];
        [captureDevice unlockForConfiguration];
        
    }else{
        NSLog(@"handle the error appropriately");
    }
}


//SEC  快门值
- (CGFloat)getDeviceSEC{
    
    //activeFormat.minExposureDuration and activeFormat.maxExposureDuration
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
   // CGFloat currentDuration = CMTimeGetSeconds(captureDevice.exposureDuration) ;

//    NSLog(@"currentDuration ==%.3f  时间基 = %d  数值 = %f",CMTimeGetSeconds(captureDevice.exposureDuration),captureDevice.exposureDuration.timescale,captureDevice.exposureDuration.value);
    return captureDevice.exposureDuration.timescale/captureDevice.exposureDuration.value;
}

//延时摄影   减小帧间隔录像  类比运动相机一帧持续时间
- (void)cameraBackgroundDidChangeDelayedPhotography:(CGFloat)videoFramePerDuration{
    
    [self.captureSession stopRunning];
    CGFloat desiredFPS = 1.0/videoFramePerDuration;
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        
        for (AVFrameRateRange *range  in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.minFrameRate) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    
    if (selectedFormat) {
        
        if ([videoDevice lockForConfiguration:nil]) {
            //NSLog(@"selected format:%@",selectedFormat);
            videoDevice.activeFormat = selectedFormat;
            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}

//延时摄影
- (CGFloat)getVideoFramePerDuration{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return captureDevice.activeVideoMaxFrameDuration.value;
}

//慢动作拍摄  加大帧到240开启 否则关闭
- (void)cameraBackgroundDidChangeSlowMotion:(BOOL)slowMotion{
    
    [self.captureSession stopRunning];
    CGFloat desiredFPS = (slowMotion==YES ?240.0: 60.0);
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    
    for (AVCaptureDeviceFormat *format in [videoDevice formats]) {
        
        for (AVFrameRateRange *range  in format.videoSupportedFrameRateRanges) {
            CMFormatDescriptionRef desc = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(desc);
            int32_t width = dimensions.width;
            if (range.minFrameRate <= desiredFPS && desiredFPS <= range.minFrameRate) {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    
    if (selectedFormat) {
        
        if ([videoDevice lockForConfiguration:nil]) {
            
            NSLog(@"selected format:%@",selectedFormat);
            if (slowMotion) {
                
                videoDevice.activeFormat = selectedFormat;
                videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
                videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)desiredFPS);
                
            }else{
                
                //慢动作拍摄关
                videoDevice.activeFormat = _defaultFormat;
                videoDevice.activeVideoMinFrameDuration = _defaultMinFrameDuration;
                videoDevice.activeVideoMaxFrameDuration = _defaultMaxFrameDuration;
            }
            [videoDevice unlockForConfiguration];
        }
    }
    [self.captureSession startRunning];
}


//是否慢动作
- (BOOL)isSlowMode{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return captureDevice.activeVideoMinFrameDuration.value == 240;
}


- (AVCaptureDevice *)activeDevice{
    
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    // return self.captureDevice;
}


- (void)whiteBalanceMode:(AVCapture_WhiteBalance_Mode)whiteBalanceMode{
    
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //先获取当前的结构体值
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:captureDevice.deviceWhiteBalanceGains];
    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {
        
        float tint = 150;
        if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Auto) {
//            tint = -150;
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            [captureDevice unlockForConfiguration];
            return;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Clear){
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
            tint = 35;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Overcast){
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
            tint = 10;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_FluorescentLamp){
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
            tint = 45;
        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_IncandescentLamp){
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeLocked];
            tint = 55;
        }
        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
        balanceTemperatureAndTintValues.temperature = temperatureAndTintValues.temperature;
        balanceTemperatureAndTintValues.tint = tint;
        
//        float temperature = 3000;
//        if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Auto) {
//            temperature = 3000;
//        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Clear){
//            temperature = 4000;
//        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_Overcast){
//            temperature = 6000;
//        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_FluorescentLamp){
//            temperature = 8000;
//        }else if (whiteBalanceMode == AVCapture_WhiteBalance_Mode_IncandescentLamp){
//            temperature = 9000;
//        }
//        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
//        balanceTemperatureAndTintValues.temperature = temperature;
//        balanceTemperatureAndTintValues.tint = temperatureAndTintValues.tint;
        AVCaptureWhiteBalanceGains deviceGains = [captureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:balanceTemperatureAndTintValues];
        [captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:deviceGains completionHandler:^(CMTime syncTime) {
            NSLog(@"setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains");
        }];
        [captureDevice unlockForConfiguration];
    } else
    {
        NSLog(@"设置白平衡失败");
    }
}

//手动设置白平衡色温
- (void)setWhiteBalanceTemperature:(int)tint{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //先获取当前的结构体值
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:captureDevice.deviceWhiteBalanceGains];
    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {
        
//        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
//        balanceTemperatureAndTintValues.temperature = temperature;
//        balanceTemperatureAndTintValues.tint = temperatureAndTintValues.tint;
        [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        AVCaptureWhiteBalanceTemperatureAndTintValues balanceTemperatureAndTintValues ;
        balanceTemperatureAndTintValues.temperature = temperatureAndTintValues.temperature;
        balanceTemperatureAndTintValues.tint = tint;
        
        AVCaptureWhiteBalanceGains deviceGains = [captureDevice deviceWhiteBalanceGainsForTemperatureAndTintValues:balanceTemperatureAndTintValues];
        [captureDevice setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:deviceGains completionHandler:^(CMTime syncTime) {
            NSLog(@"setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains");
        }];
        [captureDevice unlockForConfiguration];
        
    } else
    {
        NSLog(@"设置白平衡失败");
    }
}


- (float)getWhiteBalanceTemparature{
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:AVCaptureWhiteBalanceGainsCurrent];
    AVCaptureWhiteBalanceTemperatureAndTintValues temperatureAndTintValues = [captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:captureDevice.deviceWhiteBalanceGains];
    return temperatureAndTintValues.tint;
//    return temperatureAndTintValues.temperature;
    
}

//手机防抖 开关
- (void)cameraAntiShakeMode:(AVCaptureVideoStabilizationMode)sabilizationMode{
    
    AVCaptureConnection *captureConnection = [self videoCaptureConnection];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice.activeFormat isVideoStabilizationModeSupported:sabilizationMode] && captureConnection.preferredVideoStabilizationMode != sabilizationMode) {
        
        captureConnection.preferredVideoStabilizationMode = sabilizationMode;
    }
}


//是否防抖
- (BOOL)isSabilizationMode{
    
    AVCaptureConnection *captureConnection = [self videoCaptureConnection];
    return captureConnection.preferredVideoStabilizationMode!=AVCaptureVideoStabilizationModeOff;
}

@end
