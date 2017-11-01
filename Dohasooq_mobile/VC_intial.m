//
//  VC_intial.m
//  Dohasooq_mobile
//
//  Created by Test User on 24/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_intial.h"

@interface VC_intial ()<UITableViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *country_arr,*lang_arr;
    NSMutableDictionary *temp_dict;
    NSString *country_ID;
}

@end

@implementation VC_intial

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap_DTECt:)];
//    [tap setCancelsTouchesInView:NO];
//    tap.delegate = self;
//    [_TBL_list_lang addGestureRecognizer:tap];
//     [_TBL_list_coutry addGestureRecognizer:tap];
//    [self.view addGestureRecognizer:tap];

    _VW_ceter.center = self.view.center;
    country_arr = [[NSMutableArray alloc]init];
    CGRect frameset = _TBL_list_coutry.frame;
    frameset.origin.x =_TXT_country.frame.origin.x;
    frameset.origin.y =_TXT_country.frame.origin.y + _TXT_country.frame.size.height + 5;
    frameset.size.width = _TXT_country.frame.size.width;
    frameset.size.height = 120;
    _TBL_list_coutry.frame = frameset;
    
    frameset = _TBL_list_lang.frame;
    frameset.origin.x =_TXT_language.frame.origin.x;
    frameset.origin.y =_TXT_language.frame.origin.y + _TXT_language.frame.size.height + 5;
    frameset.size.width = _TXT_language.frame.size.width;
    frameset.size.height = 120;
    _TBL_list_lang.frame = frameset;

    _TBL_list_coutry.hidden = YES;
    _TBL_list_lang.hidden = YES;
    _TBL_list_lang.delegate =self;
    _TBL_list_lang.dataSource = self;
    _TBL_list_coutry.delegate =self;
    _TBL_list_coutry.dataSource = self;
    
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _TXT_country.inputView = dummyView;
    _TXT_language.inputView = dummyView;

    [_BTN_next addTarget:self action:@selector(go_to_login) forControlEvents:UIControlEventTouchUpInside];
    
    [self country_api_call];
}
-(void)go_to_login
{
    [self performSegueWithIdentifier:@"intial_login" sender:self];
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
    if(textField == _TXT_country)
    {
    _TBL_list_coutry.hidden = NO;
    _TBL_list_lang.hidden  =YES;
        
    }
    else if(textField == _TXT_language)
    {
        _TBL_list_lang.hidden  =NO;
         _TBL_list_coutry.hidden = YES;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _TXT_country)
    {
         _TBL_list_coutry.hidden = YES;
    }
    else if(textField == _TXT_language)
    {
         _TBL_list_coutry.hidden = YES;
    }

}
#pragma tableview delgates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _TBL_list_coutry)
    {
        return country_arr.count;
    }
    else
    return lang_arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _TBL_list_coutry)
    {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    temp_dict = [country_arr objectAtIndex:indexPath.row];


    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
        cell.textLabel.text = [temp_dict valueForKey:@"name"];
        return cell;
    }
    else
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];

        if (cell == nil)
        {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if(lang_arr.count == 0)
        {
            cell.textLabel.text = @"please select Country";
  
        }
        else
        {
        cell.textLabel.text = [[lang_arr objectAtIndex:indexPath.row]valueForKey:@"language_name"];
        }
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
    if(tableView == _TBL_list_coutry)
    {
        _TBL_list_coutry.hidden = YES;
        //NSLog(@"%@",country_arr);
        _TXT_country.text = [[country_arr objectAtIndex:indexPath.row] valueForKey:@"name"];
        country_ID = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:indexPath.row] valueForKey:@"id"]];
        _TXT_language.text = @"";
        
        [usd setInteger:[[[country_arr objectAtIndex:indexPath.row]valueForKey:@"id" ] integerValue] forKey:@"country_id"];
        //NSLog(@"Country id:::%@",[usd valueForKey:@"country_id"]);
        
        [self language_api_call];
        
    }
    if(tableView == _TBL_list_lang)
    {
        _TBL_list_lang.hidden = YES;
        //_TXT_username.text = [];
        _TXT_language.text = [[lang_arr objectAtIndex:indexPath.row]valueForKey:@"language_name"];
        
        [usd setInteger:[[[lang_arr objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue] forKey:@"language_id"];
        
        //NSLog(@"Language id:::%@",[usd valueForKey:@"language_id"]);

        
    }

}
#pragma API call
-(void)country_api_call
{
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        
        //        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        //        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@countries/index.json",SERVER_URL];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
            
            country_arr = [json_DATA valueForKey:@"countries"];
            [_TBL_list_coutry reloadData];
            
           
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
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
            [_TBL_list_lang reloadData];
            
            
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
    }
}
//#pragma mark - Tap Gesture
//-(void) Tap_DTECt :(UITapGestureRecognizer *)sender
//{
//    
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    [_TXT_country resignFirstResponder];
//    [_TXT_language resignFirstResponder];
//    
////    if ([touch.view isDescendantOfView:_TBL_list_coutry]) {
////        return NO;
////    }
////    else if ([touch.view isDescendantOfView:_TBL_list_lang]) {
////        return NO;
////    }
////    
//    return YES;
//}

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
