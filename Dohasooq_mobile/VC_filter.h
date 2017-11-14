//
//  VC_filter.h
//  Dohasooq_mobile
//
//  Created by Test User on 13/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface VC_filter : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak) IBOutlet UITextField *TXT_start_date;
@property(nonatomic,weak) IBOutlet UITextField *TXT_end_date;
@property (nonatomic, strong) UIDatePicker *start_picker;
@property (nonatomic, strong) UIDatePicker *end_picker;

@property(nonatomic,weak) IBOutlet UISlider *MIN_slider;
@property(nonatomic,weak) IBOutlet UISlider *MAX_slider;
@property(nonatomic,weak) IBOutlet UILabel *LBL_min;
@property(nonatomic,weak) IBOutlet UILabel *LBL_max;

@property(nonatomic,weak) IBOutlet NMRangeSlider *LBL_slider;


@end
