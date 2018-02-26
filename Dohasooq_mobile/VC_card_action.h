//
//  VC_card_action.h
//  Dohasooq_mobile
//
//  Created by Test User on 13/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_card_action : UIViewController
@property(nonatomic,weak) IBOutlet UICollectionView *collection_pay_options;
@property(nonatomic,weak) IBOutlet UIButton *BTN_pay;
@property(nonatomic,weak) IBOutlet UIButton *BTN_cancel;
@property(nonatomic,weak) IBOutlet UITextField *TXT_countries;
@property(nonatomic,weak) IBOutlet UILabel *LBL_timer;

@property(nonatomic,weak) IBOutlet UIButton *BTN_american_express;
@property(nonatomic,weak) IBOutlet UIButton *BTN_visa;
@property(nonatomic,weak) IBOutlet UIButton *BTN_dohabank;
@property(nonatomic,weak) IBOutlet UIButton *BTN_debit_card;




@property (nonatomic, strong) UIPickerView *country_picker_view;
@end
