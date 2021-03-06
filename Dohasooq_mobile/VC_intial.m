//
//  VC_intial.m
//  Dohasooq_mobile
//
//  Created by Test User on 24/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_intial.h"
#import "HttpClient.h"
#import "Helper_activity.h"
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
    self.screenName = @"Splash Screen";
    /*BOOL showCutomAlert = false;
    
    if (showCutomAlert) {
        // Custom
        ATAppUpdater *updater = [ATAppUpdater sharedUpdater];
        [updater setAlertTitle:NSLocalizedString(@"Nuwe Weergawe", @"Alert Title")];
        [updater setAlertMessage:NSLocalizedString(@"Weergawe %@ is beskikbaar op die AppStore.", @"Alert Message")];
        [updater setAlertUpdateButtonTitle:@"Opgradeer"];
        [updater setAlertCancelButtonTitle:@"Nie nou nie"];
        [updater setDelegate:self]; // Optional
        [updater showUpdateWithConfirmation];
        
    } else {
        // Simple
        [[ATAppUpdater sharedUpdater] setDelegate:self]; // Optional
        [[ATAppUpdater sharedUpdater] showUpdateWithConfirmation]; // OR [[ATAppUpdater sharedUpdater] showUpdateWithForce];
    }*/
    
    NSString *str_code = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/lookup?id=1352963798",str_code]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   NSError* parseError;
                                   NSDictionary *appMetadataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                   NSArray *resultsArray = (appMetadataDictionary)?[appMetadataDictionary objectForKey:@"results"]:nil;
                                   NSDictionary *resultsDic = [resultsArray firstObject];
                                   if (resultsDic) {
                                       // compare version with your apps local version
                                       NSString *iTunesVersion = [resultsDic objectForKey:@"version"];
                                       
                                       NSString *appVersion = @"1.2";
                                       
                                       NSLog(@"itunes version = %@\nAppversion = %@",iTunesVersion,appVersion);
                                       
//                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New version available" message:[NSString stringWithFormat:@"%@",appMetadataDictionary] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                                       [alert show];
//                                       
//                                       float itnVer = [iTunesVersion floatValue];
//                                       float apver = [appVersion floatValue];
//                                       
//                                       NSLog(@"The val floet itune %f\nThe val float appver%f",itnVer,apver);
                                       
                                       if (iTunesVersion && [appVersion compare:iTunesVersion] != NSOrderedSame) {
                                           
//                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:<#(nullable NSString *)#> message:<#(nullable NSString *)#> delegate:<#(nullable id)#> cancelButtonTitle:<#(nullable NSString *)#> otherButtonTitles:<#(nullable NSString *), ...#>, nil]
                                           
//                                           UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"Doha Sooq Online Shopping" message:[NSString stringWithFormat:@"New version available. Update required."] cancelButtonTitle:@"update" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           
                                               
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Version Updated %@",iTunesVersion] message:[resultsDic valueForKey:@"releaseNotes"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Update",@"Cancel", nil];
                                           alert.tag = 123456;
                                           [alert show];
//                                           }];
//                                           [alert show];
                                       }
                                   }
                               } else {
                                   // error occurred with http(s) request
                                   NSLog(@"error occurred communicating with iTunes");
                               }
                           }];
    
    
    self.view.hidden = NO;
    self.VW_ceter.hidden =NO;
    self.IMG_logo.hidden = NO;
    [self testInternetConnection];
   


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
    [self performSelector:@selector(IMAGE_PATH_API) withObject:activityIndicatorView afterDelay:0.01];


    
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
    
    
    //[_BTN_next addTarget:self action:@selector(go_to_login) forControlEvents:UIControlEventTouchUpInside];
    
    /***************************/
    
    

}
-(void)country_API_call
{
#pragma country_api_integration Method Calling
    
    @try
    {
        
        [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@countries/index.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    VW_overlay.hidden = YES;
                    [Helper_activity stop_activity_animation:self];

                  
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    NSMutableDictionary *json_DATA = data;
                    if(json_DATA)
                    {
                        [Helper_activity stop_activity_animation:self];

                        
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
                        [Helper_activity stop_activity_animation:self];

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
        [Helper_activity stop_activity_animation:self];

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
        
        
        [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Languages/getLangByCountry/%@.json",SERVER_URL,country_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    VW_overlay.hidden = YES;
                  //  [activityIndicatorView stopAnimating];
                    
                    [Helper_activity stop_activity_animation:self];


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
                            [self performSelector:@selector(IMAGE_PATH_API) withObject:activityIndicatorView afterDelay:0.01];
                        }
                    }

                    
                    [[NSUserDefaults standardUserDefaults] setObject:lang_arr forKey:@"language_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    [Helper_activity stop_activity_animation:self];

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
        [Helper_activity stop_activity_animation:self];

        //[activityIndicatorView stopAnimating];

        
    }
    
    
}


/*-(void)MENU_api_call
{
    
    @try
    {
        [Helper_activity animating_images:self];

        
        NSError *error;
        
        NSHTTPURLResponse *response = nil;
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        //    NSString *urlGetuser =[NSString stringWithFormat:@"%@menuList/%ld/%ld.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];

        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getCategoryList/%@/%@.json",SERVER_URL,country,lang];
        
        NSLog(@"%ld,%ld",(long)[user_defaults integerForKey:@"country_id"],(long)[user_defaults integerForKey:@"language_id"]);
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
            [Helper_activity stop_activity_animation:self];

        }
        
        
        if(aData)
        {
            
            
            NSDictionary *json_DATA = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            
            [Helper_activity stop_activity_animation:self];

            if (![json_DATA count]) {
                
                [HttpClient createaAlertWithMsg:@"Something went to wrong ." andTitle:@""];
                
            }
            else{
            
            
            NSLog(@"the api_collection_product%@",json_DATA);
            [[NSUserDefaults standardUserDefaults] setObject:json_DATA  forKey:@"pho"];
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
        
        
        
        
    }
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];

        NSLog(@"%@",exception);
       //  activityIndicatorView.hidden = YES;
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
       
}
 */
-(void)IMAGE_PATH_API
{
    @try
    {
        
        [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/allImagePaths",SERVER_URL];
        
        
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                    
                    [Helper_activity stop_activity_animation:self];
                }
                @try
                {
                    if (data) {
                        
                        [Helper_activity stop_activity_animation:self];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Images_path"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        //  [self MENU_api_call];
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
                    else
                    {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        
                        
                        
                    }
                }
                @catch(NSException *exception)
                {
                    
                }
                
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        
    }
    
}


#pragma mark Cart Count

-(void)cart_count{
    [Helper_activity animating_images:self];

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
        [Helper_activity stop_activity_animation:self];

        
    }
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
            //            VW_overlay.hidden = YES;
            //            [activityIndicatorView stopAnimating];
            [Helper_activity stop_activity_animation:self];

            
            
        }
        if (data) {
            [Helper_activity stop_activity_animation:self];

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
                
                [Helper_activity stop_activity_animation:self];

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


#pragma mark - Alertview deligate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123456) {
        switch (buttonIndex) {
            case 0:
            {
                NSString *iTunesLink = [NSString stringWithFormat:@"itms://itunes.apple.com/us/app/apple-store/id1352963798?mt=8"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            }
                break;
                
            case 1:
            
                NSLog(@"1");
                break;
            
                
                
            default:
                break;
        }
    }
}

@end
