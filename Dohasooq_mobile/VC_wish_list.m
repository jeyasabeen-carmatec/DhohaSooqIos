//
//  VC_wish_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_wish_list.h"
#import "UIBarButtonItem+Badge.h"
#import "wish_list_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface VC_wish_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_product,*response_Arr;
    NSInteger product_count;
    UITapGestureRecognizer *tapGesture1 ;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;

}


@end

@implementation VC_wish_list

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"wish_list_cell" bundle:nil];
    [_TBL_wish_list_items registerNib:nib forCellReuseIdentifier:@"wish_list_cell"];
    
    [self set_UP_VIEW];
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

    [self performSelector:@selector(wish_list_api_calling) withObject:nil afterDelay:0.01];

}

-(void)set_UP_VIEW
{
    [self wish_list_api_calling];
    
    CGRect set_frame = _TBL_wish_list_items.frame;
    set_frame.origin.y =  - self.navigationController.navigationBar.frame.origin.y+20;
    set_frame.size.height = self.view.frame.size.height - set_frame.origin.y;
    _TBL_wish_list_items.frame = set_frame;
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    

    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action:)];
    
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action:)];
    //NSString *badge_value = @"25";
    
    
//    if(badge_value.length > 2)
//    {
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//        
//    }
//    else{
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//        
//    }

}

#pragma tableview delagates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return response_Arr.count;
    //return arr_product.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        wish_list_cell *cell = (wish_list_cell *)[tableView dequeueReusableCellWithIdentifier:@"wish_list_cell"];
    
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"wish_list_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

     #pragma Webimage URl Cachee
    
    NSString *img_url = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"image"]];
    [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                  options:SDWebImageRefreshCached];
    cell.LBL_item_name.text = [[response_Arr objectAtIndex:indexPath.row] valueForKey:@"product_name"];
    NSString *str = @"% off";
    
    
         cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"product_discount"],str];
    
    //NSString *str1 = [NSString stringWithFormat:@"%ld",[[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"special_price"] integerValue]];
    
         NSString *current_price = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"special_price"] ];
           NSString *prec_price = [NSString stringWithFormat:@"%@", [[response_Arr objectAtIndex:indexPath.row] valueForKey:@"product_price"] ];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setAlignment:NSTextAlignmentCenter];

    NSString *text = [NSString stringWithFormat:@"QR %@ QR %@",current_price,prec_price];

        if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
//            NSDictionary *attribs = @{
//                                      NSForegroundColorAttributeName:cell.LBL_current_price.textColor,
//                                      NSFontAttributeName:cell.LBL_current_price.font
//                                      };
           

            
            if ([current_price isEqualToString:@""] || [current_price isEqualToString:@"<null>"]) {
                
                
                NSString *text = [NSString stringWithFormat:@"QR %@",prec_price];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                
//                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                //NSParagraphStyleAttributeName
                cell.LBL_current_price.attributedText = attributedText;
                
                
                
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
                [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(current_price.length+7, [prec_price length])];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            cell.LBL_current_price.attributedText = attributedText;

        }
        }
        else
        {
            cell.LBL_current_price.text = text;
        }
        
        UIImage *newImage = [cell.BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIGraphicsBeginImageContextWithOptions(cell.BTN_close.image.size, NO, newImage.scale);
        [[UIColor darkGrayColor] set];
        [newImage drawInRect:CGRectMake(0, 0, cell.BTN_close.image.size.width, newImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.BTN_close.image = newImage;
        
        cell.BTN_close .userInteractionEnabled = YES;
        
    tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close:)];
        
        tapGesture1.numberOfTapsRequired = 1;
        
        [tapGesture1 setDelegate:self];
        
        [cell.BTN_close addGestureRecognizer:tapGesture1];
    
 
        [cell.Btn_add_cart addTarget:self action:@selector(btn_add_to_cart_action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
    
    cell._TXT_count.tag = indexPath.row;
    cell.BTN_plus.tag = indexPath.row;
    cell.BTN_minus.tag = indexPath.row;
    cell.Btn_add_cart.tag = indexPath.row;
    
        cell._TXT_count.layer.borderWidth = 0.4f;
        cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
        
        cell.BTN_plus.layer.borderWidth = 0.4f;
        cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
        cell.BTN_minus.layer.borderWidth = 0.4f;
        cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
    
    
//    CGSize result = [[UIScreen mainScreen] bounds].size;
//         if(result.height >= 480)
//        {
//            
//            [[cell LBL_ad_to_cart] setFont:[UIFont systemFontOfSize:10]];
//            
//            
//        }
//        else if(result.height >= 667)
//        {
//            
//             [[cell LBL_ad_to_cart] setFont:[UIFont systemFontOfSize:14]];
//            
//        }

        return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 147.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"id"]] forKey:@"product_id"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
   
    wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:indexPath];

    if (cell._TXT_count.tag == indexPath.row) {
        //NSString *items=cell._TXT_count.text;
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",cell._TXT_count.text] forKey:@"item_count"];


    }
    [self performSegueWithIdentifier:@"wish_to_product_detail" sender:self];
}


#pragma button_actions


-(void)btn_add_to_cart_action:(UIButton*)btn{
    
    [[NSUserDefaults standardUserDefaults]setObject:[[response_Arr objectAtIndex:btn.tag] valueForKey:@"product_price"] forKey:@"item_count"];
    [self add_to_cart_API_calling];
    
}

-(void)btn_cart_action:(UIBarButtonItem *)btn
{
    [self performSegueWithIdentifier:@"wish_to_cart" sender:self];

    NSLog(@"cart_clicked");
}
-(void)tapGesture_close:(UITapGestureRecognizer *)tapgstr
{
    CGPoint location = [tapgstr locationInView:_TBL_wish_list_items];
    NSIndexPath *indexPath = [_TBL_wish_list_items indexPathForRowAtPoint:location];
    NSString *product_id = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.row] valueForKey:@"id"]];
    
    [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
    [self performSelector:@selector(delete_from_wishLis) withObject:nil afterDelay:0.01];
    
}
-(void)minus_action:(UIButton*)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:index];
    product_count = [cell._TXT_count.text integerValue];
    if (product_count<= 0) {
       // [btn removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        product_count = 0;
    }
    else{
        product_count = product_count-1;
        cell._TXT_count.text = [NSString stringWithFormat:@"%ld",product_count];
           }
    [[NSUserDefaults standardUserDefaults]setObject:[[response_Arr objectAtIndex:index.row] valueForKey:@"id"] forKey:@"product_id"];
    [self updating_cart_List_api];
}
-(void)plus_action:(UIButton*)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:index];
    product_count = [cell._TXT_count.text integerValue];
    product_count = product_count+1;
    cell._TXT_count.text = [NSString stringWithFormat:@"%ld",product_count];
    [[NSUserDefaults standardUserDefaults]setObject:[[response_Arr objectAtIndex:index.row] valueForKey:@"id"] forKey:@"product_id"];
    [self updating_cart_List_api];
    
}
- (IBAction)back_action_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma wish_list_api_calling

-(void)wish_list_api_calling{
    response_Arr = [[NSMutableArray alloc]init];

    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    //http://192.168.0.171/dohasooq/apis/customerWishList/46/1/1
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/customerWishList/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    @try {
                        //[response_Arr addObjectsFromArray:data];
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        response_Arr = data;
                        NSLog(@"Wish List Data*******%@*********",response_Arr);
                        [self.TBL_wish_list_items reloadData];
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                    }
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        NSLog(@"%@",exception);
    }
}

#pragma mark add_to_cart_API_calling

-(void)add_to_cart_API_calling{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *items_count = [[NSUserDefaults standardUserDefaults]valueForKey:@"item_count"];
    
    //apis/addcartapi.json
    
//    this->request->data['pdtId'];
//    $userId = $this->request->data['userId'];
//    $qtydtl = $this->request->data['quantity'];
//    $custom = $this->request->data['custom'];
//    $variant = $this->request->data['variant'];
    
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    // NSDictionary *parameters = @{@"pdtId":[[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"],@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
    
    NSString *pdId = [[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"];
    NSDictionary *parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
    }
    
    if(aData)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Response  Error %@ Response %@",error,dict);
        [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
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
                    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
                    
                }
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }

        }
    }];
}

#pragma mark delete_from_wishList_API_calling

-(void)delete_from_wishLis{
    
   /* Del WishList
    
http://192.168.0.171/dohasooq/apis/delFromWishList/1/24.json
    
    example
    Product_id =1
    User_Id = 24

*/
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_ID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
       
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/delFromWishList/%@/%@.json",SERVER_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"],user_ID];
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"....%@",urlGetuser);
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"data:::%@",data);
                    @try {
                        
                        [HttpClient createaAlertWithMsg:[data valueForKey:@"msg"] andTitle:@""];
                        [self performSelector:@selector(wish_list_api_calling) withObject:nil afterDelay:0.01];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                        
                    }
                   
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);

    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)wishList_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"wish_to_cart" sender:self];
}
#pragma mark updating_cart_API
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
    NSLog(@"%@",parameters);
    
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



@end

