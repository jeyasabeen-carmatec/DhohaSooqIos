//
//  DragRefreshTableFooterView_ot.m
//  WinningTicket
//
//  Created by Test User on 04/03/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import "DragTableFooterView_ot.h"
#import "DragTableDragState_ot.h"
#import "DejalActivityView.h"
#import "DGActivityIndicatorView.h"

#define TEXT_COLOR                          [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION             (0.18f)

@implementation DragTableFooterView_ot
{
	DragTableDragState_ot _state;
    BOOL _isLoading;
    
	UILabel *_statusLabel;
	DGActivityIndicatorView *_activityView;
    
    UIView *_backgroundView;
}
@synthesize isLoading = _isLoading;
@synthesize pullUpText = _pullUpText, releaseText = _releaseText, loadingText = _loadingText;

#pragma mark - Text
- (void)setPullUpText:(NSString *)pullUpText
{
    _pullUpText = pullUpText;
    
    //refresh status label immediately
    self.state = self.state;
}

- (void)setReleaseText:(NSString *)releaseText
{
    _releaseText = releaseText;
    
    //refresh status label immediately
    self.state = self.state;
}

- (void)setLoadingText:(NSString *)loadingText
{
    _loadingText = loadingText;
    
    //refresh status label immediately
    self.state = self.state;
}

#pragma mark - UIs
- (UILabel *)loadingStatusLabel
{
    return _statusLabel;
}

- (DGActivityIndicatorView *)loadingIndicator
{
    return _activityView;
}

- (UIView *)backgroundView
{
    return _backgroundView;
}

#pragma mark - Events

- (CGFloat)footerVisbleHeightInScrollView:(UIScrollView *)scrollView
{
    return CGRectGetHeight(scrollView.frame) - (CGRectGetMinY(self.frame) - scrollView.contentOffset.y);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.releaseText = NSLocalizedString(@"Release to load more...", @"Release to load more Events");
        self.pullUpText = NSLocalizedString(@"Pull up to load more...", @"Pull down to load more Events");
        self.loadingText = NSLocalizedString(@"Loading...", @"Loading Events");
        
        _isLoading = NO;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 12.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
		
        _activityView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor darkGrayColor]];
		_activityView.frame = CGRectMake(28.0f, 10.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self insertSubview:_backgroundView atIndex:0];
		
		[self setState:DragTableDragStateNormal_ot];
    }
    return self;
}

- (DragTableDragState_ot)state
{
    return _state;
}

- (void)setState:(DragTableDragState_ot)aState
{
	switch (aState)
    {
		case DragTableDragStatePulling_ot:
        {
			_statusLabel.text = self.releaseText;
        }
			break;
		case DragTableDragStateNormal_ot:
        {
			_statusLabel.text = self.pullUpText;
			[_activityView stopAnimating];
        }
			break;
		case DragTableDragStateLoading_ot:
        {
			_statusLabel.text = self.loadingText;
			[_activityView startAnimating];
        }
			break;
		default:
			break;
	}
	_state = aState;
}

- (void)dragTableDidScroll:(UIScrollView *)scrollView
{
    if (_state != DragTableDragStateLoading_ot && scrollView.isDragging)
    {
		BOOL _loading = _isLoading;
		if (_state == DragTableDragStatePulling_ot && [self footerVisbleHeightInScrollView:scrollView] < LOADMORE_TRIGGER_HEIGHT && !_loading)
        {
			[self setState:DragTableDragStateNormal_ot];
		}
        else if (_state == DragTableDragStateNormal_ot && [self footerVisbleHeightInScrollView:scrollView] > LOADMORE_TRIGGER_HEIGHT && !_loading)
        {
			[self setState:DragTableDragStatePulling_ot];
		}
	}
}

- (void)dragTableDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = _isLoading;
    CGFloat footerVisibleHeight = [self footerVisbleHeightInScrollView:scrollView];
	if (footerVisibleHeight >= LOADMORE_TRIGGER_HEIGHT && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(dragTableFooterDidTriggerLoadMore:)])
        {
			[_delegate dragTableFooterDidTriggerLoadMore:self];
            _isLoading = YES;
		}
		[self setState:DragTableDragStateLoading_ot];
        
        CGFloat contentInsetHeightAdder = scrollView.frame.size.height - scrollView.contentSize.height;
        contentInsetHeightAdder = MAX(0, contentInsetHeightAdder);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LOADMORE_TRIGGER_HEIGHT + contentInsetHeightAdder, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)triggerLoading:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, LOADMORE_TRIGGER_HEIGHT)];
    [self dragTableDidEndDragging:scrollView];
}

//Prevent animation conflict when refresh triggerd. Pass `NO` to `shouldChangeContentInset` when refresh triggered.
- (void)endLoading:(UIScrollView *)scrollView shouldChangeContentInset:(BOOL)shouldChangeContentInset
{
    if (_isLoading)
    {
        if (shouldChangeContentInset)
        {
            NSString *edgeInsetString = NSStringFromUIEdgeInsets(UIEdgeInsetsZero);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 scrollView, @"scrollView",
                                 edgeInsetString, @"edgeInset",
                                 nil];
            [self performSelector:@selector(setScrollViewContentInset:) withObject:dic afterDelay:0.5];
        }
        _isLoading = NO;
    }
	[self setState:DragTableDragStateNormal_ot];
}

//For set `contentInset` with delay usage.
//Prevent call [table reloadData] and `endLoading:shouldChangeContentInset:` at the same runloop.
//If [table reloadData] and [table setContentInset"] at the same runloop, `contentOffset` behaves strangely.
- (void)setScrollViewContentInset:(NSDictionary *)dic
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIScrollView *scrollView = dic[@"scrollView"];
    NSString *edgeInsetString = dic[@"edgeInset"];
    UIEdgeInsets edgeInset = UIEdgeInsetsFromString(edgeInsetString);
    [scrollView setContentInset:edgeInset];
    [UIView commitAnimations];
}

@end
