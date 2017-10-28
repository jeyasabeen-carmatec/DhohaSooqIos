//
//  sports_booking_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sports_booking_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *IMG_team1_flag;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_team2_flag;
@property(nonatomic,weak) IBOutlet UILabel *LBL_match_teams;
@property(nonatomic,weak) IBOutlet UILabel *LBL_match_time;
@property(nonatomic,weak) IBOutlet UILabel *LBL_match_venue;
@property(nonatomic,weak) IBOutlet UIButton *BTN_book_ticket;


@end
