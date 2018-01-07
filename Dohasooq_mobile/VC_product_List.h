//
//  VC_product_List.h
//  Dohasooq_mobile
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VC_filter_product_list.h"
#import "MIBadgeButton.h"

@interface VC_product_List : UIViewController <filter_protocol>
{
    NSMutableArray *productDataArray;

}
@property(nonatomic,weak) IBOutlet UICollectionView *collection_product;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_product;
@property(nonatomic,weak) IBOutlet UILabel *LBL_product_count;
@property(nonatomic,weak) IBOutlet UILabel *LBL_product_name;
@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_cart;
@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *products;
@property(nonatomic,strong) IBOutlet UIButton *BTN_filter;
@property(nonatomic,strong) IBOutlet UIButton *BTN_top;

//filter VIEW

@property(nonatomic,weak) IBOutlet UIView *VW_filter;
@property(nonatomic,weak) IBOutlet UIView *VW_only_filter;

@property(nonatomic,weak) IBOutlet UIView *V_line;

@property(nonatomic,weak) IBOutlet UIButton *BTN_add_cart;
@property(nonatomic,weak) IBOutlet UITextField *BTN_sort;
@property(nonatomic,strong) UIPickerView *sort_pickers;

//EMPTY VIEW
@property(nonatomic,weak)IBOutlet UIView *VW_empty;
@property(nonatomic,weak)IBOutlet UIButton *BTN_empty;
@property(nonatomic,weak)IBOutlet UILabel *LBL_oops;
@property(nonatomic,weak)IBOutlet UILabel *LBL_no_products;


- (IBAction)productList_to_cartPage:(id)sender;


@end
