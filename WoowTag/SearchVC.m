//
//  SearchVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/7/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "SearchVC.h"
#import "WoowTagContstant.h"
#import <AddressBookUI/AddressBookUI.h>

@interface SearchVC () 

// current location
- (void)startUpdatingCurrentLocation;
- (void)stopUpdatingCurrentLocation;
- (void)displayError:(NSError*)error;
  
@end


@implementation SearchVC
@synthesize txtfldKeyword = _txtfldKeyword;
@synthesize txtfldLocation = _txtfldLocation;
@synthesize btnResults = _btnResults;
@synthesize sliderDistance = _sliderDistance;
@synthesize lblDistance = _lblDistance;
@synthesize resultVC = _resultVC;
 
@synthesize currentUserCoordinate = _currentUserCoordinate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startUpdatingCurrentLocation];
    _currentUserCoordinate = kCLLocationCoordinate2DInvalid;
    [self.txtfldLocation setText:@"Tsim Sha Tsui, Hong Kong"];
    
    //    548cd2
    //    2a5ea0
    
    if(self.txtfldLocation.text != nil  && self.txtfldLocation.text.length >0 ){
        self.btnResults.enabled = YES;
    } else{
        self.btnResults.enabled = NO;
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Function only here
-(IBAction)showResult:(id)sender {
	int distance =  round(self.sliderDistance.value) ;
    NSString *querystring = [NSString stringWithFormat:@"name=%@&location=%@&distance=%d",self.txtfldKeyword.text, self.txtfldLocation.text,distance];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObject:self.txtfldKeyword.text forKey:@"name"];
    [parameter setObject: self.txtfldLocation.text forKey:@"location"];
    [parameter setObject:[NSString stringWithFormat:@"%d",distance]  forKey:@"distance"];
    
    [parameter setValue:[NSString stringWithFormat:@"%d",RESULTSNUMBER_PER_PAGE] forKey:@"results_per_page"];
        [parameter setValue:[NSString stringWithFormat:@"%d",RESULTS_FIRSTPAGE] forKey:@"current_page"];
    
    NSLog(@"This is query string ==  %@ ",querystring);
    
    ResultVC *resultVC = [[ResultVC alloc] initWithNibName:@"ResultVC" bundle:nil];
    resultVC.parameters =  parameter;
    [self.navigationController pushViewController:resultVC animated:YES];
 
     [resultVC performSearch];
     
    
    
}
-(IBAction)distanceSliderValueChanged:(id)sender {
	int distance = round(self.sliderDistance.value);
	// update display label
	self.lblDistance.text = [NSString stringWithFormat:@"%d km", distance];
	 
}
 

 
-(IBAction)getCurrentLocation:(id)sender{
    CLGeocoder *geocoder =[[CLGeocoder alloc] init];
    
    CLLocationCoordinate2D coord = _currentUserCoordinate;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude] ;
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        if((placemarks!=nil) &&([placemarks count]>0 )){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];  
            NSString *addressString =[NSString stringWithFormat:@"%@, %@, %@",(placemark.thoroughfare)?placemark.thoroughfare:@"",(placemark.locality)?placemark.locality:@"",(placemark.country)?placemark.country:@""];
            self.txtfldLocation.text=addressString;
        }
    }];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField.tag==SEARCH_TEXTFIELD_LOCATION){
        if(textField.text.length>0){
            self.btnResults.enabled = YES;
        }else{
            self.btnResults.enabled = NO;
        }
    }
    return YES; 
}

// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled: message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default: message = [error description];
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                          message:message
                                                         delegate:nil 
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] ;
        [alert show];
    });   
}

#pragma mark - CLLocationManagerDelegate

- (void)startUpdatingCurrentLocation
{
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || 
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        return;
    }
    
    // if locationManager does not currently exist, create it
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 10.0f; // we don't need to be any more accurate than 10m
        _locationManager.purpose = @"This may be used to obtain your reverse geocoded address";
    }
    
    [_locationManager startUpdatingLocation];
    
    
}

- (void)stopUpdatingCurrentLocation
{
    [_locationManager stopUpdatingLocation];
    
    //    [self showCurrentLocationSpinner:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{		
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        return;
    }
    
    _currentUserCoordinate = [newLocation coordinate];
    
    // after recieving a location, stop updating
    [self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    // stop updating
    [self stopUpdatingCurrentLocation];
    
    // since we got an error, set selected location to invalid location
    _currentUserCoordinate = kCLLocationCoordinate2DInvalid;
    
    // show the error alert
    UIAlertView *alert = [[UIAlertView alloc] init] ;
    alert.title = @"Error updating location";
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}


@end
