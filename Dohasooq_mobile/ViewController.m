//
//  ViewController.m
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"

@interface ViewController ()<UITextFieldDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
   
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self set_UP_View];
    
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

-(void)set_UP_View
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];

    _VW_fields.center = self.view.center;
    
    
    @try {
        
    NSString *need_sign = @"NEED AN ACCOUNT ?";
    NSString *sign_UP = @"SIGN UP";
    NSString *text = [NSString stringWithFormat:@"%@ %@",need_sign,sign_UP];
    if ([_LBL_sign_up respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_sign_up.textColor,
                                  NSFontAttributeName: _LBL_sign_up.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        CGSize result = [[UIScreen mainScreen] bounds].size;

        NSRange ename = [text rangeOfString:need_sign];
        
        
        if(result.height <= 480)
        {
            // iPhone Classic
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                    range:ename];
        }
        else if(result.height <= 568)
        {
            // iPhone 5
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
                                    range:ename];
        }
        

        
        
        
        
        
        
        
        NSRange cmp = [text rangeOfString:sign_UP];
        
        if(result.height <= 480)
        {
            // iPhone Classic
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                    range:cmp];
        }
        else if(result.height <= 568)
        {
            // iPhone 5
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:20.0]}
                                    range:cmp];
        }

        
        
        self.LBL_sign_up.attributedText = attributedText;
    }
    else
    {
        _LBL_sign_up.text = text;
    }
    }
    @catch(NSException *exception)
    {
        NSLog(@"the exception:%@",exception);
    }
    
   // CGRect frameset = _LBL_sign_up.frame;
  //  frameset.origin.y = _BTN_sign_up.frame.origin.y + (_BTN_sign_up.frame.size.height/2) - 3;
   // _LBL_sign_up.frame = frameset;
    
    
    _BTN_sign_up.layer.cornerRadius = _BTN_sign_up.frame.size.height / 2;
    _BTN_sign_up.layer.masksToBounds = YES;
    [_BTN_sign_up addTarget:self action:@selector(sign_up_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_login addTarget:self action:@selector(login_home) forControlEvents:UIControlEventTouchUpInside];
    
    _TXT_username.text = @"karuna@carmatec.in";
    _TXT_password.text = @"qazplm123";
   
    
    
}

#pragma textfield delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_TXT_username resignFirstResponder];
    [_TXT_password resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    if(textField == _TXT_username || textField == _TXT_password)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        
    }
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
     [UIView beginAnimations:nil context:NULL];
            
     self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}

#pragma BUTTON ACTIONS
- (IBAction)forgot_pwd_action:(UIButton *)sender
{
[self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
}
-(void)sign_up_action
{
    [self performSegueWithIdentifier:@"sign_up_segue" sender:self];
}
-(void)login_home
{
    NSString *msg;
    NSString *text_to_compare_email = _TXT_username.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if([_TXT_username.text isEqualToString:@""])
    {
        [_TXT_username becomeFirstResponder];
        msg = @"Please enter Email";
        
    }
    
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_username becomeFirstResponder];
        msg = @"Please enter valid email address";
        
        
    }
    else if([_TXT_password.text isEqualToString:@""])
    {
        
        [_TXT_password becomeFirstResponder];
        msg = @"Please enter Password";
    }
  //  [self performSegueWithIdentifier:@"logint_to_home" sender:self];


    else
    {
        [self.view endEditing:TRUE];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(LOGIN_up_api_integration) withObject:activityIndicatorView afterDelay:0.01];
        
    }
    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
    
}
-(void)LOGIN_up_api_integration
{
    @try
    {
        NSString *email = _TXT_username.text;
        NSString *password = _TXT_password.text;
        NSDictionary *parameters = @{
                                      @"username": email,
                                      @"password": password
                                     
                                      };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;

        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/login/1.json",SERVER_URL];
       // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            if([status isEqualToString:@"1"])
            {
                
                [[NSUserDefaults standardUserDefaults] setObject:[json_DATA valueForKey:@"detail"] forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self MENU_api_call];

                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            }
            else
            {
                if ([msg isEqualToString:@"User already exists"])
                {
                    msg = @"Email address already in use, Please try with different email.";
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            
        }
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
    }
    

}
-(void)MENU_api_call
{
    
    @try
    {
    NSError *error;
    
    NSHTTPURLResponse *response = nil;
    NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
//    NSString *urlGetuser =[NSString stringWithFormat:@"%@menuList/%ld/%ld.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/menuList/1/1.json",SERVER_URL];

    NSLog(@"%ld,%ld",[user_defaults integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]);
    
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            
           
            NSMutableArray *json_DATA = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            
                        [[NSUserDefaults standardUserDefaults] setObject:json_DATA forKey:@"menu_detail"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self performSegueWithIdentifier:@"logint_to_home" sender:self];
                        NSLog(@"the api_collection_product%@",json_DATA);
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
