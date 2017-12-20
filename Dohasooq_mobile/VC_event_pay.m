//
//  VC_event_pay.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_event_pay.h"

@interface VC_event_pay ()

@end

@implementation VC_event_pay

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;

   
    NSMutableArray  *dtl = [[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"];
 
    NSMutableDictionary  *event_dtl_dict = [[NSMutableDictionary alloc]init];
    
    
    event_dtl_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_detail"];
    @try
    {
        _LBL_event_name.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_eventname"]];
    }
    @catch(NSException *exception)
    {
    NSLog(@"%@",exception);
    }
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
        _LBL_event_name.textAlignment = NSTextAlignmentRight;
    }
    else{
         _LBL_event_name.textAlignment = NSTextAlignmentLeft;
    }

                           
    _LBL_event_name.numberOfLines = 0;
    [_LBL_event_name sizeToFit];
   
    
    
    CGRect framseset = _LBL_location.frame ;
    framseset.origin.y = _LBL_event_name.frame.origin.y+ _LBL_event_name.frame.size.height + 3;
    _LBL_location.frame = framseset;
   
    @try
    {
      _LBL_location.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_Venue"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }

     [_LBL_location sizeToFit];
    
  

    _LBL_event_name.numberOfLines = 0;
 
    
       NSLog(@"_LBL_event_name %f",_LBL_event_name.frame.size.width);
      NSLog(@"_LBL_location %f",_LBL_location.frame.size.width);
    
    framseset = _LBL_time.frame ;
    framseset.origin.y = _LBL_location.frame.origin.y+ _LBL_location.frame.size.height + 3;
    _LBL_time.frame = framseset;
    @try
    {
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        
        [df1 setDateFormat:@"yyyy-MM-dd"];
        [df setDateFormat:@"dd MMM yyyy"];
        NSString *temp_str = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_startDate"]];
        NSDate *str_date = [df1 dateFromString:temp_str];
        NSString *start_date = [df stringFromDate:str_date];
        


    _LBL_time.text = [NSString stringWithFormat:@"%@ , %@",start_date,[event_dtl_dict valueForKey:@"_StartTime"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
   // [_LBL_persons sizeToFit];

    
    framseset = _LBL_persons.frame ;
    framseset.origin.y = _LBL_time.frame.origin.y+ _LBL_time.frame.size.height ;
    _LBL_persons.frame = framseset;
    @try
    {
    _LBL_persons.text = [NSString stringWithFormat:@"Number of persons:%@",[dtl objectAtIndex:0]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    framseset = _LBL_service_charges.frame ;
    framseset.origin.y = _LBL_persons.frame.origin.y + 3;
    _LBL_service_charges.frame = framseset;
    
    framseset = _VW_contents.frame ;
    framseset.size.height = _LBL_persons.frame.origin.y + _LBL_persons.frame.size.height +20;
    _VW_contents.frame = framseset;
    
    
    framseset = _BTN_pay.frame ;
    framseset.origin.y = _VW_contents.frame.origin.y + _VW_contents.frame.size.height +15;
    _BTN_pay.frame = framseset;
    @try
    {
       //product_list_home
       // logint_to_home

    
    NSString *str = [NSString stringWithFormat:@"%@",[dtl objectAtIndex:1]];
    NSString *text = [NSString stringWithFormat:@"TOTAL price \n%@ QAR",str];
    _LBL_service_charges.text = text;
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
 /*   if ([_LBL_service_charges respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_service_charges.textColor,
                                  NSFontAttributeName: _LBL_service_charges.font
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName:[UIColor whiteColor]}
                                    range:ename];
        }
        _LBL_service_charges.attributedText = attributedText;
    }
    else
    {
        _LBL_service_charges.text = text;
    }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }*/

    [_BTN_pay addTarget:self action:@selector(pay_action_checked) forControlEvents:UIControlEventTouchUpInside];
    
    [_LBL_service_charges sizeToFit];
    _VW_contents.layer.cornerRadius = 2.0f;
    _VW_contents.layer.masksToBounds = YES;
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}

#pragma Button Ations
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pay_action_checked
{
    [self performSegueWithIdentifier:@"pay_to_options" sender:self];
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
