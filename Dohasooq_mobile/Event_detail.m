//
//  Event_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 20/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Event_detail.h"
#import "Gender_cell.h"
#import "cost_count_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface Event_detail ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *event_dtl_dict;
    NSMutableArray *event_cost_arr,*values_arr;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation Event_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self set_UP_VIEW];
}
-(void)set_UP_VIEW
{
    values_arr = [[NSMutableArray alloc]init];
    for(int i = 0; i <event_cost_arr.count;i++)
    {
        [values_arr addObject:@"0"];
    }
    NSLog(@"%@",values_arr);
    
    @try
    {
    _LBL_event_name.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_eventname"]];
    [_LBL_event_name sizeToFit];
    
    _LBL_event_address.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_Venue"]];
    [_LBL_event_address sizeToFit];
    
    NSString *img_url = [event_dtl_dict valueForKey:@"_thumbURL"];
        img_url = [img_url stringByReplacingOccurrencesOfString:@"App" withString:@"movie"];
        
    [_IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                           placeholderImage:[UIImage imageNamed:@"logo.png"]
                                    options:SDWebImageRefreshCached];

    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }

     CGRect frameset =_LBL_event_address.frame;
    frameset.origin.y = _LBL_event_name.frame.origin.y + _LBL_event_name.frame.size.height;
    _LBL_event_address.frame = frameset;
    
  
    frameset = _LBL_event_date.frame;
    frameset.origin.y = _LBL_event_address.frame.origin.y + _LBL_event_address.frame.size.height + 7;
    _LBL_event_date.frame = frameset;
    
    @try
    {
        
    _LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",[event_dtl_dict valueForKey:@"_startDate"],[event_dtl_dict valueForKey:@"_endDate"]];
     }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }


    frameset = _LBL_event_time.frame;
    frameset.origin.y = _LBL_event_date.frame.origin.y + _LBL_event_date.frame.size.height ;
    _LBL_event_time.frame = frameset;
    @try
    {
    _LBL_event_time.text =[NSString stringWithFormat:@"%@ - %@",[event_dtl_dict valueForKey:@"_StartTime"],[event_dtl_dict valueForKey:@"_endTime"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }

    
    frameset = _VW_event.frame;
    frameset.size.height = _LBL_event_time.frame.origin.y + _LBL_event_time.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_event.frame = frameset;
    
    frameset = _IMG_back_ground.frame;
    frameset.size.height = _LBL_event_time.frame.origin.y + _LBL_event_time.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _IMG_back_ground.frame = frameset;
    
    
    frameset = _VW_event_dtl.frame;
    frameset.size.height = _VW_event.frame.origin.y + _VW_event.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_event_dtl.frame = frameset;
    
    @try
    {
    _LBL_data.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_EDescription"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    [_LBL_data sizeToFit];
    
    frameset = _LBL_data.frame;
    frameset.origin.y= _LBL_author.frame.origin.y + _LBL_author.frame.size.height;
    _LBL_data.frame = frameset;
    
    frameset = _VW_author.frame;
    frameset.origin.y = _VW_event.frame.origin.y + _VW_event.frame.size.height;
    frameset.size.height = _LBL_data.frame.origin.y + _LBL_data.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_author.frame = frameset;
    
   
    
    [_TBL_quantity reloadData];
    
    frameset = _VW_Quantity.frame;
    frameset.origin.y = _VW_author.frame.origin.y + _VW_author.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    frameset.size.height = _TBL_quantity.frame.origin.y + _TBL_quantity.frame.size.height + 20;
    _VW_Quantity.frame = frameset;
    
    
    [self.Scroll_contents addSubview:_VW_event_dtl];
    [self.Scroll_contents addSubview:_VW_author];
    [self.Scroll_contents addSubview:_VW_Quantity];
    
    
    @try
    {
        
    }
    @catch(NSException *excpetion)
    {
        NSLog(@"%@",excpetion);
    }

   // [self ATTRIBUTED_TEXT];
    
    
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
    [self performSelector:@selector(getData) withObject:activityIndicatorView afterDelay:0.01];
    
    

}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,_VW_Quantity.frame.origin.y + _VW_Quantity.frame.size.height);
    
}

#pragma Getdata
-(void)getData
{
   
    event_dtl_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_detail"];
    event_cost_arr = [[NSMutableArray alloc]init];
    event_cost_arr = [[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    [self set_UP_VIEW];
    [self viewDidLayoutSubviews];
    
}


#pragma Tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        
    return event_cost_arr.count;
    }
    else if(section == 1)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Gemder_cell";
   

   
    if(indexPath.section == 0)
    {
        Gender_cell *gcell = (Gender_cell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(gcell == nil)
        
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"Gender_cell" owner:self options:nil];
            gcell = [nib objectAtIndex:0];
       }
        NSMutableDictionary *ticket_dicket =  [event_cost_arr objectAtIndex:indexPath.row];
        gcell.BTN_plus.layer.cornerRadius = gcell.BTN_plus.frame.size.width/2;
        gcell.BTN_plus.layer.masksToBounds = YES;
        
        gcell.BTN_minus.layer.cornerRadius = gcell.BTN_minus.frame.size.width/2;
        gcell.BTN_minus.layer.masksToBounds = YES;
        [gcell.LBL_result setTag:indexPath.row];
        [gcell.BTN_plus setTag:indexPath.row];
        [gcell.BTN_minus setTag:indexPath.row];
        
        [gcell.BTN_plus addTarget:self action:@selector(BTN_plus_action:) forControlEvents:UIControlEventTouchUpInside];
        [gcell.BTN_minus addTarget:self action:@selector(BTN_minus_action:) forControlEvents:UIControlEventTouchUpInside];

        
        
        @try
        {
            
      
        gcell.LBL_gender_cat.text = [ticket_dicket valueForKey:@"_TicketName"];
        gcell.LBL_price.text = [NSString stringWithFormat:@"QAR %@",[ticket_dicket valueForKey:@"_TicketPrice"]];
        gcell.LBL_result.text = [values_arr objectAtIndex:indexPath.row];
        
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
        return gcell;
    }
    else
    {
        if(indexPath.section == 1)
        {
    cost_count_cell *ccell = (cost_count_cell *)[tableView dequeueReusableCellWithIdentifier:@"costcell"];
    
    if(ccell == nil)
        
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"Gender_cell" owner:self options:nil];
        ccell = [nib objectAtIndex:1];
    }
        @try
        {
            
        NSString *str = @"365";//gcell.LBL_result.text;
            NSString *text = [NSString stringWithFormat:@"No of Tickets: %@",str];
            
            
            if ([ccell.LBL_no_tickets respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:ccell.LBL_no_tickets.textColor,
                                          NSFontAttributeName: ccell.LBL_no_tickets.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                
                
                
                NSRange ename = [text rangeOfString:str];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:17.0]}
                                            range:ename];
                }
                ccell.LBL_no_tickets.attributedText = attributedText;
            }
            else
            { ccell.LBL_no_tickets.text = text;
            }
            
            
            NSString *str1 = @"465";//gcell.LBL_price.text;
            NSString *text1 = [NSString stringWithFormat:@"Total Price: %@",str1];
            
            
            if ([ccell.LBL_total_price respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:ccell.LBL_total_price.textColor,
                                          NSFontAttributeName:ccell.LBL_total_price.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
                
                
                
                NSRange ename = [text1 rangeOfString:str1];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:17.0]}
                                            range:ename];
                }
                ccell.LBL_total_price.attributedText = attributedText;
            }
            else
            { ccell.LBL_total_price.text = text1;
            }
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
             return ccell;
        }
    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100;
    }
    else
    {
        if(indexPath.section == 1)
        return 100;
    }
    return 30;
}


#pragma Button_Actions
//-(void)male_plus_action
//{
//    int count = [_LBL_male_COUNT.text intValue];
//    _LBL_male_COUNT.text = [NSString stringWithFormat:@"%d",count + 1];
//}
//-(void)male_minus_action
//{
//    int count = [_LBL_male_COUNT.text intValue];
//    if(count == 0)
//    {
//        _LBL_male_COUNT.text = [NSString stringWithFormat:@"%d",count];
//
//    }
//    else
//    {
//        _LBL_male_COUNT.text = [NSString stringWithFormat:@"%d",count - 1];
//
//    }
//}
//-(void)female_plus_action
//{
//    int count = [_LBL_female_COUNT.text intValue];
//    _LBL_female_COUNT.text = [NSString stringWithFormat:@"%d",count + 1];
//}
//-(void)female_minus_action
//{
//    int count = [_LBL_female_COUNT.text intValue];
//    if(count == 0)
//    {
//        _LBL_female_COUNT.text = [NSString stringWithFormat:@"%d",count];
//        
//    }
//    else
//    {
//        _LBL_female_COUNT.text = [NSString stringWithFormat:@"%d",count - 1];
//        
//    }
//}
#pragma Button Actions
-(void)BTN_plus_action:(UIButton *)sender
{
     NSLog(@"%ld",(long)sender.tag);
    int i = [[values_arr objectAtIndex:sender.tag] intValue];
    i = i + 1;
    NSString *add_val = [NSString stringWithFormat:@"%d",i];
    [values_arr replaceObjectAtIndex:sender.tag withObject:add_val];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    [self.TBL_quantity beginUpdates];
    [self.TBL_quantity reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_quantity endUpdates];
    
}

-(void)BTN_minus_action:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    int i = [[values_arr objectAtIndex:sender.tag] intValue];
   // i = i - 1;
    if( i == 0)
    {
        i =0;
    }
    else
    {
         i = i - 1;
    }
    NSString *add_val = [NSString stringWithFormat:@"%d",i];
    [values_arr replaceObjectAtIndex:sender.tag withObject:add_val];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    [self.TBL_quantity beginUpdates];
    [self.TBL_quantity reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_quantity endUpdates];

    
}
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
