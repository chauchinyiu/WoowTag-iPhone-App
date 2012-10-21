//
//  SearchVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/7/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ResultVC.h"
@interface SearchVC : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate> {
	// view components
    
 
	UITextField				*_txtfldLocation;
    UITextField				*_txtfldKeyword;
	UIButton				*_btnResults;
	UISlider				*_sliderDistance;
	UILabel					*_lblDistance;
    
  
	ResultVC  *_resultVC;
 
    CLLocationManager *_locationManager; // location manager for current location
    CLLocationCoordinate2D _currentUserCoordinate; // used to store the users selection
    
    
    
}

@property(nonatomic,retain) IBOutlet UITextField	*txtfldLocation;
@property(nonatomic,retain) IBOutlet UITextField	*txtfldKeyword;
@property(nonatomic,retain) IBOutlet UIButton		*btnResults;
@property(nonatomic,retain) IBOutlet UISlider		*sliderDistance;
@property(nonatomic,retain) IBOutlet UILabel		*lblDistance;
@property(nonatomic,retain) ResultVC *resultVC;

 
@property(nonatomic, assign) CLLocationCoordinate2D currentUserCoordinate;
 

-(IBAction)showResult:(id)sender;
-(IBAction)distanceSliderValueChanged:(id)sender;
-(IBAction)getCurrentLocation:(id)sender;
 
 

@end
