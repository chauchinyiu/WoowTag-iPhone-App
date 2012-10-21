//
//  NSManagedObject+Management.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/17/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "NSManagedObject+Management.h"
#import "SaveProduct.h"
@implementation NSManagedObject (NSManagedObject_Management)

+(SaveProduct *) getSaveProductByProductID:(NSString *)pid withManagedObjectContext:(NSManagedObjectContext*)context
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SaveProduct" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"productid= %@", pid]];
     [request setFetchLimit:1];
     
     NSArray *results = [context executeFetchRequest:request error:nil];        
     
     SaveProduct* saveproduct = nil;  
     
     if ([results count] > 0)
     {
         saveproduct = (SaveProduct*)[results objectAtIndex:0];  
     }
     
     
     return saveproduct;
 }

+(SaveStore *) getSaveStoreByStoreID:(NSString *)pid withManagedObjectContext:(NSManagedObjectContext*)context
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"SaveStore" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"storeid= %@", pid]];
    [request setFetchLimit:1];
    
    NSArray *results = [context executeFetchRequest:request error:nil];        
    
    SaveStore* savestore = nil;  
    
    if ([results count] > 0)
    {
        savestore = (SaveStore*)[results objectAtIndex:0];    
    }
        
    return savestore;
}

+(NSArray *) getAllDataFromEntityName:(NSString *) entityname withManagedObjectContext:(NSManagedObjectContext*)context;
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityname inManagedObjectContext:context]];  
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];        
    
    if (error != nil)
    {
        //handle errors
    }    
    return results;
}

@end
