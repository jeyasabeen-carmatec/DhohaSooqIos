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


@interface VC_product_List ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *arr_product;
    NSMutableArray *productDataArray;
    CGRect frame;
    NSString *type_product;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *json_Response_Dic;

}

@end

@implementation VC_product_List

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.collection_product registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    }
    else
    {
        [self.collection_product registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    }
    
    
    [self set_UP_VW];
    
   
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
    
    [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
    [self performSelector:@selector(product_list_API) withObject:activityIndicatorView afterDelay:0.01];
    
}

-(void)set_UP_VW
{
    
   
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
    
    //arr_product = [[NSMutableArray alloc]init];
    /**/
    productDataArray = [[NSMutableArray alloc]init];
    
    
    NSString *badge_value = @"25";
    _BTN_cart.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
    if(badge_value.length > 2)
    {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
        
    }
    
    NSString *prodct_count = [NSString stringWithFormat:@"0"];
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
    //[self dismissViewControllerAnimated:NO completion:nil] ;
  //  [self.navigationController popToRootViewControllerAnimated:YES];product_list_home
    [self performSegueWithIdentifier:@"product_list_home" sender:self];

}

- (IBAction)wish_list_action:(UIBarButtonItem *)sender
{
    
    
     [self performSegueWithIdentifier:@"productList_to_wishList" sender:self];
    
}

#pragma Collection View Delgates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
//   if([type_product isEqualToString:@"hot_deals"] || [type_product isEqualToString:@"best_deals"])
//    {
//    return [[productDataArray objectAtIndex:0] count];
//             
//     }
//    
        return productDataArray.count;
    }

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
    @try
    {
//    if([type_product isEqualToString:@"hot_deals"] || [type_product isEqualToString:@"best_deals"])
//    {
//        NSString *img_url = [NSString stringWithFormat:@"%@%@",IMG_URL,[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
//        [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
//                             placeholderImage:[UIImage imageNamed:@"logo.png"]
//                                      options:SDWebImageRefreshCached];
//        
//        
//        pro_cell.LBL_item_name.text = [[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"ProductDescriptions"] valueForKey:@"title"];
//        pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[[productDataArray objectAtIndex:indexPath.row]valueForKey:@"product_reviews"]valueForKey:@"rating"]];
//        pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
//        NSString *current_price = [NSString stringWithFormat:@"QR %@", [[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
//        NSString *prec_price = [NSString stringWithFormat:@"QR %@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
//        NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
//        
//        if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
//            
//            // Define general attributes for the entire text
//            NSDictionary *attribs = @{
//                                      NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
//                                      NSFontAttributeName:pro_cell.LBL_current_price.font
//                                      };
//            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
//            
//            
//            
//            NSRange ename = [text rangeOfString:current_price];
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                        range:ename];
//            }
//            else
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
//                                        range:ename];
//            }
//            
//            NSRange cmp = [text rangeOfString:prec_price];
//            //        [attributedText addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:3] range:[text rangeOfString:prec_price]];
//            
//            
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
//                                        range:cmp];
//            }
//            else
//            {
//                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:14.0],NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick),NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
//            }
//            pro_cell.LBL_current_price.attributedText = attributedText;
//            
//        }
//        else
//        {
//            pro_cell.LBL_current_price.text = text;
//        }
//        int  n = [[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"] intValue]-[[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"] intValue];
//        float discount = (n*100)/[[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"] intValue];
//        NSString *str = @"% off";
//
//        pro_cell.LBL_discount.text =[NSString stringWithFormat:@"%.0f%@",discount,str];
//
//      return pro_cell;
   // }

//    else
//    {
     #pragma Webimage URl Cachee
    
    NSString *img_url = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
    [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                  options:SDWebImageRefreshCached];
    
    
    pro_cell.LBL_item_name.text = [[productDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
           pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
    pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
    
    NSString *current_price = [NSString stringWithFormat:@"QR %@", [[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
        
    NSString *prec_price = [NSString stringWithFormat:@"QR %@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
    NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
  
    if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
                if ([current_price isEqualToString:@"QR <null>"]) {
            
            
                NSString *text = [NSString stringWithFormat:@" %@",prec_price];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                    
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
        [attributedText addAttribute:NSStrikethroughStyleAttributeName
                               value:@2
                               range:NSMakeRange([prec_price length]+4, [current_price length]-3)];
        pro_cell.LBL_current_price.attributedText = attributedText;
        
    }
    }
    else
    {
        pro_cell.LBL_current_price.text = text;
    }
        
    NSString *str = @"%off";
    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"discount"],str];
    
    [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
        
        if ([[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
            
            [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
        }
        else{
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
    NSUserDefaults *userDflts = [NSUserDefaults standardUserDefaults];
    [userDflts setObject:[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
   
     [self performSegueWithIdentifier:@"product_list_detail" sender:self];
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
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
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Add_to_wishList_API Calling

-(void)Wishlist_add:(UIButton *)sender
{
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    if (user_id == nil) {
        
        user_id =0;
        [HttpClient createaAlertWithMsg:@"Please Login" andTitle:@""];
        //homeQtkt_to_login
        [self performSegueWithIdentifier:@"product_list_login" sender:self];
        
    }
    else{
    
    @try
    {
       NSString *product_id = [[productDataArray objectAtIndex:sender.tag] valueForKey:@"id"];
        [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
        
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
                    json_Response_Dic = data;
                    if(json_Response_Dic)
                    {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        NSLog(@"The Wishlist %@",json_Response_Dic);
                        
                        @try {
                            if ([[json_Response_Dic valueForKey:@"msg"] isEqualToString:@"add"]) {
                                
                                [self product_list_API];
                                

                                [HttpClient createaAlertWithMsg:@"Item added successfully" andTitle:@""];
                                
                                
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
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        NSLog(@"The Wishlist%@",json_Response_Dic);
                        
                        
                    }
                    
                    
                }
                
            });
        }];
    }
    }
    @catch(NSException *exception)
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"already added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
    
    VW_overlay.hidden=YES;
    [activityIndicatorView stopAnimating];
    }
    

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

        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
         NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        
        NSString *url_key = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"product_list_key"]];
         NSString *discount = [[NSUserDefaults standardUserDefaults]valueForKey:@"discount"];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"http://192.168.0.171/dohasooq/apis/productList/%@/%@/%@/%@/%@/Customer.json",url_key,discount,country,languge,user_id];
         //NSString *urlGetuser = @"http://192.168.0.171/dohasooq/apis/productList/All/0/1/1/27/Customer.json";
        

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
                    NSMutableDictionary *json_DATA = data;
                    if(json_DATA)
                    {
                        @try {
                            VW_overlay.hidden = YES;
                            [activityIndicatorView stopAnimating];
                            productDataArray = [json_DATA valueForKey:@"products"];
                            NSLog(@"%@",productDataArray);
                            
                            self.LBL_product_name.text = [NSString stringWithFormat:@"%@ - %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"item_name"],[[NSUserDefaults standardUserDefaults] valueForKey:@"sub_name"]];
                            NSLog(@"%ld",[productDataArray count]);
                            self.LBL_product_count.text = [NSString stringWithFormat:@"%lu Products",(unsigned long)[productDataArray count]];
                            
                            
                            //NSLog(@"%@",json_DATA);
                            //NSLog(@"id for products %@",[[[productDataArray objectAtIndex:0] valueForKey:@"DISTINCT Products"] valueForKey:@"id"]);
                            
                            // NSLog(@"%@",productDataArray);
                            // NSLog(@"URL KEY IS::::%@",[[productDataArray objectAtIndex:0] valueForKey:@"url_key"]);
                            
                            [self.collection_product reloadData];
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

#pragma mark  cart_count_api
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


- (IBAction)productList_to_cartPage:(id)sender {
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    if (user_id == nil) {
        
        user_id =0;
        [HttpClient createaAlertWithMsg:@"Please Login" andTitle:@""];
        //homeQtkt_to_login
        [self performSegueWithIdentifier:@"product_list_login" sender:self];
        
    }
    else{
    [self performSegueWithIdentifier:@"product_list_cart" sender:self];
    }
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
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    
                    
                    @try {
                        [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
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

@end
