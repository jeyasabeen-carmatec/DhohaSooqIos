//
//  VC_event_user.h
//  Dohasooq_mobile
//
//  Created by Test User on 28/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface VC_event_user : UIViewController<UIGestureRecognizerDelegate>
@property(nonatomic,weak) IBOutlet UIView *VW_contents;
@property(nonatomic,weak) IBOutlet UIScrollView *scroll_contents;
@property(nonatomic,weak) IBOutlet UIButton *BTN_pay;
@property(nonatomic,weak) IBOutlet UILabel *LBL_amount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_service_charges;
@property(nonatomic,weak) IBOutlet UIImageView *LBL_stat;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;
@property(nonatomic,weak) IBOutlet UILabel *LBL_total_charge;
@property(nonatomic,weak) IBOutlet UIButton *BTN_terms;



@property(nonatomic,weak) IBOutlet UIButton *BTN_apply;
@property (nonatomic, strong) UIPickerView *phone_picker_view;



@property(nonatomic,weak) IBOutlet UITextField *TXT_name;
@property(nonatomic,weak) IBOutlet UITextField *TXT_mail;
@property(nonatomic,weak) IBOutlet UITextField *TXT_phone;
@property(nonatomic,weak) IBOutlet UITextField *TXT_code;
@property(nonatomic,weak) IBOutlet UITextField *TXT_voucher;

//terms and conditions
@property(nonatomic,weak) IBOutlet UIButton *BTN_ok_terms;

@property(nonatomic,weak) IBOutlet UIView *VW_terms;
@property(nonatomic,weak) IBOutlet UIWebView *web_terms;


@end
