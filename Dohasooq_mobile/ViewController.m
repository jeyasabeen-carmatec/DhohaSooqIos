//
//  ViewController.m
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import <Google/SignIn.h>


@interface ViewController ()<UITextFieldDelegate,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSDictionary *social_dictl;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*************** Google SignIn ***************/
    // Receive signed user information from AppDelegate.m
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"GoogleUserInfo" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        NSString *userId = [note.userInfo objectForKey:@"userId"];
//        NSString *idToken = [note.userInfo objectForKey:@"idToken"];
//        NSString *accessToken = [note.userInfo objectForKey:@"accessToken"];
//        NSString *userName = [note.userInfo objectForKey:@"userName"];
//        NSString *userEmail = [note.userInfo objectForKey:@"userEmail"];
//        
//        NSLog(@"ISUGoogleViewController ===> [1] ID : %@ | [2] idToken : %@ | [3] accessToken : %@ | [4] name : %@ | [5] email : %@",
//              userId, idToken, accessToken, userName, userEmail);
//        
//          }];
//    
    
    
    // Region start
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Create google button instance
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    // Region end
    [self set_UP_View];
    
}
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [activityIndicatorView stopAnimating];
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
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];

    
}

-(void)set_UP_View
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
    
    
    
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
    
    _TXT_username.text = @"venugopal@mailinator.com";
    _TXT_password.text = @"qazplm123";
    
    [_BTN_facebook addTarget:self action:@selector(facebook_action:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Google_PLUS addTarget:self action:@selector(Google_PLUS_ACTIOn) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_guest addTarget:self action:@selector(guest_action) forControlEvents:UIControlEventTouchUpInside];


    
    
    
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
-(void)Google_PLUS_ACTIOn
{
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
  
  [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    
    [[GIDSignIn sharedInstance] signOut];

    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *accessToken = user.authentication.accessToken;
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    // ...
    NSLog(@"AppDelegate ===> [1] ID : %@ | [2] idToken : %@ | [3] accessToken : %@ | [4] name : %@ | [5] email : %@", user.userID,user.authentication.idToken, user.authentication.accessToken, user.profile.name, user.profile.email);
    
    
    // Notify to ISUGoogleViewController class to regist
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, @"userId",
                          idToken, @"idToken",
                          accessToken, @"accessToken",
                          name, @"userName",
                          email, @"userEmail",
                          nil];
    NSString *str = [dict valueForKey:@"userName"];
    NSArray *arr = [str componentsSeparatedByString:@" "];
    NSLog(@"The first name is:%@",[arr objectAtIndex:0]);
    NSString *first_name = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
    NSString *last_name = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
    NSString *emails = [NSString stringWithFormat:@"%@",[dict valueForKey:@"userEmail"]];


    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(google_LOGIN) withObject:activityIndicatorView afterDelay:0.01];
    [self Google_plus_login:first_name:last_name:emails];

    

    
    
    
   
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleUserInfo" object:[UIApplication sharedApplication].keyWindow.rootViewController userInfo:dict];
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
/***************** Google Sign In ******************/


- (IBAction)forgot_pwd_action:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
}
-(void)sign_up_action
{
    [self performSegueWithIdentifier:@"sign_up_segue" sender:self];
}
-(void)facebook_action:(UIButton*)sender{
    
    NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
    NSLog(@"Token:%@",fbAccessToken);
    if([[NSUserDefaults standardUserDefaults]  objectForKey:@"login_details"])
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_details"];
        NSLog(@"dict ------ %@",dict);
        
        
    }

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
   // login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login
     logInWithReadPermissions: @[@"email",@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error)
         {
             NSLog(@"Process error");
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
             [login logOut];
             //[FBSDKProfile setCurrentProfile:nil];

         }
         else
         {
              NSLog(@"RESULT - %@",result.token.userID);
             [self getFacebookProfileInfo:result.token.userID];

         }
     }];

}
-(void)getFacebookProfileInfo:(NSString *)user_ID {
    
//    
//    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@"id,name,email" forKey:@"fields"];
//    
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                  id result, NSError *error) {
//         NSLog(@"result:%@",result);
//        // aHandler(result, error);
//     }];
//    
    if([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,first_name,last_name,picture,email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
        {
            if(!error)
            {
                NSLog(@"THE RESPOBSE - :%@",result);
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"login_details"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                social_dictl = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_details"];
                NSLog(@"dict ------ %@",social_dictl);
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(Facebook_login) withObject:activityIndicatorView afterDelay:0.01];

               // [self Facebook_login];
                

                
            }
        }];
        
    }
    
        
}
    - (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
error:(NSError *)error{
    NSLog(@"LOGGED IN TO FACEBOOK");
   // [self fetchUserInfo];
}
-(void)google_LOGIN
{
    
}
-(void)Google_plus_login:(NSString *)f_name :(NSString *)l_name :(NSString *)e_mail
{
    
        NSString *type = @"Google_Plus";
        NSString *first_name = f_name;
        NSString *last_name = l_name;
        NSString *email = e_mail;

        NSDictionary *parameters = @{
                                     @"login_type": type,
                                     @"email": email,
                                     @"first_name": first_name,
                                     @"last_name": last_name

                                     };
        
        @try
        {
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
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            
           json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            if([status isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary *dictMutable = [[json_DATA valueForKey:@"detail"] mutableCopy];
                [dictMutable removeObjectsForKeys:[[json_DATA valueForKey:@"detail"] allKeysForObject:[NSNull null]]];
                
                 [[NSUserDefaults standardUserDefaults] setValue:dictMutable forKey:@"userdata"];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
    }

    
}

-(void)Facebook_login
{
    @try
    {
        NSString *type = @"Facebook";
        NSString *first_name = [NSString stringWithFormat:@"%@",[social_dictl valueForKey:@"first_name"]];
        NSString *last_name = [NSString stringWithFormat:@"%@",[social_dictl valueForKey:@"last_name"]];
        NSString *email = [NSString stringWithFormat:@"%@",[social_dictl valueForKey:@"email"]];
        
        NSDictionary *parameters = @{
                                     @"login_type": type,
                                     @"email": email,
                                     @"first_name": first_name,
                                     @"last_name": last_name
                                     
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
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            if([status isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary *dictMutable = [[json_DATA valueForKey:@"detail"] mutableCopy];
                [dictMutable removeObjectsForKeys:[[json_DATA valueForKey:@"detail"] allKeysForObject:[NSNull null]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:dictMutable forKey:@"userdata"];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
    }
    
    
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
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
                
                [[NSUserDefaults standardUserDefaults] setObject:[json_DATA valueForKey:@"detail"] forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults]setObject:self.TXT_username.text forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"user_email"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                
                [self MENU_api_call];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            }
            else
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;

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
        
        NSLog(@"%ld,%ld",(long)[user_defaults integerForKey:@"country_id"],(long)[user_defaults integerForKey:@"language_id"]);
        
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
-(void)guest_action
{
    [self performSegueWithIdentifier:@"logint_to_home" sender:self];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
