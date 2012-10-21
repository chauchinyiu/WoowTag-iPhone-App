//
//  ResultListMapVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Product.h"
#import "AddressAnnotation.h"
@interface ResultListMapVC : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
    UIViewController     *_managingViewController;
    MKMapView *_mapView;
    NSMutableArray *_annotationList;
    NSMutableArray *_products;   
    CLLocationManager *_locationManager;
    BOOL isZoom;
}
@property (nonatomic, retain) NSMutableArray *annotationList;
@property (nonatomic, retain) UIViewController   * managingViewController;
@property (nonatomic, retain) NSMutableArray *products; 
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (id)initWithParentViewController:(UIViewController *)aViewController ;
@end
