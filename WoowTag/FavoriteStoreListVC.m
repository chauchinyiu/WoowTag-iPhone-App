//
//  FavoriteStoreListVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/18/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "FavoriteStoreListVC.h"
#import "NSManagedObject+Management.h"
#import "StoreResultTableViewCell.h"
@interface FavoriteStoreListVC()
- (Store *) convertSaveStoreToStore:(SaveStore*) saveStore ;
@end
@implementation FavoriteStoreListVC
@synthesize tableView = _tableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize storelist = _storelist;
@synthesize tableViewCell = _tableViewCell;
@synthesize noResultView;
@synthesize managedObjectContext = _managedObjectContext;
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
        NSManagedObject *storeToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];       
        NSLog(@"store %@ : ",[[self.storelist objectAtIndex:indexPath.row] name]  );
        NSLog(@"storeDete %@ : ", ((SaveStore*)storeToDelete).name  );
        [self.managedObjectContext deleteObject:storeToDelete];    
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
    self.storelist = [NSManagedObject getAllDataFromEntityName:@"SaveStore" withManagedObjectContext:self.managedObjectContext];
    if(self.storelist == nil || [self.storelist count] < 1){
        self.noResultView.hidden = NO;
        self.tableView.hidden = YES;
    }else{
        self.noResultView.hidden = YES;
        self.tableView.hidden = NO;
    }
    isEditMode = NO;
//    [self.tableView reloadData];
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
    //    return [self.storelist count]; 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StoreResultTableViewCell";
    
    StoreResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StoreResultTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
            
    }
    
    SaveStore *sto= (SaveStore *) [self.fetchedResultsController objectAtIndexPath:indexPath];       
     [cell setSaveStore:sto];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SaveStore *prod= (SaveStore *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    StoreInfoVC *detailVC =  [[StoreInfoVC alloc] initWithNibName:@"StoreInfoVC" bundle:nil];
    
    detailVC.store =  [self convertSaveStoreToStore:prod];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
   // if([AppDelegate connectedToNetwork])
        //[detailVC getStoreFromWebService:prod.Storeid];
    
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SaveStore" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //    [fetchRequest setFetchBatchSize:20];
    
    //    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
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


 - (Store *) convertSaveStoreToStore:(SaveStore*) saveStore {
    Store* store = [[Store alloc] init];
    store.storeId = saveStore.storeid;
    store.name = saveStore.name;
    store.latitude = saveStore.latitude;
    store.longitude = saveStore.longitude;
    store.phone = saveStore.phone;
    store.address = saveStore.address;
    store.imageUrl = saveStore.imageUrl;
    store.fax = saveStore.fax;
     store.description = saveStore.store_description;
     store.store_url = saveStore.store_url;
    return store;
    
 }
@end
