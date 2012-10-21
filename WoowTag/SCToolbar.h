//
//  SCToolbar.h
//  ExampleNavBarBackground
//
//  Created by Thomas Blätte on 17.05.11.
//  Copyright 2011 Autoscout24 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCToolbar : UIToolbar
{
	BOOL _itemsAreStyled;
	UIImage *_backgroundImage;
	UIImageView *_topShadowView;
	BOOL _hideShadow;
}

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, assign) BOOL showShadow;

@end
