//
//  AgentTests.m
//  MalometerTDD
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Agent+Model.h"


@interface AgentTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Agent *sut;
}

@end


@implementation AgentTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
//    [self createFixture];
    [self createSut];
}


- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createFixture {
    // Test data
}


- (void) createSut {
    sut = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Agent class]) inManagedObjectContext:context];
}


- (void) tearDown {
    [self releaseSut];
//    [self releaseFixture];
    [self releaseCoreDataStack];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {

}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    // Prepare

    // Operate

    // Check
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

- (void) testAssessmentEquals4 {
    sut.motivation = @2;
    sut.destructionPower =@6;
    
    XCTAssertEqualObjects(sut.assessment, @4, @"Assesment must be 4");
}

- (void) testAssessmentByFormula {
    sut.motivation = @2;
    sut.destructionPower =@2;
    
    XCTAssertEqualObjects(sut.assessment, @2, @"Assesment must be 2");
}

- (void) testShouldCallAccessValueForKey {
    id partialMock = OCMPartialMock(sut);
    
    OCMExpect([partialMock willChangeValueForKey:@"motivation"]);
    OCMExpect([partialMock didChangeValueForKey:@"motivation"]);
    OCMStub([partialMock destructionPower]).andReturn(@2);
    OCMStub([partialMock motivation]).andReturn(@2);
    
    [partialMock setMotivation:@2];
    
    XCTAssertNoThrow([partialMock verify], @"Must call motivation observing");
    
}

-(void) testShouldChangeValueForDestructionPower{
    id destructionMock =OCMPartialMock(sut);
    
    OCMExpect([destructionMock willChangeValueForKey:@"destructionPower"]);
    OCMExpect([destructionMock didChangeValueForKey:@"destructionPower"]);
    OCMStub([destructionMock destructionPower]).andReturn(@2);
    OCMStub([destructionMock motivation]).andReturn(@2);
    
    
    [destructionMock setDestructionPower:@3];
    XCTAssertNoThrow([destructionMock verify], @"destruction poer changed");
}

- (void) testShouldChangeValueForAssessment {
    id destructionMock =OCMPartialMock(sut);
    
    OCMExpect([destructionMock willChangeValueForKey:@"assessment"]);
    OCMExpect([destructionMock didChangeValueForKey:@"assessment"]);
    OCMStub([destructionMock destructionPower]).andReturn(@2);
    OCMStub([destructionMock motivation]).andReturn(@2);
    
    [destructionMock setDestructionPower:@3];
        [destructionMock setMotivation:@2];
    XCTAssertNoThrow([destructionMock verify], @"Must call assessment observing");
}

-(void)testCanOrderAgents{
    Agent *agent2= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Agent class]) inManagedObjectContext:context];
    
    Agent *agent3= [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Agent class]) inManagedObjectContext:context];
    sut.name=@"agent1";
    agent3.name=@"agent3";
    agent2.name=@"agent2";
    [context save:nil];
    
    NSFetchRequest *request = [Agent shortedRequest];
    NSArray *agentArrayOrdenated = [context executeFetchRequest:request error:NULL];
    
    for (int i=0 ; i<3;i++){
        Agent *agentObj=agentArrayOrdenated[i];
        NSString *name=[NSString stringWithFormat:@"agent%i",i+1];
        XCTAssertEqualObjects(agentObj.name, name, @"");

    }
    
}

- (void) testRequestWithPredicate {
    sut.name = @"Pepinillos";
    [context save:NULL];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"Pepinillos"];
    
    NSFetchRequest *request = [Agent shortedRequestWithPredicate:predicate];
    
    Agent *retrievedAgent = [[context executeFetchRequest:request error:NULL] firstObject];
    
    XCTAssertEqualObjects(@"Pepinillos", retrievedAgent.name, @"Names must equal");
}

-(void)testRequestForShortDescriptors{
    
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *MotivationSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"motivation" ascending:YES];
    
    NSArray *sortDescriptors = @[MotivationSortDescriptor, nameSortDescriptor];
    
    NSFetchRequest *request = [Agent requestWithSortDescriptors:sortDescriptors];
    
    XCTAssertEqualObjects(sortDescriptors, request.sortDescriptors, @"Sort descriptors must match");
}

- (void)testAgentNameShouldNotBeEmpty {
    NSString *invalidName = @"";
    
    XCTAssertFalse([sut validateName:&invalidName error:NULL], @"It must not be validate");
}

- (void)testAgentNameShouldHaveAlphanumericCharacters {
    NSString *invalidName = @" ";
    
    XCTAssertFalse([sut validateName:&invalidName error:NULL], @"It must not be validate");
}

- (void)testAgentMotivationShouldNotBeMoreThanFive {
    sut.motivation = @6;
    sut.name = @"agent";
    
    XCTAssertFalse([sut validateForInsert:NULL], @"It must not be validate");
}

- (void)testAgentDestructionPowerShouldNotBeMoreThanFive {
    sut.destructionPower = @6;
    sut.name = @"agent";
    
    XCTAssertFalse([sut validateForInsert:NULL], @"It must not be validate");
}

@end
