//
//  DetailMapVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "DetailMapVC.h"
#import "UIImageView+AFNetworking.h"
@interface DetailMapVC()
- (void) showAddress:(CLLocationCoordinate2D) loc  ;
-(void) gotoGridView;
-(void) getCurrentLocation:(id) sender;
@end
@implementation DetailMapVC
@synthesize managingViewController=_managingViewController;
@synthesize product=_product;
@synthesize mapView =_mapView;
- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"DetailMapVC" bundle:nil]) {
        self.managingViewController = aViewController;
        self.title = @"Map";
    }
    return self;
}

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

    CLLocationCoordinate2D location;
    NSLog(@"Lat ::: %@ Lng ::: %@",self.product.store.longitude , self.product.store.latitude);
    
    location.latitude = [self.product.store.latitude doubleValue]; 
    location.longitude = [self.product.store.longitude doubleValue]; 
    [self showAddress:location];
}

- (void) showAddress:(CLLocationCoordinate2D) loc   {
    //Hide the keypad
   
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.002;
    span.longitudeDelta=0.002;
    
    CLLocationCoordinate2D location = loc;
    region.span=span;
    region.center=location;
    if(addAnnotation != nil) {
        [self.mapView removeAnnotation:addAnnotation];
        addAnnotation = nil;
    }
    
    if(self.product.imagelinks!=nil && [self.product.imagelinks count]>0){
        _imagethumbnailurl = [self.product.imagelinks objectAtIndex:0];
    }else{
        _imagethumbnailurl =nil;
    }
     
    addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    addAnnotation.mTitle = self.product.name;
    addAnnotation.mSubTitle = [NSString stringWithFormat:@"$ %@ , %@ Stocks",self.product.price, self.product.stock];
    
    [self.mapView addAnnotation:addAnnotation];
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
}
-(void)viewWillAppear:(BOOL)animated{
//    UIBarButtonItem *locatebtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"193-location-arrow.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(getCurrentLocation:)];
//    self.managingViewController.navigationItem.rightBarButtonItem = locatebtn;
    
    UIView *toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70 , 44)];
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 30,30)];
    [sortBtn setImage:[UIImage imageNamed:@"location_button.png"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(getCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:sortBtn];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 7, 30,30)];
    [mapBtn setImage:[UIImage imageNamed:@"grid_button.png"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(gotoGridView) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:mapBtn];
    
    UIBarButtonItem *customBarButtomItem  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    self.managingViewController.navigationItem.rightBarButtonItem =  customBarButtomItem;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) getCurrentLocation:(id) sender{
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}


-(void) gotoGridView{
    [AppDelegate showGridView]  ;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"productloc"];
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    annView.image = [UIImage imageNamed:@"map_marker.png"];
    if(_imagethumbnailurl!=nil){
       // UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imagethumbnailurl]]];
         UIImageView* imgview=    [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 30, 30)] ;
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        [imgview setImageWithURL:[NSURL URLWithString:_imagethumbnailurl]];
        annView.leftCalloutAccessoryView = imgview;
        
    }
    return annView;
}

 
 

@end
