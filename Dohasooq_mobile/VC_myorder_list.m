//
//  VC_myorder_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 04/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_myorder_list.h"
#import "orders_list_cell.h"
#import "HttpClient.h"

@interface VC_myorder_list ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
   NSArray *json_DATA;
    NSArray *search_arr;
    UIImageView *image_empty;
    
}
@end

@implementation VC_myorder_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_BTN_cart addTarget:self action:@selector(cart_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_wish_list addTarget:self action:@selector(wish_action) forControlEvents:UIControlEventTouchUpInside];
    [_TXT_search addTarget:self action:@selector(search_ORDERS) forControlEvents:UIControlEventEditingChanged];
  }
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;

    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;
    _TXT_search.delegate = self;
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(Orders_list_API) withObject:activityIndicatorView afterDelay:0.01];
    
    
    
    
    
}
-(void)cart_action
{
    [self performSegueWithIdentifier:@"orders_cart" sender:self];
    
}
-(void)wish_action
{
    [self performSegueWithIdentifier:@"orders_wish" sender:self];

    
}
#pragma cart_count_api
-(void)cart_count{
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
            
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];
        }
        if (data) {
            
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];
            NSLog(@"%@",data);
            NSDictionary *dict = data;
            @try {
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
                NSString *wishlist = [NSString stringWithFormat:@"%@",[dict valueForKey:@"wishlistcount"]];
                
                
                
                if([wishlist intValue] > 0)
                {
                    
                    @try
                    {
                        [_BTN_wish_list setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
                        [_BTN_wish_list setBadgeString:[NSString stringWithFormat:@"%@",wishlist]];
                    }
                    @catch(NSException *Exception)
                    {
                        
                    }
                    
                }
                
                if([badge_value intValue] > 0 )
                {
                    @try
                    {
                        
                        [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
                    }
                    @catch(NSException *Exception)
                    {
                        
                    }
                    
                    [_BTN_cart setBadgeString:[NSString stringWithFormat:@"%@",badge_value]];
                    
                    
                }
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
                
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];
            }
            
        }
    }];
}

-(void)search_ORDERS
{
    @try {
        NSString *substring = [NSString stringWithString:_TXT_search.text] ;
        if(substring.length < 1)
        {
            [self Orders_list_API];
            
        }
        else
        {

        NSArray *arr = [json_DATA  mutableCopy];
        NSArray *arr1 = [arr mutableCopy];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self.order_number CONTAINS[cd] %@",substring];
        
       json_DATA = [arr1 filteredArrayUsingPredicate:predicate1];
            
        NSLog(@"Temp store array %@",json_DATA);
           if(json_DATA.count < 1)
           {
               [self Orders_list_API];
           }
       [_TBL_orders reloadData];
        }
        
    }
    @catch(NSException *exeption)
    {
        NSLog(@"THe Exception form search_ORDERS%@",exeption);
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)home_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    NSString *substring = [NSString stringWithString:_TXT_search.text];
//    
//    
//    NSArray *arr = [json_DATA  mutableCopy];
//    NSArray *arr1 = [arr mutableCopy];
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self.order_number.stringValue CONTAINS %@",substring];
//    
//     json_DATA = [arr1 filteredArrayUsingPredicate:predicate1];
//    
//    NSLog(@"Temp store array %@",json_DATA);
    return [json_DATA count];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        
        index = 0;
        
    }
    else{
        index = 1;
    }
    
    orders_list_cell *order_cell = (orders_list_cell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (order_cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"orders_list_cell" owner:self options:nil];
        order_cell = [nib objectAtIndex:index];
    }
  
    NSString *str = [NSString stringWithFormat:@"%@",[[json_DATA objectAtIndex:indexPath.row] valueForKey:@"order_number"]];
    str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    NSString *str_order = @"ORDER ID :";
    NSString *text = [NSString stringWithFormat:@"%@%@",str_order,str];
    
    
    if ([order_cell.BTN_order_ID.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.BTN_order_ID.titleLabel.textColor,
                                  NSFontAttributeName: order_cell.BTN_order_ID.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
         NSRange ename = [text rangeOfString:str];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        
        if(result.height <= 480)
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor darkGrayColor]}
                                    range: [text rangeOfString:str_order]];

            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor colorWithRed:0.15 green:0.31 blue:0.62 alpha:1.0]}
                                    range:ename];
            
        }
        else if(result.height <= 568)
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName :[UIColor darkGrayColor]}
                                    range: [text rangeOfString:str_order]];

            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName :[UIColor colorWithRed:0.15 green:0.31 blue:0.62 alpha:1.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor darkGrayColor]}
                                    range: [text rangeOfString:str_order]];

            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor colorWithRed:0.15 green:0.31 blue:0.62 alpha:1.0]}
                                    range:ename];
        }

          [order_cell.BTN_order_ID setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [order_cell.BTN_order_ID setTitle:text forState:UIControlStateNormal];
    }
    NSString *date = [NSString stringWithFormat:@"%@",[[json_DATA  objectAtIndex:indexPath.row] valueForKey:@"order_created"]];
    date = [date stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    NSString *order_text = @"Ordered On ";
    NSString *date_text = [NSString stringWithFormat:@"%@%@",order_text,date];
    
    
    if ([order_cell.LBL_order_date respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.LBL_order_date.textColor,
                                  NSFontAttributeName: order_cell.LBL_order_date.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
        
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0]}
                                range:[date_text rangeOfString:date]];
        
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
          NSRange ename = [date_text rangeOfString:date];
        if(result.height <= 480)
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor darkGrayColor]}
                                    range:[date_text rangeOfString:order_text]];

            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                    range:ename];
        }

            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor darkGrayColor]}
                                        range:[date_text rangeOfString:order_text]];
                

                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:ename];
            }
           else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor darkGrayColor]}
                                            range:[date_text rangeOfString:order_text]];
                    

                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                            range:ename];
                }

        
        
        order_cell.LBL_order_date.attributedText = attributedText;
    }
    else
    {
        order_cell.LBL_order_date.text = text;
    }
    NSString *qr = [NSString stringWithFormat:@"%@",[[json_DATA  objectAtIndex:indexPath.row] valueForKey:@"order_total"]];
    qr = [qr stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    NSString *price = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],qr];
    
    if ([order_cell.LBL_price respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.LBL_price.textColor,
                                  NSFontAttributeName:order_cell.LBL_price .font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:price attributes:attribs];
        
        NSRange qrs = [price rangeOfString:qr];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                    range:qrs];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor redColor]}
                                    range:qrs];
        }
        order_cell.LBL_price.attributedText = attributedText;
    }
    else
    {
        order_cell.LBL_price.text = price;
    }
    order_cell.VW_content.layer.borderWidth = 0.5f;
    order_cell.VW_content.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    [order_cell.BTN_order_ID addTarget:self action:@selector(move_to_next:) forControlEvents:UIControlEventTouchUpInside];
    [order_cell.BTN_track_location addTarget:self action:@selector(move_to_next:) forControlEvents:UIControlEventTouchUpInside];
    order_cell.BTN_order_ID.tag = indexPath.row;
    order_cell.BTN_track_location.tag = indexPath.row;
    
    
    return order_cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    if(indexPath.section == 0)
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:[[search_arr objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"order_ID"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//    }
//    else{
        [[NSUserDefaults standardUserDefaults] setValue:[[json_DATA objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"order_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
   // }

    
    [self performSegueWithIdentifier:@"order_list_detail" sender:self];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 92;
}

#pragma mark Track and Order Id Buttons Action
-(void)move_to_next:(UIButton *)sender{
    
    [[NSUserDefaults standardUserDefaults] setValue:[[json_DATA objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"order_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"order_list_detail" sender:self];
}
-(void)move_to_detail:(UIButton *)sender
{
    
        [[NSUserDefaults standardUserDefaults] setValue:[[json_DATA objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"order_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      [self performSegueWithIdentifier:@"order_list_detail" sender:self];
        
   
}
-(void)Orders_list_API
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
       @try
    {
    
        NSDictionary *parameters = @{
                                     @"customerId": user_id
                                     };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Apis/orderlistapi.json",SERVER_URL];
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
          NSMutableDictionary *json_DAT = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            json_DATA = [json_DAT valueForKey:@"Orders"];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            if([json_DATA isKindOfClass:[NSArray class]])
            {
             
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
                image_empty.hidden = YES;
                [self cart_count];
                
                NSString *str_header_title = [NSString stringWithFormat:@"MY ORDERS(%lu)",(unsigned long) [json_DATA count]];
                [_BTN_header setTitle:str_header_title forState:UIControlStateNormal];
                [_TBL_orders reloadData];
               

                
            }
            else{
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;

                _TBL_orders.hidden =  YES;
               image_empty = [[UIImageView alloc]init];
                CGRect frame_image = image_empty.frame;
                frame_image.size.height = 200;
                frame_image.size.width = 200;
                image_empty.frame = frame_image;
                image_empty.center = self.view.center;
                [self.view addSubview:image_empty];
                image_empty.image = [UIImage imageNamed:@"Orders_not_found"];
                

            }
            [self.TBL_orders reloadData];
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            
            
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

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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
