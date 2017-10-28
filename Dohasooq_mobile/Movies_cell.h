//
//  Movies_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 21/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Movies_cell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *LBL_movie_name;
@property (weak, nonatomic) IBOutlet UILabel *LBL_language;
@property (weak, nonatomic) IBOutlet UILabel *LBL_censor;
@property (weak, nonatomic) IBOutlet UILabel *LBL_duration;
@property (weak, nonatomic) IBOutlet UIImageView *IMG_banner;
@property (weak, nonatomic) IBOutlet UILabel *LBL_rating;

@end
