//
//  VC_sign_up.m
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_sign_up.h"

@interface VC_sign_up ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    float scroll_height;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;

}
@end

@implementation VC_sign_up

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    
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
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
     [self set_UP_View];

}
-(void)set_UP_View
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    
    //[self.Scroll_contents addSubview:_LBL_sign_up];
    CGRect setup_frame  = _VW_contents.frame;
   // setup_frame.origin.y = _LBL_sign_up.frame.origin.y + _LBL_sign_up.frame.size.height + 20;
    setup_frame.size.width = _Scroll_contents.frame.size.width;
    setup_frame.size.height = _BTN_close.frame.origin.y + _BTN_close.frame.size.height+ 20;
    _VW_contents.frame = setup_frame;
    [self.Scroll_contents addSubview:_VW_contents];
    
    setup_frame = _BTN_close.frame;
    setup_frame.origin.x = self.view.frame.size.width / 2;
    _BTN_close.frame = setup_frame;
    
     scroll_height =_VW_contents.frame.origin.y+ _VW_contents.frame.size.height;
    
    UIImage *newImage = [_BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_BTN_close.image.size, NO, newImage.scale);
    [[UIColor darkGrayColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _BTN_close.image.size.width/2, newImage.size.height/2)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _BTN_close.image = newImage;
    
    _BTN_close .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    [_BTN_close addGestureRecognizer:tapGesture1];
    [_BTN_submit addTarget:self action:@selector(submit_Action) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)tapGesture_close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scroll_height);

    
}
#pragma textfield delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField)
    {
        scroll_height = scroll_height + 120;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField)
    {
        scroll_height = scroll_height - 120;
        [self viewDidLayoutSubviews];
    }
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==1)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 30)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    if(textField.tag==2)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 30)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    if(textField.tag==3)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 15)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789()+- "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
 return YES;
}
#pragma Button Actions
-(void)submit_Action
{
    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSString *text_to_comapre_apss = _TXT_password.text;
    NSPredicate *pass_test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pass_RegEx];
   
    NSString *msg;
    if ([_TXT_F_name.text isEqualToString:@""])
    {
         [_TXT_F_name becomeFirstResponder];
         msg = @"Please enter First Name field";
       
    }
    else if(_TXT_F_name.text.length < 3)
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @"First name should not be less than 3 characters";
        
    }
      else if([_TXT_F_name.text isEqualToString:@" "])
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
   }
    else if ([_TXT_L_name.text isEqualToString:@""])
    {
        [_TXT_L_name becomeFirstResponder];
        msg = @"Please enter Last Name field";
        
    }
    else if(_TXT_L_name.text.length < 1)
    {
        [_TXT_L_name becomeFirstResponder];
        msg = @"Last name should not be less than 1 character";
      
        
    }
      else if([_TXT_L_name.text isEqualToString:@" "])
    {
        [_TXT_L_name becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
        
    }
    else if([_TXT_email.text isEqualToString:@""])
    {
         [_TXT_email becomeFirstResponder];
         msg = @"Please enter Email";
       
    }

     else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
         [_TXT_email becomeFirstResponder];
         msg = @"Please enter valid email address";
       
        
      
    }
     else if ([_TXT_phone.text isEqualToString:@""])
     {
          [_TXT_phone becomeFirstResponder];
          msg = @"Please enter Phone Number";
        
        
         
     }

    else if (_TXT_phone.text.length < 5)
    {
         [_TXT_phone becomeFirstResponder];
         msg = @"Phone Number cannot be less than 5 digits";
       
        
       
    }
    else if(_TXT_phone.text.length>15)
    {
         [_TXT_phone becomeFirstResponder];
          msg = @"Phone Number should not be more than 15 characters";
       
      
    }
    else if([_TXT_phone.text isEqualToString:@" "])
    {
          [_TXT_phone becomeFirstResponder];
         msg = @"Blank space are not allowed";
      
       
    }
    else if([_TXT_password.text isEqualToString:@""])
    {
         [_TXT_password becomeFirstResponder];
        msg = @"Please enter Password";
       
        
    }
    else if(_TXT_password.text.length < 8)
    {
         [_TXT_password becomeFirstResponder];
        msg = @"Short passwords are easy to guess. Try one with at least 8 characters";
       
    }
    else if(_TXT_password.text.length > 64)
    {
        [_TXT_password becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
    }
    else if([pass_test evaluateWithObject:text_to_comapre_apss] == NO)
    {
        [_TXT_password becomeFirstResponder];
        msg = @"Password should contain at least one special character,one numeral,one uppercase letter";
        
    }
    else if(_TXT_con_password.text.length == 0)
    {
        [_TXT_password becomeFirstResponder];
        msg = @"Please confirm password";
    }
    else if(![_TXT_con_password.text isEqualToString:_TXT_password.text])
    {
        [_TXT_con_password becomeFirstResponder];
         msg = @"These passwords don't match. Try again?";
    }
    
    else
    {
        [self.view endEditing:TRUE];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(_sign_up_api_integration) withObject:activityIndicatorView afterDelay:0.01];
        
    }
    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

    }
   // [self performSegueWithIdentifier:@"" sender:self];
    
   
}
#pragma API call
-(void)_sign_up_api_integration
{
    @try
    {
    NSString *fname = _TXT_F_name.text;
    NSString *lname = _TXT_L_name.text;
    NSString *email = _TXT_email.text;
    NSString *phone_num = _TXT_phone.text;
    NSString *password = _TXT_password.text;
    NSString *confirm_apssword = _TXT_con_password.text;
    NSError *error;
    NSError *err;
    NSHTTPURLResponse *response = nil;
   
    NSDictionary *parameters = @{ @"firstname": fname,
                                  @"lastname": lname,
                                  @"email": email,
                                  @"phone": phone_num,
                                  @"password": password,
                                  @"password2":confirm_apssword
                                  };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
    NSLog(@"the posted data is:%@",parameters);
    NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/signup/1.json",SERVER_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response Api post sighn up API %@",json_DATA);
        NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"status"]];
        NSString *msg = [json_DATA valueForKey:@"message"];


        if([status isEqualToString:@"1"])
        {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];

            //[self performSegueWithIdentifier:@"normalsighnuptoinitialVC" sender:self];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
