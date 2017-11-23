//
//  ViewController.h
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoshiTextField.h"


@interface ViewController : UIViewController


@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_username;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_password;
@property(nonatomic,weak) IBOutlet UIButton *BTN_login;
@property(nonatomic,weak) IBOutlet UIView *VW_fields;


@property(nonatomic,weak) IBOutlet UIButton *BTN_sign_up;
@property(nonatomic,weak) IBOutlet UILabel *LBL_sign_up;

@property (weak, nonatomic) IBOutlet UIButton *BTN_skip;




@end

