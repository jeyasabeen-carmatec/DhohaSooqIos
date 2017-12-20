//
//  VC_change_Password.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_change_Password.h"

@interface VC_change_Password ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;

}
@end

@implementation VC_change_Password

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _vw_align.center = self.view.center;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
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
    
    
    
}

#pragma textfield delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == _TXT_new_pwd || textField == _TXT_new_pwd)
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{ if (textField == _TXT_old_pwd)
{
    NSInteger inte = textField.text.length;
    if(inte >= 64)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}
    if (textField == _TXT_new_pwd)
    {
        
        
        NSInteger inte = textField.text.length;
        if(inte >= 64)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
            
        }
        
        return YES;
    }
    if (textField == _TXT_confirm_pwd)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 64)
        {
            if ([string isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        return YES;
    }


    
    return YES;
}

- (IBAction)BTN_save_action:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];

    
    NSString *msg;

     if([_TXT_old_pwd.text isEqualToString:@""])
    {
        [_TXT_old_pwd becomeFirstResponder];
        msg = @"Please enter Password";
        
        
    }
    else if(_TXT_old_pwd.text.length < 8)
    {
        [_TXT_old_pwd becomeFirstResponder];
        msg = @"Short passwords are easy to guess. Try one with at least 8 characters";
        
    }
    else if(_TXT_old_pwd.text.length > 64)
    {
        [_TXT_old_pwd becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
    }
   else if([_TXT_new_pwd.text isEqualToString:@""])
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Please enter Password";
        
        
    }
    else if(_TXT_new_pwd.text.length < 8)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Short passwords are easy to guess. Try one with at least 8 characters";
        
    }
    else if(_TXT_new_pwd.text.length > 64)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
    }
    else if([_TXT_confirm_pwd.text isEqualToString:@""])
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Please enter Password";
        
        
    }
    else if(_TXT_confirm_pwd.text.length < 8)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Short passwords are easy to guess. Try one with at least 8 characters";
        
    }
    else if(_TXT_confirm_pwd.text.length > 64)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
    }
    else if(![_TXT_new_pwd.text  isEqualToString:_TXT_confirm_pwd.text])
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"These passwords don't match. Try again?";

    }
    else
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        
        [self performSelector:@selector(API_CALL) withObject:nil afterDelay:0.01];
        
    }
    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

    }
}
-(void)API_CALL
{
    
 
    @try
    {
        NSString *old_pwd = _TXT_old_pwd.text;
        NSString *new_pwd = _TXT_new_pwd.text;
        NSString *confirm_pwd = _TXT_confirm_pwd.text;

        NSDictionary *parameters = @{
                                     @"old_password": old_pwd,
                                     @"password": new_pwd,
                                     @"confirm_password":confirm_pwd
                                     
                                     };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];

        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/change-password/1/%@.json",SERVER_URL,user_id];
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
                
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                [self performSegueWithIdentifier:@"cahnge_password_identofier" sender:self];
                
            }
            else
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
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

- (IBAction)back_action:(id)sender {
    
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
