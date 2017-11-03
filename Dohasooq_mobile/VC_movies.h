//
//  VC_movies.h
//  Dohasooq_mobile
//
//  Created by Test User on 02/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "XMLDictionary.h"


@interface VC_movies : UIViewController
//Movies Tab
@property(nonatomic,weak) IBOutlet UICollectionView *Collection_movies;
@property(nonatomic,weak) IBOutlet UIView *VW_line;
@property(nonatomic,weak) IBOutlet UIView *VW_segment;
@property(nonatomic,weak) IBOutlet UIView *VW_Movies;
@property(nonatomic,weak) IBOutlet UIButton *BTN_all_lang;
@property(nonatomic,weak) IBOutlet UIButton *BTN_all_halls;
@end
