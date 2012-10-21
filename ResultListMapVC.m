//
//  ResultListMapVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "ResultListMapVC.h"
#import "UIImageView+AFNetworking.h"
#import "LocationCalculationHelper.h"
#import "WoowtagButton.h"
#import "ProductDetailVC.h"
@interface ResultListMapVC()
-(AddressAnnotation *) createMapAnnotationFromProduct:(Product *) product;
-(void) gotoDetailVC:(id) sender;
-(void) zoomMap;
-(void) getCurrentLocation:(id)sender;
-(void) gotoGridView; 
@end
@implementation ResultListMapVC
@synthesize managingViewController=_managingViewController;
@synthesize mapView =_mapView;
@synthesize products= _products;
@synthesize locationManager = _locationManager;
@synthesize annotationList = _annotationList;
- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"ResultListMapVC" bundle:nil]) {
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
    // Do any additional setup after loading the view from its nib.
    isZoom = NO;
    
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

- (void)viewWillAppear:(BOOL)animated{
    
    if(self.products!=nil && [self.products count]>0){
        for(int i=0;i<[self.products count] ; i++){
            AddressAnnotation *pin = [self createMapAnnotationFromProduct:[self.products objectAtIndex:i]];
            [self.mapView addAnnotation:pin];
            
        }
        
        [self zoomMap];
    }
    
    

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

// zom map tp closest 10 annotations
-(void)zoomMap{
    
    
    if(isZoom) 
        return;
    
    MKCoordinateRegion region;
    
    if([self.mapView.annotations count] == 0){
        // the default region, if no annotations are existing:
        region.center.latitude = 0;
        region.center.longitude = 0;
        region.span.latitudeDelta = 160;
        region.span.longitudeDelta = 225;
    } else {
        // calculate the region:
        // 1st the center opf all annotations
        CLLocationCoordinate2D center = [LocationCalculationHelper getCenterOfAnnotations:self.mapView.annotations];
        NSMutableArray *sorted = nil;
        // 2nd sort all annotations by their distance to the center
        if ([self.mapView.annotations count] > 10) {
            sorted = [LocationCalculationHelper sortedAnnotations:self.mapView.annotations byDistanceTo:center];
        } else {
            sorted = [NSMutableArray arrayWithArray:self.mapView.annotations];
        }
        
        //2b remove user location from sorted items
        for(id<MKAnnotation> myMapItem in sorted) {
            if ([myMapItem isKindOfClass:[MKUserLocation class]]) {
                [sorted removeObject:myMapItem];
                break;
            }
        }
        
        // 3rd create a region, that fits the first 10 annotations of the sorted list
        region = [LocationCalculationHelper createRegionFittingFirst:10 annotations:sorted withCenter:center];
        // add a little bit more space for the annoations at the border
        if ([self.mapView.annotations count] <= 10) {
            region.span.longitudeDelta = region.span.longitudeDelta*1.1;
        }
    }
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
    isZoom = YES;
}    

 

-(AddressAnnotation *) createMapAnnotationFromProduct:(Product *) item{
    CLLocationCoordinate2D location;
    NSLog(@"Lat ::: %@ Lng ::: %@",item.store.longitude ,item.store.latitude);
    
    location.latitude = [item.store.latitude doubleValue]; 
    location.longitude = [item.store.longitude doubleValue]; 
    
    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    addAnnotation.mTitle = item.name;
    addAnnotation.mImageUrl = [item.imagelinks objectAtIndex:0];
    addAnnotation.mSubTitle = [NSString stringWithFormat:@"$ %@ , %@ Stocks",item.price, item.stock];
    addAnnotation.product = item;
    
    return addAnnotation;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{   
     MKPinAnnotationView *annView;
    if([annotation isKindOfClass:[AddressAnnotation class]]){
         annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"productlocation"];
        //    annView.pinColor = MKPinAnnotationColorGreen;
        annView.image = [UIImage imageNamed:@"woow_location.png"];
        annView.animatesDrop=NO;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        NSString *img = ((AddressAnnotation *)annotation).mImageUrl;
        Product *obj = ((AddressAnnotation *)annotation).product;
        if(obj!=nil){
            
            UIImageView* imgview=    [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 30, 30)] ;
            imgview.contentMode = UIViewContentModeScaleAspectFit;
            [imgview setImageWithURL:[NSURL URLWithString:img]];
            annView.leftCalloutAccessoryView = imgview;
            WoowtagButton* button = [[WoowtagButton alloc] init];
            [button setImage:[UIImage imageNamed:@"btnDetail.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btnDetail_high.png"] forState:UIControlStateHighlighted];
            button.frame = CGRectMake(0, 0, 30, 30);
            [button addTarget:self action:@selector(gotoDetailVC:) forControlEvents:UIControlEventTouchDown];
            button.carriedProduct = obj;
            annView.rightCalloutAccessoryView = button;        
        }
    }else if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    return annView;
    
}

-(void) gotoDetailVC:(id) sender{
    Product *product = ((Product *)((WoowtagButton *)sender).carriedProduct); 
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithNibName:@"ProductDetailVC" bundle:nil];
    detailVC.product = product; 
    [self.managingViewController.navigationController pushViewController:detailVC animated:YES];
    
}

-(void) gotoGridView{
    [AppDelegate showGridView]  ;

}

-(void)  getCurrentLocation:(id)sender{
     self.mapView.showsUserLocation=YES ;
}

@end
