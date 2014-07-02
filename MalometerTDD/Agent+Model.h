//
//  Agent+Model.h
//  MalometerTDD
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Agent.h"

@interface Agent (Model)

+ (NSFetchRequest *)shortedRequest;
+ (NSFetchRequest *)shortedRequestWithPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *)requestWithSortDescriptors:(NSArray *)sortDescriptors;

@end
