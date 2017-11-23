//
//  VC_cart_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_cart_list.h"
#import "UIBarButtonItem+Badge.h"
#import "Cart_cell.h"
#import "tbl_amount.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VC_cart_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *cart_array;
    NSDictionary *json_dict;
    NSInteger product_count;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    UITapGestureRecognizer *tapGesture1;
}

@end

@implementation VC_cart_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       [self set_UP_VIEW];
    UINib *nib = [UINib nibWithNibName:@"Cart_cell" bundle:nil];
    [_TBL_cart_items registerNib:nib forCellReuseIdentifier:@"Cart_cell"];
    [self.BTN_clear_cart addTarget:self action:@selector(clear_cart_action:) forControlEvents:UIControlEventTouchUpInside];
    
   }
-(void)viewWillAppear:(BOOL)animated{
    
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
    VW_overlay.hidden = YES;
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
    [self performSelector:@selector(cartList_api_calling) withObject:activityIndicatorView afterDelay:0.01];

}
-(void)set_UP_VIEW
{
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
//    NSString *badge_value = @"25";
//    
//    
//    if(badge_value.length > 2)
//    {
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//        
//    }
//    else{
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//        
//    }
//    NSString *qr = @"QR";
//    NSString *price = @"4565";
//    NSString *plans = @"VIEW PRICE DETAILS";
//    NSString *text = [NSString stringWithFormat:@"%@ %@\n%@",qr,price,plans];
//    if ([_LBL_price respondsToSelector:@selector(setAttributedText:)]) {
//        
//        // Define general attributes for the entire text
//        NSDictionary *attribs = @{
//                                  NSForegroundColorAttributeName:_LBL_price.textColor,
//                                  NSFontAttributeName:_LBL_price.font
//                                  };
//        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
//        
//        
//        
//        NSRange ename = [text rangeOfString:qr];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                    range:ename];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
//                                    range:ename];
//        }
//        NSRange cmp = [text rangeOfString:price];
//        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
//        //
//        
//        
//        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
//                                    range:cmp];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
//                                    range:cmp ];
//        }
//        NSRange cmp1 = [text rangeOfString:plans];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:19.0]}
//                                    range:cmp1];
//            
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0]}
//                                    range:cmp1];        }
//
//        
//       _LBL_price.attributedText = attributedText;
//    }
//    else
//    {
//        _LBL_price.text = text;
//    }
        NSString *next = @"";
    NSString *next_text = [NSString stringWithFormat:@"NEXT %@",next];
    if ([_LBL_next respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_next.textColor,
                                  NSFontAttributeName:_LBL_next.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:next_text attributes:attribs];
        
        
        
        NSRange ename = [next_text rangeOfString:next];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        
        _LBL_next.attributedText = attributedText;
    }
    else
    {
        _LBL_next.text = next_text;
    }
    
    UIImage *newImage = [_IMG_cart.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_IMG_cart.image.size, NO, newImage.scale);
    [[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0] set];
    [newImage drawInRect:CGRectMake(0, 0, _IMG_cart.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _IMG_cart.image = newImage;

    

    

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
    return cart_array.count;
    }
    else
    {
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        Cart_cell *cell = (Cart_cell *)[tableView dequeueReusableCellWithIdentifier:@"Cart_cell"];


    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"Cart_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
   }
    
      
        cell.LBL_item_name.text = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"pname"]];
        NSString *img_url = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"product_image_path"]];
        
        [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                  options:SDWebImageRefreshCached];
        NSString *current_price = [NSString stringWithFormat:@"%@", [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"special_price"]];
        
        NSString *prec_price = [NSString stringWithFormat:@"%@", [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"product_price"]];
        
        NSString *text = [NSString stringWithFormat:@"QR %@   %@",current_price,prec_price];
        
        
            if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                if ([current_price isEqualToString:@""]|| [current_price isEqualToString:@"null"]||[current_price isEqualToString:@"<null>"]) {
                    
                    
                    NSString *text = [NSString stringWithFormat:@"QR %@",prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:[text rangeOfString:prec_price]];
                    //cell.LBL_current_price.text = [NSString stringWithFormat:@"QR %@",prec_price];
                    cell.LBL_current_price.attributedText = attributedText;
                    cell.LBL_discount.text = @"0% off";
                    
                }
                else{
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
                
                
                NSRange ename = [text rangeOfString:current_price];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:ename];
                }
                NSRange cmp = [text rangeOfString:prec_price];
                //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
                //
                
                
                //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                            range:cmp];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                            range:cmp ];
                }
                @try {
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(current_price.length+6, [prec_price length])];
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
                
                cell.LBL_current_price.attributedText = attributedText;
                    float disc = [prec_price integerValue]-[current_price integerValue];
                    float digits = disc/[prec_price integerValue];
                    int discount = digits *100;
                    NSString *of = @"% off";
                    cell.LBL_discount.text =[NSString stringWithFormat:@"%d%@",discount,of];
                    
                    
                    
            }
            }
            else
            {
                cell.LBL_current_price.text = text;
            }
            
       

    //cell.LBL_discount.text = [temp_dict valueForKey:@"key4"];
    
    
//    UIImage *newImage = [cell.BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIGraphicsBeginImageContextWithOptions(cell.BTN_close.image.size, NO, newImage.scale);
//    [[UIColor darkGrayColor] set];
//    [newImage drawInRect:CGRectMake(0, 0, cell.BTN_close.image.size.width/2, newImage.size.height/2)];
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    cell.BTN_close.image = newImage;
    
   // cell.BTN_close .userInteractionEnabled = YES;
    
//    tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close)];
//    
//    tapGesture1.numberOfTapsRequired = 1;
//    
//    [tapGesture1 setDelegate:self];
//    
//    [cell.BTN_close addGestureRecognizer:tapGesture1];
        [cell.BTN_close addTarget:self action:@selector(remove_from_cart:) forControlEvents:UIControlEventTouchUpInside];
        
    
    [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
    [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
        
    cell.BTN_plus.tag = indexPath.row;
    cell.BTN_minus.tag = indexPath.row;
    cell._TXT_count.tag = indexPath.row;
        cell.BTN_close.tag = indexPath.row;
        
    cell._TXT_count.layer.borderWidth = 0.4f;
    cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
    cell.BTN_plus.layer.borderWidth = 0.4f;
    cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
    cell.BTN_minus.layer.borderWidth = 0.4f;
    cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
     return cell;
    }
    else
    {
        tbl_amount *cell = (tbl_amount *)[tableView dequeueReusableCellWithIdentifier:@""];

        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"tbl_amount" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.redempion_lbl.hidden = YES;
        cell.redemption_amt.hidden = YES;
        
        NSString *total_amt = [NSString stringWithFormat:@"%@",[json_dict valueForKey:@"sub_total"]];
        
        if ([total_amt isEqualToString:@"(null)"]|| [total_amt isEqualToString:@"<null>"]) {
            NSString *code = @"QR";
            total_amt = @"0";
            NSString *text = [NSString stringWithFormat:@"%@ %@",code,total_amt];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:[text rangeOfString:total_amt]];
            
            cell.LBL_amount.attributedText = attributedText;
            cell.LBL_total_amount.attributedText = attributedText;
        }
        else{
        NSString *text = [NSString stringWithFormat:@"QR %@",total_amt];
        
        if ([cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:cell.LBL_total_amount.textColor,
                                      NSFontAttributeName:cell.LBL_total_amount.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [text rangeOfString:total_amt];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:19.0]}
                                        range:ename];
            }
            NSRange cmp = [text rangeOfString:total_amt];
            //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
            //
            
            
            //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:21.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}
                                        range:cmp ];
            }

            cell.LBL_total_amount.attributedText = attributedText;
        }
        else
        {
            cell.LBL_total_amount.text = text;
        }
        }

        
        return cell;

    }
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 147.0;
}
#pragma button_actions
-(void)btnfav_action
{
    NSLog(@"fav_clicked");
}
-(void)btn_cart_action
{
     NSLog(@"cart_clicked");
}
//-(void)tapGesture_close
//{
//    CGPoint location = [tapGesture1 locationInView:_TBL_cart_items];
//    NSIndexPath *indexPath = [_TBL_cart_items indexPathForRowAtPoint:location];

//    //Cart_cell *cell = (Cart_cell *)[_TBL_cart_items cellForRowAtIndexPath:indexPath];
//    NSString *product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
//    [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
//    [self performSelector:@selector(delete_from_cart) withObject:activityIndicatorView afterDelay:0.01];
//    
//    
//
//    NSLog(@"the cancel clicked");
//}
-(void)remove_from_cart:(UIButton*)sender{
    @try {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        NSString *product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
        [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
        [self performSelector:@selector(delete_from_cart) withObject:activityIndicatorView afterDelay:0.01];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
   
}
-(void)minus_action:(UIButton*)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    Cart_cell *cell = (Cart_cell *)[_TBL_cart_items cellForRowAtIndexPath:index];
    product_count = [cell._TXT_count.text integerValue];
    if (product_count<= 0) {
        [btn removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        product_count = product_count-1;
        cell._TXT_count.text = [NSString stringWithFormat:@"%ld",product_count];
        
    }
     [[NSUserDefaults standardUserDefaults]setObject:cell._TXT_count.text forKey:@"item_count"];
    NSString *product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:index.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
    [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
    // Update cart Api method calling
    
    [self updating_cart_List_api];
    
}
-(void)plus_action:(UIButton*)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    Cart_cell *cell = (Cart_cell *)[self.TBL_cart_items cellForRowAtIndexPath:index];
    product_count = [cell._TXT_count.text integerValue];
    product_count = product_count+1;
    cell._TXT_count.text = [NSString stringWithFormat:@"%ld",product_count];
    
    NSString *product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:index.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
    [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
    [[NSUserDefaults standardUserDefaults]setObject:cell._TXT_count.text forKey:@"item_count"];
    // Update cart Api method calling
    
    [self updating_cart_List_api];
    
    
}

- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BTN_next_action:(id)sender {
     [self performSegueWithIdentifier:@"order_detail_segue" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wishListAction:(id)sender {
    [self performSegueWithIdentifier:@"cart_to-wishList" sender:self];
}

/*
 apis/shoppingcartapi.json
 POST
params.put("customerId",customerid);
                 params.put("languageId",  language_val);
                 params.put("countryId",  country_val);
 
 */
#pragma mark cartList_api_calling
-(void)cartList_api_calling{
    
    @try {
        cart_array = [[NSMutableArray alloc]init];
        
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        // NSDictionary *parameters = @{@"pdtId":[[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"],@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
        NSString *langId = [[NSUserDefaults standardUserDefaults]valueForKey:@"language_id"];
        NSString *cntrId = [[NSUserDefaults standardUserDefaults]valueForKey:@"country_id"];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        
        NSDictionary *parameters = @{@"customerId":custmr_id,@"languageId":langId,@"countryId":cntrId};
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
        
        
        NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/shoppingcartapi.json",SERVER_URL]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];
        }
        
        if(aData)
        {
            json_dict = [NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            @try {
                [self custom_text_view_price_details];
                NSArray *allkeysArr = [[json_dict valueForKey:@"data"] allKeys];
                for (int i = 0; i<allkeysArr.count; i++) {
                    [cart_array addObject:[[json_dict valueForKey:@"data"] valueForKey:[allkeysArr objectAtIndex:i]]];
                }
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];
                [self.TBL_cart_items reloadData];
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];
                
            }
            
            
        }

    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
/*
 Clear cart/ Empty cart
 Function Name : apis/clearcartapi.json
 Parameters :$customerId
 Method : GET

 */
-(void)clear_cart_action:(UIButton*)sender{
//    [self clear_cart_api];
    [self performSelector:@selector(clear_cart_api) withObject:activityIndicatorView afterDelay:0.01];
    [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
}
#pragma mark clear_cart_api_calling
-(void)clear_cart_api{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/clearcartapi/%@.json",SERVER_URL,custmr_id];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                    [self cartList_api_calling];
                    [self.TBL_cart_items reloadData];
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
    }
}
#pragma cart_count_api

-(void)cart_count{
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
        }
        if (data) {
            NSLog(@"%@",data);
            @try {
                NSString *badge_value = [NSString stringWithFormat:@"%@",[data valueForKey:@"count"]];
                //NSString *badge_value = @"11";
                if(badge_value.length > 2)
                {
                    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
                    
                }
                else{
                    self.navigationItem.rightBarButtonItem.badgeValue = badge_value ;
                    
                }
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
        }
    }];
}




-(void)custom_text_view_price_details{
    NSString *qr = @"QR";
    NSString *price = [NSString stringWithFormat:@"%@",[json_dict valueForKey:@"sub_total"]];
    if ([price isEqualToString:@""]||[price isEqualToString:@"null"]||[price isEqualToString:@"<null>"]) {
        price = @"0";
    }
    NSString *plans = @"VIEW PRICE DETAILS";
    NSString *text = [NSString stringWithFormat:@"%@ %@\n%@",qr,price,plans];
    if ([_LBL_price respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_price.textColor,
                                  NSFontAttributeName:_LBL_price.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:qr];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                    range:ename];
        }
        NSRange cmp = [text rangeOfString:price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp ];
        }
        NSRange cmp1 = [text rangeOfString:plans];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:19.0]}
                                    range:cmp1];
            
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0]}
                                    range:cmp1];        }
        
        
        _LBL_price.attributedText = attributedText;
    }
    else
    {
        _LBL_price.text = text;
    }

}
#pragma delete_from_cart_API_calling

-(void)delete_from_cart{
    /*
     
     Delete product from cart
     
     Function Name : apis/deletepdtcartapi.json
     Parameters :$productID,$customerId
     Method : GET

     */
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/deletepdtcartapi/%@/%@.json",SERVER_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"],custmr_id];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                    [self cartList_api_calling];
                    [self.TBL_cart_items reloadData];
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
    }

}
#pragma updating_cart_API
/*
 Update cart
 apis/updatecartapi.json
 Parameters :
 
 quantity,
 productId,
 customerId
 
 Method : POST
 */

-(void)updating_cart_List_api{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSDictionary *parameters = @{@"quantity":[[NSUserDefaults standardUserDefaults] valueForKey:@"item_count"],@"productId":[[NSUserDefaults standardUserDefaults]valueForKey:@"product_id"],@"customerId":custmr_id};
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updatecartapi.json",SERVER_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
            if (data) {
                //NSLog(@"%@",data);
            
                
                @try {
                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                } @catch (NSException *exception) {
                    NSLog(@"exception:: %@",exception);
                }
                
              
            }
            
        });
        
    }];
}

#pragma mark Update quantity in checkout with shipcharges
/*
 Update quantity in checkout with shipcharges
 Function Name : apis/updateqtycheckoutapi.json
 Parameters :$customerId
 Method : GET*/



@end
