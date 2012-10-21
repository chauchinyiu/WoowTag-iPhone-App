//
//  GridVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/7/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "GridVC.h"
#import "WoowTagContstant.h"
#import "SearchVC.h"
#import "FavoriteProductListVC.h"
#import "FavoriteStoreListVC.h"
#import <QuartzCore/QuartzCore.h>
@interface GridVC() 
-(void) relocateThumbnailScrollView:(CGPoint) location;
-(void)retrieveLastSearch;
-(void) showLastSearchScollView;
@end
@implementation GridVC
@synthesize lastSearchScrollView =_lastSearchScrollView;
@synthesize lastSearchProducts = _lastSearchProducts;
@synthesize bookmarkImageView =_bookmarkImageView;
@synthesize searchBtn,favStoreBtn,favProductBtn, infoBtn ;
@synthesize slogan,searchLbl,favProductsLbl,favStoresLbl, infoLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    [self setupLastSearchScrollView];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_button_press.png"] forState:UIControlStateHighlighted];
    [favProductBtn setBackgroundImage:[UIImage imageNamed:@"favorite_product_press.png"] forState:UIControlStateHighlighted];
    [favStoreBtn setBackgroundImage:[UIImage imageNamed:@"favorite_store_press.png"] forState:UIControlStateHighlighted];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"about_us_press.png"] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}
-(void) setupLastSearchScrollView{

    self.lastSearchScrollView = [[ThumbnailScrollView alloc] init];
    // maximum is 300 in y axis
    CGRect newFrame = CGRectMake(0, 420, self.lastSearchScrollView.frame.size.width, self.lastSearchScrollView.frame.size.height);
    self.lastSearchScrollView.frame = newFrame;
    self.lastSearchScrollView.delegate = self;
    [self.view addSubview:self.lastSearchScrollView];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	
	// Only move the placard view if the touch was in the placard view
	if ([[touch view] tag]== GRID_LASTSEARCH_SCROLLVIEW) {
		// In case of a double tap outside the placard view, update the placard's display string
        return;
	}
	// Animate the first touch
	CGPoint touchPoint = [touch locationInView:self.view];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, move the placardView to its location
    if ([[touch view] tag]==GRID_LASTSEARCH_SCROLLVIEW)  {
		CGPoint location = [touch locationInView:self.view];
        NSLog(@" x: %f y: %f",location.x,location.y);
        [self relocateThumbnailScrollView:location];
        return;
	}
}

-(void) relocateThumbnailScrollView:(CGPoint) location{
    if((location.y > 300)&&(location.y <420)){
        CGRect oldFrame = self.lastSearchScrollView.frame;
        CGFloat newX = 0; // + oldFrame.size.width / 2.0;
        CGFloat newY = location.y; // + oldFrame.size.height / 2.0;
        
        CGRect newFrame = CGRectMake(newX, newY, oldFrame.size.width, oldFrame.size.height);
        
        self.lastSearchScrollView.frame = newFrame;
        
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
- (void) viewWillAppear:(BOOL)animated
{  
    [self retrieveLastSearch];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
-(void)retrieveLastSearch{
    
	NSDictionary *lastsearchparameter = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LASTSEARCH_KEY];
    
    if([lastsearchparameter count]>0){
        [ProductList callListWebService:@"product_search" withParameter: lastsearchparameter WithBlock:^(ProductList *productlist) {
            if (productlist) {
                NSLog(@"Products == %@", productlist);
                NSDate *latestsearchdate = [[NSUserDefaults standardUserDefaults] objectForKey:LASTSEARCH_DATE];
                NSString *dateString = [NSDateFormatter localizedStringFromDate:latestsearchdate
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterMediumStyle];
                [self.lastSearchScrollView.titlelabel setText:[NSString stringWithFormat:@"%@ : %@",LASTSEARCH_TITLE ,dateString]];

                self.lastSearchProducts = productlist.products;
                [self.lastSearchScrollView setProductsImage:productlist.products];
                [self showLastSearchScollView];
                
            }
            
        }];
    } 
    
}

#pragma mark -
#pragma mark actions

- (IBAction)btnPressGridButton:(id)sender {
    
    switch ([sender tag]) {
            
        case GRID_BTN_SEARCH:{
            
            SearchVC *searchvc = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
            [self.navigationController pushViewController:searchvc animated:YES];
        }
            break;
        case GRID_BTN_FAV_PRODUCT:{
    
            FavoriteProductListVC *favlistVC = [[FavoriteProductListVC alloc] initWithNibName:@"FavoriteProductListVC" bundle:nil];
            [self.navigationController pushViewController:favlistVC animated:YES];
        }
            break;     
        case GRID_BTN_FAV_STORE:{

            FavoriteStoreListVC *favStoreListVC = [[FavoriteStoreListVC alloc] initWithNibName:@"FavoriteStoreListVC" bundle:nil];
            [self.navigationController pushViewController:favStoreListVC animated:YES];
        }
            break;       
            
        case GRID_BTN_INFO:{
            
            FavoriteStoreListVC *favStoreListVC = [[FavoriteStoreListVC alloc] initWithNibName:@"FavoriteStoreListVC" bundle:nil];
            NSLog(@"%@",self.navigationController);
            [self.navigationController presentModalViewController:favStoreListVC animated:YES];
        }
            break; 
        default:
            break;
    }
}

-(void) showLastSearchScollView{
    CGRect viewFrame = self.lastSearchScrollView.frame;
    viewFrame.origin.y = 300;
    
    [UIView animateWithDuration:1
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.lastSearchScrollView.frame = viewFrame;
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}
-(void)imageClickedAtView:(id)sender{
    UITapGestureRecognizer *tap = sender;
    
    int index =tap.view.tag -1 ;
    NSLog(@"Product %@ : ", [self.lastSearchProducts objectAtIndex: index]  );
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithNibName:@"ProductDetailVC" bundle:nil];
    detailVC.product = [self.lastSearchProducts objectAtIndex: index] ;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)imageSelectedAtView:(id)sender{
    
}

@end
