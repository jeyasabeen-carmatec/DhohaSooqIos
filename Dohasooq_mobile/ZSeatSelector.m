//
//  ZSeatSelector.m
//  
//
//  Created by Ricardo Zertuche on 7/30/15.
//
//

#import "ZSeatSelector.h"

@implementation ZSeatSelector

#pragma mark - Init and Configuration

- (void)setSeatSize:(CGSize)size{
    seat_width = size.width;
    seat_height = size.height;
}
-(void)setMap:(NSString *)map :(NSArray *)title_arrs :(NSArray *)title :(NSArray *)family :(NSString *)name
{
    int countVAL = 0;
    self.delegate = self;
    zoomable_view = [[UIView alloc]init];
    
     initial_seat_x = 0;
     initial_seat_y = 0;
     final_width = 0;
    
    NSLog(@"Map length = %d adrray count %d",(int)map.length,(int)[title_arrs count]);
    
    for (int i = 0; i<map.length; i++) {
        char seat_at_position = [map characterAtIndex:i];
        
        if (seat_at_position == '/')
        {
            countVAL = countVAL + 1;
        }
        
        
        if (seat_at_position == 'A') {
            
            if([name isEqualToString:@"balcony"])
            {

                [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:TRUE isDisabled:false :[title_arrs objectAtIndex:i-1]:[title objectAtIndex:countVAL]:[family objectAtIndex:countVAL]];
                
                initial_seat_x += 1;
              }
            else{
             
                
                [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:TRUE isDisabled:false :[title_arrs objectAtIndex:i]:[title objectAtIndex:countVAL]:[family objectAtIndex:countVAL ]];
                
                initial_seat_x += 1;

            }
         
            
        }
        
        else if (seat_at_position == 'D') {
            [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:TRUE isDisabled:false :[title_arrs objectAtIndex:initial_seat_x]:[title objectAtIndex:countVAL]:[family objectAtIndex:countVAL]];
            initial_seat_x += 1;
            
        }
        else if (seat_at_position == 'U') {
            if([name isEqualToString:@"balcony"])
            {
                
                [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:false isDisabled:true :[title_arrs objectAtIndex:i -1]:[title objectAtIndex:countVAL]:[family objectAtIndex:countVAL]];
                
                initial_seat_x += 1;
            }
            else{
                
                
                [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:false isDisabled:true :[title_arrs objectAtIndex:i]:[title objectAtIndex:countVAL]:[family objectAtIndex:countVAL]];
                
                initial_seat_x += 1;
                
            }

//             [self createSeatButtonWithPosition:initial_seat_x and:initial_seat_y isAvailable:false isDisabled:false :[title_arrs objectAtIndex:i-1]:[title objectAtIndex:countVAL]:[family objectAtIndex:countVAL]];

          //  initial_seat_x += 1;
            
        } else if(seat_at_position=='_'){
            initial_seat_x += 1;
            
        }
        else {
            if (initial_seat_x>final_width) {
                final_width = initial_seat_x;
            }
            initial_seat_x = 0;
            initial_seat_y += 1;
        }
        
    }
    zoomable_view.frame = CGRectMake(40, 0, final_width*seat_width, initial_seat_y*seat_height);
    [self setContentSize:zoomable_view.frame.size];
    CGFloat newContentOffsetX = (self.contentSize.width - self.frame.size.width) / 2;
    self.contentOffset = CGPointMake(newContentOffsetX, 0);
    self.maximumZoomScale = 6.0f;
    self.minimumZoomScale  = 0.4f;
    self.delegate = self;
    
    
    

    selected_seats = [[NSMutableArray alloc]init];
    [self addSubview:zoomable_view];
    
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
  
    return zoomable_view;
}

- (void)createSeatButtonWithPosition:(int)initial_x_seat and:(int)initial_y_seat isAvailable:(BOOL)available isDisabled:(BOOL)disabled :(NSString *)title_cell :(NSString *)title_row :(NSString *)family{
    
    title_btn = [[UIButton alloc]init];
    title_btn.frame = CGRectMake(-20,initial_seat_y*25, 20, 20);
    title_btn.backgroundColor = [UIColor clearColor];
    [title_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    title_btn.titleLabel.font = [UIFont systemFontOfSize:12];
  
    [title_btn setTitle:title_row forState:UIControlStateNormal];
  
    [zoomable_view addSubview:title_btn];

    
    ZSeat *seatButton = [[ZSeat alloc]initWithFrame:
                         CGRectMake(initial_x_seat*25,
                                    initial_y_seat*25,
                                    20 ,
                                    20)];
    seatButton.backgroundColor = [UIColor grayColor];

    if([family isEqualToString:@"1"])
    {
    seatButton.layer.borderWidth = 0.8f;
    seatButton.layer.borderColor = [UIColor redColor].CGColor;
    [seatButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        
    }
    else
    {
        seatButton.layer.borderWidth = 0.8;
        seatButton.layer.borderColor = [UIColor grayColor].CGColor;
        [seatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


    }
    

    if (available && disabled) {
        [self setSeatAsDisabled:seatButton];
    } else if (available && !disabled) {
        [self setSeatAsAvaiable:seatButton];
    } else {
        [self setSeatAsUnavaiable:seatButton];
    }
    [seatButton setTitle:title_cell forState:UIControlStateNormal];
    [seatButton setAvailable:available];
    [seatButton setDisabled:disabled];
    [seatButton setRow:initial_seat_y+1];
    [seatButton setColumn:initial_seat_x+1];
    [seatButton setPrice:self.seat_price];
    [seatButton addTarget:self action:@selector(seatSelected:) forControlEvents:UIControlEventTouchDown];
    seatButton.titleLabel.font = [UIFont systemFontOfSize:8];
    [seatButton setTitle:title_cell forState:UIControlStateNormal];
    [zoomable_view addSubview:seatButton];
    
    
}

#pragma mark - Seat Selector Methods

- (void)seatSelected:(ZSeat*)sender{
    if (!sender.selected_seat && sender.available) {
        if (self.selected_seat_limit) {
            [self checkSeatLimitWithSeat:sender];
        } else {
            [self setSeatAsSelected:sender];
            [selected_seats addObject:sender];
        }
    } else {
        [selected_seats removeObject:sender];
        if (sender.available && sender.disabled) {
            [self setSeatAsDisabled:sender];
        } else if (sender.available && !sender.disabled) {
            [self setSeatAsAvaiable:sender];
        }
    }
    
    [self.seat_delegate seatSelected:sender];
    [self.seat_delegate getSelectedSeats:selected_seats];
}
- (void)checkSeatLimitWithSeat:(ZSeat*)sender{
    if ([selected_seats count]<self.selected_seat_limit) {
        [self setSeatAsSelected:sender];
        [selected_seats addObject:sender];
    } else {
        ZSeat *seat_to_make_avaiable = [selected_seats objectAtIndex:0];
        if (seat_to_make_avaiable.disabled)
            [self setSeatAsDisabled:seat_to_make_avaiable];
        else
            [self setSeatAsAvaiable:seat_to_make_avaiable];
        [selected_seats removeObjectAtIndex:0];
        [self setSeatAsSelected:sender];
        [selected_seats addObject:sender];
    }
}

#pragma mark - Seat Images & Availability

- (void)setAvailableImage:(UIButton *)available_image andUnavailableImage:(UIButton *)unavailable_image andDisabledImage:(UIButton *)disabled_image andSelectedImage:(UIButton *)selected_image{
    
    self.unavailable_image.backgroundColor   = [UIColor grayColor];
    self.unavailable_image  = unavailable_image;
    self.disabled_image     = disabled_image;
    self.selected_image     = selected_image;
}
- (void)setSeatAsUnavaiable:(ZSeat *)sender{
    sender.backgroundColor = [UIColor grayColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [sender setSelected_seat:TRUE];
}
- (void)setSeatAsAvaiable:(ZSeat*)sender{
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [sender setSelected_seat:FALSE];
}
- (void)setSeatAsDisabled:(ZSeat*)sender{
    sender.backgroundColor = [UIColor grayColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [sender setSelected_seat:FALSE];
}
- (void)setSeatAsSelected:(ZSeat*)sender{
    sender.backgroundColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setSelected_seat:TRUE];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // NSLog(@"didZoom");
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    //NSLog(@"scrollViewWillBeginZooming");
}

@end
