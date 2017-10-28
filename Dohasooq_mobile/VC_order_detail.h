//
//  VC_order_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 28/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_order_detail : UIViewController

@property(nonatomic,weak) IBOutlet UILabel *LBL_order_detail;
@property(nonatomic,weak) IBOutlet UILabel *LBL_shipping;
@property(nonatomic,weak) IBOutlet UILabel *LBL_Payment;
@property(nonatomic,weak) IBOutlet UITextField *TXT_first;
@property(nonatomic,weak) IBOutlet UITextField *TXT_second;
@property(nonatomic,weak) IBOutlet UIView *VW_top;

@property(nonatomic,weak) IBOutlet UITableView *TBL_orders;

@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_cart;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *LBL_navigation;


@property(nonatomic,weak) IBOutlet UILabel *LBL_product_summary;
@property(nonatomic,weak) IBOutlet UILabel *LBL_next;
@property(nonatomic,weak) IBOutlet UIButton *BTN_next;


//shipping view
@property(nonatomic,weak) IBOutlet UIView *VW_shipping;
@property(nonatomic,weak) IBOutlet UITableView *TBL_address;
//@property(nonatomic,weak) IBOutlet UIButton *BTN_add;
@property(nonatomic,weak) IBOutlet UIView *VW_next;

//payment view
@property(nonatomic,weak) IBOutlet UIView *VW_payment;



// card view
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_card;
@property(nonatomic,weak) IBOutlet UIView *VW_card;
@property(nonatomic,weak) IBOutlet UIImageView *LBL_stat;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;


@property(nonatomic,weak) IBOutlet UILabel *LBL_terms;
@property(nonatomic,weak) IBOutlet UIButton *BTN_pay;

//Summary View

@property(nonatomic,weak) IBOutlet UIView *VW_summary;
@property(nonatomic,weak) IBOutlet UILabel *LBL_total;
@property(nonatomic,weak) IBOutlet UIButton *BTN_apply_promo;

@property(nonatomic,weak) IBOutlet UIButton *BTN_Product_summary;
@property(nonatomic,weak) IBOutlet UILabel *LBL_arrow;

// view delivery slot
@property(nonatomic,weak) IBOutlet UIView *VW_delivery_slot;
@property(nonatomic,weak) IBOutlet UIButton *BTN_done;
- (IBAction)order_to_cartPage:(id)sender;
- (IBAction)order_to_wishListPage:(id)sender;

@end
