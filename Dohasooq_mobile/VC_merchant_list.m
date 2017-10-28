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

@interface VC_merchant_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_product;
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
        
    
    
}//http://192.168.0.171/dohasooq/Apis/merchantList/3/1.json

@end

@implementation VC_merchant_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
//    
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
//    [self performSelector:@selector(Merchant_api_integration) withObject:activityIndicatorView afterDelay:0.01];
//    _TBL_merchants.rowHeight = UITableViewAutomaticDimension;

}


-(void)set_UP_VIEW
{
//    _search_bar.layer.borderWidth = 0.4f;
//    _search_bar.layer.borderColor = [UIColor clearColor].CGColor;
    
    _search_bar.layer.shadowColor = [[UIColor clearColor] CGColor];
    _search_bar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _search_bar.layer.shadowRadius = 4.0f;
    _search_bar.layer.shadowOpacity = 1.0f;
arr_product = [[NSMutableArray alloc]init];
//NSDictionary *temp_dictin;
//  temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"AL Saad Street,P.O.BOX:1117,\nDoha,Ad Dawhah,1117\nQatar",@"key1",@"3326698",@"key2",@"support@aljaberWatches.com",@"key3",@"Al Jaber Watches",@"key4",@"merchant.png",@"key5",nil];
//[arr_product addObject:temp_dictin];
}
#pragma table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return arr_product.count;
    }
    else
    {
        return 1;
    }
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
        temp_dict = [arr_product objectAtIndex:indexPath.row];
    
         NSString *address= [temp_dict valueForKey:@"location"];
         address = [address stringByReplacingOccurrencesOfString:@" " withString:@"NotMentioned"];
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
        NSString *img_url = [NSString stringWithFormat:@"%@%@",IMG_URL,[temp_dict valueForKey:@"image"]];
    
       [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                          options:SDWebImageRefreshCached];
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

- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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
       // NSError *err;
        NSHTTPURLResponse *response = nil;
        
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
//        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Apis/merchantList/3/1.json",SERVER_URL];
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
