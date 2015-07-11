//
//  VersionDataStructure_Tests.m
//  MProtoBufLib
//
//  Created by Roman Priebe on 25/05/2015.
//  Copyright (c) 2015 Mynigma UG (haftungsbeschränkt). All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VersionDataStructure.h"

@interface VersionDataStructure_Tests : XCTestCase

@end

@implementation VersionDataStructure_Tests

- (void)testDataWrapping
{
    NSString* testVersion = @"SomeVersion";
    
    VersionDataStructure* newStructure = [[VersionDataStructure alloc] initWithVersion:testVersion];
    
    XCTAssertNotNil(newStructure);
    
    NSData* parsedData = newStructure.serialisedData;
    
    XCTAssertNotNil(parsedData);
    
    
    VersionDataStructure* reparsedStructure = [VersionDataStructure deserialiseData:parsedData];
    
    XCTAssertNotNil(reparsedStructure);
    
    XCTAssertEqualObjects(newStructure.version, reparsedStructure.version);
}

- (void)testNilSafe
{
    //version is a rquired field, so this test is relatively pointless
    VersionDataStructure* dataStructure = [[VersionDataStructure alloc] initWithVersion:@""];
    
    [dataStructure serialisedData];
}



@end
