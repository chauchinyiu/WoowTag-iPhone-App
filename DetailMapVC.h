//
//  DetailMapVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Product.h"
#import "AddressAnnotation.h"
@interface DetailMapVC : UIViewController <MKMapViewDelegate> {
    UIViewController     *_managingViewController;
    Product *_product;
    MKMapView *_mapView;
    AddressAnnotation *addAnnotation;
    NSString *_imagethumbnailurl;
    
}
@property (nonatomic, retain)  Product *product;
@property (nonatomic, retain) UIViewController   * managingViewController;
@property (nonatomic, retain)  IBOutlet MKMapView *mapView;
- (id)initWithParentViewController:(UIViewController *)aViewController ;
@end
