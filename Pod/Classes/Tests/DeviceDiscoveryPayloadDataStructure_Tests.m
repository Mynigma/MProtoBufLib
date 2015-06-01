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

#import "TestHelper.h"
#import <XCTest/XCTest.h>
#import "DeviceDiscoveryPayloadDataStructure.h"

@interface DeviceDiscoveryPayloadDataStructure_Tests : XCTestCase

@end

@implementation DeviceDiscoveryPayloadDataStructure_Tests


- (void)testDataWrapping
{
    NSString* UUID = @"dfhsdfhTEST";
    NSString* type = @"difhdsihgTEST";
    NSString* name = @"deiwfhiehfTEST";
    NSArray* emailAddresses = @[@"dhfhsfhgsheh@TEST.com"];
    NSString* privateKeyLabel1 = @"dhwhfhegedhfgTEST";
    NSString* privateKeyLabel2 = @"dhwhfhegedhfgTEST2";
    NSArray* privateKeyLabels = @[privateKeyLabel1, privateKeyLabel2];
    NSString* OSIdentifier = @"dhaufhuwehdwTEST";
    NSString* version = @"fjdhfidTEST";
    

    DeviceDiscoveryPayloadDataStructure* newStructure = [[DeviceDiscoveryPayloadDataStructure alloc] initWithUUID:UUID type:type name:name emailAddresses:emailAddresses privateKeyLabels:privateKeyLabels OSIdentifier:OSIdentifier version:version];
    
    XCTAssertNotNil(newStructure);
    
    NSData* parsedData = newStructure.serialisedData;
    
    XCTAssertNotNil(parsedData);
    
    
    DeviceDiscoveryPayloadDataStructure* dataStructure = [DeviceDiscoveryPayloadDataStructure deserialiseData:parsedData];
    
    XCTAssertNotNil(dataStructure);
    
    XCTAssertEqualObjects(UUID, dataStructure.UUID);
    XCTAssertEqualObjects(type, dataStructure.type);
    XCTAssertEqualObjects(name, dataStructure.name);
    XCTAssertEqualObjects(emailAddresses, dataStructure.emailAddresses);
    XCTAssertEqualObjects(privateKeyLabels, dataStructure.privateKeyLabels);
    XCTAssertEqualObjects(OSIdentifier, dataStructure.OSIdentifier);    
    XCTAssertEqualObjects(version, dataStructure.version);
}

- (void)testNilSafe
{
    DeviceDiscoveryPayloadDataStructure* dataStructure = [[DeviceDiscoveryPayloadDataStructure alloc] initWithUUID:nil type:nil name:nil emailAddresses:nil privateKeyLabels:nil OSIdentifier:nil version:nil];
    
    [dataStructure serialisedData];
}



@end
