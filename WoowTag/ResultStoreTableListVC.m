//
//  ResultStoreTableListVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/10/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import "ResultStoreTableListVC.h"

@implementation ResultStoreTableListVC
@synthesize tableView = _tableView;
@synthesize tableViewCell = _tableViewCell;
@synthesize stores = _stores;
@synthesize managingViewController=_managingViewController;
@synthesize noResultView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"ResultStoreTableListVC" bundle:nil]) {
        self.managingViewController = aViewController;
        
        self.title = @"Stores";
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
         self.tableView.rowHeight = 70.0f;
    // Do any additional setup after loading the view from its nib.
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
    
    [self.managingViewController viewWillAppear:NO];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_stores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StoreResultTableViewCell";
    
    StoreResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StoreResultTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
    }
  //  NSLog(@"Product %@ : ",[_stores objectAtIndex:indexPath.row]   );
    [cell setStore:[_stores objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Product %@ : ",[[_stores objectAtIndex:indexPath.row]  storeId] );
    Store* shop = [_stores objectAtIndex:indexPath.row] ; 
    StoreInfoVC *storeVC =[[StoreInfoVC alloc] initWithNibName:@"StoreInfoVC" bundle:nil]; 
    if([AppDelegate connectedToNetwork])
        [storeVC getStoreFromWebService:shop.storeId];
    else
        storeVC.store = shop;
    [self.managingViewController.navigationController pushViewController:storeVC animated:YES];
}

@end
