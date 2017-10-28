//
//  events_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 18/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface events_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *IMG_event;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_location;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_date;

@property(nonatomic,weak) IBOutlet UIImageView *IMG_qtickets;
@property(nonatomic,weak) IBOutlet UILabel *LBL_banner_label;

@end
