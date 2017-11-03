//
//  VC_events.m
//  Dohasooq_mobile
//
//  Created by Test User on 02/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_events.h"
#import "events_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VC_events ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *Events_arr;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}


@end

@implementation VC_events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     Events_arr = [[NSMutableArray alloc] init];
       [self ATTRIBUTE_TEXT];
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
    VW_overlay.hidden = YES;
    
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(Events_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
    
    
}
-(void)ATTRIBUTE_TEXT
{
    NSString *str = @"";
    NSString *text = [NSString stringWithFormat:@"VENUES %@",str];
    
    
    if ([_BTN_venues.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_venues.titleLabel.textColor,
                                  NSFontAttributeName: _BTN_venues.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:str];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0]}
                                    range:ename];
        }
        [_BTN_venues setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_venues setTitle:text forState:UIControlStateNormal];
    }
    
}
#pragma Table view dlegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    
  
        return Events_arr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];
        
        NSMutableArray *events_dict = [Events_arr objectAtIndex:indexPath.section];
        
        if (cell == nil)
            
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"events_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if(indexPath.section %2!=0)
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
            
            NSLog(@"the array count is:%lu",(unsigned long)Events_arr.count);
            
            cell.LBL_event_name.text = [events_dict valueForKey:@"_eventname"];
            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",[events_dict valueForKey:@"_startDate"],[events_dict valueForKey:@"_endDate"]];
            cell.LBL_event_location.text =  [events_dict valueForKey:@"_Venue"];
            cell.LBL_banner_label.hidden = YES;
            NSString *img_url = [events_dict valueForKey:@"_bannerURL"];
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
        if(indexPath.section %2 !=0 )
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
    if(tableView == _TBL_event_list)
    {
        @try
        {
            NSMutableDictionary *event_dtl = [Events_arr objectAtIndex:indexPath.section];
            NSLog(@"the detail of event is:%@",event_dtl);
            NSString *show_browser = [NSString stringWithFormat:@"%@",[event_dtl valueForKey:@"_showBrowser"]];
            [[NSUserDefaults standardUserDefaults] setObject:event_dtl forKey:@"event_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            if([show_browser intValue] == 1)
            {
                [self performSegueWithIdentifier:@"Event_WebVIEW" sender:self];
            }
            
            else
            {
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(event_detail) withObject:activityIndicatorView afterDelay:0.01];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"%@",exception);
            
        }
        
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

-(void)event_detail
{
    
    [self performSegueWithIdentifier:@"Event_detail_segue" sender:self];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
    
}
-(void)Events_API_CALL
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    Events_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Events_arr"];
    [_TBL_event_list reloadData];
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
