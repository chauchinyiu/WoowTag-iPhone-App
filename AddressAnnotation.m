//
//  AddressAnnotation.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize coordinate;
@synthesize mTitle=_mTitle;
@synthesize mSubTitle=_mSubTitle;
@synthesize mImageUrl = _mImageUrl;
@synthesize product=_product;
- (NSString *)subtitle{
    return _mSubTitle;
}

- (NSString *)title{
    return _mTitle;
}
 
-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate=c;
    NSLog(@"%f,%f",c.latitude,c.longitude);
    return self;
}


@end
