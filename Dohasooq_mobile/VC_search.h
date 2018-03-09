//
//  VC_search.h
//  Dohasooq_mobile
//
//  Created by Test User on 31/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_search : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UITextField *TXT_search;
@property(nonatomic,weak) IBOutlet UIButton *BTN_search;
@property(nonatomic,weak) IBOutlet UITableView *TBL_results;
@property(nonatomic,weak) IBOutlet UIView *VW_nav;


@end
