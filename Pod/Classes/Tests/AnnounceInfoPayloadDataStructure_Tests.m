//
//                           MMMMMMMMMMMM
//                     MMMMMMMMMMMMMMMMMMMMMMMM
//                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//             MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//           MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//         MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//       MMMMMMMMMMMMMMMMMMMMMMM     MMMMMMMMMMMMMMMMMMMMMMMM
//      MMMMMMMMM                        MMMMMMMMMMMMMMMMMMMMM
//     MMMMMMMMMM  MMMMMMMMMMMMMMMMMMM               MMMMMMMMMM
//    MMMMMMMMMMM  MM           MMM  MMMMMMMMMMMMMM  MMMMMMMMMMM
//   MMMMMMMMMMMM  MMMMMMMMMMMMMMMM  MMMMMMM     MM    MMMMMMMMMM
//   MMMMMMMMM     MM            MM  MMMMMMM     MM     MMMMMMMMM
//  MMMMMMMMMM     MMMMMMMMMMMMMMMM  MM    M   MMMM     MMMMMMMMMM
//  MMMMMMMMMM          MMM     MMM  MMMMMMMMMM         MMMMMMMMMM
//  MMMMMMMMMM             MMMMMMMM  MM   M             MMMMMMMMMM
//  MMMMMMMMMM                   MMMM                   MMMMMMMMMM
//  MMMMMMMMMM                                          MMMMMMMMMM
//  MMMMMMMMMM                                          MMMMMMMMMM
//  MMMMMMMMMM        MMMMM                MMMMM        MMMMMMMMMM
//  MMMMMMMMMM        MMMMMMMMM       MMMMMMMMMM        MMMMMMMMMM
//   MMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMM
//   MMMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMMM
//    MMMMMMMM        MMMMMMMMMMMMMMMMMMMMMMMMMM        MMMMMMMM
//     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//      MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//         MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//           MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//             MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//                 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
//                     MMMMMMMMMMMMMMMMMMMMMMMM
//                           MMMMMMMMMMMM
//
//
//	Copyright © 2012 - 2015 Roman Priebe
//
//	This file is part of M - Safe email made simple.
//
//	M is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	M is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with M.  If not, see <http://www.gnu.org/licenses/>.
//

#import "AnnounceInfoPayloadDataStructure.h"
#import <XCTest/XCTest.h>
#import "TestHelper.h"



@interface AnnounceInfoPayloadDataStructure_Tests : XCTestCase

@end

@implementation AnnounceInfoPayloadDataStructure_Tests

- (void)testDataWrapping
{
    NSData* hashData = [TestHelper sampleData:@1];
    NSData* payloadData = [TestHelper sampleData:@2];
    NSString* version = @"SomeVersion";

    NSString* keyLabel = @"TestKeyLabel1";
    
    NSData* encData = [TestHelper encData:@1];
    NSData* verData = [TestHelper verData:@1];
    
    AnnounceInfoPayloadDataStructure* newStructure = [[AnnounceInfoPayloadDataStructure alloc] initWithPublicKeyLabel:keyLabel encData:encData verData:verData hashData:hashData deviceDiscoveryPayloadData:payloadData version:version];
    
    XCTAssertNotNil(newStructure);
    
    NSData* parsedData = newStructure.serialisedData;
    
    XCTAssertNotNil(parsedData);
    
    
    AnnounceInfoPayloadDataStructure* dataStructure = [AnnounceInfoPayloadDataStructure deserialiseData:parsedData];
    
    XCTAssertNotNil(dataStructure);
    
    XCTAssertEqualObjects(@"TestKeyLabel1", dataStructure.keyLabel);
    XCTAssertEqualObjects(hashData, dataStructure.hashData);
    XCTAssertEqualObjects(payloadData, dataStructure.deviceDiscoveryPayloadData);
    XCTAssertEqualObjects(version, dataStructure.version);
}

- (void)testNilSafe
{
    AnnounceInfoPayloadDataStructure* dataStructure = [[AnnounceInfoPayloadDataStructure alloc] initWithPublicKeyLabel:nil encData:nil verData:nil hashData:nil deviceDiscoveryPayloadData:nil version:nil];
    
    [dataStructure serialisedData];
}



@end
