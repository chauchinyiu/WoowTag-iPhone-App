//
//  AddressAnnotation.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Product.h"
@interface AddressAnnotation :  NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *_mTitle;
    NSString *_mSubTitle;
    NSString *_mImageUrl;
    Product *_product;
}
@property (nonatomic, retain) NSString * mImageUrl;
@property (nonatomic, retain) NSString * mTitle;
@property (nonatomic, retain) NSString * mSubTitle;
@property (nonatomic, retain) Product * product;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c;
@end
