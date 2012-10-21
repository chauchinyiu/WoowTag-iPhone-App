//
//  SCPicker.m
//  FormTable
//
//  Created by Thomas Blätte on 01.09.10.
//  Copyright 2010 Autoscout24 GmbH. All rights reserved.
//

#import "SCPicker.h"
#import "SCToolbar.h"
 


@interface SCPicker ()

- (void)onDone:(id)sender;
- (void)onSegmentedControlValueChanged:(id)sender;
- (void)slideDownDidStop;

@end


@implementation SCPicker

@synthesize titleLabel=_titleLabel, toolbarTintColor=_toolbarTintColor, segmentedControlTitles=_segmentedControlTitles, selectedSegmentIndex=_selectedSegmentIndex, value=_value, delegate=_delegate, showDoneButton=_showDoneButton, modal=_modal, animated=_animated;

- (void)setSelectedSegmentIndex:(NSInteger)index
{
	_selectedSegmentIndex = index;
	
	if( _segmentedControl )
		_segmentedControl.selectedSegmentIndex = _selectedSegmentIndex;
}
   

- (id)init
{
	if( self = [super init] )
	{
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
		_titleLabel.font = [UIFont boldSystemFontOfSize:17];
		 _titleLabel.textColor = [UIColor whiteColor];
//		_titleLabel.textColor = [UIColor blueColor];
		_titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
		
		_backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		_animated = YES;
	}
	return self;
}

- (UIView *)createPickerView
{
	// Override in subclass!
	return nil;
}

- (BOOL)isVisible
{
	return (_pickerView && _pickerView.superview != nil);
}

- (CGFloat)frameHeight
{
	if( _pickerView == nil || _recreatePickerView )
		return 0;
	else
		return _pickerView.frame.size.height;
}

- (void)setShowDoneButton:(BOOL)show
{
	if( _showDoneButton != show )
		_recreatePickerView = YES;

	_showDoneButton = show;
}

- (void)showAnimated:(BOOL)animated
{
	UIWindow *hostWindow = [[UIApplication sharedApplication] keyWindow];
	
	// ***** create the pickerView *****
	
	if( _pickerView == nil || _recreatePickerView )
	{
		_pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		
		// create the actual picker
		UIView *pickerView = [self createPickerView];
		CGRect pickerRect = pickerView.frame;
		
		if( _showDoneButton || [_titleLabel.text length] || [_segmentedControlTitles count] )
		{
			// create the segmented control
			
			 
			_segmentedControl = nil;
			if( [_segmentedControlTitles count] )
			{
				_segmentedControl = [[UISegmentedControl alloc] initWithItems:_segmentedControlTitles];
				_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
				//_segmentedControl.tintColor = [UIColor scoutBlueColorWithIntensity:0.8];
				_segmentedControl.selectedSegmentIndex = _selectedSegmentIndex;
				[_segmentedControl addTarget:self action:@selector(onSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
				CGRect segRect = _segmentedControl.frame;
				segRect.origin.x = 6;
				segRect.origin.y = 8;
				if( segRect.size.width < 110 )
					segRect.size.width = 110;
				_segmentedControl.frame = segRect;
			}
			
			// create the toolbar
			
			SCToolbar *toolbar = nil;
			if( [SCToolbar conformsToProtocol:@protocol(UIAppearance)] )
				toolbar = [[SCToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
			else
				toolbar = [[SCToolbar alloc] initWithFrame:CGRectMake(0, 0, 321, 44)];
			
			//toolbar.tintColor = [UIColor colorWithRed:0.1 green:0.18 blue:0.27 alpha:0];
			
			NSMutableArray *toolbarItems = [NSMutableArray array];
			[toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ];
			
			if( _segmentedControl && [_titleLabel.text length] )
				[toolbarItems addObject:[[UIBarButtonItem alloc] initWithCustomView:_segmentedControl]];
			
			if( _showDoneButton )
				[toolbarItems addObject: [[UIBarButtonItem alloc] initWithTitle:@"OK"  style:UIBarButtonItemStylePlain target:self action:@selector(onDone:)]];

			toolbar.items = toolbarItems;
			
			[_pickerView addSubview:toolbar];
			 

			
			// add the segmented control if not done already
			if( _segmentedControl && ![_titleLabel.text length] )
				[_pickerView addSubview:_segmentedControl];
			
			
			// create the title label
			
			if( [_titleLabel.text length] )
			{
				CGRect labelRect = CGRectMake(10, 0, 300, toolbar.frame.size.height);
				
				if( _showDoneButton )
					labelRect.size.width -= 60;
				
				if( _segmentedControl )
					labelRect.size.width -= _segmentedControl.frame.size.width + 5;
				
				_titleLabel.frame = labelRect;
				
				[_pickerView addSubview:_titleLabel];
			}
			
			pickerRect.origin.y = toolbar.frame.size.height;
			_pickerView.frame = CGRectMake(0, 0, 320, toolbar.frame.size.height + pickerView.frame.size.height);
		}
		else
		{
			pickerRect.origin.y = 0;
			_pickerView.frame = CGRectMake(0, 0, 320, pickerView.frame.size.height);
		}
		
		pickerView.frame = pickerRect;
		[_pickerView addSubview:pickerView];

		_recreatePickerView = NO;
	}
	
	
	// ***** show the pickerView *****
	
	if( _pickerView && _pickerView.superview == nil )
	{
		if( _modal )
		{
			[hostWindow addSubview:_backgroundView];
			[_backgroundView addSubview:_pickerView];
		}
		else
			[hostWindow addSubview: _pickerView];
		
		CGRect parentRect = _pickerView.superview.frame;
		CGSize pickerSize = [_pickerView sizeThatFits:CGSizeZero];
		
		if( animated )
		{
			// compute the start frame
			CGRect startRect = CGRectMake(0, parentRect.size.height, pickerSize.width, pickerSize.height);
			
			_pickerView.frame = startRect;
			_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
			
			// start the slide up animation
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
		}
		
		
		// show the picker
		CGRect pickerRect = CGRectMake(0, parentRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
		
		_pickerView.frame = pickerRect;
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
		

		if( animated )
		{
			[UIView commitAnimations];
		}
	}
}
- (void)show
{
	[self showAnimated:_animated];
}

- (void)hideAnimated:(BOOL)animated
{
	if( !_pickerView || _pickerView.superview == nil )
		return;
	
	if( animated )
	{
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGRect endFrame = _pickerView.frame;
		endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
		
		// start the slide down animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
		
		_pickerView.frame = endFrame;
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

		[UIView commitAnimations];
	}
	else
	{
		[self slideDownDidStop];
	}
}
- (void)hide
{
	[self hideAnimated:_animated];
}

- (void)dealloc
{
	[self hideAnimated:NO];
 
}


#pragma mark -
#pragma mark event-handler

- (void)onDone:(id)sender
{
	if( _delegate && [_delegate respondsToSelector:@selector(pickerDidHitDone:)] )
		[_delegate performSelector:@selector(pickerDidHitDone:) withObject:self];
	
	[self hide];
}

- (void)onSegmentedControlValueChanged:(id)sender
{
	_selectedSegmentIndex = _segmentedControl.selectedSegmentIndex;
	
	if( _delegate && [_delegate respondsToSelector:@selector(picker:didSelectSegmentedControlIndex:)] )
		[_delegate picker:self didSelectSegmentedControlIndex:_selectedSegmentIndex];
}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it
	[_pickerView removeFromSuperview];
	[_backgroundView removeFromSuperview];


	_segmentedControl = nil;
}


@end
