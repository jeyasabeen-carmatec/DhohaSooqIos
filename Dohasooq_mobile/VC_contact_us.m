//
//  VC_contact_us.m
//  Dohasooq_mobile
//
//  Created by Test User on 07/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_contact_us.h"
#import "UIView+Shadow.h"
#import "HttpClient.h"

@interface VC_contact_us ()<UITextFieldDelegate>
{
    float scroll_ht;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    
    

}
@end

@implementation VC_contact_us

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}
-(void)set_up_VIEW
{
//    _LBL_address.text = @"Doha Bank\n13th Floor,Doha Bank Tower,Near Sheraton\nCorniche Street,West Bay\nPO BOX 3818\nDoha,Qatar";
    [_LBL_address sizeToFit];
    
    _VW_address.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _VW_address.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _VW_address.layer.shadowOpacity = 1.0;
    _VW_address.layer.shadowRadius = 4.0;
    
    CGRect frameset = _VW_address.frame;
    frameset.size.height = _LBL_address.frame.origin.y + _LBL_address.frame.size.height;
    _VW_address.frame = frameset;
    
    
    frameset = _VW_contact_us.frame;
    frameset.origin.y = _VW_address.frame.origin.y + _VW_address.frame.size.height + 10;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_contact_us.frame = frameset;
    
    frameset = _BTN_submit.frame;
    frameset.origin.y = _VW_contact_us.frame.origin.y + _VW_contact_us.frame.size.height + 10;
    _BTN_submit.frame = frameset;
    
    frameset = _VW_contents.frame;
    frameset.size.height = _BTN_submit.frame.origin.y + _BTN_submit.frame.size.height + 10;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_contents.frame = frameset;
    [self.Scroll_contents addSubview:_VW_contents];
    scroll_ht = _BTN_submit.frame.origin.y + _BTN_submit.frame.size.height;
    [_BTN_submit addTarget:self action:@selector(contact_SUBMIT) forControlEvents:UIControlEventTouchUpInside];
    
  
    
    
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
    [self address_API];
    
    
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(address_API) withObject:activityIndicatorView afterDelay:0.01];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scroll_ht);
}
#pragma text field delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField)
    {
        scroll_ht = scroll_ht + 100;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField)
    {
        scroll_ht = scroll_ht - 100;
        [self viewDidLayoutSubviews];
    }
    
    
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)contact_SUBMIT
{
    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSString *msg;
    if ([_TXT_F_name.text isEqualToString:@""])
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @"Please enter  Name field";
        
    }
    else if(_TXT_F_name.text.length < 3)
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @" Name should not be less than 3 characters";
        
    }
    else if([_TXT_F_name.text isEqualToString:@" "])
    {
        [_TXT_F_name becomeFirstResponder];
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
//       else if (_TXT_phone.text.length < 2)
//    {
//        [_TXT_phone becomeFirstResponder];
//        msg = @"Phone Number cannot be less than 5 digits";
//        
//    }
//    else if(_TXT_phone.text.length>15)
//    {
//        [_TXT_phone becomeFirstResponder];
//        msg = @"Phone Number should not be more than 15 characters";
//        
//        
//    }
    else if([_TXT_message.text isEqualToString:@""])
    {
        [_TXT_message becomeFirstResponder];
        msg = @"Please enter Message";
        
    }
    else{
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(address_post_API) withObject:activityIndicatorView afterDelay:0.01];

    }
       if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }

   
}
-(void)address_API
{
    @try {
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];

    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/contactInfo/%@.json",SERVER_URL,country];

    NSURL *URL = [[NSURL alloc] initWithString:urlGetuser];
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        char double_qode = '"';
        NSString *double_q = [NSString stringWithFormat:@"%c",double_qode];
        xmlString = [xmlString stringByReplacingOccurrencesOfString:double_q withString:@""];
    _LBL_address.text = xmlString;
     [self set_up_VIEW];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    }
    @catch(NSException *exception)
    {
        
    }
    

}
-(void)address_post_API
{
    @try
    {
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *fname = _TXT_F_name.text;
        NSString *email = _TXT_email.text;
        NSString *phone = _TXT_phone.text;
        NSString *company = _TXT_organisation.text;
        NSString *msg = _TXT_message.text;

        NSDictionary *parameters = @{
                                     @"name":fname,
                                     @"email":email,
                                     @"phnumber":phone,
                                     @"company":company,
                                     @"message":msg
                                     };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/contactus/%@.json",SERVER_URL,country];
         urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(aData)
        {
            
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"%@",error);
            NSLog(@"The response Api   sighn up API %@",json_DATA);
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            
        
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
