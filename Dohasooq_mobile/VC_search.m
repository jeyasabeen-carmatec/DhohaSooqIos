//
//  VC_search.m
//  Dohasooq_mobile
//
//  Created by Test User on 31/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_search.h"

@interface VC_search ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation VC_search

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TBL_results.hidden = YES;
    [_BN_close addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma Tbaleview delegate mathods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
-(void)close_action
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _TBL_results.hidden = NO;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     _TBL_results.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
