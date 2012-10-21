//
//  SaveProduct.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/17/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SaveProduct : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * productid;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * stock;
@property (nonatomic, retain) NSArray  * imagelinks;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * product_description;
@property (nonatomic, retain) NSString * storeid;
@property (nonatomic, retain) NSString * storename;
@property (nonatomic, retain) NSString * address;
@end
