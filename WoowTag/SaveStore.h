//
//  SaveStore.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/17/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SaveStore : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * storeid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * store_url;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * store_description;
@property (nonatomic, retain) NSArray * tags; 
@property (nonatomic, retain) NSString *imageUrl ; 

@end
