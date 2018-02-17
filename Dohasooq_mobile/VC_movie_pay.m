//
//  VC_movie_pay.m
//  Dohasooq_mobile
//
//  Created by Test User on 11/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_movie_pay.h"
#import "XMLDictionary/XMLDictionary.h"
#import "HttpClient.h"
#import "Helper_activity.h"

@interface VC_movie_pay ()
{
    UIActivityIndicatorView *activityIndicatorView;
    UIView *VW_overlay;
    NSString *booking_info;
    int k;
}



@end

@implementation VC_movie_pay

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    k = 0;
    NSMutableDictionary  *movie_dtl_dict = [[NSMutableDictionary alloc]init];
    
    
    movie_dtl_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"];
    @try
    {
        _LBL_event_name.text = [NSString stringWithFormat:@"%@",[movie_dtl_dict valueForKey:@"_name"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    
    _LBL_event_name.numberOfLines = 0;
    [_LBL_event_name sizeToFit];
    
    
//    
    CGRect framseset = _LBL_location.frame ;
    framseset.origin.y = _LBL_event_name.frame.origin.y+ _LBL_event_name.frame.size.height ;
    _LBL_location.frame = framseset;
    @try
    {
        _LBL_location.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"theatre"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    [_LBL_location sizeToFit];
    
    
    
  //  _LBL_event_name.numberOfLines = 0;
    
    
    
    framseset = _LBL_time.frame ;
    framseset.origin.y = _LBL_location.frame.origin.y+ _LBL_location.frame.size.height ;
    _LBL_time.frame = framseset;
    @try
    {
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        [df1 setDateFormat:@"MM-dd-yyyy"];
        [df setDateFormat:@"dd MMM yyyy"];
         NSString *temp_str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"movie_date"]];
        NSDate *str_date = [df1 dateFromString:temp_str];
        NSString *start_date = [df stringFromDate:str_date];
        

        _LBL_time.text = [NSString stringWithFormat:@"%@ , %@",start_date,[[NSUserDefaults standardUserDefaults] valueForKey:@"movie_time"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    // [_LBL_persons sizeToFit];
    
    
    framseset = _LBL_persons.frame ;
    framseset.origin.y = _LBL_time.frame.origin.y+ _LBL_time.frame.size.height ;
    _LBL_persons.frame = framseset;
    
    
    framseset = _LBL_service_charges.frame ;
    framseset.origin.x = _LBL_persons.frame.origin.x;
    framseset.origin.y = _LBL_persons.frame.origin.y + _LBL_persons.frame.size
    .height +3;
    _LBL_service_charges.frame = framseset;
    
    framseset = _LBL_seat.frame ;
    framseset.origin.y = _LBL_service_charges.frame.origin.y+ _LBL_service_charges.frame.size.height;
    _LBL_seat.frame = framseset;
    
    
    @try
    {
        _LBL_persons.text = [NSString stringWithFormat:@"Number of persons:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"seat_count"]];
        _LBL_seat.text = [NSString stringWithFormat:@"Seat:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"seats"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    [_LBL_seat sizeToFit];

   
//    
    framseset = _VW_contents.frame ;
    framseset.size.height = _LBL_seat.frame.origin.y + _LBL_seat.frame.size.height +20;
   _VW_contents.frame = framseset;
//    
//    
   framseset = _BTN_pay.frame ;
    framseset.origin.y = _VW_contents.frame.origin.y + _VW_contents.frame.size.height +15;
    _BTN_pay.frame = framseset;
    @try
    {
        
        
    NSString *text = [NSString stringWithFormat:@"Total Price : %@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],[[NSUserDefaults standardUserDefaults] valueForKey:@"charges"]];
        _LBL_service_charges.text = text;
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    [_BTN_pay addTarget:self action:@selector(pay_action_checked) forControlEvents:UIControlEventTouchUpInside];
    
    [_LBL_service_charges sizeToFit];
    _VW_contents.layer.cornerRadius = 2.0f;
    _VW_contents.layer.masksToBounds = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;

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
    
}

    - (IBAction)back_action:(id)sender
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
-(void)pay_action_checked
{
    [Helper_activity animating_images:self];
    [self performSelector:@selector(get_order_iD) withObject:activityIndicatorView afterDelay:0.01];
}
#pragma mark Generating Booking ID

-(void)get_order_iD
{
    
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", Identifier);
    
    NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/lock_confirm_request?Transaction_Id=%@&Source=11&AppVersion=1.0",[[NSUserDefaults standardUserDefaults] valueForKey:@"TID"]];

    
    NSURL *URL = [[NSURL alloc] initWithString:str_url];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"string: %@", xmlString);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
   
    
    NSLog(@"The Order Data is:%@",xmlDoc);
    NSString *str_stat = [NSString stringWithFormat:@"%@",[[xmlDoc valueForKey:@"result"] valueForKey:@"_status"]];
    if([str_stat isEqualToString:@"True"])
    {
       
        [Helper_activity stop_activity_animation:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:xmlDoc forKey:@"order_details"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
        NSString *tr_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"TID"];
        
        
        if ([[[xmlDoc valueForKey:@"result"] valueForKey:@"_Transaction_Id"] isEqualToString:tr_id])
        {
            
            
            NSLog(@"%@",[[xmlDoc valueForKey:@"result"] valueForKey:@"_OrderInfo"]);
            booking_info =[NSString stringWithFormat:@"%@", [[xmlDoc valueForKey:@"result"] valueForKey:@"_OrderInfo"]];
            
            [self performSelector:@selector(save_bookings) withObject:activityIndicatorView afterDelay:0.0001];
            
            
            // Move to Next Page
            // [self performSegueWithIdentifier:@"Movie_pay_selection" sender:self];
            
        }
        else
        {
            [HttpClient createaAlertWithMsg:@"Please Conform Booking ID" andTitle:@""];
        }
        
    

        
    }
    else
    {
        if([[[xmlDoc valueForKey:@"result"] valueForKey:@"_msg"] isEqualToString:@"send lockrequest again"])
        {
        
        [self get_order_iD];
        }
        
      
        
    }
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Save Bookings

//http://192.168.0.171/dohasooq/apis/savebooking.json
//full_name, email, mobile, bookingId, movie_event,user_id

-(void)save_bookings{
    @try {
        
        
        /*saveBookings_dic {
         email = "ysushmalatha@gmail.com";
         "full_name" = sushma;
         mobile = 9177288200;
         }*/
        
        
        
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int h = 0;h<[[dict allKeys] count];h++)
        {
            if([[[dict allKeys] objectAtIndex:h] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        
       
        
        NSDictionary *saveBookings_dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"savebooking"];
        NSLog(@"saveBookings_dic %@",saveBookings_dic);
        
        NSString *order_ID = [booking_info substringWithRange:NSMakeRange(1, booking_info.length-1)];
        
        
        NSDictionary *params=@{@"full_name":[saveBookings_dic valueForKey:@"full_name"],@"email":[saveBookings_dic valueForKey:@"email"],@"mobile":[saveBookings_dic valueForKey:@"mobile"],@"bookingId":order_ID,@"movie_event":@"movie",@"user_id":user_id};
        
        
        NSLog(@"Params %@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/savebooking.json",SERVER_URL];
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
           [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (error) {
                       NSLog(@"%@",[error localizedDescription]);
                   }
                   if (data) {
                       NSLog(@"After Saving %@",data);
                       
                       if ([data isKindOfClass:[NSDictionary class]]) {
                           
                           if ([[data valueForKey:@"success"] isEqualToString:@"success"]) {
                               
                               // Move to Next Page
                                [self performSegueWithIdentifier:@"Movie_pay_selection" sender:self];
                               
                           }
                           else{
                                 [HttpClient createaAlertWithMsg:@"Some thing wen wrong ,Check The mail " andTitle:@""];
                           }
                          
                           
                           
                       }
                    
                       
                   }
                   
               });
           }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
    }
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
