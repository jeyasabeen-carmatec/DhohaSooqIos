//
//  VC_product_List.m
//  Dohasooq_mobile
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_product_List.h"
#import "product_cell.h"
#import "UIBarButtonItem+Badge.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HttpClient.h"
#import "ViewController.h"


@interface VC_product_List ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *arr_product;
    NSMutableArray *productDataArray;
    CGRect frame;
    NSString *type_product,*sort_key,*currency_code,*product_id;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *json_Response_Dic,*json_DATA,*sort_array;

}

@end

@implementation VC_product_List

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"brnds"];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"discount_val"];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"Range_val"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    


        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.collection_product registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    }
    else
    {
        [self.collection_product registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    }
    _VW_filter.hidden = NO;

    sort_array = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Best Selling",@"bestSelling",@"New Listed",@"newListed",@"High To Low",@"highToLow",@"Low To High",@"lowToHigh",@"Discount",@"discount", nil];
    @try
    {
    [_BTN_fav setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    }
    @catch(NSException *exception)
    {
        
    }

    
   
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
    VW_overlay.hidden = YES;
    
   
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(product_list_API) withObject:activityIndicatorView afterDelay:0.01];
    
}

-(void)set_UP_VW
{
    
   VC_filter_product_list  *prod_list = [self.storyboard instantiateViewControllerWithIdentifier:@"filetr_view"];
    prod_list.delegate =  self;
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    
    
//    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
//                 @selector(btnfav_action)];
//    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
    
    //arr_product = [[NSMutableArray alloc]init];
    /**/
    
    
//    NSString *badge_value = @"25";
//    _BTN_cart.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//    if(badge_value.length > 2)
//    {
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//        
//    }
//    else{
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//        
//    }
    
    NSString *prodct_count = [NSString stringWithFormat:@"%lu",(unsigned long)[productDataArray count]];
    NSString *products = @"PRODUCTS";
    NSString *text = [NSString stringWithFormat:@"%@ %@",prodct_count,products];
    @try
    {
        if ([_LBL_product_count respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_product_count.textColor,
                                      NSFontAttributeName: _LBL_product_count.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [text rangeOfString:prodct_count];
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
            
            NSRange cmp = [text rangeOfString:products];
            
            //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:14.0]}
                                        range:cmp];
            }
            self.LBL_product_count.attributedText = attributedText;
        }
        else
        {
            _LBL_product_count.text = text;
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    _sort_pickers = [[UIPickerView alloc] init];
    _sort_pickers.delegate = self;
    _sort_pickers.dataSource = self;
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"Done" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:close];
    _BTN_sort.inputAccessoryView=conutry_close;
    self.BTN_sort.inputView = _sort_pickers;
    _BTN_sort.tintColor=[UIColor clearColor];

    
//    [_BTN_filter addTarget:self action:@selector(contact_us_action) forControlEvents:UIControlEventTouchUpInside];
//    [_BTN_add_cart addTarget:self action:@selector(add_cart_animation) forControlEvents:UIControlEventTouchUpInside];
//    
    
}-(void)btnfav_action
{
    NSLog(@"fav_clicked");
}
-(void)btn_cart_action
{
    NSLog(@"cart_clicked");
    
}
- (IBAction)back_action:(id)sender
{
    @try
    {
       [self performSegueWithIdentifier:@"product_list_home" sender:self];
        
    }
    @catch(NSException *exception)
    {
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }
    @finally
    {
        [self dismissViewControllerAnimated:NO completion:nil] ;
        
    }
   
}

- (IBAction)wish_list_action:(UIBarButtonItem *)sender
{
           NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        if([user_id isEqualToString:@"(null)"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            
            
            [self performSegueWithIdentifier:@"productList_to_wishList" sender:self];
        }
        
    
    
    
}

#pragma Collection View Delgates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return productDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
    @try
    {
#pragma Webimage URl Cachee
        
        NSString *img_url = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
        [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                             placeholderImage:[UIImage imageNamed:@"logo.png"]
                                      options:SDWebImageRefreshCached];
        @try
        {
        NSString *str = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"stock_status"]];
        str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        
            if([str isEqualToString:@"In stock"])
            {
                
            }
            else{
                pro_cell.LBL_stock.text =str;
            }

        }
        @catch(NSException *exception)
        {
        
        }
        pro_cell.LBL_item_name.text = [[productDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
        int rating = [[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"rating"] intValue];
        if(rating <= 1)
        {
            pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.92 green:0.39 blue:0.25 alpha:1.0];
        }
        else if(rating <= 2)
        {
            pro_cell.LBL_rating.backgroundColor =[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0];
        }
        else if(rating <= 3)
        {
            pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.19 green:0.56 blue:0.78 alpha:1.0];
        }
        else
        {
            pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.25 green:0.80 blue:0.51 alpha:1.0];
        }
        
        
        //pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
        
        
        NSString *current_price = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
        
        NSString *prec_price = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
        NSString *text ;
        
        if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            
            if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"] || [current_price isEqualToString:@" "]) {
                
                
                
                
                text = [NSString stringWithFormat:@"%@ %@",currency_code,prec_price];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    text = [NSString stringWithFormat:@"%@ %@",prec_price,currency_code];
                }
                
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
                
                NSRange ename = [text rangeOfString:prec_price];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                }
                
                
                
                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                //NSParagraphStyleAttributeName
                pro_cell.LBL_current_price.attributedText = attributedText;
                
                pro_cell.LBL_discount.text = @"0% off";
                
            }
            
            else{
                
                // Define general attributes for the entire text
                //        NSDictionary *attribs = @{
                //                                  NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
                //                                  NSFontAttributeName:pro_cell.LBL_current_price.font
                //                                  };
                
                prec_price = [currency_code stringByAppendingString:prec_price];
                
                text = [NSString stringWithFormat:@"%@ %@ %@",currency_code,current_price,prec_price];
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    prec_price = [prec_price stringByAppendingString:currency_code];
                    text = [NSString stringWithFormat:@"%@ %@ %@",prec_price,current_price,currency_code];
                }
                
                
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
                
                
                NSRange ename = [text rangeOfString:current_price];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:ename];
                }
                
                
                NSRange qrname = [text rangeOfString:currency_code];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                            range:qrname];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                            range:qrname];
                }
                
                
                
                
                NSRange cmp = [text rangeOfString:prec_price];
                //        [attributedText addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:3] range:[text rangeOfString:prec_price]];
                
                
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                            range:cmp];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
                }
                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                           value:@2
                                           range:NSMakeRange(0 ,[prec_price length])];
                }
                
                else{
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                           value:@2
                                           range:NSMakeRange([current_price length]+[currency_code length]+2 ,[prec_price length])];
                }
                
                
                pro_cell.LBL_current_price.attributedText = attributedText;
                
            }
        }
        else
        {
            pro_cell.LBL_current_price.text = text;
        }
        
        NSString *str = @"%off";
        NSString *str_discount = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"discount"]];
        if([str_discount isEqualToString:@"0"])
        {
            pro_cell.LBL_discount.text = [NSString stringWithFormat:@""];

        }
        else{
        pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"discount"],str];
        }
        
        [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
        
        if ([[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
            [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
            
            [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
        }
        else{
            [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
            
            [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [pro_cell.BTN_fav addTarget:self action:@selector(Wishlist_add:) forControlEvents:UIControlEventTouchUpInside];
        //  }
        return pro_cell;
    }
    @catch(NSException *exception)
    {
        
    }
    
    return pro_cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/2.011, 281);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.5;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,4,0);  // top, left, bottom, right
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *temp_str = [[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_image"];
//    NSRange range = [temp_str rangeOfString:@"/Merchant"];
//    
//    if (range.location == NSNotFound) {
//        NSLog(@"The string (testString) does not contain 'how are you doing' as a substring");
//    }
//    else {
//        NSLog(@"Found the range of the substring at (%lu, %lu)", (unsigned long)range.location, range.location + range.length);
//    }
//    NSString *lastChar = [temp_str substringFromIndex:range.location + range.length];
//    char firstLetter = [lastChar characterAtIndex:0];
//    if(!firstLetter)
//    {
//        firstLetter = '0';
//    }
//    
//    NSLog(@"THE iD:%c",firstLetter);
//    

    NSUserDefaults *userDflts = [NSUserDefaults standardUserDefaults];
    //NSString *merchant_ID = [NSString stringWithFormat:@"%c",firstLetter];
    [userDflts setObject:[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
    [userDflts setValue:[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"merchant_id"]  forKey:@"Mercahnt_ID"];
    [userDflts synchronize];

    
   
     [self performSegueWithIdentifier:@"product_list_detail" sender:self];
   
}
/*-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *direction = ([scrollView.panGestureRecognizer translationInView:scrollView.superview].y >0)?@"up":@"down";
    if([direction isEqualToString:@"up"])
    {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [_VW_filter.layer addAnimation:animation forKey:nil];
        
        _VW_filter.hidden = YES;
    }
    else if([direction isEqualToString:@"down"])
    {
        
        
        _VW_filter.hidden = NO;
    }
    //NSLog(@"%@",direction);
    
    
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/delFromWishList/%@/%@.json",SERVER_URL,product_id,user_ID];
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    NSDictionary *dict = data;
                    if([[dict valueForKey:@"msg"] isEqualToString:@"del"])
                   
                    
                    @try {
                        [HttpClient createaAlertWithMsg:@"Item deleted Succesfully"andTitle:@""];
                        [self product_list_API];
                        
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                        
                    }
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
}


#pragma mark Add_to_wishList_API Calling

-(void)Wishlist_add:(UIButton *)sender
{
    
    //NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
        @try
    {
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        if([user_id isEqualToString:@"(null)"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            

            
            
            NSLog(@"%@",productDataArray);
            product_id =[NSString stringWithFormat:@"%@", [[productDataArray objectAtIndex:sender.tag] valueForKey:@"id"]];
            //[[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
            
            if ([[[productDataArray objectAtIndex:sender.tag] valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                [self delete_from_wishLis];
                [self product_list_API];
            }
            else{
                
                
                NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,product_id,user_id];
                urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            
                            VW_overlay.hidden=YES;
                            [activityIndicatorView stopAnimating];
                            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                        }
                        if (data) {
                            
                            if([data isKindOfClass:[NSDictionary class]])
                            {
                                json_Response_Dic = data;

                                VW_overlay.hidden=YES;
                                [activityIndicatorView stopAnimating];
                                NSLog(@"The Wishlist %@",json_Response_Dic);
                                
                                @try {
                                    if ([[json_Response_Dic valueForKey:@"msg"] isEqualToString:@"add"]) {
                                        
                                        [self product_list_API];
                                        
                                        
                                        [HttpClient createaAlertWithMsg:@"Added to your wishlist" andTitle:@""];
                                        
                                        
                                    }
                                    else{
                                        
                                        [self product_list_API];                            }
                                    
                                    
                                } @catch (NSException *exception) {
                                    NSLog(@"%@",exception);
                                    [self product_list_API];
                                    
                                }
                                
                            }
                            else
                            {
                                VW_overlay.hidden=YES;
                                [activityIndicatorView stopAnimating];
                                
                                [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
                                NSLog(@"The Wishlist%@",json_Response_Dic);
                                
                                
                            }
                            
                            
                        }
                        
                    });
                }];
            }
        }
    }
        @catch(NSException *exception)
        {
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"already added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
            
            NSLog(@"The error is:%@",exception);
            [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        }
        
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
    }
    
    

-(void)startAnimation:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.collection_product];
    NSIndexPath *indexPath = [self.collection_product indexPathForItemAtPoint:buttonPosition];
    product_cell *cell = (product_cell *)[_collection_product cellForItemAtIndexPath:indexPath];
    
    if(indexPath)
    {
        
    frame = cell.BTN_fav.frame;
    frame.origin.y = buttonPosition.y;
    frame.origin.x = buttonPosition.x;
    frame.size.height = cell.BTN_fav.frame.size.height;
    frame.size.height = cell.BTN_fav.frame.size.width;
    cell.BTN_fav.frame = frame;
    }
  
   // cell.BTN_fav.hidden = NO;
    
    NSLog(@"The index is:%ld",(long)indexPath.row);
    //Add the initial circle
    UIView* circleView = [[UIView alloc] initWithFrame:frame];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    //set colors
    [circleLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:circleView.bounds] CGPath]];
    [circleView.layer addSublayer:circleLayer];
    [self.collection_product addSubview:circleView];
    
    //Animate circle
    [circleView setTransform:CGAffineTransformMakeScale(0, 0)];
    [UIView animateWithDuration:0.7 animations:^{
        [circleView setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
    } completion:^(BOOL finished) {
        circleView.hidden = YES;
        //start next animation
        [self createIconAnimation:sender];
    }];
}

-(void)createIconAnimation :(UIButton *)tag{
    
    //load icon which pops up
    UIImageView* iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Untitled"]];
    iconImage.frame = frame;
    [iconImage setTransform:CGAffineTransformMakeScale(0, 0)];
    [self.collection_product addSubview:iconImage];
    
    //animate icon
    [UIView animateWithDuration:0.3/1.5 animations:^{
        iconImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            iconImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                iconImage.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    
    //add circles around the icon
    int numberOfCircles = 20;
   // CGPoint center = iconImage.center;
    float radius= 35;
    BOOL isBig = YES;;
    for (int i = 0; i<numberOfCircles; i++)
    {
        
        float circleRadius = 10;
        if (isBig) {
            circleRadius = 5;
            isBig = NO;
        }else{
            isBig = YES;
        }
        
        UIView* circleView = [[UIView alloc] initWithFrame:frame];
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        [circleLayer setStrokeColor:[[UIColor redColor] CGColor]];
        [circleLayer setFillColor:[[UIColor redColor] CGColor]];
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:circleView.bounds] CGPath]];
        [circleView.layer addSublayer:circleLayer];
        [self.collection_product addSubview:circleView];
        
        //animate circles
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [circleView setTransform:CGAffineTransformMakeTranslation(radius/3*cos(M_PI/numberOfCircles*i*2), radius/3*sin(M_PI/numberOfCircles*i*2))];
            [circleView setTransform:CGAffineTransformScale(circleView.transform, 0.01, 0.01)];
        } completion:^(BOOL finished) {
            circleView.hidden = YES;
        }];
    
        
        
    }
   
    CGPoint buttonPosition = [tag convertPoint:CGPointZero toView:self.collection_product];
    NSIndexPath *indexPath = [self.collection_product indexPathForItemAtPoint:buttonPosition];
    product_cell *cell = (product_cell *)[_collection_product cellForItemAtIndexPath:indexPath];
    
    [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
    [cell.BTN_fav setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    for (UIView *view1 in cell.BTN_fav.subviews) {
        NSLog(@"The view is %@",view1);
    }


    
}
#pragma mark product_list_api_integration Method Calling

/*
 Updated Product List API
 
 URL : http://192.168.0.171/dohasooq/apis/productList/cakes-and-chocolates/0/1/1/30/Customer.json
 Method: GET
 
 Params:
 CatKey = cakes-and_chocolates
 discount = 0
 country id =1
 language id=1
 user id=30
 user type "Customer"
 Note: If you want all the products means pass CatKey as "All"
  http://192.168.0.171/dohasooq/apis/productList/All/0/1/1/30/Customer.json

 */
-(void)product_list_API
{
    
    @try
    {
        productDataArray = [[NSMutableArray alloc]init];


        NSString *list_TYPE = [[NSUserDefaults standardUserDefaults] valueForKey:@"product_list_url"];
        NSString *urlGetuser;
        urlGetuser =[NSString stringWithFormat:@"%@",list_TYPE];
 
       
        
        

        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"%@",urlGetuser);

        
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    
                   
                  json_DATA = data;
                    
                    if([json_DATA isKindOfClass:[NSDictionary class]])
                    {
                        @try {
                            VW_overlay.hidden = YES;
                            [activityIndicatorView stopAnimating];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
                                
                            });
                            

                            
                            //currency_code
                            
                             currency_code = [json_DATA valueForKey:@"currency"] ;
                            
//                            if ([[json_DATA valueForKey:@"currency"] isKindOfClass:[NSDictionary class]]) {
//                                currency_code = [[json_DATA valueForKey:@"currency"] valueForKey:@"currency_code"];
//                            }
                            
                            @try
                            {
                            if([[json_DATA valueForKey:@"products"] isEqualToString:@""])
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No products Found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                [alert show];
                               // [productDataArray removeAllObjects];
                                [_collection_product reloadData];
                                [self set_UP_VW];
                                

                            }
                            }
                            @catch(NSException *exception)
                            {
                            productDataArray = [json_DATA valueForKey:@"products"];
                                //BOOL stat = @"YES";
                                
                                if([[json_DATA valueForKey:@"brands"] isKindOfClass:[NSDictionary class]])
                                {
                                    [[NSUserDefaults standardUserDefaults]  setObject:[json_DATA valueForKey:@"brands"] forKey:@"brands_LISTs"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    NSLog(@"THE JSON DTA BRADS:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"brands_LISTs"]);
                                    
                                 }
                                else
                                {
                            
                                    NSLog(@"THE userdefaults%@",[[json_DATA valueForKey:@"brnads"]allValues]);
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brands_LISTs"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];

                               
                                }
                            

                                
                            NSLog(@"THE respons PRODUCT LIST:%@",json_DATA);
                            
                                @try
                                {
                                NSString *str_name =[NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"displayName"] objectAtIndex:0] valueForKey:@"name"]];
                                self.LBL_product_name.text = [NSString stringWithFormat:@"%@",str_name];
                                    
                                }
                                @catch(NSException *exception)
                                {
                                    self.LBL_product_name.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"item_name"]];
                                }
                                [[NSUserDefaults standardUserDefaults] setValue:self.LBL_product_name.text forKey:@"search_val"];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                

                           // }
                           
                            [self.collection_product reloadData];
                            [self set_UP_VW];
                            }
                        } @catch (NSException *exception) {
                            VW_overlay.hidden = YES;
                            [activityIndicatorView stopAnimating];
                            NSLog(@"%@",exception);
                        }
                        
                        

                    }
                    
                      
                   
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
       
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
            NSDictionary *dict = data;
            @try {
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
            }
            
        }
    }];
}
#pragma mark set_badge_value_to_cart
-(void)set_badge_value_to_cart:(NSString *)badge_value{
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        if(badge_value.length > 2)
        {
            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
            
        }
        else{
            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
            
        }
    }
    else{
        if(badge_value.length > 2)
        {
            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
            
        }
        else{
            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
            
        }
    }

}

- (IBAction)filter_action:(id)sender {
    
    [self performSegueWithIdentifier:@"product_list_filter" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)productList_to_cartPage:(id)sender {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
        
        [self performSegueWithIdentifier:@"product_list_cart" sender:self];
    }
}
#pragma picker_actions
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [sort_array allValues].count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [sort_array allValues][row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str =[[sort_array allValues] objectAtIndex:row];
    self.BTN_sort.text =[NSString stringWithFormat:@"%@  ",str];
    NSLog(@"THe sort text is:%@",_BTN_sort.text);
    sort_key = [sort_array allKeys][row];
}
-(void)countrybuttonClick
{
    [self.BTN_sort resignFirstResponder];

    NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
    
    NSString *country = [user_dflts valueForKey:@"country_id"];
    NSString *languge = [user_dflts valueForKey:@"language_id"];
    NSDictionary *dict = [user_dflts valueForKey:@"userdata"];
    NSString *min = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"products_min"]];
    NSString *max = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"products_max"]];
    NSString *brands = [user_dflts valueForKey:@"brnds"];
    NSString *discount = [user_dflts valueForKey:@"discount_val"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *url_str = [NSString stringWithFormat:@"%@apis/productList/%@/0/%@/%@/%@/Customer.json?discountValue=%@ &range=%@,%@&brand=%@&sortKeyword=%@",SERVER_URL,[[NSUserDefaults standardUserDefaults]valueForKey:@"product_list_key"],country,languge,user_id,discount,min,max,brands,sort_key];
    url_str = [url_str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    url_str = [url_str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:url_str forKey:@"product_list_sort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(sort_API) withObject:nil afterDelay:0.01];


    
}

-(void)sort_API
{
    @try
    {
        
    
    NSString *list_TYPE = [[NSUserDefaults standardUserDefaults] valueForKey:@"product_list_sort"];
    NSString *urlGetuser;
    urlGetuser =[NSString stringWithFormat:@"%@",list_TYPE];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@",urlGetuser);
    
    [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data1, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
            }
            if (data1) {
                NSDictionary *json_DAT;
                json_DAT = data1;
                if(json_DATA)
                {
                    @try {
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        @try
                        {
                            if([[json_DATA valueForKey:@"products"] isKindOfClass:[NSArray class]])
                            {
                                
                                productDataArray = [json_DATA valueForKey:@"products"];
                                //BOOL stat = @"YES";
                                
                                if([[json_DATA valueForKey:@"brands"] isKindOfClass:[NSDictionary class]])
                                {
                                    [[NSUserDefaults standardUserDefaults]  setObject:[json_DATA valueForKey:@"brands"] forKey:@"brands_LISTs"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    NSLog(@"THE JSON DTA BRADS:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"brands_LISTs"]);
                                    
                                }
                                else
                                {
                                    
                                    NSLog(@"THE userdefaults%@",[[json_DATA valueForKey:@"brnads"]allValues]);
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brands_LISTs"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    
                                    
                                }
                                

                                
                            }
                            else
                            {
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No products Found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                [alert show];
                                // [productDataArray removeAllObjects];
                                [_collection_product reloadData];
                                

                            }
                        }
                        @catch(NSException *exception)
                        {
                            
                            
                            NSLog(@"THE respons PRODUCT LIST:%@",json_DATA);
                            
                            @try
                            {
                                self.LBL_product_name.text = [NSString stringWithFormat:@"%@",[[[json_DATA valueForKey:@"displayName"] objectAtIndex:0] valueForKey:@"name"]];
                                
                            }
                            @catch(NSException *exception)
                            {
                                self.LBL_product_name.text = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"displayName"]];
                            }
//                            [[NSUserDefaults standardUserDefaults] setValue:self.LBL_product_name.text forKey:@"search_val"];
//                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            
                            // }
                            
                            [self.collection_product reloadData];
                            [self set_UP_VW];
                        }
                    } @catch (NSException *exception) {
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        NSLog(@"%@",exception);
                    }
                    
                    
                    
                }
                
                
                
            }
            
        });
    }];
     
     }
     @catch(NSException *exception)
     {
         
     }

}

-(void)filetr_URL:(NSString *)str
{
    NSLog(@"Strig %@",str);
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"cancel:");
            
        }
        else{
            
            
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
            [self presentViewController:login animated:NO completion:nil];
            
            
        }
    }
}

/*
 
 -(void)filetr_URL:(NSString *)str
 {
 NSLog(@"Enter 2");
 NSString *list_TYPE = str;
 NSString *urlGetuser;
 urlGetuser =[NSString stringWithFormat:@"%@",list_TYPE];
 urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
 NSLog(@"%@",urlGetuser);
 
 
 [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
 dispatch_async(dispatch_get_main_queue(), ^{
 if (error) {
 
 VW_overlay.hidden = YES;
 [activityIndicatorView stopAnimating];
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
 [alert show];
 [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
 }
 if (data) {
 NSDictionary *json_DAT;
 json_DAT = data;
 if(json_DAT)
 {
 @try {
 VW_overlay.hidden = YES;
 [activityIndicatorView stopAnimating];
 @try
 {
 if([[json_DAT valueForKey:@"products"] isEqualToString:@""])
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No products Found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
 [alert show];
 // [productDataArray removeAllObjects];
 [_collection_product reloadData];
 
 
 }
 }
 @catch(NSException *exception)
 {
 productDataArray = [json_DAT valueForKey:@"products"];
 //BOOL stat = @"YES";
 
 if([[json_DATA valueForKey:@"brands"] isKindOfClass:[NSDictionary class]])
 {
 [[NSUserDefaults standardUserDefaults]  setObject:[json_DAT valueForKey:@"brands"] forKey:@"brands_LISTs"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 NSLog(@"THE JSON DTA BRADS:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"brands_LISTs"]);
 
 }
 else
 {
 
 NSLog(@"THE userdefaults%@",[[json_DAT valueForKey:@"brnads"]allValues]);
 [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brands_LISTs"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 
 
 }
 
 
 
 NSLog(@"THE respons PRODUCT LIST:%@",json_DAT);
 
 @try
 {
 self.LBL_product_name.text = [NSString stringWithFormat:@"%@",[[[json_DAT valueForKey:@"displayName"] objectAtIndex:0] valueForKey:@"name"]];
 
 }
 @catch(NSException *exception)
 {
 self.LBL_product_name.text = [NSString stringWithFormat:@"%@",[json_DAT valueForKey:@"displayName"]];
 }
 [[NSUserDefaults standardUserDefaults] setValue:self.LBL_product_name.text forKey:@"search_val"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 
 
 // }
 
 [self.collection_product reloadData];
 [self set_UP_VW];
 }
 } @catch (NSException *exception) {
 VW_overlay.hidden = YES;
 [activityIndicatorView stopAnimating];
 NSLog(@"%@",exception);
 }
 
 
 
 }
 
 
 
 }
 
 });
 }];
 
 }
 
 */
@end
