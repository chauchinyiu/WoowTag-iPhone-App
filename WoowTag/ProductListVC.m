//
//  ProductListVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/26/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import "ProductListVC.h"
#import "Product.h"
#import "ProductDetailVC.h"
@interface ProductListVC()
-(void) gotoGridView;@end
@implementation ProductListVC
@synthesize tableView = _tableView;
@synthesize productlist = _productlist;
@synthesize tableViewCell = _tableViewCell; 
@synthesize storeName = _storeName;
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
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    UIView *toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30 , 44)];
 
    
    UIButton *gridBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 30,30)];
    [gridBtn setImage:[UIImage imageNamed:@"grid_button.png"] forState:UIControlStateNormal];
    [gridBtn addTarget:self action:@selector(gotoGridView) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:gridBtn];
    
    UIBarButtonItem *customBarButtomItem  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    self.navigationItem.rightBarButtonItem =  customBarButtomItem;
    self.navigationItem.title = self.storeName;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [self.productlist count];
}

-(void) gotoGridView{
    [AppDelegate showGridView]  ;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProductResultTableViewCell";
    
    ProductResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ProductResultTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
    }
    
    Product *prod=  [self.productlist  objectAtIndex:indexPath.row];       
    [cell setProduct:prod];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Product *prod=   [self.productlist objectAtIndex:indexPath.row];
    ProductDetailVC *detailVC =  [[ProductDetailVC alloc] initWithNibName:@"ProductDetailVC" bundle:nil];
    
    detailVC.product = prod;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    if([AppDelegate connectedToNetwork])
        [detailVC getProductFromWebService:prod.productId];
    
    
}

@end
