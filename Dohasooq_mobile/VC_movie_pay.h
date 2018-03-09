//
//  VC_movie_pay.h
//  Dohasooq_mobile
//
//  Created by Test User on 11/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_movie_pay : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UIView *VW_contents;
@property(nonatomic,weak) IBOutlet UIButton *BTN_pay;
@property(nonatomic,weak) IBOutlet UILabel *LBL_service_charges;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_location;
@property(nonatomic,weak) IBOutlet UILabel *LBL_time;
@property(nonatomic,weak) IBOutlet UILabel *LBL_persons;
@property(nonatomic,weak) IBOutlet UILabel *LBL_seat;

@end
