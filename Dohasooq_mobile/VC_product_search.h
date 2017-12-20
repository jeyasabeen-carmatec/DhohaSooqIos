//
//  VC_product_search.h
//  Dohasooq_mobile
//
//  Created by Test User on 14/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_product_search : UIViewController
@property(nonatomic,weak) IBOutlet UITextField *TXT_search;
@property(nonatomic,weak) IBOutlet UIButton *BTN_close;
@property(nonatomic,weak) IBOutlet UITableView  *TBL_search_results;

@property(nonatomic,weak) IBOutlet UIView *VW_navMenu;
@property(nonatomic,weak) IBOutlet UIButton *BTN_search;




@end
