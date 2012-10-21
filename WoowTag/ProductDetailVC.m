//
//  ProductDetailVC.m
//  WoowTag
//  Created by Chau Chin Yiu on 6/9/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "ProductDetailVC.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "DetailListVC.h"
#import "DetailMapVC.h"
#import "SaveProduct.h"


@interface ProductDetailVC()
- (void) didChangeSegmentControl:(UISegmentedControl *)control;
- (NSArray *)segmentedViewControllerContent;
 
- (void)showWithCustomView:(NSString*) labeltext;
@end

@implementation ProductDetailVC 
@synthesize product=_product;
@synthesize segmentedControl =_segmentedControl;
@synthesize activeViewController=_activeViewController;
@synthesize segmentedViewControllers = _segmentedViewControllers;
@synthesize managedObjectContext = _managedObjectContext;
 
#define IMAGE_WIDTH       260
#define IMAGE_HEIGHT      198
#define IMAGE_SPACING     10
#define IMAGE_PADDING     35

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

    self.segmentedViewControllers = [self segmentedViewControllerContent];
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    NSArray * segmentTitles = [self.segmentedViewControllers arrayByPerformingSelector:@selector(title)];
    self.navigationItem.title = @"Product";

    [self.segmentedControl setTitle:[segmentTitles objectAtIndex:0] forSegmentAtIndex:0];
    [self.segmentedControl setTitle:[segmentTitles objectAtIndex:1] forSegmentAtIndex:1];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(didChangeSegmentControl:)
                    forControlEvents:UIControlEventValueChanged];
    [self didChangeSegmentControl:self.segmentedControl]; 
    
    
}

-(void) showMapView{
    self.segmentedControl.selectedSegmentIndex =1;
    [self didChangeSegmentControl:self.segmentedControl]; 
}
- (void)didChangeSegmentControl:(UISegmentedControl *)control {
    if (self.activeViewController) {
        [self.activeViewController viewWillDisappear:NO];
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController viewDidDisappear:NO];
    }
    
    self.activeViewController = [self.segmentedViewControllers objectAtIndex:control.selectedSegmentIndex];
    
    [self.activeViewController viewWillAppear:NO];
    [self.view addSubview:self.activeViewController.view];
    [self.activeViewController viewDidAppear:NO];
    
    NSString * segmentTitle = [control titleForSegmentAtIndex:control.selectedSegmentIndex];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:segmentTitle style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (NSArray *)segmentedViewControllerContent {
    
    DetailListVC * controller1 = [[DetailListVC alloc] initWithParentViewController:self];
    DetailMapVC * controller2 = [[DetailMapVC alloc] initWithParentViewController:self];
    controller1.product =self.product;
    controller1.view.frame = CGRectMake(0, 30, 320, 430);
    controller2.product =self.product;
    controller2.view.frame = CGRectMake(0, 30, 320, 430);
    NSArray * controllers = [NSArray arrayWithObjects:controller1, controller2, nil];
    
    
    
    return controllers;
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

-(void) saveProduct{
    SaveProduct *prod= [NSManagedObject getSaveProductByProductID:[NSString stringWithFormat:@"%@",self.product.productId] withManagedObjectContext:self.managedObjectContext];
    
    if(prod != nil){
        NSLog(@"Save product %@ ",prod.product_description);
        [self showWithCustomView:@"Product is saved"];
        return;
    }else{
        
        // Create and configure a new instance of the Event entity.
        SaveProduct *saveproduct = (SaveProduct *)[NSEntityDescription insertNewObjectForEntityForName:@"SaveProduct"  inManagedObjectContext:self.managedObjectContext];
        
        [saveproduct setName:self.product.name];
        [saveproduct setProductid:[NSString stringWithFormat:@"%@",self.product.productId]];
        [saveproduct setStock:self.product.stock];
        [saveproduct setPrice:self.product.price];
        [saveproduct setProduct_description:self.product.description];
        [saveproduct setStoreid:[NSString stringWithFormat:@"%@",self.product.store.storeId]];
        [saveproduct setRate:self.product.rate];
        [saveproduct setStorename: self.product.store.name];
        [saveproduct setAddress: self.product.store.address];
        
        [saveproduct setImagelinks:self.product.imagelinks];
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        } 
        [self showWithCustomView:@"Completed !"];
        
    }
    
}

- (void)showWithCustomView:(NSString*) labeltext{
	
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText =labeltext;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

-(void)getProductFromWebService:(NSString *) productid{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = @"Loading";
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObject:productid forKey:@"id"];
    [Product callDetailWebService:@"product" withParameter: parameter  WithBlock:^( Product *prod) {
        if (prod) {
            _product = prod;
            [self viewDidLoad];
        } 
         [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}




@end
