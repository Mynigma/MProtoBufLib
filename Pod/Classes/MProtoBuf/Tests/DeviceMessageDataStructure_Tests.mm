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

#import "deviceMessages.pb.h"

#import <XCTest/XCTest.h>
#import "TestHelper.h"
#import "DeviceMessageDataStructure.h"

@interface DeviceMessageDataStructure_Tests : XCTestCase

@end

@implementation DeviceMessageDataStructure_Tests


//message deviceMessage {
//    optional string messageCommand = 1;
//    optional bytes payload = 2;
//    optional int64 sentDate = 3;
//    optional int64 expiryDate = 4;
//    optional bool burnAfterReading = 5;
//    optional string threadID = 6;
//    optional string senderUUID = 7;
//    repeated string recipientUUIDs = 8;
//    optional string version = 9;
//}


- (void)testDataWrapping
{
    NSString* messageCommand = [TestHelper sampleString:@1];
    NSData* payload = [TestHelper sampleData:@1];
    NSDate* sentDate = [TestHelper sampleDate:@1];
    NSDate* expiryDate = [TestHelper sampleDate:@2];
    BOOL burnAfterReading = NO;
    NSString* threadID = [TestHelper sampleString:@2];
    NSString* senderUUID = [TestHelper sampleString:@3];
    NSString* recipientUUID = [TestHelper sampleString:@4];
    NSString* version = [TestHelper sampleString:@5];
    
    DeviceMessageDataStructure* dataStructure = [[DeviceMessageDataStructure alloc] initWithMessageCommand:messageCommand payload:payload sentDate:sentDate expiryDate:expiryDate burnAfterReading:burnAfterReading threadID:threadID senderUUID:senderUUID recipientUUIDs:@[recipientUUID] version:version];
    
    NSData* data = dataStructure.serialisedData;
    
    DeviceMessageDataStructure* parsedDataStructure = [DeviceMessageDataStructure deserialiseData:data];
    
    XCTAssertNotNil(parsedDataStructure);
    
    XCTAssertEqualObjects(dataStructure.messageCommand, parsedDataStructure.messageCommand);
    XCTAssertEqualObjects(dataStructure.payload, parsedDataStructure.payload);
    XCTAssertEqualObjects(dataStructure.sentDate, parsedDataStructure.sentDate);
    XCTAssertEqualObjects(dataStructure.expiryDate, parsedDataStructure.expiryDate);
    XCTAssertEqual(dataStructure.burnAfterReading, parsedDataStructure.burnAfterReading);
    XCTAssertEqualObjects(dataStructure.threadID, parsedDataStructure.threadID);
    XCTAssertEqualObjects(dataStructure.senderUUID, parsedDataStructure.senderUUID);
    XCTAssertEqualObjects(dataStructure.recipientUUIDs, parsedDataStructure.recipientUUIDs);
    XCTAssertEqualObjects(dataStructure.version, parsedDataStructure.version);
}

- (void)testNilSafe
{
    DeviceMessageDataStructure* dataStructure = [[DeviceMessageDataStructure alloc] initWithMessageCommand:nil payload:nil sentDate:nil expiryDate:nil burnAfterReading:NO threadID:nil senderUUID:nil recipientUUIDs:nil version:nil];
    
    [dataStructure serialisedData];
}

@end
