//
//  VC_product_search.m
//  Dohasooq_mobile
//
//  Created by Test User on 14/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_product_search.h"

@interface VC_product_search ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *search_ARR;;
    NSArray *search_arr;
    NSString *lower,*upper,*discount;
    
}
@end

@implementation VC_product_search

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
  
    
    CGRect frame_nav = _VW_navMenu.frame;
    frame_nav.origin.x = 0.0f;
    frame_nav.size.width = self.navigationController.navigationBar.frame.size.width - _BTN_search.frame.size.width;
    _VW_navMenu.frame = frame_nav;
    
    frame_nav = _TXT_search.frame;
    frame_nav.size.width = _VW_navMenu.frame.size.width - _BTN_search.frame.size.width- _BTN_close.frame.size.width;
    _TXT_search.frame = frame_nav;
    
    frame_nav = _BTN_search.frame;
    frame_nav.origin.x = _TXT_search.frame.size.width - _BTN_search.frame.size.width-2;
    _BTN_search.frame =  frame_nav;
   //  _TBL_search_results.hidden = YES;
    
    _TXT_search.delegate = self;
//    _TXT_search.layer.borderWidth = 0.2f;
//    _TXT_search.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_BTN_close addTarget:self action:@selector(Close_Action) forControlEvents:UIControlEventTouchUpInside];
    [_TXT_search addTarget:self action:@selector(search_API) forControlEvents:UIControlEventEditingChanged];
    [_BTN_search addTarget:self action:@selector(search_API_ALL) forControlEvents:UIControlEventTouchUpInside];
    _BTN_search.tag = 1;
    
    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;

   // [self search_API_ALL];


}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
   
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.navigationController.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;
    _TBL_search_results.hidden = YES;
   // [_TBL_search_results reloadData];
    
    
    
}
-(void)Close_Action
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma Textfield delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //_TBL_search_results.hidden =NO;
   // [self search_API_ALL];
}
-(void)search_API
{
    if(_TXT_search.text.length < 1)
    {
        _TBL_search_results.hidden =NO;
    }
    else
    {
        [self performSelector:@selector(search_API_CALL) withObject:activityIndicatorView afterDelay:0.01];

    }
//{
//    if(_BTN_search.tag == 0)
//    {
//    NSString *substring = [NSString stringWithString:_TXT_search.text];
//    
//    NSArray *arr = [search_ARR mutableCopy];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['name'] CONTAINS[cd] %@",substring];
//    
//    search_arr = [arr filteredArrayUsingPredicate:predicate];
//    [self.TBL_search_results reloadData];
//    }
//    else
//    {
//
//     // NSString *search_str = _TXT_search.text;
//               _TBL_search_results.hidden = NO;
////        VW_overlay.hidden = NO;
////        [activityIndicatorView startAnimating];
     //   [self performSelector:@selector(search_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
        
        
  //   }
    
}
-(void)search_API_CALL
{
    
    @try
    {
        NSString *search_str = _TXT_search.text;
        NSError *error;
        // NSError *err;
        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSString *country = [user_dflts valueForKey:@"country_id"];
        NSString *languge = [user_dflts valueForKey:@"language_id"];
       // NSDictionary *dict = [user_dflts valueForKey:@"userdata"];
        //NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        
        // http://192.168.0.171/dohasooq/apis/productList/txt_Handbags/0/1/2/137/Customer.json
        
        NSString *urlGetuser = [NSString stringWithFormat:@"%@apis/productList/txt_%@/0/%@/%@/Customer.json",SERVER_URL,search_str,country,languge];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
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
            NSDictionary *dictin = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",dictin);
            search_ARR = [dictin valueForKey:@"products"];
            if([search_ARR isKindOfClass:[NSArray class]])
            {
                @try {
                    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                                 ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                    NSArray *sortedArray = [search_ARR sortedArrayUsingDescriptors:sortDescriptors];
                    
                    search_ARR = sortedArray;
                    [_TBL_search_results reloadData];
                    
                    NSLog(@"Sorted Array :::%@",search_ARR);
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }

                
                [_TBL_search_results reloadData];
               
                _TBL_search_results.hidden =  NO;
                 _VW_empty.hidden = YES;
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                
            }
            else
            {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                _TBL_search_results.hidden =  YES;
               
                _VW_empty.hidden = NO;

                //  [_TBL_search_results reloadData];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            }
            
            
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if(_BTN_search.tag == 1)
//    {
        return 1;
//    }
//    else
//    {
//    return 2;
//    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(_BTN_search.tag == 0)
//    {
//    NSString *substring = [NSString stringWithString:_TXT_search.text];
//    
//    NSArray *arr = [search_ARR mutableCopy];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['name'] CONTAINS[cd] %@",substring];
//    
//    search_arr = [arr filteredArrayUsingPredicate:predicate];
//    if(section == 0)
//    {
//        return search_arr.count;
//    }
//    else{
//         return search_ARR.count;
//    }
//    }
//    else{
        return [search_ARR  count];
   /// }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
//    }
//    if(_BTN_search.tag == 0)
//    {
//    if(indexPath.section == 0)
//    {
//         cell.textLabel.text = [NSString stringWithFormat:@"%@",[[search_arr objectAtIndex:indexPath.row] valueForKey:@"name"]];
//    }
//    else
//    {
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"name"]];
//    }
//    }
//    else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",
                               [[search_ARR objectAtIndex:indexPath.row] valueForKey:@"title"]];
    
    NSString *str = cell.textLabel.text;
      str  =[str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str  =[str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    cell.textLabel.text = str;
    

    
        
   // }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(_BTN_search.tag == 1)
//    {
    NSString *url_key= [NSString stringWithFormat:@"%@",[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"title"]];
//    url_key = [url_key lowercaseString];
//    url_key = [url_key stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
   // NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
   // apis/productNamesList/" + country_val + "/" + language_val + "/.json
    NSString *list_TYPE = @"productList";
    
    NSString *str_key = [NSString stringWithFormat:@"%@/txt_%@/0",list_TYPE,[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"title"]];
    [[NSUserDefaults standardUserDefaults] setValue:str_key forKey:@"product_list_key"];
    

    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_%@/0/%@/%@.json",SERVER_URL,list_TYPE,url_key,country,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setValue:[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self performSegueWithIdentifier:@"search_product_list" sender:self];
   // }
//    else
//    {
//        NSString *url_key= [NSString stringWithFormat:@"%@",[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"name"]];
//        url_key = [url_key lowercaseString];
//        url_key = [url_key stringByReplacingOccurrencesOfString:@" " withString:@"-"];
//        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
//        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
//        // NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
//        // apis/productNamesList/" + country_val + "/" + language_val + "/.json
//        NSString *list_TYPE = @"productList";
//        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_%@/0/%@/%@.json",SERVER_URL,list_TYPE,_TXT_search.text,country,languge];
//        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        
//        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [[NSUserDefaults standardUserDefaults] setValue:[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"item_name"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        
//        [self performSegueWithIdentifier:@"search_product_list" sender:self];
//
//    }
    
    
    
}
-(void)search_API_ALL

{
    if(_TXT_search.text.length > 0)
    {
    _BTN_search.tag = 0;
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
      NSString *list_TYPE = @"productList";
    NSString *str_key = [NSString stringWithFormat:@"%@/txt_%@/0",list_TYPE,_TXT_search.text];
        [[NSUserDefaults standardUserDefaults] setValue:str_key forKey:@"product_list_key"];

    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_%@/0/%@/%@.json",SERVER_URL,list_TYPE,_TXT_search.text,country,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   // [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self performSegueWithIdentifier:@"search_product_list" sender:self];
    }
    else
    {
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *list_TYPE = @"productList";
        NSString *str_key = [NSString stringWithFormat:@"%@/txt_%@/0",list_TYPE,_TXT_search.text];
        [[NSUserDefaults standardUserDefaults] setValue:str_key forKey:@"product_list_key"];
      NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_/0/%@/%@.json",SERVER_URL,list_TYPE,country,languge];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"search_product_list" sender:self];


    }

    
    
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(search_DATA) withObject:activityIndicatorView afterDelay:0.01];

}
-(void)search_DATA
{
    @try
    {
      NSError *error;
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
       NSString *list_TYPE = @"productNamesList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@.json",SERVER_URL,list_TYPE,country,languge];
    
    NSHTTPURLResponse *response = nil;
    //   Languages/getLangByCountry/"+countryid+".json
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
        search_ARR  = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response Api post sighn up API %@",search_ARR);
       // search_ARR = [dictin valueForKey:@"products"];
        if([search_ARR isKindOfClass:[NSArray class]])
        {
            [_TBL_search_results reloadData];
            
            _TBL_search_results.hidden =  NO;
                       VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            
        }
        else
        {
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            _TBL_search_results.hidden =  YES;
                      //  [_TBL_search_results reloadData];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No data found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
        }
        
        
        
    }
}

@catch(NSException *exception)
{
    NSLog(@"The error is:%@",exception);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
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
