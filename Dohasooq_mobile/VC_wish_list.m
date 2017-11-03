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
@interface VC_wish_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *arr_product;
    NSString *TXT_count;
}


@end

@implementation VC_wish_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self set_UP_VIEW];
}
-(void)set_UP_VIEW
{
    [self wish_list_api_calling];
    arr_product = [[NSMutableArray alloc]init];
    NSDictionary *temp_dictin;
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
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

}

#pragma tableview delagates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return arr_product.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        wish_list_cell *cell = (wish_list_cell *)[tableView dequeueReusableCellWithIdentifier:@"wish_list_cell"];
        NSDictionary *temp_dict=[arr_product objectAtIndex:indexPath.row];
        
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"wish_list_cell" owner:self options:nil];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
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
- (IBAction)back_action_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma wish_list_api_calling

-(void)wish_list_api_calling{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"http://192.168.0.171/dohasooq/apis/getWishList/%@/Customer.json",user_id];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"*******%@*********",data);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wishList_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"wish_to_cart" sender:self];
}
@end
