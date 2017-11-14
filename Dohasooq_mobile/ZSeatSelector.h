//
//  ZSeatSelector.h
//  
//
//  Created by Ricardo Zertuche on 7/30/15.
//
//

#import <UIKit/UIKit.h>
#import "ZSeat.h"

@class ZSeatSelector;
@protocol ZSeatSelectorDelegate <NSObject>
- (void)seatSelected:(ZSeat *)seat;
@optional
- (void)getSelectedSeats:(NSMutableArray *)seats;
@end

@interface ZSeatSelector : UIScrollView <UIScrollViewDelegate>{
    float seat_width;
    float seat_height;
    NSMutableArray *selected_seats;
    UIView *zoomable_view;
    int initial_seat_x;
    int initial_seat_y ;
    int final_width;
    UIButton *title_btn;
    
}

@property (nonatomic, retain) NSArray  *title_arr;
@property (nonatomic, retain) UIButton *unavailable_image;
@property (nonatomic, retain) UIButton *disabled_image;
@property (nonatomic, retain) UIButton *selected_image;
@property (nonatomic) int selected_seat_limit;

@property (nonatomic) float seat_price;
@property (retain) id seat_delegate;
-(void)title_row_button:(NSArray *)title_arr;

-(void)setSeatSize:(CGSize)size;

-(void)setMap:(NSString *)map :(NSArray *)title_arrs :(NSArray *)title :(NSArray *)family :(NSString *)name;

- (void)createSeatButtonWithPosition :(int)initial_x_seat and :(int)initial_y_seat isAvailable :(BOOL)available isDisabled :(BOOL)disabled :(NSString *)title_cell :(NSString *)title_row :(NSString *)family;
@end
