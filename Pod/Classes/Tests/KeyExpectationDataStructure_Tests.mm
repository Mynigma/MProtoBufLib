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

#import "backupData.pb.h"

#import <XCTest/XCTest.h>
#import "KeyExpectationDataStructure.h"


@interface KeyExpectationDataStructure_Tests : XCTestCase

@end

@implementation KeyExpectationDataStructure_Tests


//message keyExpectation
//{
//    optional string fromAddress = 1;
//    optional string toAddress = 2;
//    optional string keyLabel = 3;
//    optional int32 dateAnchored = 4;
//    optional string version = 5;
//}


- (void)testDataWrapping
{
    NSString* keyLabel = @"eurru23i3r924@mynigma.org";
    NSString* fromAddress = @"dfhsfhu@mynigma.org";
    NSString* toAddress = @"dhufhewuhf@mynigma.org";
    NSDate* dateAnchored = [NSDate dateWithTimeIntervalSince1970:36427534];
    NSString* version = @"2.13.0";
    
    KeyExpectationDataStructure* originalStructure = [[KeyExpectationDataStructure alloc] initWithKeyLabel:keyLabel fromAddress:fromAddress toAddress:toAddress dateAnchored:dateAnchored version:version];
    
    mynigma::keyExpectation* protoStructure = new mynigma::keyExpectation;
    
    [originalStructure serialiseIntoProtoBufStructure:protoStructure];
    
    KeyExpectationDataStructure* reparsedStructure = [KeyExpectationDataStructure deserialisedProtoBufStructure:protoStructure];
    
    XCTAssertEqualObjects(originalStructure.keyLabel, reparsedStructure.keyLabel);
    XCTAssertEqualObjects(originalStructure.fromAddress, reparsedStructure.fromAddress);
    XCTAssertEqualObjects(originalStructure.toAddress, reparsedStructure.toAddress);
    XCTAssertEqualObjects(originalStructure.dateAnchored, reparsedStructure.dateAnchored);
    XCTAssertEqualObjects(originalStructure.version, reparsedStructure.version);
    
    delete protoStructure;
}

- (void)testNilSafe
{
    KeyExpectationDataStructure* dataStructure = [[KeyExpectationDataStructure alloc] initWithKeyLabel:nil fromAddress:nil toAddress:nil dateAnchored:nil version:nil];
    
    mynigma::keyExpectation* protoStructure = new mynigma::keyExpectation;
    
    [dataStructure serialiseIntoProtoBufStructure:protoStructure];
    
    delete protoStructure;
}

@end
