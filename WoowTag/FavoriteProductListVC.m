//
//  FavoriteProductListVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/18/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "FavoriteProductListVC.h"
#import "NSManagedObject+Management.h"
#import "ProductResultTableViewCell.h"
@interface FavoriteProductListVC()
- (Product *) convertSaveProductToProduct:(SaveProduct*) saveProduct ;
@end
@implementation FavoriteProductListVC
@synthesize tableView = _tableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize productlist = _productlist;
@synthesize tableViewCell = _tableViewCell; 
@synthesize managedObjectContext = _managedObjectContext;
@synthesize noResultView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
   
    return self;
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    if (isEditMode == YES) {
         [self.tableView setEditing: NO animated: YES];
          isEditMode = NO;
    }else{ 
        [self.tableView setEditing: YES animated: YES];
        isEditMode = YES;
    }
}    
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *productToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];       
         NSLog(@"Product %@ : ",[[self.productlist objectAtIndex:indexPath.row] name]  );
         NSLog(@"ProductDete %@ : ", ((SaveProduct*)productToDelete).name  );
        [self.managedObjectContext deleteObject:productToDelete];    
        [self.managedObjectContext save:nil];
    }
    
}
 



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) delete:(id)sender{
    NSLog(@"delete");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
     self.productlist = [NSManagedObject getAllDataFromEntityName:@"SaveProduct" withManagedObjectContext:self.managedObjectContext];
    if(self.productlist == nil || [self.productlist count] < 1){
        self.noResultView.hidden = NO;
        self.tableView.hidden = YES;
    }else{
        self.noResultView.hidden = YES;
        self.tableView.hidden = NO;
    }
    isEditMode = NO;
 
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.productlist count]; 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
 
    SaveProduct *prod= (SaveProduct *) [self.fetchedResultsController objectAtIndexPath:indexPath];       
    [cell setSaveProduct:prod];
    return cell;
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SaveProduct *prod= (SaveProduct *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    ProductDetailVC *detailVC =  [[ProductDetailVC alloc] initWithNibName:@"ProductDetailVC" bundle:nil];
   
     detailVC.product = [self convertSaveProductToProduct:prod];
    
    [self.navigationController pushViewController:detailVC animated:YES];

    if([AppDelegate connectedToNetwork])
        [detailVC getProductFromWebService:prod.productid];
    
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SaveProduct" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
    
//    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	  
	}
    
    return _fetchedResultsController;
}  

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

 

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            

            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (Product *) convertSaveProductToProduct:(SaveProduct*) saveProduct {
    Product* product = [[Product alloc] init];
    product.productId = saveProduct.productid;
    product.name = saveProduct.name;
    product.price = saveProduct.price;
    product.stock = saveProduct.stock;
    product.imagelinks = saveProduct.imagelinks;
    //TODO store object creation
    Store* store = [[Store alloc] init];
    store.storeId = saveProduct.storeid;
    store.name = saveProduct.storename;
    store.address = saveProduct.address;
    product.store = store;
    return product;
    
}
@end
