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
    
#pragma _product_list_api_integration Method Calling
    
    @try
    {
        /*NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
         NSString *urlGetuser =[NSString stringWithFormat:@"%@Pages/catalog/%@/1/1.json",SERVER_URL,[usd valueForKey:@"url_key_home"]];*/
    NSString *urlGetuser =[NSString stringWithFormat:@"%@Pages/catalog/womens-clothing/1/1.json",SERVER_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
        }
             if (data) {
                 NSMutableDictionary *json_DATA = data;
                 //NSLog(@"%@",json_DATA);
                 productDataArray = [json_DATA valueForKey:@"products"];
                 //NSLog(@"id for products %@",[[[productDataArray objectAtIndex:0] valueForKey:@"DISTINCT Products"] valueForKey:@"id"]);
                 
                // NSLog(@"%@",productDataArray);
                // NSLog(@"URL KEY IS::::%@",[[productDataArray objectAtIndex:0] valueForKey:@"url_key"]);
                 
                 [self.collection_product reloadData];
             }
        
        });
    }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
   
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
    
    NSString *prodct_count = [NSString stringWithFormat:@"45656"];
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
    
    
    [_BTN_filter addTarget:self action:@selector(contact_us_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_add_cart addTarget:self action:@selector(add_cart_animation) forControlEvents:UIControlEventTouchUpInside];
    
    
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
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)wish_list_action:(UIBarButtonItem *)sender {
     [self performSegueWithIdentifier:@"productList_to_wishList" sender:self];
    
}

#pragma Collection View Delgates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return productDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
    
    //Webimage URl Cachee
    
//    NSString *url = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
//    UIImage* serverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//    pro_cell.IMG_item.image = serverImage;
    
    #pragma Webimage URl Cachee
    
    NSString *img_url = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
    [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                  options:SDWebImageRefreshCached];
    
    
    pro_cell.LBL_item_name.text = [[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"ProductDescriptions"] valueForKey:@"title"];
    pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"rating"]];
    pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
    
    NSString *current_price = [NSString stringWithFormat:@"QR%@", [[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
    NSString *prec_price = [NSString stringWithFormat:@"QR%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
    NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
    
    if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
                                  NSFontAttributeName:pro_cell.LBL_current_price.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:current_price];
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
        
        NSRange cmp = [text rangeOfString:prec_price];
        //        [attributedText addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:3] range:[text rangeOfString:prec_price]];
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:14.0],NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick),NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
        }
        pro_cell.LBL_current_price.attributedText = attributedText;
        
    }
    else
    {
        pro_cell.LBL_current_price.text = text;
    }
    NSString *str = @"%off";
    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"discount"],str];
    
    [pro_cell.BTN_fav setTag:indexPath.row];
    [pro_cell.BTN_fav addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    [userDflts setObject:[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"url_key"] forKey:@"URL_Key"];
    //[userDflts setInteger:[[[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"DISTINCT Products"] valueForKey:@"id"] integerValue]forKey:@"product_Id"];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)productList_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"product_list_cart" sender:self];
}
@end
