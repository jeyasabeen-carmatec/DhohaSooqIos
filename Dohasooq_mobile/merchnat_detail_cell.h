//
//  merchnat_detail_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 21/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface merchnat_detail_cell : UICollectionViewCell
{
    HCSStarRatingView *rating;
}
@property(nonatomic,weak) IBOutlet UIButton *BTN_rate;

@property(nonatomic,weak) IBOutlet UIImageView *IMG_item;
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property(nonatomic,weak) IBOutlet UITextView *TXT_cost;
@property(nonatomic,weak) IBOutlet UIButton *BTN_discount;




@end
