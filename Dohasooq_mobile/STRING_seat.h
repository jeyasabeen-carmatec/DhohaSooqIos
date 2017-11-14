//
//  STRING_seat.h
//  ZSeatSelector
//
//  Created by Test User on 08/11/17.
//  Copyright © 2017 Ricardo Zertuche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STRING_seat : NSObject
//-(NSString *)SEAT_alloc :(NSArray *)ARR_ALLseat :(NSArray *)ARR_Gangway :(NSArray *)ARR_gangCount;
-(NSArray *) GET_allSEAT :(NSArray *)seats :(NSArray *)available_seat :(NSString *)GAng_ini :(NSArray *) gagngway :(NSArray *)gangway_count;
-(NSArray *) set_title :(NSArray *)seats :(NSString *) Gang_ini : (NSArray *) gagngway :(NSArray *)gangway_count;

@end
