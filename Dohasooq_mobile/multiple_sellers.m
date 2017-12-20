//
//  multiple_sellers.m
//  Dohasooq_mobile
//
//  Created by Test User on 19/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "multiple_sellers.h"
#import "sellers_cell.h"
#import "HCSStarRatingView.h"
#import "HttpClient.h"
@interface multiple_sellers ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray *seller_arr;
    HCSStarRatingView *starRatingView;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation multiple_sellers

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    seller_arr = [[NSMutableArray alloc]init];
    
@try
    {
  NSDictionary   *sellers_DICT = [[NSUserDefaults standardUserDefaults] valueForKey:@"multiple_seller_detail"];
    NSLog(@"The keys are:%@",[sellers_DICT allKeys]);
    for(int i=0;i<[[sellers_DICT allKeys] count];i++)
    {
        if([[sellers_DICT valueForKey:[[sellers_DICT allKeys] objectAtIndex:i]] isKindOfClass:[NSDictionary class]])
        {
            [seller_arr  addObject:[sellers_DICT  valueForKey:[[sellers_DICT allKeys] objectAtIndex:i]]];
        }
        
    }
    }
    @catch(NSException *exception)
    {
        
    }
    @try
    {
        
        [_BTN_fav setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
        [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    }
    @catch(NSException *exception)
    {
        
    }
      VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
    });

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.navigationController.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return seller_arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    sellers_cell *seller = (sellers_cell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (seller == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"sellers_cell" owner:self options:nil];
        seller = [nib objectAtIndex:0];
    }

    
    @try
    {
    NSString *cost_str = [NSString stringWithFormat:@"%@ %@",[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"currency_code"],[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"price"]];
    cost_str = [cost_str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
     cost_str = [cost_str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    cost_str = [cost_str stringByReplacingOccurrencesOfString:@"" withString:@""];
    seller.LBL_cost.text = cost_str;
    
    NSString *delivary_stat = [NSString stringWithFormat:@"%@",[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"delivered_in"]];
    delivary_stat = [delivary_stat stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    delivary_stat = [delivary_stat stringByReplacingOccurrencesOfString:@"(null)" withString:@"Not mentioned"];
    delivary_stat = [delivary_stat stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
    seller.LBL_status.text =  delivary_stat;
    
    
    NSString *item_str = [NSString stringWithFormat:@"%@",[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"title"]];
    item_str = [item_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    item_str = [item_str stringByReplacingOccurrencesOfString:@"(null)" withString:@"Not mentioned"];
    item_str = [item_str stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
    seller.LBL_name.text =  item_str;
    
    

    starRatingView = [[HCSStarRatingView alloc] initWithFrame:seller.LBL_rating.frame];
      starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    starRatingView.allowsHalfStars = YES;
    [seller addSubview:starRatingView];
    
    starRatingView.value = [[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"totalRatings"] intValue];
    NSString *str_ratings = [NSString stringWithFormat:@"%@",[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"totalRatings"]];
    str_ratings = [str_ratings stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    str_ratings = [str_ratings stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
    str_ratings = [str_ratings stringByReplacingOccurrencesOfString:@"" withString:@"0"];
    
    NSString *str_reviews = [NSString stringWithFormat:@"%@",[[seller_arr objectAtIndex:indexPath.row] valueForKey:@"reviewCount"]];
    str_reviews = [str_reviews stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    str_reviews = [str_reviews stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
    str_reviews = [str_reviews stringByReplacingOccurrencesOfString:@"" withString:@"0"];
        
    
    NSString *str_review_rating = [NSString stringWithFormat:@"%@ Ratings & %@ Reviews",str_ratings,str_reviews];
    
        if ([seller.LBL_riview respondsToSelector:@selector(setAttributedText:)])
        {
            
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_review_rating attributes:nil];
            
            NSRange ename = [str_review_rating rangeOfString:str_ratings];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0],NSForegroundColorAttributeName:seller.BTN_details.backgroundColor}
                                        range:ename];
            
            NSRange ranges = [str_review_rating rangeOfString:str_reviews];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0],NSForegroundColorAttributeName:seller.BTN_details.backgroundColor}
                                    range:ranges];
            seller.LBL_riview.attributedText = attributedText;
  
            
        }
        else
        {
            seller.LBL_riview.text = str_review_rating;
        }
    seller.BTN_add_cart.layer.cornerRadius = 2.0f;
    seller.BTN_add_cart.layer.masksToBounds = YES;
    seller.BTN_details.layer.cornerRadius = 2.0f;
    seller.BTN_details.layer.masksToBounds = YES;
        seller.BTN_add_cart.tag = indexPath.row;
        seller.BTN_details.tag =  indexPath.row;
        [seller.BTN_add_cart addTarget:self action:@selector(add_to_cart:) forControlEvents:UIControlEventTouchUpInside];
        [seller.BTN_details addTarget:self action:@selector(Details_action:) forControlEvents:UIControlEventTouchUpInside];

    }
    @catch(NSException *Exception)
    {
        
    }
  
    return seller;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168;
}
- (IBAction)Wish_list_action:(id)sender {
    
    [self performSegueWithIdentifier:@"multiplesller_wishlist" sender:self];
}


- (IBAction)cart_action:(id)sender {
    [self performSegueWithIdentifier:@"multiple_sellers_cart" sender:self];
}

-(void)add_to_cart:(UIButton *)sender
{
    @try
    {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *stock =  [[seller_arr objectAtIndex:sender.tag]valueForKey:@"stock_status"];
    stock = [stock stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    stock = [stock stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    

    if([stock isEqualToString:@""] || [stock isEqualToString:@"Out of stock"])
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Out of Stock" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    else if([[[seller_arr objectAtIndex:sender.tag]valueForKey:@"product_variants"] isKindOfClass:[NSArray class]])
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        
        
        
        if([[[seller_arr objectAtIndex:sender.tag] valueForKey:@"product_variants"] count] == 0)
        {
            if([user_id isEqualToString:@"(null)"])
            {
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
                alert.tag = 1;
                [alert show];
                
            }
            else
            {
                @try {
                    
                    NSError *error;
                    NSHTTPURLResponse *response = nil;
                    NSString *pdId = [NSString stringWithFormat:@"%@",[[seller_arr objectAtIndex:sender.tag] valueForKey:@"product_id"]];
                    NSDictionary *parameters = @{@"pdtId":pdId
                                                 ,@"userId":user_id,@"quantity":@"1",@"custom":@"",@"variant":@""};
                    
                    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
                    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL]];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:urlProducts];
                    [request setHTTPMethod:@"POST"];
                    [request setHTTPBody:postData];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                    if (error) {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        
                        [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                    }
                    
                    if(aData)
                    {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        
                        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
                        
                        if ([[dict valueForKey:@"success"] isEqualToString:@"1"]) {
                            
                            [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
                            // [self delete_from_wishLis];
                            
                        }
                        
                        
                        
                        NSLog(@"  Error %@ Response %@",error,dict);
                        [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
                    }
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];
                    
                }
                
                
                
                
            }

            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:[[seller_arr objectAtIndex:sender.tag] valueForKey:@"merchant_id"] forKey:@"Mercahnt_ID"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[[seller_arr objectAtIndex:sender.tag] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.navigationController popViewControllerAnimated:NO];
        }
       
       
            
    }
    else
    {
        if([user_id isEqualToString:@"(null)"])
        {
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            @try {
                
                NSError *error;
                NSHTTPURLResponse *response = nil;
                NSString *pdId = [NSString stringWithFormat:@"%@",[[seller_arr objectAtIndex:sender.tag] valueForKey:@"product_id"]];
                NSDictionary *parameters = @{@"pdtId":pdId
                                             ,@"userId":user_id,@"quantity":@"1",@"custom":@"",@"variant":@""};
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
                NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL]];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:urlProducts];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:postData];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if (error) {
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];

                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                
                if(aData)
                {
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];

                    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
                    
                    if ([[dict valueForKey:@"success"] isEqualToString:@"1"]) {
                        
                           [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
                        // [self delete_from_wishLis];
                        
                    }
                    
                    
                    
                    NSLog(@"  Error %@ Response %@",error,dict);
                    [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
                }
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];

            }
            

            
            
        }

        
    }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];

        
    }
}
#pragma mark cart_count_api
-(void)cart_count{
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             
             ];
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
        }
        if (data) {
            NSLog(@"%@",data);
            NSDictionary *dict = data;
            @try {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
                NSString *wishlist = [NSString stringWithFormat:@"%@",[dict valueForKey:@"wishlistcount"]];
                
                //NSString *badge_value = @"11";
                if(badge_value.length > 99 || wishlist.length > 99)
                {
                    [_BTN_cart setBadgeString:[NSString stringWithFormat:@"%@+",badge_value]];
                    [_BTN_fav setBadgeString:[NSString stringWithFormat:@"%@+",wishlist]];
                    
                    
                }
                else{
                    [_BTN_cart setBadgeString: [NSString stringWithFormat:@"%@",badge_value]];
                    [_BTN_fav setBadgeString:[NSString stringWithFormat:@"%@",wishlist]];
                    
                    
                }
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
            }
            
        }
    }];
}


-(void)Details_action:(UIButton *)sender
{
    
    [[NSUserDefaults standardUserDefaults] setValue:[[seller_arr objectAtIndex:sender.tag] valueForKey:@"merchant_id"] forKey:@"Mercahnt_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setValue:[[seller_arr objectAtIndex:sender.tag] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (IBAction)BTN_back_action:(id)sender
{

  [self.navigationController popViewControllerAnimated:NO];
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