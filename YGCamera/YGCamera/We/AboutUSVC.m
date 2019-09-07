//
//  AboutUSVC.m
//  YGCamera
//
//  Created by chen hua on 2019/4/10.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "AboutUSVC.h"
#import "AboutUSCell.h"

@interface AboutUSVC ()


@property(nonatomic,copy)NSArray *datasourceArr;
@property(nonatomic,copy)NSArray *imageSourceArr;

@end

@implementation AboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.datasourceArr = @[@"公众号",@"官网",@"APP推荐给朋友"];
    self.imageSourceArr = @[@"navWePub",@"navWeWeb",@"navWeRec"];
//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
//    tableHeaderView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AboutUSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUSCell" forIndexPath:indexPath];
  
    [cell.leftImage setImage:[UIImage imageNamed:self.imageSourceArr[indexPath.section]]];
    [cell.contentLAb setText:self.datasourceArr[indexPath.section]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 10;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==  0) {
        [self performSegueWithIdentifier:@"aboutUSDetail" sender:self];
    }else if (indexPath.section == 2){
        
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
