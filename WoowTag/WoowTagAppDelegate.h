//
//  WoowTagAppDelegate.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/7/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridVC.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#define AppDelegate (WoowTagAppDelegate *)[[UIApplication sharedApplication] delegate] 

@interface WoowTagAppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *_window;
    GridVC *_gridvc;
    UIView *_blendView;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void) showGridView;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) GridVC *gridvc;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;
- (BOOL) connectedToNetwork;
@end
