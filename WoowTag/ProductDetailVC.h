//
//  ProductDetailVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/9/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoowTagContstant.h"
#import "Product.h"
#import "UIImageView+AFNetworking.h"
#import "NSArray+PerformSelector.h"
#import "NSManagedObject+Management.h"
#import "MBProgressHUD.h"


@interface ProductDetailVC : UIViewController <UIApplicationDelegate , UINavigationControllerDelegate, MBProgressHUDDelegate>{

    Product *_product;
    NSManagedObjectContext *_managedObjectContext; 
    UISegmentedControl *_segmentedControl;
}
@property (nonatomic, retain) Product  *product ;
 
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext; 
// new 
@property (nonatomic, retain) IBOutlet  UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIViewController  * activeViewController;
@property (nonatomic, retain ) NSArray    * segmentedViewControllers;

-(void)getProductFromWebService:(NSString *) productid;
-(void) saveProduct;
-(void) showMapView; 

@end
