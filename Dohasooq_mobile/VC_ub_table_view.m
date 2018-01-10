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
    [_BTN_title setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:@"item_name"] uppercaseString] forState:UIControlStateNormal];
    sub_arr = [[NSMutableArray alloc] init];
    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
    sortedArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"product_sub_list"] mutableCopy];
  //  sub_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"product_sub_list"] mutableCopy];
    NSMutableArray *arr = [NSMutableArray array];
    
    
    NSMutableSet *seenYears = [NSMutableSet set];
    for (NSDictionary *item in [sortedArray valueForKey:@"child_categories"]) {
        //Extract the part of the dictionary that you want to be unique:
        NSDictionary *yearDict = [item dictionaryWithValuesForKeys:@[@"name"]];
        if ([seenYears containsObject:yearDict]) {
            continue;
        }
        [seenYears addObject:yearDict];
        [arr addObject:item];
        //  [duplicatesRemoved addObject:item];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    NSArray *srt_arr = [arr sortedArrayUsingDescriptors:@[sortDescriptor]];
    [sub_arr  addObjectsFromArray:[srt_arr mutableCopy]];
    [_TBL_sub_brnds reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [sub_arr count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [[[sub_arr  objectAtIndex:indexPath.row] valueForKey:@"name"] uppercaseString];
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // product_list_type
    
     [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"discount"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *name = [[sub_arr objectAtIndex:indexPath.row] valueForKey:@"name"];
//   NSString *item_name = [NSString stringWithFormat:@"%@ - %@",[[NSUserDefaults standardUserDefaults]  valueForKey:@"item_name"],name];
   // [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"search_val"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sub_name"];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"sub_name"];
     [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        user_id = 0;
    }
    
    NSString *list_TYPE = @"productList";
    NSString *url_key = [NSString stringWithFormat:@"%@/%@/0",list_TYPE,[[sub_arr objectAtIndex:indexPath.row] valueForKey:@"url_key"]];
    
    
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
    [[NSUserDefaults standardUserDefaults] setValue:@"sublist" forKey:@"list_seg"];
    [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"sublist_product_list" sender:self];
    
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
