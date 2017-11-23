//
//  merchnat_detail_cell.m
//  Dohasooq_mobile
//
//  Created by Test User on 21/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "merchnat_detail_cell.h"

@implementation merchnat_detail_cell

- (void)awakeFromNib {
    [super awakeFromNib];
    rating = [[HCSStarRatingView alloc] initWithFrame:_BTN_rate.frame];
    rating.maximumValue = 5;
    rating.minimumValue = 0;
    rating.value = 0;
    rating.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    rating.backgroundColor = [UIColor clearColor];

    [self addSubview:rating];
    rating.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //[starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    rating.allowsHalfStars = YES;
    rating.value = 2.5f;

    // Initialization code
}

@end
