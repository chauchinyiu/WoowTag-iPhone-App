//
//  ResultProductTableListVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "ResultProductTableListVC.h"
#import "ProductResultTableViewCell.h"
#import "Product.h"
#import "ProductDetailVC.h"
#import "ResultVC.h"
@implementation ResultProductTableListVC
@synthesize tableView = _tableView;
@synthesize tableViewCell = _tableViewCell;
@synthesize products = _products;
@synthesize totalnums = _totalnums;
@synthesize pageNum = _pageNum;
@synthesize showMoreCell = _showMoreCell;
@synthesize managingViewController=_managingViewController;
@synthesize noResultView;
- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"ResultProductTableListVC" bundle:nil]) {
        self.managingViewController = aViewController;
        
        self.title = @"Products";
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
    _pageNum =1;
     [super viewDidLoad];
     self.tableView.rowHeight = 70.0f;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int totalnums = [self.totalnums intValue];
    int numrow = [_products count];
    if([_products count] < totalnums)
        return numrow+1;
    else
        return numrow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    
    if(indexPath.row== [_products count]  &&
        indexPath.row < [_totalnums intValue]){
//            if(_loadNextPageFailed){
//                ((UIActivityIndicatorView *)[self.showMoreCell viewWithTag:CELL_SHOWMORECELL_LOADING]).hidden = YES;
//                ((UIButton *)[self.showMoreCell viewWithTag:CELL_SHOWMORECELL_BUTTON]).hidden = NO;
//            }else{
//                ((UIActivityIndicatorView *)[self.showMoreCell viewWithTag:CELL_SHOWMORECELL_LOADING]).hidden = NO;
//                ((UIButton *)[self.showMoreCell viewWithTag:CELL_SHOWMORECELL_BUTTON]).hidden = YES;
//            }
 
            [self onLoadNextPage:nil];
         
            return self.showMoreCell;
        
    }else{
        static NSString *CellIdentifier = @"ProductResultTableViewCell";
        
        ProductResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ProductResultTableViewCell" owner:self options:nil];
            cell = _tableViewCell;
            self.tableViewCell = nil;
        }
        [cell setProduct:[_products objectAtIndex:indexPath.row]];
         return cell;
    }


}

- (void)viewWillAppear:(BOOL)animated{
  
    [self.managingViewController viewWillAppear:NO];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int totalnums = [self.totalnums intValue];

    if([_products count] < totalnums && indexPath.row == [_products count])
        return 44.0f;
    else
        return 100.0f;  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row== [_products count]  &&
       indexPath.row < [_totalnums intValue]){
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Product %@ : ",[[_products objectAtIndex:indexPath.row] productId] );
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithNibName:@"ProductDetailVC" bundle:nil];
    detailVC.product = [_products objectAtIndex:indexPath.row];
    [self.managingViewController.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)onLoadNextPage:(id)sender
{
    
	// load next page
    _pageNum = _pageNum +1;
     
    [(ResultVC *)self.managingViewController loadMoreData:_pageNum]; 
	_isLoading = YES;
	_loadNextPageFailed = NO;
}



@end
