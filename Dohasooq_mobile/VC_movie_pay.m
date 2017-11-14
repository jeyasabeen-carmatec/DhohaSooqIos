//
//  VC_movie_pay.m
//  Dohasooq_mobile
//
//  Created by Test User on 11/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_movie_pay.h"
#import "XMLDictionary/XMLDictionary.h"

@interface VC_movie_pay ()
{
    UIActivityIndicatorView *activityIndicatorView;
    UIView *VW_overlay;
}



@end

@implementation VC_movie_pay

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray  *dtl = [[NSUserDefaults standardUserDefaults] valueForKey:@"movie_dtl_dict"];
    
    NSMutableDictionary  *movie_dtl_dict = [[NSMutableDictionary alloc]init];
    NSDictionary *time_dict = [[NSUserDefaults standardUserDefaults]  valueForKey:@"movie_id"];
    
    
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
    
    
    
    CGRect framseset = _LBL_location.frame ;
    framseset.origin.y = _LBL_event_name.frame.origin.y+ _LBL_event_name.frame.size.height + 3;
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
    
    
    
    _LBL_event_name.numberOfLines = 0;
    
    
    
    framseset = _LBL_time.frame ;
    framseset.origin.y = _LBL_location.frame.origin.y+ _LBL_location.frame.size.height + 3;
    _LBL_time.frame = framseset;
    @try
    {
        _LBL_time.text = [NSString stringWithFormat:@"%@ , %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"movie_date"],[[NSUserDefaults standardUserDefaults] valueForKey:@"movie_time"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    // [_LBL_persons sizeToFit];
    
    
    framseset = _LBL_persons.frame ;
    framseset.origin.y = _LBL_time.frame.origin.y+ _LBL_time.frame.size.height ;
    _LBL_persons.frame = framseset;
    
    framseset = _LBL_seat.frame ;
    framseset.origin.y = _LBL_persons.frame.origin.y+ _LBL_persons.frame.size.height ;
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
    
    framseset = _LBL_service_charges.frame ;
    framseset.origin.y = _LBL_persons.frame.origin.y + 3;
    _LBL_service_charges.frame = framseset;
    
    framseset = _VW_contents.frame ;
    framseset.size.height = _LBL_seat.frame.origin.y + _LBL_seat.frame.size.height +20;
    _VW_contents.frame = framseset;
    
    
    framseset = _BTN_pay.frame ;
    framseset.origin.y = _VW_contents.frame.origin.y + _VW_contents.frame.size.height +15;
    _BTN_pay.frame = framseset;
    @try
    {
        
        
    NSString *text = [NSString stringWithFormat:@"TOTAL price \n%@ QAR",[[NSUserDefaults standardUserDefaults] valueForKey:@"charges"]];
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
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_order_iD) withObject:activityIndicatorView afterDelay:0.01];
}
-(void)get_order_iD
{
    NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/lock_confirm_request?Transaction_Id=MB3JEZ7L&AppSource=3&AppVersion=1.0"];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"string: %@", xmlString);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"dictionary: %@", xmlDoc);
    NSLog(@"The Order Data is:%@",xmlDoc);
    [[NSUserDefaults standardUserDefaults] setObject:xmlDoc forKey:@"order_details"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];

    
        [self performSegueWithIdentifier:@"Movie_pay_selection" sender:self];
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
