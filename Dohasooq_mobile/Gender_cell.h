//
//  Gender_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 26/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Gender_cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *LBL_gender_cat;
@property(nonatomic,weak) IBOutlet UILabel *LBL_price;
@property(nonatomic,weak) IBOutlet UIButton *BTN_minus;
@property(nonatomic,weak) IBOutlet UILabel *LBL_result;
@property(nonatomic,weak) IBOutlet UIButton *BTN_plus;

@end
