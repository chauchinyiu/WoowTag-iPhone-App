//
//  StoreVC.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/1/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//
#import "StoreInfoVC.h"
#import "UIImageView+AFNetworking.h"
#import "ProductListVC.h"
@interface StoreInfoVC()
-(void) saveStore;
-(void) gotoGridView;
- (void)showWithCustomView:(NSString*) labeltext;
@end
@implementation StoreInfoVC
@synthesize store = _store;
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;
@synthesize storeImage=_storeImage;
@synthesize storeName=_storeName;
@synthesize productListBtn;
@synthesize  storeDescription;
@synthesize managedObjectContext =_managedObjectContext;
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
    self.storeName.text = self.store.name;
    NSString *urlstring= [self.store.imageUrl stringByReplacingOccurrencesOfString:@"/thumb/" withString:@"/medium/"];  
    
    NSURL *url = [NSURL URLWithString:urlstring];
    [self.storeImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"store_preview"]];
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    self.navigationItem.title = @"Store";

    [self.tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) viewWillAppear:(BOOL)animated{
    UIView *toolbar =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70 , 44)];
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 30,30)];
    [sortBtn setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(saveStore) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:sortBtn];
    
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 7, 30,30)];
    [mapBtn setImage:[UIImage imageNamed:@"grid_button.png"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(gotoGridView) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:mapBtn];
    
    UIBarButtonItem *customBarButtomItem  = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    self.navigationItem.rightBarButtonItem =  customBarButtomItem;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *temptext; 
    
    switch (indexPath.row) {
        case 0:
            
            temptext = [WoowTagToolKit convertStringArrayToString:self.store.tags] ;
            break;
        case 1:
            temptext =  self.store.address ;
            break;
        case 2: 
            temptext =  self.store.phone ;
            break;
        case 3: 
            temptext =  self.store.description ;
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
    
    
    DetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
    }
    
    
    switch (indexPath.row) {
        case 0:
            
            [cell setDetailInfo:@"tag.png"  withLabel:[WoowTagToolKit convertStringArrayToString:self.store.tags]];
           
            break;
        case 1:
            
            [cell setDetailInfo:@"address.png" withLabel:self.store.address];
           
            break;
        case 2: 
            [cell setDetailInfo:@"phone.png"  withLabel:self.store.phone];
            
            break;
        case 3: 
            [cell setDetailInfo:@"description.png"  withLabel:self.store.description];
            
            break;
            
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getStoreFromWebService:(NSString *) storeid{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = @"Loading";
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObject:storeid forKey:@"id"];
    [Store callStoreWebService:@"store" withParameter: parameter  WithBlock:^( Store *storefromServer) {
        if (storefromServer) {
            self.store = storefromServer;
            [self viewDidLoad];
        } 
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void) saveStore{
    SaveStore *savestore= [NSManagedObject getSaveStoreByStoreID:[NSString stringWithFormat:@"%@",self.store.storeId] withManagedObjectContext:self.managedObjectContext];
    
    if(savestore != nil){
        NSLog(@"Save Store %@ ",savestore.store_description);
        [self showWithCustomView:@"Store is saved"];
        return;
    }else{
        
        // Create and configure a new instance of the Event entity.
        savestore = (SaveStore *)[NSEntityDescription insertNewObjectForEntityForName:@"SaveStore"  inManagedObjectContext:self.managedObjectContext];
        [savestore setStoreid:[NSString stringWithFormat:@"%@",self.store.storeId]];
        [savestore setStore_url:self.store.store_url];
        NSLog(@"dsfasdfas %@", self.store.description);
        if([self.store.description isKindOfClass: [NSString class]]){
            [savestore setStore_description:self.store.description];
        }
        [savestore setName:self.store.name];
        [savestore setPhone:self.store.phone];
        [savestore setLatitude:[NSString stringWithFormat:@"%@",self.store.latitude]];
        [savestore setLongitude:[NSString stringWithFormat:@"%@",self.store.longitude]];
        [savestore setAddress:self.store.address];
        [savestore setFax:self.store.fax];
         [savestore setTags:self.store.tags];
        [savestore setImageUrl:self.store.imageUrl];
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        } 
        [self showWithCustomView:@"Completed !"];
        
    }
    
}
-(void) gotoGridView{
    [AppDelegate showGridView]  ;
}
- (IBAction)showProductList:(id)sender{
    ProductListVC *productListVC =  [[ProductListVC alloc] initWithNibName:@"ProductListVC" bundle:nil];
    
    productListVC.productlist = self.store.productList;
    productListVC.storeName = self.store.name;
    [self.navigationController pushViewController:productListVC animated:YES];
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


@end
