//
//  VC_myorders.m
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_myorders.h"
#import "first_top_cell.h"
#import "orders_cell.h"
#import "cost_find_cell.h"
#import "address_cell.h"
#import "HttpClient.h"
#import "tbl_amount.h"
#import "Payment_summary_cell.h"
#import "Transaction_Type_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_myorders ()<UITableViewDataSource,UITableViewDelegate>
{
NSMutableDictionary *jsonresponse_dic_address,*json_DATA;
UIView *VW_overlay;
UIActivityIndicatorView *activityIndicatorView;
int j ,i;
}

@end

@implementation VC_myorders

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(orders_LIST_Detail) withObject:activityIndicatorView afterDelay:0.01];
    
    
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        NSArray *key = [[json_DATA valueForKey:@"Order"] allKeys];
        NSInteger count =0;
        @try
        {
            count = [[[[json_DATA valueForKey:@"Order"] valueForKey:[key objectAtIndex:0]] valueForKey:@"Products"] count];
        }
        @catch(NSException *exception)
        {
            count = 0;
            
        }
     
        return count;
    }
  
        return 1;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        
        index = 1;
        
    }
    else{
        index = 0;
    }
    
    
    
    NSArray *keys_arr = [[json_DATA valueForKey:@"Order"] allKeys];
    
    switch (indexPath.section) {
           
        case 0:
        {
            orders_cell *order_cell = (orders_cell *)[tableView dequeueReusableCellWithIdentifier:@"orders_cell"];
            if (order_cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"orders_cell" owner:self options:nil];
                order_cell = [nib objectAtIndex:index];
            }
            
            
            NSString *img_url = [NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
        
            
            [order_cell.IMG_item_image sd_setImageWithURL:[NSURL URLWithString:img_url]
                                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                                  options:SDWebImageRefreshCached];
            
            NSString *item_name =  [NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"product_name"]];
            item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            item_name = [item_name stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
            
            NSString *item_seller =[NSString stringWithFormat:@"Seller:%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"merchant_name"]];
            
            
            //
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                item_seller =[NSString stringWithFormat:@"البائع: %@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"merchant_name"]];
            }
            
            
            
            item_seller = [item_seller stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            item_seller = [item_seller stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
            
            
            order_cell.LBL_item_name.numberOfLines = 0;
            order_cell.LBL_item_name.text = item_name;
            order_cell.LBL_seller.text = item_seller;
            
            NSString *qr =[NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"product_subtotal"]];
            qr = [qr stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            qr = [qr stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
            
            NSString *price = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],qr];
            
            if ([order_cell.LBL_price respondsToSelector:@selector(setAttributedText:)]) {
                
            NSDictionary *attribs = @{NSForegroundColorAttributeName:order_cell.LBL_price.textColor,
                                          NSFontAttributeName:order_cell.LBL_price .font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:price attributes:attribs];
                
                NSRange qrs = [price rangeOfString:qr];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:qrs];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:qrs];
                }
                order_cell.LBL_price.attributedText = attributedText;
            }
            else
            {
                order_cell.LBL_price.text = price;
            }
            
            
            NSString *qty =[NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"product_qty"]];
            qty = [qty stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            qty = [qty stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
            
            order_cell.LBL_QTY.text = [NSString stringWithFormat:@"QTY:%@",qty];
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                  order_cell.LBL_QTY.text = [NSString stringWithFormat:@"الكمية:%@",qty];
            }
            
            
             NSString *date =[NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"delivery_time"]];
            
            date = [date stringByReplacingOccurrencesOfString:@"<null>" withString:@"No delivery time allocated "];
            date = [date stringByReplacingOccurrencesOfString:@"" withString:@"No delivery time allocated "];
            NSString *expect_text = @"Expected Delivary On  ";
            
            NSString *date_text = [NSString stringWithFormat:@"%@%@",expect_text,date];
            
            
            if ([order_cell.LBL_Deliver_on respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:order_cell.LBL_Deliver_on.textColor,
                                          NSFontAttributeName: order_cell.LBL_Deliver_on.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
                
                
                
                NSRange ename = [date_text rangeOfString:date];
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height <= 480)
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                            range:[date_text rangeOfString:expect_text]];

                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                            range:ename];

                    
                }
                else if(result.height <= 568)
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                            range:[date_text rangeOfString:expect_text]];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                            range:ename];

                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                            range:[date_text rangeOfString:expect_text]];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                            range:ename];
                    
                    

             
                }

                
                
                order_cell.LBL_Deliver_on.attributedText = attributedText;
            }
            else
            {
                order_cell.LBL_Deliver_on.text = date_text;
            }
            [order_cell.BTN_rating addTarget:self action:@selector(review_Screen:) forControlEvents:UIControlEventTouchUpInside];
            NSString *status = [NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:indexPath.row] valueForKey:@"shipment_status"]];
            status = [status stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            status = [status stringByReplacingOccurrencesOfString:@"null" withString:@""];
            status = [status stringByReplacingOccurrencesOfString:@"" withString:@""];
           order_cell.BTN_rating.hidden = YES;
            
            
           

            
          
            if([status isEqualToString:@""])
            {
                order_cell.IMG_track_image.image = [UIImage imageNamed:@"5"];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    UIImage* flippedImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"5"].CGImage
                                                                scale:[UIImage imageNamed:@"5"].scale
                                                          orientation:UIImageOrientationUpMirrored];
                    order_cell.IMG_track_image.image = flippedImage;
                }
                
                
            }
            else  if([status isEqualToString:@"Pending"])
            {
                order_cell.IMG_track_image.image = [UIImage imageNamed:@"4"];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    UIImage* flippedImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"4"].CGImage
                                                                scale:[UIImage imageNamed:@"4"].scale
                                                          orientation:UIImageOrientationUpMirrored];
                    order_cell.IMG_track_image.image = flippedImage;
                }
                
                
            }
            else  if([status isEqualToString:@"Packed"])
            {
                order_cell.IMG_track_image.image = [UIImage imageNamed:@"3"];
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    UIImage* flippedImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"3"].CGImage
                                                                scale:[UIImage imageNamed:@"3"].scale
                                                          orientation:UIImageOrientationUpMirrored];
                    order_cell.IMG_track_image.image = flippedImage;
                }
            }
            else  if([status isEqualToString:@"Dispatched"])
            {
                order_cell.IMG_track_image.image = [UIImage imageNamed:@"2"];
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    UIImage* flippedImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"2"].CGImage
                                                                scale:[UIImage imageNamed:@"2"].scale
                                                          orientation:UIImageOrientationUpMirrored];
                    order_cell.IMG_track_image.image = flippedImage;
                }
                
            }
            else  if([status isEqualToString:@"Delivered"])
            {
                order_cell.LBL_Deliver_on.text = @"Delivered";
                order_cell.BTN_rating.hidden = NO;
                
                order_cell.IMG_track_image.image = [UIImage imageNamed:@"1"];
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    UIImage* flippedImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"1"].CGImage
                                                                scale:[UIImage imageNamed:@"1"].scale
                                                          orientation:UIImageOrientationUpMirrored];
                    order_cell.IMG_track_image.image = flippedImage;
                }
                
            }



            
            return order_cell;
        }
            break;
        case 1:
        {
            cost_find_cell *cost_cell = (cost_find_cell *)[tableView dequeueReusableCellWithIdentifier:@"cost_cell"];
            
            if (cost_cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"cost_find_cell" owner:self options:nil];
                cost_cell = [nib objectAtIndex:index];
            }
            NSString *item = [NSString stringWithFormat:@"%lu",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] count]];
            item = [item stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            item = [item stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
           cost_cell.LBL_Total_items.text = [NSString stringWithFormat:@"Total Items: %@",item];
            
            NSString *qr = [NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"order_total"]];
            qr = [qr stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            qr = [qr stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
            
            NSString *price = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],qr];
            
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                cost_cell.LBL_Total_items.text = [NSString stringWithFormat:@" إجمالي العناصر: %@",item];
                price = [NSString stringWithFormat:@"%@ %@",qr,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
            }
            
            if ([cost_cell.LBL_cost respondsToSelector:@selector(setAttributedText:)]) {
                
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cost_cell.LBL_cost.textColor,
                                          NSFontAttributeName:cost_cell.LBL_cost.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:price attributes:attribs];
                
                NSRange qrs = [price rangeOfString:qr];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:qrs];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:qrs];
                }
                cost_cell.LBL_cost.attributedText = attributedText;
            }
            else
            {
                cost_cell.LBL_cost.text = price;
            }
            return cost_cell;
        }
            break;
            
        case 2:
        {
            static NSString *cellIdentifier = @"dklsjfkljdsfk123";
            address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
                cell = [nib objectAtIndex:index];
            }
            cell.BTN_edit_addres.hidden = YES;
            cell.BTN_edit.hidden = YES;
             cell.Btn_close.hidden =  YES;
            
            cell.VW_layer.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.VW_layer.layer.borderWidth = 0.5f;
            
            
            NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_firstname"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_lastname"]];
            name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            cell.LBL_name.text = name_str;
            
            NSString *adddress1 = [NSString stringWithFormat:@"%@ , %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_address1"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_address2"]];
            adddress1 = [adddress1 stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *city = [NSString stringWithFormat:@"%@ , %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_city"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_state"]];
            city = [city stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *country = [NSString stringWithFormat:@"%@ , %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_country"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"billing_zip_code"]];
            country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *phone = [NSString stringWithFormat:@"Mobile : %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Billing"] valueForKey:@"customermobile"]];
            phone = [phone stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *address_str = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",adddress1,city,country,phone];
            
            address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            cell.LBL_address.text = address_str;
            
            
            
            return cell;
        }
            break;
            
        case 3:
        {
            static NSString *cellIdentifier = @"dklsjfkldfgfhjdsfk123";
            address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
                cell = [nib objectAtIndex:index];
            }
            
            cell.BTN_edit_addres.hidden = YES;
            cell.BTN_edit.hidden = YES;
            cell.Btn_close.hidden =  YES;
            
            cell.VW_layer.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.VW_layer.layer.borderWidth = 0.5f;
            
            NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_firstname"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_lastname"]];
            name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            cell.LBL_name.text = name_str;
            
            NSString *adddress1 = [NSString stringWithFormat:@"%@ , %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_address1"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_address2"]];
            adddress1 = [adddress1 stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *city = [NSString stringWithFormat:@"%@ , %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_city"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_state"]];
            city = [city stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *country = [NSString stringWithFormat:@"%@ , %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_country"],[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_zip_code"]];
            country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            NSString *phone = [NSString stringWithFormat:@"Mobile : %@",[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Shipping"] valueForKey:@"shipping_mobile"]];
            phone = [phone stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];

            
            NSString *address_str = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",adddress1,city,country,phone];
            
            address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            cell.LBL_address.text = address_str;
            
            return cell;
        }
            break;
          
        case 4:{
            
            //Transaction_Type_cell
            
            Transaction_Type_cell *cell = (Transaction_Type_cell *)[tableView dequeueReusableCellWithIdentifier:@"pay_cell"];
            
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"Transaction_Type_cell" owner:self options:nil];
                cell = [nib objectAtIndex:index];
            }
            
            NSString *transaction_str;
              NSString *str_pay = @" AMOUNT PAID THROUGH:";
            NSString *type_str;
            @try {
                if ([[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"transactionstatus"] isKindOfClass:[NSDictionary class]]) {
                
                    type_str =[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"transactionstatus"] valueForKey:@"payment_method"];
                    if ([type_str isEqualToString:@"<nil>"]||[type_str isEqualToString:@"<null>"]||[type_str isEqualToString:@""]) {
                        type_str = @"";
                    }
                   
                }
                 transaction_str = [NSString stringWithFormat:@" %@ %@",str_pay,type_str];
                
                if ([cell.lbl_transaction respondsToSelector:@selector(setAttributedText:)]) {
                    
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.lbl_transaction.textColor,
                                              NSFontAttributeName: cell.lbl_transaction.font
                                              };
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:transaction_str attributes:attribs];
                    
                    
                    
                    NSRange ename = [transaction_str rangeOfString:type_str];
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height <= 480)
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                                range:[transaction_str rangeOfString:str_pay]];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                                range:ename];
                        
                        
                    }
                    else if(result.height <= 568)
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                                range:[transaction_str rangeOfString:str_pay]];
                        
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                                range:ename];
                        
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                               range:[transaction_str rangeOfString:str_pay]];
                        
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                                range:ename];
            
                    }
                    
                    
                    
                    cell.lbl_transaction.attributedText = attributedText;

                }
                else{
                     cell.lbl_transaction.text = transaction_str;
                }
                
                
                
                
            } @catch (NSException *exception) {
               //cell.lbl_transaction.attributedText = attributedText;
            }
            return cell;
        }
            break;
        default:
        {
            Payment_summary_cell *cell = (Payment_summary_cell *)[tableView dequeueReusableCellWithIdentifier:@"pay_cell"];
            
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"Payment_summary_cell" owner:self options:nil];
                cell = [nib objectAtIndex:index];
            }
            NSString *sub_total = [NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"order_subtotal"]];
            sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
            sub_total = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],sub_total];
            
            NSString *shipping = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"shipping_amount"]];
            shipping = [shipping stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
            
            NSString *discount = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"discount"]];
            discount = [discount stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
            NSString *str_disc =[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"discount"];
            
            if([str_disc isKindOfClass:[NSNull class]])
            {
                cell.LBL_discount.text = @"";
                cell.LBL_discount_TXT.text = @"";
            }
            else
            {
            @try
            {
            str_disc = [str_disc stringByReplacingOccurrencesOfString:@"<nil>" withString:@"0"];

            str_disc = [str_disc stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];

            }
            @catch(NSException *exception)
            {
                cell.LBL_discount.text = @"";
                cell.LBL_discount_TXT.text = @"";
            }
            cell.LBL_discount.text = @"";
            if([str_disc isEqualToString:@"0"])
            {
                
                cell.LBL_discount.text = @"";
                cell.LBL_discount_TXT.text = @"";
            }
            else if(!str_disc)
            {
                cell.LBL_discount.text = @"";
                cell.LBL_discount_TXT.text = @"";
                
            }
            else{
               
                 cell.LBL_discount.text = discount;
                cell.LBL_discount_TXT.text = @"Discount";
            }
            }
           
            cell.LBL_sub_total.text = sub_total;
            cell.LBL_ship_charge.text = shipping;
            
            cell.LBL_total.text =sub_total;
            NSString *current_price = [[NSUserDefaults standardUserDefaults] valueForKey:@"currency"];
             //NSString *current_price = [NSString stringWithFormat:@"QR"];
            NSString *prec_price = [NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]]  valueForKey:@"order_total"]];
            NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
            
            if ([cell.LBL_total respondsToSelector:@selector(setAttributedText:)]) {
                
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_total.textColor,
                                          NSFontAttributeName:cell.LBL_total.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                
                
                
                NSRange ename = [text rangeOfString:current_price];
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
                NSRange cmp = [text rangeOfString:prec_price];
            
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                            range:cmp ];
                
                cell.LBL_total.attributedText = attributedText;
            }
            else
            {
                cell.LBL_total.text = text;
            }
            
            
            return cell;
        }
            break;
               }
    
    }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        return 260;
    }
    
    if(indexPath.section == 1 || indexPath.section == 4)
    {
        return 45;
    }
    
    if(indexPath.section == 2)
    {
        return 190;
    }
    
    if(indexPath.section == 3)
    {
        return 190;
    }
    
    return 180;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 || indexPath.section == 3)
    {
    return 10;
    }
    else
    {
        return 30;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2)
    {
        return @"BILLING ADDRESS";
    }
    if (section == 3)
    {
        return @"SHIPPING ADDRESS";
    }
    else{
        return @"";
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.TBL_orders.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(10,0, self.TBL_orders.frame.size.width-20, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [headerView addSubview:label];
    label.textColor = [UIColor lightGrayColor];
    [label setFont:[UIFont fontWithName:@"Poppins-Regular" size:15]];
    if(section == 2)
    {
    
        label.text=@"BILLING ADDRESS";
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            label.text = @"عنوان الفاتورة ";
            label.textAlignment = NSTextAlignmentRight;
        }
        
    
    }
    if(section == 3)
    {
        label.text= @"SHIPPING ADDRESS";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            label.text = @"عنوان الشحن";
            label.textAlignment = NSTextAlignmentRight;
        }
    }
    
    
    return headerView;
}

-(void)orders_LIST_Detail
{
   @try
    {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *ORDER_ID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"]];

    
    NSString *urlString =[NSString stringWithFormat:@"%@Apis/orderviewapi.json",SERVER_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    //    [request setHTTPBody:body];
    
    // text parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
    [body appendData:[[NSString stringWithFormat:@"%@",user_id]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orderId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",ORDER_ID]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"langId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",languge]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //
    NSError *er;
//    NSHTTPURLResponse *response = nil;

    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (returnData) {
        json_DATA = [[NSMutableDictionary alloc]init];
    json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
               NSLog(@"%@", [NSString stringWithFormat:@"JSON DATA OF ORDER DETAIL: %@", json_DATA]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.TBL_orders reloadData];

        });
        
        
        NSArray *keys_arr = [[json_DATA valueForKey:@"Order"] allKeys];
        NSString *str = [NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"order_number"]];
        str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        str = [str stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
        NSString *od_id = @"ORDER ID: ";
         NSString *text = [NSString stringWithFormat:@"%@%@",od_id,str];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
        od_id = @":رقم الطلبية";
        text = [NSString stringWithFormat:@"%@%@",str,od_id];
        }
        
        
        if ([_LBL_order_ID respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_order_ID.textColor,
                                      NSFontAttributeName: _LBL_order_ID.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [text rangeOfString:str];
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                        range:[text rangeOfString:od_id]];

                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor blueColor]}
                                        range:ename];
 
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                        range:[text rangeOfString:od_id]];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor blueColor]}
                                        range:ename];

            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                        range:[text rangeOfString:od_id]];

                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName :[UIColor blueColor]}
                                        range:ename];
                

            }
            

            
            _LBL_order_ID.attributedText = attributedText;
        }
        else
        {
            _LBL_order_ID.text = text;
        }
        NSString *date = [NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"order_created"]];
        date = [date stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        date = [date stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
        
        NSString *date_txt= @"Ordered On:";
        NSString *date_text = [NSString stringWithFormat:@"%@%@",date_txt,date];
        
        
        if ([_LBL_order_date respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_order_date.textColor,
                                      NSFontAttributeName: _LBL_order_date.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
            
            
            
            NSRange ename = [date_text rangeOfString:date];
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:[date_text rangeOfString:date_txt]];

                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:8.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:ename];
                
                
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:[date_text rangeOfString:date_txt]];
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:10.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:ename];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:[date_text rangeOfString:date_txt]];
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:ename];
            }
            
            _LBL_order_date.attributedText = attributedText;
        }
        else
        {
            _LBL_order_date.text = text;
        }
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;


        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
   
    }
    @catch(NSException *exception)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSLog(@"THE EXception:%@",exception);
        
    }
  
}

- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)review_Screen:(UIButton *)sender
{
    NSArray *keys_arr = [[json_DATA valueForKey:@"Order"] allKeys];
    NSString *item_name =  [NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:sender.tag] valueForKey:@"product_name"]];
    NSString *item_seller =[NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:sender.tag] valueForKey:@"merchant_name"]];
    NSString *image_url =  [NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:sender.tag] valueForKey:@"product_image"]];
    NSString *product_ID =[NSString stringWithFormat:@"%@",[[[[[json_DATA valueForKey:@"Order"] valueForKey:[keys_arr objectAtIndex:0]] valueForKey:@"Products"] objectAtIndex:sender.tag] valueForKey:@"product_id"]];

    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"review_item_name"];
    [[NSUserDefaults standardUserDefaults] setValue:item_seller forKey:@"review_item_seller_name"];
    [[NSUserDefaults standardUserDefaults] setValue:image_url forKey:@"review_item_image_name"];
    [[NSUserDefaults standardUserDefaults] setValue:product_ID forKey:@"review_Prod_ID"];


    [[NSUserDefaults standardUserDefaults] synchronize];

    

    [self performSegueWithIdentifier:@"order_rating" sender:self];
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
