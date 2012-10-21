//
//  NSManageeObject+Management.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/17/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveProduct.h"
#import "SaveStore.h"
@interface NSManagedObject (NSManagedObject_Management)
+(SaveProduct *) getSaveProductByProductID:(NSString *)pid withManagedObjectContext:(NSManagedObjectContext *)context;
+(SaveStore *) getSaveStoreByStoreID:(NSString *)pid withManagedObjectContext:(NSManagedObjectContext*)context;

+(NSArray *) getAllDataFromEntityName:(NSString *) entityname withManagedObjectContext:(NSManagedObjectContext*)context;
@end
