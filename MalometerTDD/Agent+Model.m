//
//  Agent+Model.m
//  MalometerTDD
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Agent+Model.h"

@implementation Agent (Model)

+ (NSFetchRequest *)shortedRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Agent class])];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return fetchRequest;
}

+ (NSFetchRequest *)shortedRequestWithPredicate:(NSPredicate *)predicate{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Agent class])];
    
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return fetchRequest;
}

+ (NSFetchRequest *)requestWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Agent class])];
    [fetchRequest setFetchBatchSize:20];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}

- (BOOL)validateName:(id __autoreleasing *)name error:(NSError * __autoreleasing *)error {
    NSString *stringName = *name;
    stringName = [stringName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [stringName length] != 0;
}

- (NSNumber *)assessment {
    return [self assesmentFormula];
}

- (NSNumber *)destructionPower {
    return [self primitiveValueForKey:@"destructionPower"];
}

- (NSNumber *)motivation {
    return [self primitiveValueForKey:@"motivation"];
}

- (void)setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:@"motivation"];
    [self setPrimitiveValue:motivation forKey:@"motivation"];
    [self didChangeValueForKey:@"motivation"];
    
    [self refreshAssement];
}

- (void)setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:@"destructionPower"];
    [self setPrimitiveValue:destructionPower forKey:@"destructionPower"];
    [self didChangeValueForKey:@"destructionPower"];

    [self refreshAssement];
}


- (void)refreshAssement {
    [self willChangeValueForKey:@"assessment"];
    [self setPrimitiveValue:[self assesmentFormula] forKey:@"assessment"];
    [self didChangeValueForKey:@"assessment"];
}

- (NSNumber *)assesmentFormula {
    return [NSNumber numberWithInteger:([self.destructionPower integerValue] + [self.motivation integerValue]) / 2];
}


@end
