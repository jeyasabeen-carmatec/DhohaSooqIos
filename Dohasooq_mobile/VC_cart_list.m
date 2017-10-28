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

@interface VC_cart_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_product;
    NSString *TXT_count;
}

@end

@implementation VC_cart_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       [self set_UP_VIEW];
    
}
-(void)set_UP_VIEW
{
    arr_product = [[NSMutableArray alloc]init];
    NSDictionary *temp_dictin;
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@" 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin]; temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];

    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
    NSString *badge_value = @"25";
    
    
    if(badge_value.length > 2)
    {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
        
    }
    NSString *qr = @"QR";
    NSString *price = @"4565";
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
        _LBL_next.text = text;
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
    return arr_product.count;
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
        NSDictionary *temp_dict=[arr_product objectAtIndex:indexPath.row];


    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"Cart_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    temp_dict = [arr_product objectAtIndex:indexPath.row];
    cell.IMG_item.image = [UIImage imageNamed:[temp_dict valueForKey:@"key5"]];
    cell.LBL_item_name.text = [temp_dict valueForKey:@"key1"];
    cell.LBL_current_price.text = [temp_dict valueForKey:@"key2"];
    NSString *current_price = [NSString stringWithFormat:@"%@", [temp_dict valueForKey:@"key2"]];
    NSString *prec_price = [NSString stringWithFormat:@"%@", [temp_dict valueForKey:@"key3"]];
    NSString *text = [NSString stringWithFormat:@"QR %@   %@",current_price,prec_price];
    
    if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.LBL_current_price.textColor,
                                  NSFontAttributeName:cell.LBL_current_price.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:current_price];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:19.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        NSRange cmp = [text rangeOfString:prec_price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                    range:cmp ];
        }
        cell.LBL_current_price.attributedText = attributedText;
    }
    else
    {
        cell.LBL_current_price.text = text;
    }
    
    
    
    //pro_cell.LBL_prev_price.text =  [temp_dict valueForKey:@"key3"];
    cell.LBL_discount.text = [temp_dict valueForKey:@"key4"];
    
    
    UIImage *newImage = [cell.BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(cell.BTN_close.image.size, NO, newImage.scale);
    [[UIColor darkGrayColor] set];
    [newImage drawInRect:CGRectMake(0, 0, cell.BTN_close.image.size.width/2, newImage.size.height/2)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.BTN_close.image = newImage;
    
    cell.BTN_close .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    [cell.BTN_close addGestureRecognizer:tapGesture1];
    
    TXT_count = cell._TXT_count.text;
    cell._TXT_count.text = TXT_count;
    
    [cell.BTN_plus addTarget:self action:@selector(plus_action) forControlEvents:UIControlEventTouchUpInside];
    [cell.BTN_minus addTarget:self action:@selector(minus_action) forControlEvents:UIControlEventTouchUpInside];
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
        NSString *current_price = [NSString stringWithFormat:@"QR"];
        NSString *prec_price = [NSString stringWithFormat:@"6800"];
        NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
        
        if ([cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:cell.LBL_total_amount.textColor,
                                      NSFontAttributeName:cell.LBL_total_amount.font
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
            cell.LBL_total_amount.attributedText = attributedText;
        }
        else
        {
            cell.LBL_total_amount.text = text;
        }
        
        
        return cell;

    }
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"order_detail_segue" sender:self];
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
-(void)tapGesture_close
{
   // [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"the cancel clicked");
}
-(void)minus_action
{
    int s = [TXT_count intValue];
    s = s - 1;
    TXT_count = [NSString stringWithFormat:@"%d",s];
}
-(void)plus_action
{
    int s = [TXT_count intValue];
    s = s + 1;
    TXT_count = [NSString stringWithFormat:@"%d",s];
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)wishListAction:(id)sender {
    [self performSegueWithIdentifier:@"cart_to-wishList" sender:self];
}
@end
