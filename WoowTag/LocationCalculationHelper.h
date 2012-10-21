//
//  LocationCalculationHelper.h
//  
//
//  Created by Chau Chin yiu on 12.07.11.
//  Copyright 2011 Woowtag. All rights reserved.
//
// Some helpers for location / coordinates calculations.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationCalculationHelper : NSObject {
    
}

/* Calculates the center of the given annoations. The objects of the array must implement the protocol MKAnnotation. */
+(CLLocationCoordinate2D)getCenterOfAnnotations:(NSArray*)annotations;

/* Returns a new array with the objects of the annoations array, ordered by their distance to the given center (ascending). 
 * The objects of the array must implement the protocol MKAnnotation. */
+(NSMutableArray*)sortedAnnotations:(NSArray*)annotations byDistanceTo:(CLLocationCoordinate2D)center;

/* Returns a region with the given center. The region fits the first "num" objects of the annotations array. 
 * The objects of the array must implement the protocol MKAnnotation. */
+(MKCoordinateRegion)createRegionFittingFirst:(int)num annotations:(NSArray*)annotations withCenter:(CLLocationCoordinate2D)center;

@end
