//
//  STRING_seat.m
//  ZSeatSelector
//
//  Created by Test User on 08/11/17.
//  Copyright © 2017 Ricardo Zertuche. All rights reserved.
//

#import "STRING_seat.h"

@implementation STRING_seat

//-(NSString *)SEAT_alloc :(NSArray *)ARR_ALLseat :(NSArray *)ARR_Gangway :(NSArray *)ARR_gangCount
//{
//    NSArray *ARR_getSEATS = [self GET_allSEAT:ARR_ALLseat :ARR_Gangway :ARR_gangCount];
//    NSMutableArray *ARR_process = [[NSMutableArray alloc] init];
//    
//
//}



-(NSArray *) GET_allSEAT :(NSArray *)seats :(NSArray *)available_seat :(NSString *)GAng_ini :(NSArray *) gagngway :(NSArray *)gangway_count
{
    NSMutableArray *ARR_SeatALLOC = [[NSMutableArray alloc]init];
    NSMutableArray *ARR_finalDATA = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < [seats count]; i++)
    {
        [ARR_SeatALLOC addObject:[seats objectAtIndex:i]];
    }
    for(int k =0;k<[GAng_ini intValue];k++)
    {
        [ARR_SeatALLOC insertObject:@"__" atIndex:k];
    }
    for (int j = 0; j < [gagngway count]; j++)
    {
        NSString *String = [gagngway objectAtIndex:j];
        NSInteger index = [ARR_SeatALLOC indexOfObject:String];
        for (int k = 0; k < [[gangway_count objectAtIndex:j] intValue]; k ++)
        {
            [ARR_SeatALLOC insertObject:@"__" atIndex:index+k+1];
        }
    }
    
    for (int s = 0; s < [ARR_SeatALLOC count]; s ++) {
        NSString *STR_val;
        if ([[ARR_SeatALLOC objectAtIndex:s] isEqualToString:@"__"]) {
           // [ARR_finalDATA addObject:@"_"];
            STR_val =@"_";
        }
        else
        {
            for (int p = 0; p < [available_seat count]; p++)
            {
                if ([available_seat containsObject:[ARR_SeatALLOC objectAtIndex:s]])
                {
//                    [ARR_finalDATA addObject:@"A"];
                    STR_val = @"A";
                }
                else
                {
//                    [ARR_finalDATA addObject:@"U"];
                    STR_val = @"U";
                }
            }
        }
        [ARR_finalDATA addObject:STR_val];
    }
    
    [ARR_finalDATA addObject:@"/"];
    return ARR_finalDATA;
}
-(NSArray *) set_title :(NSArray *)seats :(NSString *)Gang_ini : (NSArray *) gagngway :(NSArray *)gangway_count
{
    
    NSMutableArray *ARR_SeatALLOC = [[NSMutableArray alloc]init];
   // NSMutableArray *ARR_SeatAs = [[NSMutableArray alloc]init];
    NSMutableArray *gangarr = [[NSMutableArray alloc]init];
    for (int i = 0; i < [seats count]; i++)
    {
        [ARR_SeatALLOC addObject:[seats objectAtIndex:i]];
    }
    for(int k =0;k<[Gang_ini intValue];k++)
    {
        [ARR_SeatALLOC insertObject:@" " atIndex:k];
    }

    for(int k =0;k<[gagngway count];k++)
    {
         [gangarr addObject:[[gagngway objectAtIndex:k] substringFromIndex:1]];
    }
    for (int j = 0; j < [gagngway count]; j++)
    {
        NSString *String = [gangarr objectAtIndex:j];
        NSInteger index = [ARR_SeatALLOC indexOfObject:String];
        for (int k = 0; k < [[gangway_count objectAtIndex:j] intValue]; k ++)
        {
            [ARR_SeatALLOC insertObject:@" " atIndex:index+k+1];
        }
        
    }
    [ARR_SeatALLOC addObject:@" "];
    return ARR_SeatALLOC;
}

@end
