//
//  billing_address.h
//  Dohasooq_mobile
//
//  Created by Test User on 05/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface billing_address : UITableViewCell
@property(nonatomic,weak) IBOutlet UITextField *TXT_first_name;
@property(nonatomic,weak) IBOutlet UITextField *TXT_last_name;
@property(nonatomic,weak) IBOutlet UITextField *TXT_address1;
@property(nonatomic,weak) IBOutlet UITextField *TXT_address2;
@property(nonatomic,weak) IBOutlet UITextField *TXT_city;
@property(nonatomic,weak) IBOutlet UITextField *TXT_state;
@property(nonatomic,weak) IBOutlet UITextField *TXT_country;
@property(nonatomic,weak) IBOutlet UITextField *TXT_zip;
@property(nonatomic,weak) IBOutlet UITextField *TXT_email;
@property(nonatomic,weak) IBOutlet UITextField *TXT_phone;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;
@property(nonatomic,weak) IBOutlet UIImageView *LBL_stat;


@end
