//
//  VC_seat_book.h
//  Dohasooq_mobile
//
//  Created by Test User on 10/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSeatSelector.h"
#import "ZSeat.h"
#import "STRING_seat.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_seat_book : GAITrackedViewController<ZSeatSelectorDelegate>

@property(nonatomic,weak) IBOutlet UIView *VW_seat;
@property(nonatomic,weak) IBOutlet UIButton *BTN_book;
@property(nonatomic,weak) IBOutlet UILabel *LBL_no_ofseats;



@end
