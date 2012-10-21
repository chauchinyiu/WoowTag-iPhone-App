//
//  LocationCalculationHelper.m
//  IS24GewerbeiPhone
//
//  Created by tjolau on 12.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationCalculationHelper.h"

NSInteger compareDistance(id num1, id num2,  CLLocation* context ){
    
    int retour;
    // fist we need to cast all the parameters
    CLLocation* location =context;
    id<MKAnnotation> param1 = num1;
    id<MKAnnotation> param2 = num2;
    
    // then we can use them as standard ObjC objects
    CLLocation* locationCoordinates = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    CLLocation* locationPOI1 = [[CLLocation alloc] initWithLatitude:param1.coordinate.latitude longitude:param1.coordinate.longitude];
    CLLocation* locationPOI2 = [[CLLocation alloc] initWithLatitude:param2.coordinate.latitude longitude:param2.coordinate.longitude];
    CLLocationDistance distance1 = [locationPOI1 distanceFromLocation:locationCoordinates];
    CLLocationDistance distance2 = [locationPOI2 distanceFromLocation:locationCoordinates];
    
    //make the comparaison
    if (distance1 < distance2)
        retour = NSOrderedAscending;
    else if (distance1 > distance2)
        retour = NSOrderedDescending;
    else
        retour = NSOrderedSame;
    
//    [locationCoordinates release];
//    [locationPOI1 release];
//    [locationPOI2 release];
    return retour;
    
}

@implementation LocationCalculationHelper

+(CLLocationCoordinate2D)getCenterOfAnnotations:(NSArray*)annotations {
    CLLocationCoordinate2D res;
    res.latitude = 100;
    res.longitude = 200;
    if ([annotations count] > 0) {
        CLLocationDegrees minLat = +90;
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees minLong = +180;
        CLLocationDegrees maxLong = -180;
        for(id<MKAnnotation> myMapItem in annotations) {
            if ([myMapItem isKindOfClass:[MKUserLocation class]]) {
                //ignore userlocation annotation to calc center
                continue;
            }
            minLat = fmin(minLat, myMapItem.coordinate.latitude);
            maxLat = fmax(maxLat, myMapItem.coordinate.latitude);
            minLong = fmin(minLong, myMapItem.coordinate.longitude);
            maxLong = fmax(maxLong, myMapItem.coordinate.longitude);
        }
        res.latitude = (minLat + maxLat ) / 2.0;
        res.longitude = (minLong + maxLong ) / 2.0;
    }
    return res;
}

+(NSMutableArray*)sortedAnnotations:(NSArray*)annotations byDistanceTo:(CLLocationCoordinate2D)center{
    NSMutableArray *res = [[NSMutableArray alloc] init] ;
    if ([annotations count] > 0) {
        [res addObjectsFromArray:annotations];
        CLLocation* centerLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
        [res sortUsingFunction:compareDistance context:objc_unretainedPointer(centerLocation)];
        
        
    }
    return res;
}

+(MKCoordinateRegion)createRegionFittingFirst:(int)num annotations:(NSArray*)annotations withCenter:(CLLocationCoordinate2D)center {
    MKCoordinateRegion region;
    int maxCount2 = fmin(num, [annotations count]);
    CLLocationDegrees minLat = +90;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees minLong = +180;
    CLLocationDegrees maxLong = -180;
    for (int i = 0; i < maxCount2; i++) {
        id<MKAnnotation> myMapItem = (id<MKAnnotation>)[annotations objectAtIndex:i];
        minLat = fmin(minLat, myMapItem.coordinate.latitude);
        maxLat = fmax(maxLat, myMapItem.coordinate.latitude);
        minLong = fmin(minLong, myMapItem.coordinate.longitude);
        maxLong = fmax(maxLong, myMapItem.coordinate.longitude);
    }
    
    region.center.latitude = center.latitude;
    region.center.longitude = center.longitude;
    region.span.latitudeDelta = (maxLat-minLat)*1.5;
    region.span.longitudeDelta = (maxLong -minLong)*1.5;
    return region;
}


@end
