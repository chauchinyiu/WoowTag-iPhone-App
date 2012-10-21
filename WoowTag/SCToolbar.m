//
//  SCToolbar.m
//
//  Created by Thomas Blätte on 17.05.11.
//  Copyright 2011 Autoscout24 GmbH. All rights reserved.
//

#import "SCToolbar.h"
 


@interface SCToolbar ()

- (void)styleItems;

@end



@implementation SCToolbar

#pragma mark -
#pragma mark properties

- (UIImage *)backgroundImage
{
	if( !_backgroundImage )
		_backgroundImage =  [UIImage imageNamed:@"blue_nav_bar.png"] ;

	return _backgroundImage;
}

- (void)setBackgroundImage:(UIImage *)newImage
{
	if( newImage != _backgroundImage )
	{
		 
		_backgroundImage = [newImage copy];
	}
}

- (BOOL)showShadow
{
	return !_hideShadow;
}

- (void)setShowShadow:(BOOL)newShowShadow
{
	_hideShadow = !newShowShadow;
	_topShadowView.hidden = _hideShadow;
}


#pragma mark -
#pragma mark UIView

- (void)dealloc
{
	
	[_topShadowView removeFromSuperview];
 
}

- (void)didMoveToSuperview
{
	[_topShadowView removeFromSuperview];
	
	if( self.superview )
	{
		if( !_topShadowView )
			_topShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_top.png"]];
		
		CGRect shadowRect = _topShadowView.bounds;
		CGRect selfRect = self.frame;
		
		shadowRect.origin.x = selfRect.origin.x;
		shadowRect.origin.y = selfRect.origin.y - shadowRect.size.height;
		shadowRect.size.width = selfRect.size.width;
		
		_topShadowView.frame = shadowRect;
		[self.superview addSubview:_topShadowView];
	}
	
	_topShadowView.hidden = _hideShadow;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect shadowRect = _topShadowView.bounds;
	CGRect selfRect = self.frame;
	
	shadowRect.origin.x = selfRect.origin.x;
	shadowRect.origin.y = selfRect.origin.y - shadowRect.size.height;
	shadowRect.size.width = selfRect.size.width;
	
	_topShadowView.frame = shadowRect;
	_topShadowView.hidden = _hideShadow;

	[self styleItems];
}

- (void)drawRect:(CGRect)rect
{
	[self.backgroundImage drawInRect:self.bounds];
}

#pragma mark -
#pragma mark internal functions

- (void)styleItems
{
	if( _itemsAreStyled || [self.items count] == 0 )
		return;
	
	// style bar button items
	
	for( UIBarButtonItem *bbi in self.items )
	{
		if( !bbi.customView && [bbi respondsToSelector:@selector(applyCustomStyle)] )
		{
//			[(SCBarButtonItem *)bbi applyCustomStyle];
			
			[self addSubview:bbi.customView];	// there is a bug in iOS up to version 4.1. On those iOS versions the bbi.customView would not be visible if it wasn't added to the toolbar again
		}
	}
	
	
	if( ![UIBarButtonItem conformsToProtocol:@protocol(UIAppearance)] )
	{
		// move and resize rect on older iOS versions. This is a dirty workaround, but works
		
		CGRect rect = self.frame;
		BOOL rectChanged = NO;
		
		if( [[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending )	// if iOS version < 4.0
		{
			if( [[self.items objectAtIndex:0] isKindOfClass:[UIBarButtonItem class]] && rect.size.width == 320 )
			{
				rect.origin.x -= 6;
				rect.size.width += 6;
				rectChanged = YES;
			}
		}

		
		if( [[self.items objectAtIndex:[self.items count]-1] isKindOfClass:[UIBarButtonItem class]] &&  (rect.origin.x + rect.size.width) == 320 )
		{
			rect.size.width += 6;
			rectChanged = YES;
		}
		
		self.frame = rect;
	}
	
	_itemsAreStyled = YES;
}

@end
