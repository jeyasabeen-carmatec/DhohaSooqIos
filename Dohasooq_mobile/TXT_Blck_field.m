//
//  TXT_Blck_field.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "TXT_Blck_field.h"

@implementation TXT_Blck_field

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(10, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(10, bounds.origin.y, bounds.size.width, bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
