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
#import "TestHelper.h"
#import "PublicKeyDataStructure.h"


@interface PublicKeyDataStructure_Tests : XCTestCase

@end

@implementation PublicKeyDataStructure_Tests



//message publicKey
//{
//    required string keyLabel = 1;
//    required bytes encrKeyData = 2;
//    required bytes verKeyData = 3;
//    
//    optional int32 dateCreated = 6;
//    optional bool isCompromised = 7;
//    optional string version = 8;
//    
//    repeated string currentKeyForEmail = 10;
//    optional int32 dateObtained = 11;
//    optional int32 dateDeclared = 12;
//    optional bool fromServer = 13;
//    repeated string introducesKeys = 14;
//    repeated string isIntroducedByKeys = 15;
//}


- (void)testDataWrapping
{
    NSString* keyLabel = @"eurru23i3r924@mynigma.org";
    NSDate* dateAnchored = [NSDate dateWithTimeIntervalSince1970:3641534];
    NSString* version = @"2.13.0";
    NSString* introducingKey = @"intro4546846785678";
    NSString* introducedKey = @"introed34658679766878";
    NSString* currentForEmail = @"fjiwehhefud2@mynigma.org";
    
    NSNumber* index = @1;
    
    NSData* encData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_EncKey%@", index?index:@""] ofType:@"txt"]];
    NSData* verData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_VerKey%@", index?index:@""] ofType:@"txt"]];
    
    PublicKeyDataStructure* originalStructure = [[PublicKeyDataStructure alloc] initWithPublicKeyLabel:keyLabel encData:encData verData:verData introducesKeys:@[introducedKey] isIntroducedByKeys:@[introducingKey] currentKeyForEmails:@[currentForEmail] dateAnchored:dateAnchored version:version];
    
    mynigma::publicKey* protoStructure = new mynigma::publicKey;
    
    [originalStructure serialiseIntoProtoBufStructure:protoStructure];
    
    PublicKeyDataStructure* reparsedStructure = [PublicKeyDataStructure deserialisedProtoBufStructure:protoStructure];
    
    XCTAssertEqualObjects(originalStructure.keyLabel, reparsedStructure.keyLabel);
    XCTAssertEqualObjects(originalStructure.dateAnchored, reparsedStructure.dateAnchored);
    XCTAssertEqualObjects(originalStructure.version, reparsedStructure.version);
    XCTAssertEqualObjects(originalStructure.introducesKeys, reparsedStructure.introducesKeys);
    XCTAssertEqualObjects(originalStructure.isIntroducedByKeys, reparsedStructure.isIntroducedByKeys);
    XCTAssertEqualObjects(originalStructure.currentKeyForEmails, reparsedStructure.currentKeyForEmails);
    XCTAssertEqualObjects(originalStructure.isIntroducedByKeys, reparsedStructure.isIntroducedByKeys);
    
    delete protoStructure;
}

- (void)testNilSafe
{
    PublicKeyDataStructure* dataStructure = [[PublicKeyDataStructure alloc] initWithPublicKeyLabel:nil encData:nil verData:nil introducesKeys:nil isIntroducedByKeys:nil currentKeyForEmails:nil dateAnchored:nil version:nil];
    
    mynigma::publicKey* protoStructure = new mynigma::publicKey;
    
    [dataStructure serialiseIntoProtoBufStructure:protoStructure];
    
    delete protoStructure;
}


@end
