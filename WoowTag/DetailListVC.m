//
//  DetailVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "DetailListVC.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "DYRateView.h"
#import "StoreInfoVC.h"


@interface DetailListVC()
- (void)layoutScrollImages;
-(void) resizeUILabel:(UILabel*) label withString:(NSString*) string ;
-(void) handleTap ;
- (void) saveProduct;
-(void) goToImageGallery;
- (void) setUpRateView ;
- (void)onCall;
-(void) gotoGridView;
@end
@implementation DetailListVC
@synthesize selectedImageIndex = _selectedImageIndex;
@synthesize bigImageLinks =_bigImageLinks;
@synthesize product=_product;
@synthesize previewScrollView=_previewScrollView;
@synthesize pageControl=_pageControl;
@synthesize mainScrollView=_mainScrollView; 
@synthesize productTitle = _productTitle;
@synthesize price = _price;

@synthesize managingViewController=_managingViewController;
@synthesize tableView = _tableView;
@synthesize tableViewCell = _tableViewCell;
#define IMAGE_WIDTH        260
#define IMAGE_HEIGHT       198
#define IMAGE_SPACING       10
#define IMAGE_PADDING     35

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"DetailListVC" bundle:nil]) {
        self.managingViewController = aViewController;
        
        self.title = @"Detail";
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
    [super viewDidLoad];
    self.selectedImageIndex =0;
    
    [_mainScrollView setContentSize:CGSizeMake(320, 700)];
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.tag= DETAIL_MAIN_SCROLLVIEW;
	_previewScrollView.clipsToBounds = YES;		
	_previewScrollView.scrollEnabled = YES;
    _previewScrollView.tag= DETAIL_IMAGE_OVERVIEW_SCROLLVIEW;
    [_previewScrollView setShowsHorizontalScrollIndicator:NO];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self setUpRateView];
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [_previewScrollView addGestureRecognizer:singleTap];
    [_previewScrollView addGestureRecognizer:doubleTap];
	[_previewScrollView addGestureRecognizer:twoFingerTap];
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	_previewScrollView.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
    int counts = [self.product.imagelinks count];
    _pageControl.numberOfPages = counts;
    _pageControl.currentPage = 0;
    if(counts >0){
        self.bigImageLinks = [NSMutableArray array];
        
        for (int i = 0; i <counts  ; i++)
        {
            
            NSString *urlstring= [self.product.imagelinks objectAtIndex:i];
            
            if(urlstring !=nil ){
                UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH ,IMAGE_HEIGHT )];
                
                [[frameView layer] setBorderColor:[[UIColor blackColor] CGColor]];
                [[frameView layer] setBorderWidth: 1.0];
                [[frameView layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, IMAGE_WIDTH-10, IMAGE_HEIGHT-10) ];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.bigImageLinks addObject:[MWPhoto photoWithURL:[NSURL URLWithString: [urlstring stringByReplacingOccurrencesOfString:@"/thumb/" withString:@"/original/"]]]]; 
                urlstring= [urlstring stringByReplacingOccurrencesOfString:@"/thumb/" withString:@"/medium/"];  
                
                NSURL *url = [NSURL URLWithString:urlstring];
                [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"product_preview"]];
                
                frameView.tag = i+1;
                [frameView addSubview:imageView];
                [_previewScrollView addSubview:frameView];
            }
            
            // now place the photos in serial layout within the scrollview
        }
    }else{
        UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH ,IMAGE_HEIGHT )];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, IMAGE_WIDTH-10, IMAGE_HEIGHT-10) ];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"product_preview"]];
        [[frameView layer] setBorderColor:[[UIColor blackColor] CGColor]];
        [[frameView layer] setBorderWidth: 1.0];
        [[frameView layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
        frameView.tag = 1;
        [frameView addSubview:imageView];
        [_previewScrollView addSubview:frameView];
    }
    [self layoutScrollImages];
    [self.productTitle setText:self.product.name];
    [self.price setText:[NSString stringWithFormat:@"$ %@",self.product.price]];
    //    [self.inStock setText:[NSString stringWithFormat:@"%@ stocks", self.product.stock]];
    
    
}

- (void) setUpRateView {
    DYRateView *rateView =  [[DYRateView alloc] initWithFrame:CGRectMake(10, 280, 160, 14)]   ;
    rateView.rate = [self.product.rate floatValue];
    rateView.alignment = RateViewAlignmentLeft;
    [_mainScrollView addSubview:rateView];
}

-(void) resizeUILabel:(UILabel*) label withString:(NSString*) string {
    CGRect currentFrame = label.frame;
    CGSize max = CGSizeMake(label.frame.size.width, 500);
    CGSize expected = [string sizeWithFont:label.font constrainedToSize:max lineBreakMode:label.lineBreakMode]; 
    currentFrame.size.height = expected.height;
    label.frame = currentFrame;
}



 

- (void)viewWillAppear:(BOOL)animated{
    UIView *toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70 , 44)];
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 30,30)];
    [sortBtn setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(saveProduct) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:sortBtn];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 7, 30,30)];
    [mapBtn setImage:[UIImage imageNamed:@"grid_button.png"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(gotoGridView) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:mapBtn];
    
    UIBarButtonItem *customBarButtomItem  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    self.managingViewController.navigationItem.rightBarButtonItem =  customBarButtomItem;
}

-(void) gotoGridView{
     [AppDelegate showGridView]  ;
  }

-(void) saveProduct{
    [((ProductDetailVC *) self.managingViewController) saveProduct]  ;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)layoutScrollImages
{
	UIView *view = nil;
	NSArray *subviews = [_previewScrollView subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = IMAGE_PADDING;
    int count = [subviews count];
    int imageindex = 0;
	for (int i=0 ; i<count  ; i++)
	{   view =  [subviews objectAtIndex:i];
		if ([view isKindOfClass:[UIView class]]&& (view.tag > 0) )
		{   CGRect frame = view.frame;
            
            if(imageindex==0){
                frame.origin = CGPointMake(curXLoc, 15);
                view.frame = frame;
                curXLoc += (IMAGE_WIDTH);
            }else{
                curXLoc+= IMAGE_SPACING;
                frame.origin = CGPointMake(curXLoc, 15);
                view.frame = frame;
                curXLoc += (IMAGE_WIDTH);
            }
            imageindex++;
		}
	}
	
    
    
    [_previewScrollView setContentSize:CGSizeMake(([self.product.imagelinks count]  * IMAGE_WIDTH)+(([self.product.imagelinks count]-1)*IMAGE_SPACING)+ IMAGE_PADDING *2, IMAGE_HEIGHT+10 )];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    int indexNextImageVisible = (scrollView.contentOffset.x - IMAGE_PADDING_LEFT  + self.previewScrollView.frame.size.width) / (IMAGE_WIDTH + IMAGE_SPACING);
    //    int indexPrevImageVisible = (scrollView.contentOffset.x - IMAGE_PADDING_LEFT) / (IMAGE_WIDTH + IMAGE_SPACING);
    if(scrollView.tag==DETAIL_MAIN_SCROLLVIEW){
        return;
    }
    
    int selectedImageIdx = (scrollView.contentOffset.x - IMAGE_PADDING   +  self.previewScrollView.frame.size.width + IMAGE_WIDTH / 2) / (IMAGE_WIDTH + IMAGE_SPACING) - 1;
    if(self.selectedImageIndex != selectedImageIdx && selectedImageIdx < [self.product.imagelinks count]){
        self.selectedImageIndex = selectedImageIdx;
    }
    
    NSLog(@"Scroll contentoffset x %f  ::::: Image index %d",scrollView.contentOffset.x , self.selectedImageIndex);
    
}
// TODO go to image gallery
-(void)handleTap{
    NSLog(@"Scroll position tag  %d", self.selectedImageIndex);
    [self goToImageGallery];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView.tag==DETAIL_MAIN_SCROLLVIEW){
        return;
    }
    [self.previewScrollView scrollRectToVisible:CGRectMake((IMAGE_WIDTH + IMAGE_SPACING) * self.selectedImageIndex, 0, self.previewScrollView.frame.size.width, IMAGE_HEIGHT) animated:YES];
    _pageControl.currentPage = self.selectedImageIndex;
}


-(void) goToImageGallery{
    // Create & present browser
    if(self.bigImageLinks != nil && [self.bigImageLinks count]>0){
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        // Set options
        browser.wantsFullScreenLayout = YES; // Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
        browser.displayActionButton = YES; // Show action button to save, copy or email photos (defaults to NO)
        [browser setInitialPageIndex:1]; // Example: allows second image to be presented first
        // Present
        [self.managingViewController.navigationController pushViewController:browser animated:YES];
    }
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.bigImageLinks.count;
    
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.bigImageLinks.count)
        return [self.bigImageLinks objectAtIndex:index];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSString *temptext; 
    switch (indexPath.row) {
        case 0:
            
            temptext = self.product.store.name ;
            break;
        case 1:
            temptext =  self.product.store.phone ;
            break;
        case 2: 
            temptext =  self.product.store.address ;
            break;
        case 3:
            temptext = [WoowTagToolKit convertStringArrayToString:self.product.tags] ;
            
            break;
        case 4:
            temptext = [NSString stringWithFormat:@"%@ in stock", self.product.stock] ;
            break; 
        case 5:
            temptext = self.product.description ;
            break;
        default:
            temptext= @"";
            break;
 

    }
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    CGSize size = [temptext sizeWithFont:font 
                       constrainedToSize:CGSizeMake(230, 1000)
                           lineBreakMode:UILineBreakModeWordWrap]; // default mode
    float numberOfLines = size.height / font.lineHeight;
    if(numberOfLines>1){
        return 20+  21* numberOfLines   ;
    }else{
        return 35;
    } 
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DetailTableViewCell";
    
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
    }

    switch (indexPath.row) {
        case 0:
            
            [cell setDetailInfo:@"store.png"  withLabel:self.product.store.name];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        case 1:
            
            [cell setDetailInfo:@"phone.png" withLabel:self.product.store.phone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        case 2: 
            [cell setDetailInfo:@"address.png"  withLabel:self.product.store.address];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            break;
        case 3:
           
      
            [cell setDetailInfo:@"tag.png" withLabel:[NSString stringWithFormat:@"%@",
                                                      [WoowTagToolKit convertStringArrayToString:self.product.tags]]];
                  
              break;
        case 4:
            
            [cell setDetailInfo:@"stock.png"  withLabel:[NSString stringWithFormat:@"%@ in stock", self.product.stock]];
            break; 
            
        case 5:
            [cell setDetailInfo:@"description.png" withLabel:self.product.description];
            break;
        default:
            break;


    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreInfoVC *storeVC =nil; 
    
    switch (indexPath.row) {
        case 0:
            storeVC =[[StoreInfoVC alloc] initWithNibName:@"StoreInfoVC" bundle:nil]; 
            if([AppDelegate connectedToNetwork])
                [storeVC getStoreFromWebService:self.product.store.storeId];
            else
                storeVC.store = self.product.store;
            [self.managingViewController.navigationController pushViewController:storeVC animated:YES];
            break;
        case 1:
//            [cell setDetailInfo:@"pricetag.png" withLabel:[NSString stringWithFormat:@"$ %@",self.product.price]];
            if(self.product.store.phone != nil && [self.product.store.phone length]>0){
                [self onCall];
            }
            break;
        case 2:
            [(ProductDetailVC*)self.managingViewController showMapView];
            break; 
        case 3:
            break;
        case 4: 
            break;
        case 5:             
            break;
        default:
            break;
    }
    
}

- (void)onCall
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	if(self.product.store.phone){
        [actionSheet addButtonWithTitle:self.product.store.phone];
    }
	
	actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
	
	[actionSheet showInView:self.view];

}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",  self.product.store.phone  ]]];
    }  
}

@end
