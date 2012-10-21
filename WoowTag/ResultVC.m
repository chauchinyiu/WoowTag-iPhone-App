//
//  ResultVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/4/12.
//  Copyright (c) 2012 WoowTag. All rights reserved.
//

#import "ResultVC.h"
#import "ProductResultTableViewCell.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "Product.h"
#import "ProductDetailVC.h"
#import "ResultListMapVC.h"
#import "ResultProductTableListVC.h"
#import "SCValuePicker.h"

@interface ResultVC()
- (void)didChangeSegmentControl:(UISegmentedControl *)control;
- (NSArray *)segmentedViewControllerContent;
- (NSMutableArray *)getListOfStore:(NSArray *) prods;
- (NSMutableArray *) mergePreviousLoaded:(NSArray *)previous_stores toLatestLoaded:(NSArray *)latest_stores;
- (void) gotoGridView;
- (void) showSortPicker;
@end
@implementation ResultVC
 
@synthesize products = _products;
@synthesize parameters =_parameters;
@synthesize segmentedControl =_segmentedControl;
@synthesize activeViewController=_activeViewController;
@synthesize segmentedViewControllers = _segmentedViewControllers;
 
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
    _productTableListVC = [[ResultProductTableListVC alloc] initWithParentViewController:self];
    _storeTableListVC = [[ResultStoreTableListVC alloc] initWithParentViewController:self];
    _mapListVC = [[ResultListMapVC alloc] initWithParentViewController:self];
    self.segmentedViewControllers = [self segmentedViewControllerContent];
    
    NSArray * segmentTitles = [self.segmentedViewControllers arrayByPerformingSelector:@selector(title)];
    [self.segmentedControl setTitle:[segmentTitles objectAtIndex:0] forSegmentAtIndex:0];
    [self.segmentedControl setTitle:[segmentTitles objectAtIndex:1] forSegmentAtIndex:1];
    [self.segmentedControl setTitle:[segmentTitles objectAtIndex:2] forSegmentAtIndex:2];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(didChangeSegmentControl:)
                    forControlEvents:UIControlEventValueChanged];
    [self didChangeSegmentControl:self.segmentedControl]; 
    
 
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

    _productTableListVC.view.frame = CGRectMake(0, 30, 320, 430);
    _storeTableListVC.view.frame = CGRectMake(0, 30, 320, 430);

    _mapListVC.view.frame = CGRectMake(0, 30, 320, 430);
    NSArray * controllers = [NSArray arrayWithObjects:_productTableListVC, _storeTableListVC,_mapListVC, nil];
    
    
    
    return controllers;
}


-(void)performSearch{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = @"Loading";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.parameters forKey:LASTSEARCH_KEY];
    [prefs setObject:[NSDate date] forKey: LASTSEARCH_DATE];
    [prefs synchronize];
    [ProductList callListWebService:@"product_search" withParameter:self.parameters WithBlock:^(ProductList *productlist) {
        if (productlist) {
            
            NSMutableArray *stores = [self getListOfStore:productlist.products];
            _mapListVC.products = productlist.products;
            _productTableListVC.products = productlist.products;
            _productTableListVC.pageNum = RESULTS_FIRSTPAGE;
            _productTableListVC.totalnums = productlist.totalnums;
            [_productTableListVC.tableView reloadData];
            _storeTableListVC.stores = stores;
            [_storeTableListVC.tableView reloadData];
            self.navigationItem.title = [NSString stringWithFormat:@"Results(%@)",productlist.totalnums];
            _productTableListVC.noResultView.hidden = YES;
            _productTableListVC.tableView.hidden = NO;
            _storeTableListVC.noResultView.hidden = YES;
            _storeTableListVC.tableView.hidden = NO;
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            _productTableListVC.noResultView.hidden = NO;
            _productTableListVC.tableView.hidden = YES;
            _storeTableListVC.noResultView.hidden = NO;
            _storeTableListVC.tableView.hidden = YES;
        }
    }];

}

-(void) loadMoreData:(int) pageNumber{
    [self.parameters setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"current_page"];
    [ProductList callListWebService:@"product_search" withParameter:self.parameters WithBlock:^(ProductList *productlist) {
        if (productlist) {
            
            NSMutableArray *stores = [self getListOfStore:productlist.products];
//            [_mapListVC.products  addObjectsFromArray:productlist.products] ;
            [_productTableListVC.products addObjectsFromArray: productlist.products];            
             _productTableListVC.totalnums = productlist.totalnums;
            [_productTableListVC.tableView reloadData];
            _storeTableListVC.stores = [self mergePreviousLoaded:_storeTableListVC.stores toLatestLoaded:stores];
           //  [_storeTableListVC.stores addObjectsFromArray: stores];
            [_storeTableListVC.tableView reloadData];
           }else{
          
            
        }
    }];
}

- (NSMutableArray *)getListOfStore:(NSArray *) prods{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *result =[[NSMutableArray alloc] init];
    for(int i=0; i < [prods count] ;i++){
        Product * prd=[prods objectAtIndex:i];
        if([dict objectForKey:prd.store.storeId]==nil){
            
            [result addObject:prd.store];
            [dict setObject:prd.store forKey:prd.store.storeId];
        }
    }
    return result;
}

- (NSMutableArray *) mergePreviousLoaded:(NSArray *)previous_stores toLatestLoaded:(NSArray *)latest_stores{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *result =[[NSMutableArray alloc] init];
    
    NSMutableArray *temparray = [[NSMutableArray alloc] initWithArray:previous_stores];
    [temparray addObjectsFromArray:latest_stores];
    
    for(int i=0; i < [temparray count] ;i++){
        Store * store=[temparray objectAtIndex:i];
        if([dict objectForKey:store.storeId]==nil){
            [result addObject:store];
            [dict setObject:store forKey:store.storeId];
        }
    }
    return result;
}

- (void)viewWillAppear:(BOOL)animated{
    UIView *toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70 , 44)];
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 30,30)];
    [sortBtn setImage:[UIImage imageNamed:@"sort_button.png"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(showSortPicker) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:sortBtn];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 7, 30,30)];
    [mapBtn setImage:[UIImage imageNamed:@"grid_button.png"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(gotoGridView) forControlEvents:UIControlEventTouchUpInside];

    [toolbar addSubview:mapBtn];
    
    UIBarButtonItem *customBarButtomItem  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];

    self.navigationItem.rightBarButtonItem =  customBarButtomItem;

}

-(void) gotoGridView{
         [AppDelegate showGridView]  ;
}

-(void) showSortPicker{
 
  	_sortPicker = [[SCValuePicker alloc] initWithValues:SORT_KEYS titles:SORT_TITLES];
	_sortPicker.value = [SORT_KEYS objectAtIndex:0];
    _sortAscending = @"false";
	_sortPicker.selectedSegmentIndex = ([_sortAscending isEqualToString:@"true"])? 0 : 1 ;
	_sortPicker.delegate = self;
	_sortPicker.modal = YES;
	_sortPicker.showDoneButton = YES;
	_sortPicker.titleLabel.text =  @"Sorting";
	_sortPicker.segmentedControlTitles = [NSArray arrayWithObjects:@"up",@"down"  , nil];
    
	[_sortPicker show];
 
   
}
- (void)pickerDidHitDone:(SCPicker *)picker
{
    NSString* asc=(_sortPicker.selectedSegmentIndex==0)?@"true":@"false";
	if( [_sortPicker.value isEqualToString:_sortKey] &&  [_sortAscending isEqualToString:asc])
		return;
	
	 
	_sortKey =  _sortPicker.value  ;
	_sortAscending =asc;
	
 
    [self.parameters removeObjectForKey:@"sort_key"];
    [self.parameters removeObjectForKey:@"sort_ascending"];
    [self.parameters setValue:[NSString stringWithFormat:@"%d",RESULTS_FIRSTPAGE] forKey:@"current_page"];
    [self.parameters setValue:_sortKey forKey:@"sort_key"];
    [self.parameters setValue:_sortAscending forKey:@"sort_ascending"];
     
    [self performSearch];
	 
	 
}

 
@end
