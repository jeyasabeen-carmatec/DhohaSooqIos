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

@interface VC_myorders ()<UITableViewDataSource,UITableViewDelegate>
{
NSMutableDictionary *jsonresponse_dic_address;
UIView *VW_overlay;
UIActivityIndicatorView *activityIndicatorView;
int j ,i;
}

@end

@implementation VC_myorders

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];

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
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(Shipp_address_API) withObject:activityIndicatorView afterDelay:0.01];
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
        
    }
    else if(section == 1)
    {
        return 2;
    }
    else if(section == 2)
    {
        return 1;
    }
    else if(section == 3)
    {
        return [[[jsonresponse_dic_address valueForKey:@"billaddress"]allKeys]count] ;
        
    }
    else if(section == 4)
    {
        return [[[jsonresponse_dic_address valueForKey:@"shipaddress"]allKeys]count] ;
        
    }
    else
    {
        return 1;
    }


    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        first_top_cell *top_cell = (first_top_cell *)[tableView dequeueReusableCellWithIdentifier:@"first_cell"];
        if (top_cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"first_top_cell" owner:self options:nil];
            top_cell = [nib objectAtIndex:0];
        }
        NSString *str = @"789457534";
        NSString *text = [NSString stringWithFormat:@"ORDER ID : %@",str];
        
        
        if ([top_cell.LBL_order_ID respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:top_cell.LBL_order_ID.textColor,
                                      NSFontAttributeName: top_cell.LBL_order_ID.font
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
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName :[UIColor blueColor]}
                                        range:ename];
            }
            top_cell.LBL_order_ID.attributedText = attributedText;
        }
        else
        {
            top_cell.LBL_order_ID.text = text;
        }
        NSString *date = @"sun,jun 4th,2017";
        NSString *date_text = [NSString stringWithFormat:@"Order on: %@",date];
        
        
        if ([top_cell.LBL_order_ID respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:top_cell.LBL_order_Date.textColor,
                                      NSFontAttributeName: top_cell.LBL_order_Date.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
            
            
            
            NSRange ename = [date_text rangeOfString:date];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                        range:ename];
            }
            top_cell.LBL_order_Date.attributedText = attributedText;
        }
        else
        {
            top_cell.LBL_order_Date.text = text;
        }
        


        
        return top_cell;
        
    }
    else if(indexPath.section == 1)
    {
        orders_cell *order_cell = (orders_cell *)[tableView dequeueReusableCellWithIdentifier:@"order_cell"];
        if (order_cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"orders_cell" owner:self options:nil];
            order_cell = [nib objectAtIndex:0];
        }


        
        NSString *item_name =[NSString stringWithFormat:@"Shining Diva Fashion"];
        
        item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
        NSString *item_seller =[NSString stringWithFormat:@"Seller : Anar ahar"];
        item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
        
        NSString *name_text = [NSString stringWithFormat:@"%@\n%@",item_name,item_seller];
        order_cell.LBL_item_name.numberOfLines = 0;
        
        
        if ([order_cell.LBL_item_name respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:order_cell.LBL_item_name.textColor,
                                      NSFontAttributeName:order_cell.LBL_item_name.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:name_text attributes:attribs];
            
            
            
            NSRange ename = [name_text rangeOfString:item_name];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
                                        range:ename];
            }
            NSRange cmp = [name_text rangeOfString:item_seller];
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0]}
                                        range:cmp ];
            }
            order_cell.LBL_item_name.attributedText = attributedText;
        }
        else
        {
            order_cell.LBL_item_name.text = name_text;
        }
        
        NSString *qr = @"285";
        NSString *price = [NSString stringWithFormat:@"QR :%@",qr];
        
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
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:qrs];
            }
            order_cell.LBL_price.attributedText = attributedText;
        }
        else
        {
            order_cell.LBL_price.text = price;
        }
        order_cell.LBL_QTY.text = [NSString stringWithFormat:@"QTY:1"];
        NSString *date = @"sun,jun 4th,2017";
        NSString *date_text = [NSString stringWithFormat:@"Order on: %@",date];
        
        
        if ([order_cell.LBL_Deliver_on respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:order_cell.LBL_Deliver_on.textColor,
                                      NSFontAttributeName: order_cell.LBL_Deliver_on.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
            
            
            
            NSRange ename = [date_text rangeOfString:date];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                        range:ename];
            }
            order_cell.LBL_Deliver_on.attributedText = attributedText;
        }
        else
        {
            order_cell.LBL_Deliver_on.text = date_text;
        }
        

        return order_cell;
    }
    
    else if(indexPath.section == 2)
    {
        cost_find_cell *cost_cell = (cost_find_cell *)[tableView dequeueReusableCellWithIdentifier:@"cost_cell"];

        if (cost_cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"cost_find_cell" owner:self options:nil];
            cost_cell = [nib objectAtIndex:0];
        }
        cost_cell.LBL_Total_items.text = [NSString stringWithFormat:@"TOTAL ITEMS: 2"];
        
        NSString *qr = @"285";
        NSString *price = [NSString stringWithFormat:@"QR :%@",qr];
        
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
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                        range:qrs];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
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
    if(indexPath.section == 3)
    {
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:@"address_cell"];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.BTN_edit_addres.hidden = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 4.0;
        NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
        NSArray *keys_arr = [dict allKeys];
        cell.BTN_edit_addres.hidden = YES;
        
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[dict  valueForKey:@"billingaddress"] valueForKey:@"firstname"],[[dict valueForKey:@"billingaddress"] valueForKey:@"lastname"]];
        name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        cell.LBL_address_type.text = @"BILLING ADDRESS";
//        NSString *country;
//        
//        
//        NSString *str = [[dict valueForKey:@"billingaddress"] valueForKey:@"country"];
//        NSArray *country_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
//        
//        for(int code= 0;code<country_arr.count;code++)
//        {
//            NSString *c_id = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code]valueForKey:@"id"]];
//            if([c_id intValue] == [str intValue])
//            {
//                country = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code] valueForKey:@"name"]];
//            }
//        }
//        
//        
//        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        NSString *state = [[dict valueForKey:@"billingaddress"] valueForKey:@"state"];
        NSString *country = [[dict valueForKey:@"billingaddress"] valueForKey:@"country"];
        
        state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        

        NSString *address_str = [NSString stringWithFormat:@"%@,%@\n%@ %@\n%@\n%@\nph:%@",[[dict valueForKey:@"billingaddress"] valueForKey:@"address1"],[[dict valueForKey:@"billingaddress"] valueForKey:@"address2"],[[dict valueForKey:@"billingaddress"] valueForKey:@"city"],[[dict valueForKey:@"billingaddress"] valueForKey:@"zip_code"],state,country,[[dict valueForKey:@"billingaddress"] valueForKey:@"phone"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_address.text = address_str;
        
        
        
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    if(indexPath.section == 4)
    {
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:@"address_cell"];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.BTN_edit_addres.hidden = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 4.0;
        NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"shipaddress"];
        NSArray *keys_arr = [dict allKeys];
        if(indexPath.row == keys_arr.count - 1 )
        {
            cell.BTN_edit_addres.hidden = NO;
        }
        
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
        name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        cell.LBL_address_type.text = @"SHIPPING ADDRESS";
//        NSString *country;
//        
//        
//        NSString *str = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
//        NSArray *country_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
//        
//        for(int code= 0;code<country_arr.count;code++)
//        {
//            NSString *c_id = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code]valueForKey:@"id"]];
//            if([c_id intValue] == [str intValue])
//            {
//                country = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code] valueForKey:@"name"]];
//            }
//        }
//        
//        
//        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        NSString *state = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"];
        NSString *country = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
        state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        

        
        NSString *address_str = [NSString stringWithFormat:@"%@,%@\n%@ %@\n%@\n%@\nph:%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address2"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"],state,country,[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"phone"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_address.text = address_str;
        
        
        
//        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    else{
        
        Payment_summary_cell *cell = (Payment_summary_cell *)[tableView dequeueReusableCellWithIdentifier:@"pay_cell"];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"Payment_summary_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString *current_price = [NSString stringWithFormat:@"QR"];
        NSString *prec_price = [NSString stringWithFormat:@"6800"];
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
            cell.LBL_total.attributedText = attributedText;
        }
        else
        {
            cell.LBL_total.text = text;
        }
        
        
        return cell;

        
    }

    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 55;
    }
    else if(indexPath.section == 1)
    {
        return 260;
    }
    else if(indexPath.section == 2)
    {
        return 45;
    }
    else if(indexPath.section == 3)
    {
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section == 4)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return 200;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}
-(void)Shipp_address_API
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressessapi/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    
                    jsonresponse_dic_address = data;
                    [_TBL_orders reloadData];
                    NSLog(@"*******%@*********",data);
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}
- (IBAction)back_ACTIon:(id)sender {
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
