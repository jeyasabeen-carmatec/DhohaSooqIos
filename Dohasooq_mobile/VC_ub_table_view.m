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
   // product_list_type
    
     [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"discount"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *name = [[[sub_arr valueForKey:@"child_categories"]objectAtIndex:indexPath.row] valueForKey:@"name"];
//   NSString *item_name = [NSString stringWithFormat:@"%@ - %@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"item_name"],name];
   // [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"search_val"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sub_name"];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"sub_name"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"sublist_product_list" sender:self];
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[sub_arr valueForKey:@"child_categories" ]objectAtIndex:indexPath.row] valueForKey:@"url_key"]];
    NSString *list_TYPE = @"productList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/0/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
   
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    // [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)back_ACTIon:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
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
