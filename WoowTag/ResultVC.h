//
//  ResultVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/4/12.
//  Copyright (c) 2012 WoowTag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductResultTableViewCell.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ResultProductTableListVC.h"
#import "ResultStoreTableListVC.h"
#import "ResultListMapVC.h"
#import "MBProgressHUD.h"
#import "WoowTagContstant.h"
#import "SCValuePicker.h"
#import "ProductList.h"

@interface ResultVC : UIViewController <UIApplicationDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,SCPickerDelegate>{

    NSArray *_products;
    NSMutableDictionary *_parameters;
    UISegmentedControl *_segmentedControl;
    ResultProductTableListVC * _productTableListVC ;
    ResultStoreTableListVC * _storeTableListVC ;
    ResultListMapVC * _mapListVC ; 
    SCValuePicker *_sortPicker;
    NSString *_sortKey;
    NSString *_sortAscending;
    
}
@property (nonatomic, retain) IBOutlet  UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIViewController  * activeViewController;
@property (nonatomic, retain ) NSArray    * segmentedViewControllers;
 

@property (nonatomic, retain) NSArray  *products;
@property (nonatomic, retain) NSMutableDictionary *parameters;
-(void)performSearch;
-(void) loadMoreData:(int) pageNumber;
@end