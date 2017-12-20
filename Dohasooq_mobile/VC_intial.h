//
//  VC_intial.h
//  Dohasooq_mobile
//
//  Created by Test User on 24/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hoshi_Billing_ADDR.h"

@interface VC_intial : UIViewController<UIGestureRecognizerDelegate>
@property(nonatomic,weak) IBOutlet UITextField *TXT_country;
@property(nonatomic,weak) IBOutlet UITextField *TXT_language;
@property(nonatomic,weak) IBOutlet UIButton *BTN_next;
@property(nonatomic,weak)IBOutlet  UITableView *TBL_list_coutry;
@property(nonatomic,weak) IBOutlet UITableView *TBL_list_lang;
@property(nonatomic,weak) IBOutlet UIView *VW_ceter;



@end
