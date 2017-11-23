//
//  VC_ub_table_view.m
//  Dohasooq_mobile
//
//  Created by Test User on 04/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_ub_table_view.h"

@interface VC_ub_table_view ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sub_arr;
}

@end

@implementation VC_ub_table_view

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TBL_sub_brnds.delegate = self;
    _TBL_sub_brnds.dataSource = self;
    [_BTN_title setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"item_name"] forState:UIControlStateNormal];
    sub_arr = [[NSMutableArray alloc] init];
    sub_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"product_sub_list"] mutableCopy];
    [_TBL_sub_brnds reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[sub_arr valueForKey:@"child_categories"] count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [[[sub_arr valueForKey:@"child_categories"] objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[NSUserDefaults standardUserDefaults] setValue:[[[sub_arr valueForKey:@"child_categories" ]objectAtIndex:indexPath.row] valueForKey:@"url_key"] forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"discount"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *name = [[[sub_arr valueForKey:@"child_categories"]objectAtIndex:indexPath.row] valueForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"sub_name"];
    
    [self performSegueWithIdentifier:@"sublist_product_list" sender:self];
    
    
    // [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)back_ACTIon:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
