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
    
}
@end

@implementation VC_myorder_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_TXT_search addTarget:self action:@selector(search_ORDERS) forControlEvents:UIControlEventEditingChanged];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
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
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self.order_number.stringValue CONTAINS %@",substring];
        
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
    
    orders_list_cell *order_cell = (orders_list_cell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (order_cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"orders_list_cell" owner:self options:nil];
        order_cell = [nib objectAtIndex:0];
    }
  
    NSString *str = [NSString stringWithFormat:@"%@",[[json_DATA objectAtIndex:indexPath.row] valueForKey:@"order_number"]];
    str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    NSString *text = [NSString stringWithFormat:@"ORDER ID : %@",str];
    
    
    if ([order_cell.BTN_order_ID.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.BTN_order_ID.titleLabel.textColor,
                                  NSFontAttributeName: order_cell.BTN_order_ID.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:str];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor blueColor]}
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
    NSString *date_text = [NSString stringWithFormat:@"Order on: %@",date];
    
    
    if ([order_cell.LBL_order_date respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.LBL_order_date.textColor,
                                  NSFontAttributeName: order_cell.LBL_order_date.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
        
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
          NSRange ename = [date_text rangeOfString:date];
        if(result.height <= 480)
        {
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:11.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                    range:ename];
        }

            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:ename];
            }
           else
                {
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:qrs];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0]}
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
    
//    else
//    {
//        NSString *str = [NSString stringWithFormat:@"%@",[[json_DATA objectAtIndex:indexPath.row] valueForKey:@"order_number"]];
//        str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
//        NSString *text = [NSString stringWithFormat:@"ORDER ID : %@",str];
//        
//        
//        if ([order_cell.BTN_order_ID.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
//            
//            NSDictionary *attribs = @{
//                                      NSForegroundColorAttributeName:order_cell.BTN_order_ID.titleLabel.textColor,
//                                      NSFontAttributeName: order_cell.BTN_order_ID.titleLabel.font
//                                      };
//            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
//            
//            
//            
//            NSRange ename = [text rangeOfString:str];
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                        range:ename];
//            }
//            else
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor blueColor]}
//                                        range:ename];
//            }
//            [order_cell.BTN_order_ID setAttributedTitle:attributedText forState:UIControlStateNormal];
//        }
//        else
//        {
//            [order_cell.BTN_order_ID setTitle:text forState:UIControlStateNormal];
//        }
//        NSString *date = [NSString stringWithFormat:@"%@",[[json_DATA  objectAtIndex:indexPath.row] valueForKey:@"order_created"]];
//        date = [date stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
//        NSString *date_text = [NSString stringWithFormat:@"Order on: %@",date];
//        
//        
//        if ([order_cell.LBL_order_date respondsToSelector:@selector(setAttributedText:)]) {
//            
//            NSDictionary *attribs = @{
//                                      NSForegroundColorAttributeName:order_cell.LBL_order_date.textColor,
//                                      NSFontAttributeName: order_cell.LBL_order_date.font
//                                      };
//            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
//            
//            
//            
//            NSRange ename = [date_text rangeOfString:date];
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                        range:ename];
//            }
//            else
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor blackColor]}
//                                        range:ename];
//            }
//            order_cell.LBL_order_date.attributedText = attributedText;
//        }
//        else
//        {
//            order_cell.LBL_order_date.text = text;
//        }
//        NSString *qr = [NSString stringWithFormat:@"%@",[[json_DATA  objectAtIndex:indexPath.row] valueForKey:@"order_total"]];
//        qr = [qr stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
//        NSString *price = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],qr];
//        
//        if ([order_cell.LBL_price respondsToSelector:@selector(setAttributedText:)]) {
//            
//            // Define general attributes for the entire text
//            NSDictionary *attribs = @{
//                                      NSForegroundColorAttributeName:order_cell.LBL_price.textColor,
//                                      NSFontAttributeName:order_cell.LBL_price .font
//                                      };
//            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:price attributes:attribs];
//            
//            NSRange qrs = [price rangeOfString:qr];
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                        range:qrs];
//            }
//            else
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0]}
//                                        range:qrs];
//            }
//            order_cell.LBL_price.attributedText = attributedText;
//        }
//        else
//        {
//            order_cell.LBL_price.text = price;
//        }
//        order_cell.VW_content.layer.borderWidth = 0.5f;
//        order_cell.VW_content.layer.borderColor = [UIColor grayColor].CGColor;
//        [order_cell.BTN_order_ID addTarget:self action:@selector(move_to_detail:) forControlEvents:UIControlEventTouchUpInside];
//        order_cell.BTN_order_ID.tag = indexPath.row;
//
//    }

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
-(void)move_to_detail:(UIButton *)sender
{
    
        [[NSUserDefaults standardUserDefaults] setValue:[[search_arr objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"order_ID"];
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
