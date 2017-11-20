//
//  VC_upcoming_movies.h
//  Dohasooq_mobile
//
//  Created by Test User on 14/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_upcoming_movies : UIViewController
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;

// Movie Detail
@property(nonatomic,weak) IBOutlet UIView *VW_dtl_movie;
@property(nonatomic,weak) IBOutlet UILabel *LBL_movie_name;
@property(nonatomic,weak) IBOutlet UILabel *lbl_duration;
@property(nonatomic,weak) IBOutlet UILabel *LBL_rating;
@property(nonatomic,weak) IBOutlet UILabel *LBL_year;



@property(nonatomic,weak) IBOutlet UIImageView *IMG_movie;
@property(nonatomic,weak) IBOutlet UILabel *LBL_language;
@property(nonatomic,weak) IBOutlet UIButton *BTN_trailer_watch;
@property(nonatomic,weak) IBOutlet UIButton *BTN_will_watch;
@property(nonatomic,weak) IBOutlet UIButton *BTN_will_not_watch;




// About Movie

@property(nonatomic,weak) IBOutlet UIView *VW_about_movie;
@property(nonatomic,weak) IBOutlet UILabel *LBL_movie_description;
@property(nonatomic,weak) IBOutlet UIButton *BTN_view_more;

@end
