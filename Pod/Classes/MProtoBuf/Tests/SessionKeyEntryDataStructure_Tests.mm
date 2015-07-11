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

#import "encryption.pb.h"

#import <XCTest/XCTest.h>
#import "TestHelper.h"
#import "SessionKeyEntryDataStructure.h"



@interface SessionKeyEntryDataStructure_Tests : XCTestCase

@end


//message encrSessionKeyEntry
//{
//    required string keyLabel = 1;
//    required bytes encrSessionKey = 2;
//    optional bytes introductionData = 3;
//}


@implementation SessionKeyEntryDataStructure_Tests

- (void)testDataWrapping
{
    NSString* keyLabel = [TestHelper sampleString:@1];
    NSData* encrSessionKey = [TestHelper sampleData:@1];
    NSData* introductionData = [TestHelper sampleData:@2];
    NSString* emailAddress = [TestHelper sampleString:@2];
    
    SessionKeyEntryDataStructure* entryStructure = [[SessionKeyEntryDataStructure alloc] initWithKeyLabel:keyLabel encrSessionKeyEntry:encrSessionKey introductionData:introductionData emailAddress:emailAddress];
    
    mynigma::encrSessionKeyEntry* sessionKey = new mynigma::encrSessionKeyEntry;
    
    [entryStructure serialiseIntoProtoBufStructure:sessionKey];
    
    SessionKeyEntryDataStructure* reparsedStructure = [SessionKeyEntryDataStructure deserialisedProtoBufStructure:sessionKey];
    
    XCTAssertEqualObjects(entryStructure.keyLabel, reparsedStructure.keyLabel);
    XCTAssertEqualObjects(entryStructure.encrSessionKey, reparsedStructure.encrSessionKey);
    XCTAssertEqualObjects(entryStructure.introductionData, reparsedStructure.introductionData);
    XCTAssertEqualObjects(entryStructure.emailAddress, reparsedStructure.emailAddress);
    
    delete sessionKey;
}

- (void)testNilSafe
{
    SessionKeyEntryDataStructure* dataStructure = [[SessionKeyEntryDataStructure alloc] initWithKeyLabel:nil encrSessionKeyEntry:nil introductionData:nil emailAddress:nil];
    
    mynigma::encrSessionKeyEntry* sessionKey = new mynigma::encrSessionKeyEntry;
    
    [dataStructure serialiseIntoProtoBufStructure:sessionKey];
    
    delete sessionKey;
}


@end
