//
//  VC_event_user.h
//  Dohasooq_mobile
//
//  Created by Test User on 28/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_event_user : UIViewController
@property(nonatomic,weak) IBOutlet UIView *VW_contents;
@property(nonatomic,weak) IBOutlet UIScrollView *scroll_contents;
@property(nonatomic,weak) IBOutlet UIButton *BTN_pay;
@property(nonatomic,weak) IBOutlet UILabel *LBL_amount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_service_charges;
@property(nonatomic,weak) IBOutlet UIImageView *LBL_stat;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;

@property(nonatomic,weak) IBOutlet UIButton *BTN_apply;




@end