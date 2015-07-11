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
#import "EmailRecipientDataStructure.h"
#import "encryption.pb.h"

@interface EmailRecipientDataStructure_Tests : XCTestCase

@end

@implementation EmailRecipientDataStructure_Tests


//message emailRecipient
//{
//    optional string name = 1;
//    optional string email = 2;
//    optional addresseeType type = 3 [default = T_TO];
//}


- (void)testDataWrapping
{
    NSString* name = @"Testor Testington";
    NSString* email = @"wdefhr3ewfc4234251u@mynigma.org";
    AddresseeType type = AddresseeTypeCc;
    
    EmailRecipientDataStructure* originalStructure = [[EmailRecipientDataStructure alloc] initWithName:name emailAddress:email addresseeType:type];
    
    mynigma::payloadPart_emailRecipient* protoStructure = new mynigma::payloadPart_emailRecipient;
    
    [originalStructure serialiseIntoProtoBufStructure:protoStructure];
    
    EmailRecipientDataStructure* reparsedStructure = [EmailRecipientDataStructure deserialisedProtoBufStructure:protoStructure];
    
    XCTAssertEqualObjects(originalStructure.name, reparsedStructure.name);
    XCTAssertEqualObjects(originalStructure.email, reparsedStructure.email);
    XCTAssertEqual(originalStructure.addresseeType, reparsedStructure.addresseeType);
    
    delete protoStructure;
}

- (void)testNilSafe
{
    EmailRecipientDataStructure* dataStructure = [[EmailRecipientDataStructure alloc] initWithName:nil emailAddress:nil addresseeType:AddresseeTypeFrom];
    
    mynigma::payloadPart_emailRecipient* protoStructure = new mynigma::payloadPart_emailRecipient;
    
    [dataStructure serialiseIntoProtoBufStructure:protoStructure];
    
    delete protoStructure;
}
@end
