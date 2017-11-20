//
//  upcoming_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 14/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface upcoming_cell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *LBL_movie_name;
@property (weak, nonatomic) IBOutlet UILabel *LBL_language;
@property (weak, nonatomic) IBOutlet UILabel *LBL_duration;
@property (weak, nonatomic) IBOutlet UIImageView *IMG_banner;
@property (weak, nonatomic) IBOutlet UILabel *LBL_rating;
@property (weak, nonatomic) IBOutlet UILabel *LBL_year;


@end
