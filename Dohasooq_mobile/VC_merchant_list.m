//
//  VC_merchant_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 07/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_merchant_list.h"
#import "merchant_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VC_merchant_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSArray *arr_product;
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
        
    
    
}//http://192.168.0.171/dohasooq/Apis/merchantList/3/1.json

@end

@implementation VC_merchant_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _search_bar.delegate =self;
    [self set_UP_VIEW];

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
    [self Merchant_api_integration];
    [_search_bar addTarget:self action:@selector(filter_ARR) forControlEvents:UIControlEventEditingChanged];
    
//    
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
//    [self performSelector:@selector(Merchant_api_integration) withObject:activityIndicatorView afterDelay:0.01];
//    _TBL_merchants.rowHeight = UITableViewAutomaticDimension;

}
-(void)filter_ARR
{
    @try {
        if(arr_product.count < 1)
        {
            [self Merchant_api_integration];
        }
        else
        {
        
    NSString *substring = [NSString stringWithString:_search_bar.text];
    
    NSArray *arr = [arr_product mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF[name] CONTAINS %@",substring];
    
   arr_product = [arr filteredArrayUsingPredicate:predicate];
            
            if(arr_product.count < 1)
            {
                [self Merchant_api_integration];
                
            }
        [_TBL_merchants reloadData];
        }
 
    }
    @catch(NSException *exeption)
    {
        
    }

}

-(void)set_UP_VIEW
{
//    _search_bar.layer.borderWidth = 0.4f;
//    _search_bar.layer.borderColor = [UIColor clearColor].CGColor;
    
    _search_bar.layer.shadowColor = [[UIColor clearColor] CGColor];
    _search_bar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _search_bar.layer.shadowRadius = 4.0f;
    _search_bar.layer.shadowOpacity = 1.0f;
//arr_product = [[NSMutableArray alloc]init];
}
#pragma text field delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSString *substring = [NSString stringWithString:_search_bar.text];
//    
//    NSArray *arr = [arr_product mutableCopy];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['name'] CONTAINS[cd] %@",substring];
//    
//    arr_product = [arr filteredArrayUsingPredicate:predicate];
//    if(section == 0)
//    {
//        return search_arr.count;
//    }
//    else
//    {
        return arr_product.count;
   // }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
      merchant_cell *cell = (merchant_cell *)[tableView dequeueReusableCellWithIdentifier:@"merchant_cell"];
        NSDictionary *temp_dict=[arr_product objectAtIndex:indexPath.row];
        
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"merchant_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
//        if(indexPath.section == 0)
//        {
        temp_dict = [arr_product objectAtIndex:indexPath.row];
    
         NSString *address= [temp_dict valueForKey:@"location"];
         address = [address stringByReplacingOccurrencesOfString:@"    " withString:@"NotMentioned"];
         cell.LBL_loction.text = address;
    
         NSString *str_phone =[temp_dict valueForKey:@"phone"];
         str_phone = [str_phone stringByReplacingOccurrencesOfString:@"" withString:@"NotMentioned"];
         if(str_phone.length == 0)
         {
             str_phone = @"NotMentioned";
             
         }
         cell.LBL_phone.text =str_phone;
    
        NSString *str_email =[temp_dict valueForKey:@"email"];
        str_email = [str_email stringByReplacingOccurrencesOfString:@" " withString:@"NotMentioned"];
        cell.LBL_addres.text =str_email;
    
    
        NSString *str_name =[temp_dict valueForKey:@"name"];
        //str_name = [str_name stringByReplacingOccurrencesOfString:@" " withString:@"NotMentioned"];
        cell.LBL_merchat_name.text = str_name;
        
        //Webimage URl Cachee
        NSString *img_url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[temp_dict valueForKey:@"image"]];
    
       [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                          options:SDWebImageRefreshCached];
//        }
//        else
//        {
//            temp_dict = [arr_product objectAtIndex:indexPath.row];
//            
//            NSString *address= [temp_dict valueForKey:@"location"];
//            address = [address stringByReplacingOccurrencesOfString:@"    " withString:@"NotMentioned"];
//            cell.LBL_loction.text = address;
//            
//            NSString *str_phone =[temp_dict valueForKey:@"phone"];
//            str_phone = [str_phone stringByReplacingOccurrencesOfString:@"" withString:@"NotMentioned"];
//            if(str_phone.length == 0)
//            {
//                str_phone = @"NotMentioned";
//                
//            }
//            cell.LBL_phone.text =str_phone;
//            
//            NSString *str_email =[temp_dict valueForKey:@"email"];
//            str_email = [str_email stringByReplacingOccurrencesOfString:@" " withString:@"NotMentioned"];
//            cell.LBL_addres.text =str_email;
//            
//            
//            NSString *str_name =[temp_dict valueForKey:@"name"];
//            //str_name = [str_name stringByReplacingOccurrencesOfString:@" " withString:@"NotMentioned"];
//            cell.LBL_merchat_name.text = str_name;
//            
//            //Webimage URl Cachee
//            NSString *img_url = [NSString stringWithFormat:@"%@%@",SERVER_URL,[temp_dict valueForKey:@"image"]];
//            
//            [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
//                             placeholderImage:[UIImage imageNamed:@"logo.png"]
//                                      options:SDWebImageRefreshCached];
//
//        }
       return cell;
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    }

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 0)
//    {
//   [[NSUserDefaults standardUserDefaults] setObject:[search_arr objectAtIndex:indexPath.row] forKey:@"merchant_data"];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    else{
        [[NSUserDefaults standardUserDefaults] setObject:[arr_product objectAtIndex:indexPath.row] forKey:@"merchant_data"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

  //  }
    
    
    
    [self performSegueWithIdentifier:@"merchant_detail_segue" sender:self];
}

- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    NSString *titleName = @"";
//    if (section == 0) {
//        titleName = @"";
//    }else{
//        titleName = @"Merchants Related To your Search";
//    }
//    return  titleName;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma API call
-(void)Merchant_api_integration
{
    @try
    {
        NSError *error;
    
        NSHTTPURLResponse *response = nil;
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Apis/merchantList/%@/%@.json",SERVER_URL,country,languge];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            
            
            
            arr_product = [json_DATA valueForKey:@"Success"];
            [_TBL_merchants reloadData];
            
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
