//
//  VC_merchant_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 21/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_merchant_detail.h"
#import "product_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VC_merchant_detail ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *json_Response_Dic;
     NSMutableArray *productDataArray;
}
@end

@implementation VC_merchant_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collection_items registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];

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

-(void)set_UP_VIEW
{
    _LBL_name.numberOfLines = 0;
    [_LBL_name sizeToFit ];
    CGRect  frameset = _VW_first.frame;
        _VW_second.frame = frameset;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_data"];
    
      _LBL_phone_mail.numberOfLines = 0;
    [_LBL_phone_mail sizeToFit];
    
    NSString *img_url = [NSString stringWithFormat:@"%@%@",IMG_URL,[dict valueForKey:@"image"]];
    
    [_IMG_first sd_setImageWithURL:[NSURL URLWithString:img_url]
                     placeholderImage:[UIImage imageNamed:@"logo.png"]
                              options:SDWebImageRefreshCached];

    
    NSString *str_name = [dict valueForKey:@"name"];
    str_name = [str_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    _LBL_name.text = str_name;
    
    NSString *location =[NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]];
    
    location = [location stringByReplacingOccurrencesOfString:@"    " withString:@"Not mentioned"];
    location = [location stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];

    
    _LBL_address.text =location;
    
    NSString *str_phone = [NSString stringWithFormat:@"%@",[dict valueForKey:@"phone"]];
    str_phone = [str_phone stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
    str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    NSString *str_mail =[NSString stringWithFormat:@"%@",[dict valueForKey:@"email"]];
    str_mail = [str_mail stringByReplacingOccurrencesOfString:@"" withString:@"Not mentioned"];
    str_mail = [str_mail stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
    
    _LBL_phone_mail.text = [NSString stringWithFormat:@"%@\n%@",str_phone,str_mail];

    frameset = _LBL_address.frame;
    frameset.origin.y = _LBL_name.frame.origin.y + _LBL_name.frame.size.height;
    _LBL_address.numberOfLines = 0;
    [_LBL_address sizeToFit];
    


    
    frameset = _LBL_phone_mail.frame;
    frameset.origin.y = _LBL_address.frame.origin.y + _LBL_address.frame.size.height + 10;
    _LBL_phone_mail.frame = frameset;
     [_LBL_phone_mail sizeToFit];
    
  
    frameset = _VW_first.frame;
    frameset.origin.y = _IMG_first.frame.origin.y + _IMG_first.frame.size.height + 5;
    frameset.size.width = self.scroll_contets.frame.size.width;

    frameset.size.height = _LBL_phone_mail.frame.origin.y + _LBL_phone_mail.frame.size.height;
    _VW_first.frame = frameset;
    [self.scroll_contets addSubview:_VW_first];
    
    
    frameset = _collection_items.frame;
    frameset.size.width = _scroll_contets.frame.size.width;
    _collection_items.frame = frameset;
    
    [_collection_items reloadData];
    
    frameset = _VW_second.frame;
    frameset.origin.y = _VW_first.frame.origin.y + _VW_first.frame.size.height;
    frameset.size.height = _collection_items.frame.origin.y + _collection_items.collectionViewLayout.collectionViewContentSize.height;
    frameset.size.width = self.scroll_contets.frame.size.width;
    _VW_second.frame = frameset;
    [self.scroll_contets addSubview:_VW_second];
    [self viewDidLayoutSubviews];
    
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contets layoutIfNeeded];
    _scroll_contets.contentSize = CGSizeMake(_scroll_contets.frame.size.width,_VW_second.frame.origin.y + _VW_second.frame.size.height);
    
    
}
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return productDataArray.count;;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
    
    @try
    {
        
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
        
        [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
        [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
    }
    else{
        [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];

        [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [pro_cell.BTN_fav addTarget:self action:@selector(Wishlist_add:) forControlEvents:UIControlEventTouchUpInside];
    
   
}
@catch(NSException *exception)
{
    
}
    return pro_cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collection_items.bounds.size.width/2.011, 281);
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

    [self performSegueWithIdentifier:@"merchant_detail_product_detail" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)product_list_API
{
    
    @try
    {
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        
        NSString *url_key = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_data"] valueForKey:@"url_key"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/merchantDetails/%@/%@/%@/%@/Customer.json",SERVER_URL,url_key,country,languge,user_id];
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
                            productDataArray  =[[NSMutableArray alloc]init];
                            productDataArray = [json_DATA valueForKey:@"products"];
                            NSLog(@"%@",productDataArray);
                            
                           [self.collection_items reloadData];
                            [self set_UP_VIEW];
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

#pragma mark Add_to_wishList_API Calling
-(void)Wishlist_add:(UIButton *)sender
{
    
    @try
    {
        
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[productDataArray objectAtIndex:sender.tag] valueForKey:@"id"],user_id];
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
                        
                        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        product_cell *cell = (product_cell *)[self.collection_items cellForItemAtIndexPath:index];
                        
                        
                        @try {
                            if ([[json_Response_Dic valueForKey:@"msg"] isEqualToString:@"add"]) {
                                
                              //  [self startAnimation:sender];
                                [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];

                                [cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
                                [HttpClient createaAlertWithMsg:@"Item added successfully" andTitle:@""];
                                
                                
                            }
                            else{
                                
                                [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            }
                            
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                            [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
