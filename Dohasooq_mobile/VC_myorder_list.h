//
//  VC_myorder_list.h
//  Dohasooq_mobile
//
//  Created by Test User on 04/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"

@interface VC_myorder_list : UIViewController
@property(nonatomic,weak) IBOutlet UITableView *TBL_orders;
@property(nonatomic,weak) IBOutlet UITextField *TXT_search;
@property(nonatomic,weak) IBOutlet MIBadgeButton *BTN_cart;
@property(nonatomic,weak) IBOutlet MIBadgeButton *BTN_wish_list;
@property(nonatomic,weak) IBOutlet UIButton *BTN_header;




@end
