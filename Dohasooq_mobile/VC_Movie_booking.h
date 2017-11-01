//
//  VC_Movie_booking.h
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDayPicker.h"

@interface VC_Movie_booking : UIViewController
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;

// Movie Detail
@property(nonatomic,weak) IBOutlet UIView *VW_dtl_movie;
@property(nonatomic,weak) IBOutlet UILabel *LBL_movie_name;
@property(nonatomic,weak) IBOutlet UILabel *lbl_duration;
@property(nonatomic,weak) IBOutlet UILabel *LBL_rating;
@property(nonatomic,weak) IBOutlet UILabel *LBL_censor;



@property(nonatomic,weak) IBOutlet UIImageView *IMG_movie;
@property(nonatomic,weak) IBOutlet UILabel *LBL_language;
@property(nonatomic,weak) IBOutlet UIButton *BTN_trailer_watch;


// About Movie

@property(nonatomic,weak) IBOutlet UIView *VW_about_movie;
@property(nonatomic,weak) IBOutlet UILabel *LBL_movie_description;
@property(nonatomic,weak) IBOutlet UIButton *BTN_view_more;

// Timings

@property(nonatomic,weak) IBOutlet UIView *VW_timings;
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property(nonatomic,weak) IBOutlet UITableView *tbl_timings;



@end
