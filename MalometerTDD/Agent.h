//
//  Agent.h
//  MalometerTDD
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Agent : NSManagedObject

@property (nonatomic, retain) NSNumber * assessment;
@property (nonatomic, retain) NSNumber * motivation;
@property (nonatomic, retain) NSNumber * destructionPower;
@property (nonatomic, retain) NSString * name;

@end
