//
//  VC_intial.m
//  Dohasooq_mobile
//
//  Created by Test User on 24/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_intial.h"
#import "HttpClient.h"
#import "ViewController.h"
#import "Home_page_Qtickets.h"

@interface VC_intial ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *country_arr,*lang_arr;
    NSMutableDictionary *temp_dict;
    NSString *country_ID;
    Home_page_Qtickets *QT;
    NSTimer *timer;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_intial

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = NO;
    self.VW_ceter.hidden =NO;
    self.IMG_logo.hidden = NO;
    self.IMG_back_otal.image = [UIImage imageNamed:@"Log in.jpg"];


     [self set_UP_VW];
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
        [self set_UP_VW];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(country_API_call) withObject:activityIndicatorView afterDelay:0.01];
    }
    else if([lang isEqualToString:@"()"] || [country isEqualToString:@"()"])
    {
          [self set_UP_VW];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(country_API_call) withObject:activityIndicatorView afterDelay:0.01];

    }
    else
    {
        //          QT = [self.storyboard instantiateViewControllerWithIdentifier:@"QT_controller"];
        //
        //[self  presentViewController:QT animated:NO completion:nil];
        [self start];
        
       // [self performSegueWithIdentifier:@"home_page_identifier" sender:self];
        
    }
    
}
-(void)start
{
    self.VW_ceter.hidden =YES;
    self.IMG_logo.hidden = YES;
    self.IMG_back_otal.image = [UIImage imageNamed:@"11-DS-Splash.jpg"];
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
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(MENU_api_call) withObject:activityIndicatorView afterDelay:0.01];


    
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
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.view addSubview:VW_overlay];
    
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
    //country_arr = [[NSMutableArray alloc]init];
    
//    CGRect frameset = _TBL_list_coutry.frame;
//    frameset.origin.x =_TXT_country.frame.origin.x;
//    frameset.origin.y =_TXT_country.frame.origin.y + _TXT_country.frame.size.height + 5;
//    frameset.size.width = _TXT_country.frame.size.width;
//    frameset.size.height = 120;
//    _TBL_list_coutry.frame = frameset;
//    
//    frameset = _TBL_list_lang.frame;
//    frameset.origin.x =_TXT_language.frame.origin.x;
//    frameset.origin.y =_TXT_language.frame.origin.y + _TXT_language.frame.size.height + 5;
//    frameset.size.width = _TXT_language.frame.size.width;
//    frameset.size.height = 120;
//    _TBL_list_lang.frame = frameset;
//    
    
    
    [_BTN_next addTarget:self action:@selector(go_to_login) forControlEvents:UIControlEventTouchUpInside];
    
    //[self country_api_call];
    /***************************/
    
    

}
-(void)country_API_call
{
#pragma country_api_integration Method Calling
    
    @try
    {
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@countries/index.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    NSMutableDictionary *json_DATA = data;
                    if(json_DATA)
                    {
                    
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                            country_arr = [[NSMutableArray alloc]init];
                    NSMutableArray *temp_arr = [json_DATA valueForKey:@"countries"];
                        
                        NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
                        sortedArray = temp_arr;
                        
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                     ascending:YES];
                        NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                        [country_arr addObjectsFromArray:srt_arr];
                        

                        
                    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                   // [_TBL_list_coutry reloadData];
                    }
                    else{
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];

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
    }
    

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
        
        [self language_API_calling];

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
-(void)language_API_calling{
  
    @try
    {
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Languages/getLangByCountry/%@.json",SERVER_URL,country_ID];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
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
                    [[NSUserDefaults standardUserDefaults] setObject:lang_arr forKey:@"language_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        
    }
    
    
}

-(void)go_to_login
{
    NSString *msg;
    if([_TXT_country.text isEqualToString:@""])
    {
        [_TXT_country becomeFirstResponder];
        msg = @"Please select country";
        
    }
    else if([_TXT_language.text isEqualToString:@""])
    {
          [_TXT_language becomeFirstResponder];
        msg = @"please select language";
    }
    else
    {
    
         if ([self.TXT_language.text isEqualToString:@"Arabic"])
         {
             
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"story_board_language"];
        [[NSUserDefaults  standardUserDefaults] setValue:_TXT_language.text forKey:@"story_board_language"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
        
        Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:controller];
        [self  presentViewController:navigationController animated:NO completion:nil];
        
            }
            else
             {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"story_board_language"];
                [self performSegueWithIdentifier:@"home_page_identifier" sender:self];
             // [self  presentViewController:QT animated:NO completion:nil];
             //[self performSegueWithIdentifier:@"intial_login" sender:self];
               
             }
    
//     [[NSUserDefaults standardUserDefaults] setObject:lang_arr forKey:@"languages"];
    
    [[NSUserDefaults  standardUserDefaults] setValue:_TXT_language.text forKey:@"languge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

    }
}
#pragma textfield delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_TXT_country resignFirstResponder];
    [_TXT_language resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(textField == _TXT_country)
//    {
//        _TBL_list_coutry.hidden = NO;
//        _TBL_list_lang.hidden  =YES;
//        
//    }
//    else if(textField == _TXT_language)
//    {
//        _TBL_list_lang.hidden  =NO;
//        _TBL_list_coutry.hidden = YES;
//    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if(textField == _TXT_country)
//    {
//        _TBL_list_coutry.hidden = YES;
//    }
//    else if(textField == _TXT_language)
//    {
//        _TBL_list_coutry.hidden = YES;
//    }
    
}
#pragma tableview delgates
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(tableView == _TBL_list_coutry)
//    {
//        return country_arr.count;
//    }
//    else
//        return lang_arr.count;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == _TBL_list_coutry)
//    {
//        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
//        temp_dict = [country_arr objectAtIndex:indexPath.row];
//        
//        
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//        }
//        cell.textLabel.text = [temp_dict valueForKey:@"name"];
//        return cell;
//    }
//    else
//    {
//        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
//        
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//        }
//        if(lang_arr.count == 0)
//        {
//            cell.textLabel.text = @"please select Country";
//            
//        }
//        else
//        {
//            cell.textLabel.text = [[lang_arr objectAtIndex:indexPath.row]valueForKey:@"language_name"];
//        }
//        return cell;
//        
//    }
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
//    if(tableView == _TBL_list_coutry)
//    {
//        _TBL_list_coutry.hidden = YES;
//        //NSLog(@"%@",country_arr);
//        _TXT_country.text = [[country_arr objectAtIndex:indexPath.row] valueForKey:@"name"];
//        country_ID = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:indexPath.row] valueForKey:@"id"]];
//        _TXT_language.text = @"";
//        
//        [usd setInteger:[[[country_arr objectAtIndex:indexPath.row]valueForKey:@"id" ] integerValue] forKey:@"country_id"];
//        //NSLog(@"Country id:::%@",[usd valueForKey:@"country_id"]);
//        
//       // [self language_api_call];
//#pragma Language_api_integration Method Calling
//        
//        @try
//        {
//            
//            NSString *urlGetuser =[NSString stringWithFormat:@"%@Languages/getLangByCountry/%@.json",SERVER_URL,country_ID];
//            urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (error) {
//                        [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
//                    }
//                    if (data) {
//                        NSMutableDictionary *json_DATA = data;
//                        lang_arr = [NSMutableArray array];
//                        lang_arr = [json_DATA valueForKey:@"languages"];
//                           
//                        [_TBL_list_lang reloadData];
//                        
//                        
//                    }
//                    
//                });
//            }];
//        }
//        @catch(NSException *exception)
//        {
//            NSLog(@"The error is:%@",exception);
//            [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
//           
//        }
//        
//    }
//    if(tableView == _TBL_list_lang)
//    {
//               _TBL_list_lang.hidden = YES;
//        //_TXT_username.text = [];
//        _TXT_language.text = [[lang_arr objectAtIndex:indexPath.row]valueForKey:@"language_name"];
//        
//        [usd setInteger:[[[lang_arr objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue] forKey:@"language_id"];
//        [usd setValue: [[lang_arr objectAtIndex:indexPath.row]valueForKey:@"language_name"] forKey:@"language"];
//        [usd synchronize];
//        
//        //NSLog(@"Language id:::%@",[usd valueForKey:@"language_id"]);
//        
//        
//    }
//    
//}
#pragma API call
//-(void)country_api_call
//{
//    @try
//    {
//        NSError *error;
//        // NSError *err;
//        NSHTTPURLResponse *response = nil;
//
//        //        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
//        //        NSLog(@"the posted data is:%@",parameters);
//        NSString *urlGetuser =[NSString stringWithFormat:@"%@countries/index.json",SERVER_URL];
//        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:urlProducts];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        // [request setHTTPBody:postData];
//        //[request setAllHTTPHeaderFields:headers];
//        [request setHTTPShouldHandleCookies:NO];
//        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        if(aData)
//        {
//            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//            //NSLog(@"The response Api post sighn up API %@",json_DATA);
//
////            country_arr = [json_DATA valueForKey:@"countries"];
////            [_TBL_list_coutry reloadData];
//
//
//
//        }
//    }
//
//    @catch(NSException *exception)
//    {
//        NSLog(@"The error is:%@",exception);
//    }
//
//}

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
        NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];

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
            
            [[NSUserDefaults standardUserDefaults] setObject:json_DATA forKey:@"menu_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
          //  [self performSegueWithIdentifier:@"logint_to_home" sender:self];
            
            NSLog(@"the api_collection_product%@",json_DATA);
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
           // [self dismissViewControllerAnimated:NO completion:nil];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
                
                Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:controller];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
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
