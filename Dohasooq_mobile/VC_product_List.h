//
//  VC_product_List.h
//  Dohasooq_mobile
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_product_List : UIViewController
@property(nonatomic,weak) IBOutlet UICollectionView *collection_product;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_product;
@property(nonatomic,weak) IBOutlet UILabel *LBL_product_count;
@property(nonatomic,weak) IBOutlet UILabel *LBL_product_name;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_cart;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *products;
@property(nonatomic,strong) IBOutlet UIButton *BTN_filter;


@property(nonatomic,weak) IBOutlet UIView *VW_filter;
@property(nonatomic,weak) IBOutlet UIButton *BTN_add_cart;
- (IBAction)productList_to_cartPage:(id)sender;


@end
