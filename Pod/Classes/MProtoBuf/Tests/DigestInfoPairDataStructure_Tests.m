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

#import <XCTest/XCTest.h>
#import "TestHelper.h"
#import "DigestInfoPairDataStructure.h"
#import "DigestInfoPartDataStructure.h"




@interface DigestInfoPairDataStructure_Tests : XCTestCase

@end

@implementation DigestInfoPairDataStructure_Tests


//message digestInfoPart {
//    optional bytes publicVerKeyData = 1;
//    optional bytes publicEncKeyData = 2;
//    optional bytes secretData = 3;
//    optional string deviceUUID = 4;
//    optional string deviceKeyLabel = 5;
//}

- (void)testDataWrapping
{
    NSString* keyLabel1 = @"TestKeyLabel1";

    NSNumber* index = @1;

    NSData* encData1 = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_EncKey%@", index?index:@""] ofType:@"txt"]];
    NSData* verData1 = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_VerKey%@", index?index:@""] ofType:@"txt"]];
    
    NSString* keyLabel2 = @"TestKeyLabel2";
    
    index = @2;

    NSData* encData2 = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_EncKey%@", index?index:@""] ofType:@"txt"]];
    NSData* verData2 = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_VerKey%@", index?index:@""] ofType:@"txt"]];
    
    DigestInfoPartDataStructure* initiatorPart = [[DigestInfoPartDataStructure alloc] initWithSyncKeyLabel:keyLabel1 publicEncKeyData:encData1 publicVerKeyData:verData1 deviceUUID:@"testDeviceUUID34242342" secretData:[@"euhwfuefdw" dataUsingEncoding:NSUTF8StringEncoding]];
    
    DigestInfoPartDataStructure* responderPart = [[DigestInfoPartDataStructure alloc] initWithSyncKeyLabel:keyLabel2 publicEncKeyData:encData2 publicVerKeyData:verData2 deviceUUID:@"testDeviceUUID354634742" secretData:[@"rgkreogewfa" dataUsingEncoding:NSUTF8StringEncoding]];
    
    DigestInfoPairDataStructure* dataStructure = [[DigestInfoPairDataStructure alloc] initWithInitiatorDataStructure:initiatorPart responderDataStructure:responderPart];
    
    NSData* data = dataStructure.serialisedData;
    
    DigestInfoPairDataStructure* parsedStructure = [DigestInfoPairDataStructure deserialiseData:data];
    
    DigestInfoPartDataStructure* parsedInitiatorPart = parsedStructure.initiatorDataStructure;
    DigestInfoPartDataStructure* parsedResponderPart = parsedStructure.responderDataStructure;
 
    XCTAssertEqualObjects(initiatorPart.syncKeyLabel, parsedInitiatorPart.syncKeyLabel);
    XCTAssertEqualObjects(initiatorPart.publicEncKeyData, parsedInitiatorPart.publicEncKeyData);
    XCTAssertEqualObjects(initiatorPart.publicVerKeyData, parsedInitiatorPart.publicVerKeyData);
    XCTAssertEqualObjects(initiatorPart.deviceUUID, parsedInitiatorPart.deviceUUID);
    XCTAssertEqualObjects(initiatorPart.secretData, parsedInitiatorPart.secretData);

    XCTAssertEqualObjects(responderPart.syncKeyLabel, parsedResponderPart.syncKeyLabel);
    XCTAssertEqualObjects(responderPart.publicEncKeyData, parsedResponderPart.publicEncKeyData);
    XCTAssertEqualObjects(responderPart.publicVerKeyData, parsedResponderPart.publicVerKeyData);
    XCTAssertEqualObjects(responderPart.deviceUUID, parsedResponderPart.deviceUUID);
    XCTAssertEqualObjects(responderPart.secretData, parsedResponderPart.secretData);
}

- (void)testNilSafe
{
    DigestInfoPairDataStructure* dataStructure = [[DigestInfoPairDataStructure alloc] initWithInitiatorDataStructure:nil responderDataStructure:nil];
    
    [dataStructure serialisedData];
}


@end
