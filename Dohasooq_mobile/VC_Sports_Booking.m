//
//  VC_Sports_Booking.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_Sports_Booking.h"
#import "sports_booking_cell.h"

@interface VC_Sports_Booking ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation VC_Sports_Booking

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _TBL_match_list.rowHeight = UITableViewAutomaticDimension;
}

#pragma Table view delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ceel_count = 1;
    return ceel_count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    sports_booking_cell *cell = (sports_booking_cell *)[tableView dequeueReusableCellWithIdentifier:@"sports_cell"];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"sports_booking_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
//    NSString *str = @"1st Twenty Twenty Match(T20-20)D/N Match";
//    NSString *sub_str = @"XYZ cricket stadium,Durban";
//    NSString *text = [NSString stringWithFormat:@"%@\n%@",str,sub_str];
//    cell.LBL_match_venue.text = text;
//    [cell.LBL_match_venue sizeToFit];


    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // space between cells
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 168;
}

#pragma Button Actions
- (IBAction)back_action:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
