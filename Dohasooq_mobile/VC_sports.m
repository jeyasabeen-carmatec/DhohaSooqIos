//
//  VC_sports.m
//  Dohasooq_mobile
//
//  Created by Test User on 02/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_sports.h"
#import "events_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_sports ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *Sports_arr;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_sports

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      Sports_arr = [[NSMutableArray alloc] init];
}
-(void)viewWillAppear:(BOOL)animated
{
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(Sports_API_call) withObject:activityIndicatorView afterDelay:0.01];

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return Sports_arr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];
        NSMutableArray *sports_dict = [Sports_arr objectAtIndex:indexPath.section];
        
        
        if (cell == nil)
            
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"events_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if(indexPath.section %2 !=0 )
            {
                
                cell.IMG_qtickets.hidden = NO;
            }
            else
            {
                
                cell.IMG_qtickets.hidden = YES;
            }
            
        }
        
        @try
        {
            cell.LBL_event_name.text = [sports_dict valueForKey:@"_eventname"];
            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",[sports_dict valueForKey:@"_startDate"],[sports_dict valueForKey:@"_endDate"]];
            cell.LBL_event_location.text =  [sports_dict valueForKey:@"_Venue"];
            cell.LBL_banner_label.hidden = YES;
            NSString *img_url = [sports_dict valueForKey:@"_bannerURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"App" withString:@"movie"];
            
            [cell.IMG_event sd_setImageWithURL:[NSURL URLWithString:img_url]
                              placeholderImage:[UIImage imageNamed:@"logo.png"]
                                       options:SDWebImageRefreshCached];
            
            
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
        return cell;
        
        
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float ht = 0;
    if(indexPath.section %2 !=0)
    {
        
        ht = 310;
    }
    else
    {
        
        ht = 275;
    }
    return ht;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
            @try
        {
            NSMutableDictionary *sports_dtl = [Sports_arr objectAtIndex:indexPath.section];
            NSLog(@"the detail of sports is:%@",sports_dtl);
            NSString *show_browser = [NSString stringWithFormat:@"%@",[sports_dtl valueForKey:@"_showBrowser"]];
            [[NSUserDefaults standardUserDefaults] setObject:sports_dtl forKey:@"event_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            if([show_browser intValue] == 1)
            {
                [self performSegueWithIdentifier:@"sports_webview" sender:self];
            }
            
            else
            {
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(sports_detail) withObject:activityIndicatorView afterDelay:0.01];
            }
        }
        
        @catch (NSException *exception)
        {
            NSLog(@"%@",exception);
        }
    
    
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
#pragma didselct Actions
-(void)sports_detail
{
    [self performSegueWithIdentifier:@"Home_sports_detail" sender:self];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}

-(void)Sports_API_call
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    Sports_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Sports_arr"];
    [_TBL_sports_list reloadData];
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
