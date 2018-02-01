//
//  VC_intial.m
//  Dohasooq_mobile
//
//  Created by Test User on 24/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_intial.h"
#import "HttpClient.h"
//#import "Helper_activity.h"
#import "ViewController.h"
#import "Home_page_Qtickets.h"
#import "Reachability.h"
#import "UIImage+animatedGIF.h"

@interface VC_intial ()<UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *country_arr,*lang_arr;
    NSMutableDictionary *temp_dict;
    NSString *country_ID;
    Home_page_Qtickets *QT;
    NSTimer *timer;
    UIView *VW_overlay;
    UIImageView *activityIndicatorView;
    Reachability *internetReachableFoo;
}

@end

@implementation VC_intial

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = NO;
    self.VW_ceter.hidden =NO;
    self.IMG_logo.hidden = NO;
    [self testInternetConnection];
   
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Loader-2" withExtension:@"gif"];
//    activityIndicatorView.image = [UIImage animatedImageWithAnimatedGIFURL:url];                [self performSelector:@selector(country_API_call) withObject:activityIndicatorView afterDelay:0.01];


      }

- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
            NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            lang = [lang stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            lang = [lang stringByReplacingOccurrencesOfString:@"null" withString:@""];
            lang = [lang stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            country = [country stringByReplacingOccurrencesOfString:@"null" withString:@""];
            country = [country stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            if([lang isEqualToString:@""] || [country isEqualToString:@""])
            {
                
                VW_overlay.hidden = NO;
             
            }
            else if([lang isEqualToString:@"()"] || [country isEqualToString:@"()"])
            {
                VW_overlay.hidden = NO;
                [self performSelector:@selector(country_API_call) withObject:activityIndicatorView afterDelay:0.01];
                
            }
            else
            {
                    [self start];
                
                
            }
            

        });
    };
    
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str_alert = @"No Internet Connection!";
            NSString *str_ok = @"Ok";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                str_alert = @"لا يوجد اتصال بالإنترنت!";
                str_ok = @"حسنا";
            }


            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_alert delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
            [alert show];
        });
    };
    
    [internetReachableFoo startNotifier];
}
-(void)start
{
     
    //self.IMG_back_otal.image = [UIImage imageNamed:@"11-DS-Splash.jpg"];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(targetMethod)
                                           userInfo:nil
                                            repeats:NO];
}
-(void)targetMethod
{
    [timer invalidate];
    VW_overlay.hidden = NO;
  //  [activityIndicatorView startAnimating];
    [self cart_count];
    [self performSelector:@selector(API_call) withObject:activityIndicatorView afterDelay:0.01];


    
}
-(void)picker_set_UP
{
    _country_lang_picker = [[UIPickerView alloc] init];
    _country_lang_picker.delegate = self;
    _country_lang_picker.dataSource = self;
    
    _lang_picker = [[UIPickerView alloc] init];
    _lang_picker.delegate = self;
    _lang_picker.dataSource = self;

    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.origin.x -20, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:close];
    
    UIButton *Done=[[UIButton alloc]init];
    Done.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [Done setTitle:@"Done" forState:UIControlStateNormal];
    [Done addTarget:self action:@selector(done_button_click) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:Done];

    _TXT_country.inputAccessoryView=conutry_close;
    _TXT_language.inputAccessoryView=conutry_close;
    _TXT_language.inputView = _lang_picker;
    _TXT_country.inputView = _country_lang_picker;
    _TXT_language.tintColor = [UIColor clearColor];
    _TXT_country.tintColor = [UIColor clearColor];
    
    



}
-(void)countrybuttonClick
{
    _TXT_country.text = @"";
    _TXT_language.text = @"";
    [_TXT_language resignFirstResponder];
    [_TXT_country resignFirstResponder];
}
-(void)done_button_click
{
    if( [_TXT_country.text isEqualToString:@""] && [_TXT_language.text isEqualToString:@""])
    {
       // language_id
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    [_TXT_language resignFirstResponder];
    [_TXT_country resignFirstResponder];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
        VW_overlay.layer.cornerRadius = 10.0;
    // Custom Activity Indicator
 // [Helper_activity animating_images:self];

    VW_overlay.hidden = YES;
    
}



-(void)set_UP_VW
{
      [self picker_set_UP];

    _VW_ceter.center = self.view.center;
    
    
    CGRect frameset = _IMG_logo.frame;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
         frameset.origin.y = _VW_ceter.frame.origin.y - 40;
    }
    else if(result.height <= 568)
    {
         frameset.origin.y = _VW_ceter.frame.origin.y - 60;
    }
    else
    {
        frameset.origin.y = _VW_ceter.frame.origin.y - 70;

    }
    _IMG_logo.frame = frameset;
    
    
    [_BTN_next addTarget:self action:@selector(go_to_login) forControlEvents:UIControlEventTouchUpInside];
    
    //[self country_api_call];
    /***************************/
    
    

}
-(void)country_API_call
{
#pragma country_api_integration Method Calling
    
    @try
    {
        
       // [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@countries/index.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    VW_overlay.hidden = YES;
                  
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    NSMutableDictionary *json_DATA = data;
                    if(json_DATA)
                    {
                    
                    country_arr = [[NSMutableArray alloc]init];
                    NSMutableArray *temp_arr = [json_DATA valueForKey:@"countries"];
                        
                        NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
                        sortedArray = temp_arr;
                        
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                     ascending:YES];
                        NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                        [country_arr addObjectsFromArray:srt_arr];
                        for(int i=0;i<country_arr.count;i++)
                        {
                            if([[[country_arr objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"Qatar"])
                            {
                                country_ID = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:i] valueForKey:@"id"]];
                                [[NSUserDefaults standardUserDefaults] setInteger:[country_ID integerValue] forKey:@"country_id"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [self  language_API_calling:country_ID];
                                
                                

                            }
                        }

                        
                    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                 
                        
                        
                   // [_TBL_list_coutry reloadData];
                    }
                    else{
                      
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        VW_overlay.hidden = YES;
                      //  [activityIndicatorView stopAnimating];


                    }
                    
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        VW_overlay.hidden = YES;
        //[activityIndicatorView stopAnimating];

    }
    
  //[Helper_activity stop_activity_animation:self];
}
#pragma Picker delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _country_lang_picker)
    {
    return country_arr.count;
    }
    else{
        return lang_arr.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == _country_lang_picker)
    {
    @try {
            
//            _TXT_country.text = [country_arr [0] valueForKey:@"name"];
//             country_ID = [NSString stringWithFormat:@"%@",[country_arr [0] valueForKey:@"id"]];
//            
//              [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"country_id"];
//              [[NSUserDefaults standardUserDefaults] setInteger:[[country_arr [0] valueForKey:@"id"] integerValue] forKey:@"country_id"];
//              [[NSUserDefaults standardUserDefaults]synchronize];
//        
//            [self language_API_calling];
            return [country_arr [row] valueForKey:@"name"];
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }

    }
    else{
        @try {
            
//            _TXT_language.text = [lang_arr [0]valueForKey:@"language_name"];
//            
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language_id"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language"];
//            
//            [[NSUserDefaults standardUserDefaults] setInteger:[[lang_arr [0]valueForKey:@"id"] integerValue] forKey:@"language_id"];
//            [[NSUserDefaults standardUserDefaults] setValue: [lang_arr [0]valueForKey:@"language_name"] forKey:@"language"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
            
            
            
            
             return  [lang_arr [row]valueForKey:@"language_name"];
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    }

   }
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];

    if(pickerView == _country_lang_picker)
    {
       _TXT_country.text = [country_arr [row] valueForKey:@"name"];
        country_ID = [NSString stringWithFormat:@"%@",[country_arr [row] valueForKey:@"id"]];
        _TXT_language.text = @"";
        
        
        [usd removeObjectForKey:@"country_id"];
        [usd setInteger:[[country_arr [row] valueForKey:@"id"] integerValue] forKey:@"country_id"];
        [usd synchronize];
        
       

    }
    else
    {
        _TXT_language.text = [lang_arr [row]valueForKey:@"language_name"];
        
        [usd removeObjectForKey:@"language_id"];
        [usd removeObjectForKey:@"language"];
        
        [usd setInteger:[[lang_arr [row]valueForKey:@"id"] integerValue] forKey:@"language_id"];
        [usd setValue: [lang_arr [row]valueForKey:@"language_name"] forKey:@"language"];
        [usd synchronize];

    }
  }

#pragma mark Language API Integration
-(void)language_API_calling : (NSString *)country_id{
  
    @try
    {
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Languages/getLangByCountry/%@.json",SERVER_URL,country_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    VW_overlay.hidden = YES;
                  //  [activityIndicatorView stopAnimating];

                    NSMutableDictionary *json_DATA = data;
                    //                        lang_arr = [NSMutableArray array];
                    //                        lang_arr = [json_DATA valueForKey:@"languages"];
                    lang_arr = [[NSMutableArray alloc]init];
                    NSMutableArray *temp_arr = [json_DATA valueForKey:@"languages"];
                    
                    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
                    sortedArray = temp_arr;
                    
                    
                    NSSortDescriptor *sortDescriptor;
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"language_name"
                                                                 ascending:YES];
                    NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                    
                    //   NSMutableDictionary *dictMutable = [srt_arr mutableCopy];
                    for(int i = 0;i<srt_arr.count;i++)
                    {
                        NSMutableDictionary *dictMutable = [[srt_arr objectAtIndex:i] mutableCopy];
                        [dictMutable removeObjectsForKeys:[[srt_arr objectAtIndex:i] allKeysForObject:[NSNull null]]];
                        [lang_arr addObject:dictMutable];
                            }
                    
                    for(int j=0;j<lang_arr.count;j++)
                    {
                        if([[[lang_arr objectAtIndex:j] valueForKey:@"language_name"] isEqualToString:@"English (US)"])
                        {
                            [[NSUserDefaults standardUserDefaults] setInteger:[[[lang_arr objectAtIndex:j]valueForKey:@"id"] integerValue] forKey:@"language_id"];
                            [[NSUserDefaults standardUserDefaults] setValue: [[lang_arr  objectAtIndex:j]valueForKey:@"language_name"] forKey:@"language"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self performSelector:@selector(API_call) withObject:activityIndicatorView afterDelay:0.01];
                        }
                    }

                    
                    [[NSUserDefaults standardUserDefaults] setObject:lang_arr forKey:@"language_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    VW_overlay.hidden = YES;
                   // [activityIndicatorView stopAnimating];

                }
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        VW_overlay.hidden = YES;
        //[activityIndicatorView stopAnimating];

        
    }
    
    
}


-(void)language_api_call{
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Languages/getLangByCountry/%@.json",SERVER_URL,country_ID];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            //NSLog(@"The response Api post sighn up API %@",json_DATA);
            
            lang_arr = [json_DATA valueForKey:@"languages"];
            
                      //NSLog(@"%@",lang_arr);
          
            
            
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
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
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];

        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/menuList/%@/%@.json",SERVER_URL,country,lang];
        
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
            
          
            
          //  [self performSegueWithIdentifier:@"logint_to_home" sender:self];
            
            NSLog(@"the api_collection_product%@",json_DATA);
            [[NSUserDefaults standardUserDefaults] setObject:json_DATA forKey:@"pho"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            VW_overlay.hidden = YES;
           // [self dismissViewControllerAnimated:NO completion:nil];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
                
                Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:controller];
                navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
                navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                [self  presentViewController:navigationController animated:NO completion:nil];
                
            }

            else{
           [self performSegueWithIdentifier:@"home_page_identifier" sender:self];
            }

        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
       //  activityIndicatorView.hidden = YES;
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
       
}
-(void)API_call
{
    
        @try
        {
          //  [Helper_activity animating_images:self];
            
            /**********   After passing Language Id and Country ID ************/
            NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
           
            NSString *user_id;
            @try
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                if(dict.count == 0)
                {
                    user_id = @"(null)";
                }
                else
                {
                    NSString *str_id = @"user_id";
                    // NSString *user_id;
                    for(int i = 0;i<[[dict allKeys] count];i++)
                    {
                        if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
                        {
                            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                            break;
                        }
                        else
                        {
                            
                            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                        }
                        
                    }
                }
            }
            @catch(NSException *exception)
            {
                user_id = @"(null)";
                
            }
            
            NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/home/%ld/%ld/%@/Customer.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"],user_id];            NSLog(@"country id %ld ,language id %ld",[user_defaults integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]);
            
            
            
            urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                        
                     //   [Helper_activity stop_activity_animation:self];
                    }
                    if (data) {
                        
                        [self MENU_api_call];
                        [self IMAGE_PATH_API];

                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Home_data"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self performSegueWithIdentifier:@"home_page_identifier" sender:self];

                        
                    }
                    else
                    {
                      //  [Helper_activity stop_activity_animation:self];
                        //                        VW_overlay.hidden = YES;
                        //                        [activityIndicatorView stopAnimating];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        // [self viewWillAppear:NO];
                        
                        
                        
                    }
                    
                   // [Helper_activity stop_activity_animation:self];
                    
                });
            }];
        }
        @catch(NSException *exception)
        {
            NSLog(@"The error is:%@",exception);
            [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
            //        VW_overlay.hidden = YES;
            //        [activityIndicatorView stopAnimating];
            // [self viewWillAppear:NO];
           // [Helper_activity stop_activity_animation:self];
            
        }
        
        
    

}
-(void)IMAGE_PATH_API
{
    @try
    {
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/allImagePaths",SERVER_URL];
    
    
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                
                //   [Helper_activity stop_activity_animation:self];
            }
            @try
            {
            if (data) {
                
                
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Images_path"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
            else
            {
                //  [Helper_activity stop_activity_animation:self];
                //                        VW_overlay.hidden = YES;
                //                        [activityIndicatorView stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                // [self viewWillAppear:NO];
                
                
                
            }
            }
            @catch(NSException *exception)
            {
                
            }
            
            // [Helper_activity stop_activity_animation:self];
            
        });
    }];
    }
        @catch(NSException *exception)
        {
            
        }

}
-(void)cart_count{
    
    NSString *user_id;
    @try
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        if(dict.count == 0)
        {
            user_id = @"(null)";
        }
        else
        {
            NSString *str_id = @"user_id";
            // NSString *user_id;
            for(int i = 0;i<[[dict allKeys] count];i++)
            {
                if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
                {
                    user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                    break;
                }
                else
                {
                    
                    user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                }
                
            }
        }
    }
    @catch(NSException *exception)
    {
        user_id = @"(null)";
        
    }
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
            //            VW_overlay.hidden = YES;
            //            [activityIndicatorView stopAnimating];
            
            
        }
        if (data) {
            NSLog(@"cart count sadas %@",data);
            NSDictionary *dict = data;
            @try {
                
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
                //   NSString *wishlist = [NSString stringWithFormat:@"%@",[dict valueForKey:@"wishlistcount"]];
                [[NSUserDefaults standardUserDefaults] setValue:badge_value forKey:@"cart_count"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                
            } @catch (NSException *exception) {
                //                 VW_overlay.hidden = YES;
                //                [activityIndicatorView stopAnimating];
                
                
                NSLog(@"asjdas dasjbd asdas iccxv %@",exception);
            }
            
        }
    }];
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
