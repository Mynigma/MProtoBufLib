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
#import "EncryptedDataStructure.h"
#import "SessionKeyEntryDataStructure.h"


@interface EncryptedDataStructure_Tests : XCTestCase

@end

@implementation EncryptedDataStructure_Tests


- (void)testDataWrapping
{
    NSData* encrMessageData = [TestHelper sampleData:@1];
    
    NSString* keyLabel = [TestHelper sampleString:@1];
    NSData* encrSessionKey = [TestHelper sampleData:@2];
    NSData* introduction = [TestHelper sampleData:@3];
    NSString* emailAddress = [TestHelper sampleString:@3];
    
    SessionKeyEntryDataStructure* entry = [[SessionKeyEntryDataStructure alloc] initWithKeyLabel:keyLabel encrSessionKeyEntry:encrSessionKey introductionData:introduction emailAddress:emailAddress];
    
    NSString* info = [TestHelper sampleString:@2];
    NSData* attachmentHMAC = [TestHelper sampleData:@4];
    NSData* messageHMAC = [TestHelper sampleData:@5];
    NSString* version = [TestHelper sampleString:@3];
    
    EncryptedDataStructure* dataStructure = [[EncryptedDataStructure alloc] initWithEncrMessageData:encrMessageData encrSessionKeyTable:@[entry] info:info attachmentsHMACs:@[attachmentHMAC] messageHMAC:messageHMAC version:version];
    
    NSData* data = dataStructure.serialisedData;
    
    EncryptedDataStructure* parsedDataStructure = [EncryptedDataStructure deserialiseData:data];
    
    XCTAssertNotNil(parsedDataStructure);
    
    XCTAssertEqualObjects(dataStructure.encrMessageData, parsedDataStructure.encrMessageData);
    XCTAssertEqualObjects([dataStructure.encrSessionKeyTable.firstObject keyLabel], [parsedDataStructure.encrSessionKeyTable.firstObject keyLabel]);
    XCTAssertEqualObjects([dataStructure.encrSessionKeyTable.firstObject encrSessionKey], [parsedDataStructure.encrSessionKeyTable.firstObject encrSessionKey]);
    XCTAssertEqualObjects([dataStructure.encrSessionKeyTable.firstObject introductionData], [parsedDataStructure.encrSessionKeyTable.firstObject introductionData]);
    XCTAssertEqualObjects(dataStructure.version, parsedDataStructure.version);
    XCTAssertEqualObjects(dataStructure.info, parsedDataStructure.info);
    XCTAssertEqualObjects(dataStructure.attachmentHMACs, parsedDataStructure.attachmentHMACs);
    XCTAssertEqualObjects(dataStructure.messageHMAC, parsedDataStructure.messageHMAC);
}

- (void)testNilSafe
{
    EncryptedDataStructure* dataStructure = [[EncryptedDataStructure alloc] initWithEncrMessageData:nil encrSessionKeyTable:nil info:nil attachmentsHMACs:nil messageHMAC:nil version:nil];
    
    [dataStructure serialisedData];
}


@end
