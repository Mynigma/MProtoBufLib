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
#import "PrivateKeyDataStructure.h"



@interface PrivateKeyDataStructure_Tests : XCTestCase

@end

@implementation PrivateKeyDataStructure_Tests

- (void)testDataWrapping
{
    NSString* keyLabel = @"eurru23i3r924@mynigma.org";
    NSDate* dateAnchored = [NSDate dateWithTimeIntervalSince1970:3641534];
    NSString* version = @"2.13.0";
    NSString* currentForEmail = @"fjiwehhefud2@mynigma.org";
    BOOL isCompromised = NO;
    
    NSNumber* index = @1;
    
    NSData* encData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_EncKey%@", index?index:@""] ofType:@"txt"]];
    NSData* verData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_VerKey%@", index?index:@""] ofType:@"txt"]];
    NSData* decData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_DecKey%@", index?index:@""] ofType:@"txt"]];
    NSData* sigData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_SigKey%@", index?index:@""] ofType:@"txt"]];
    
    PrivateKeyDataStructure* originalStructure = [[PrivateKeyDataStructure alloc] initWithPrivateKeyLabel:keyLabel encData:encData verData:verData decData:decData sigData:sigData dateAnchored:dateAnchored isCompromised:isCompromised currentForEmails:@[currentForEmail] version:version];
    
    mynigma::privateKey* protoStructure = new mynigma::privateKey;
    
    [originalStructure serialiseIntoProtoBufStructure:protoStructure];
    
    PrivateKeyDataStructure* reparsedStructure = [PrivateKeyDataStructure deserialisedProtoBufStructure:protoStructure];
    
    XCTAssertEqualObjects(originalStructure.keyLabel, reparsedStructure.keyLabel);
    XCTAssertEqualObjects(originalStructure.encrKeyData, reparsedStructure.encrKeyData);
    XCTAssertEqualObjects(originalStructure.verKeyData, reparsedStructure.verKeyData);
    XCTAssertEqualObjects(originalStructure.decrKeyData, reparsedStructure.decrKeyData);
    XCTAssertEqualObjects(originalStructure.signKeyData, reparsedStructure.signKeyData);
    XCTAssertEqualObjects(originalStructure.dateAnchored, reparsedStructure.dateAnchored);
    XCTAssertEqualObjects(originalStructure.version, reparsedStructure.version);
    XCTAssertEqual(originalStructure.isCompromised, reparsedStructure.isCompromised);
    XCTAssertEqualObjects(originalStructure.currentKeyForEmails, reparsedStructure.currentKeyForEmails);
    
    delete protoStructure;
}

- (void)testNilSafe
{
    PrivateKeyDataStructure* dataStructure = [[PrivateKeyDataStructure alloc] initWithPrivateKeyLabel:nil encData:nil verData:nil decData:nil sigData:nil dateAnchored:nil isCompromised:NO currentForEmails:nil version:nil];
    
    mynigma::privateKey* protoStructure = new mynigma::privateKey;
    
    [dataStructure serialiseIntoProtoBufStructure:protoStructure];
    
    delete protoStructure;
}

@end
