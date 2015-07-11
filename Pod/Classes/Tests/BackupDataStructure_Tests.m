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
#import "BackupDataStructure.h"
#import "KeyExpectationDataStructure.h"
#import "PublicKeyDataStructure.h"
#import "PrivateKeyDataStructure.h"




@interface BackupDataStructure_Tests : XCTestCase

@end

@implementation BackupDataStructure_Tests



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
    
    PrivateKeyDataStructure* privateKeyDataStructure = [[PrivateKeyDataStructure alloc] initWithPrivateKeyLabel:keyLabel encData:encData verData:verData decData:decData sigData:sigData dateAnchored:dateAnchored isCompromised:isCompromised currentForEmails:@[currentForEmail] version:version];

    keyLabel = @"sdfu23i3r924@mynigma.org";
    dateAnchored = [NSDate dateWithTimeIntervalSince1970:36201534];
    version = @"2.03.0";
    NSString* introducingKey = @"intro45dfsdf46846785678";
    NSString* introducedKey = @"introed3fg341244658679766878";
    currentForEmail = @"fjiwefdf23hhefud2@mynigma.org";
    
    index = @2;
    
    encData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_EncKey%@", index?index:@""] ofType:@"txt"]];
    verData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_VerKey%@", index?index:@""] ofType:@"txt"]];
    
    PublicKeyDataStructure* publicKeyDataStructure = [[PublicKeyDataStructure alloc] initWithPublicKeyLabel:keyLabel encData:encData verData:verData introducesKeys:@[introducedKey] isIntroducedByKeys:@[introducingKey] currentKeyForEmails:@[currentForEmail] dateAnchored:dateAnchored version:version];

    
    KeyExpectationDataStructure* keyExpectation = [[KeyExpectationDataStructure alloc] initWithKeyLabel:@"TestKeyLabel2" fromAddress:@"testAddress1@myngima.org" toAddress:@"testAddress2@myngima.org" dateAnchored:[NSDate dateWithTimeIntervalSince1970:4353425] version:@"TestVersion3423400"];
    
    version = @"SomeVersion4r346547";
    
    BackupDataStructure* originalStructure = [[BackupDataStructure alloc] initWithPrivateKeys:@[privateKeyDataStructure] publicKeys:@[publicKeyDataStructure] keyExpectations:@[keyExpectation] version:version];
    
    XCTAssertNotNil(originalStructure);
    
    NSData* parsedData = originalStructure.serialisedData;
    
    XCTAssertNotNil(parsedData);
    
    BackupDataStructure* reparsedStructure = [BackupDataStructure deserialiseData:parsedData];
    
    XCTAssertNotNil(reparsedStructure);
    
    PrivateKeyDataStructure* reparsedPrivateKeyDataStructure = reparsedStructure.privateKeys.firstObject;
    
    XCTAssertEqualObjects(privateKeyDataStructure.keyLabel, reparsedPrivateKeyDataStructure.keyLabel);
    XCTAssertEqualObjects(privateKeyDataStructure.encrKeyData, reparsedPrivateKeyDataStructure.encrKeyData);
    XCTAssertEqualObjects(privateKeyDataStructure.verKeyData, reparsedPrivateKeyDataStructure.verKeyData);
    XCTAssertEqualObjects(privateKeyDataStructure.decrKeyData, reparsedPrivateKeyDataStructure.decrKeyData);
    XCTAssertEqualObjects(privateKeyDataStructure.signKeyData, reparsedPrivateKeyDataStructure.signKeyData);
    XCTAssertEqualObjects(privateKeyDataStructure.dateAnchored, reparsedPrivateKeyDataStructure.dateAnchored);
    XCTAssertEqualObjects(privateKeyDataStructure.version, reparsedPrivateKeyDataStructure.version);
    XCTAssertEqual(privateKeyDataStructure.isCompromised, reparsedPrivateKeyDataStructure.isCompromised);
    XCTAssertEqualObjects(privateKeyDataStructure.currentKeyForEmails, reparsedPrivateKeyDataStructure.currentKeyForEmails);

    
    PublicKeyDataStructure* reparsedPublicKeyDataStructure = reparsedStructure.publicKeys.firstObject;
    
    XCTAssertEqualObjects(publicKeyDataStructure.keyLabel, reparsedPublicKeyDataStructure.keyLabel);
    XCTAssertEqualObjects(publicKeyDataStructure.dateAnchored, reparsedPublicKeyDataStructure.dateAnchored);
    XCTAssertEqualObjects(publicKeyDataStructure.version, reparsedPublicKeyDataStructure.version);
    XCTAssertEqualObjects(publicKeyDataStructure.introducesKeys, reparsedPublicKeyDataStructure.introducesKeys);
    XCTAssertEqualObjects(publicKeyDataStructure.isIntroducedByKeys, reparsedPublicKeyDataStructure.isIntroducedByKeys);
    XCTAssertEqualObjects(publicKeyDataStructure.currentKeyForEmails, reparsedPublicKeyDataStructure.currentKeyForEmails);
    XCTAssertEqualObjects(publicKeyDataStructure.isIntroducedByKeys, reparsedPublicKeyDataStructure.isIntroducedByKeys);

    
    KeyExpectationDataStructure* reparsedKeyExpectation = reparsedStructure.keyExpectations.firstObject;;
    
    XCTAssertEqualObjects(keyExpectation.keyLabel, reparsedKeyExpectation.keyLabel);
    XCTAssertEqualObjects(keyExpectation.fromAddress, reparsedKeyExpectation.fromAddress);
    XCTAssertEqualObjects(keyExpectation.toAddress, reparsedKeyExpectation.toAddress);
    XCTAssertEqualObjects(keyExpectation.dateAnchored, reparsedKeyExpectation.dateAnchored);
    XCTAssertEqualObjects(keyExpectation.version, reparsedKeyExpectation.version);

    XCTAssertEqualObjects(version, reparsedStructure.version);
}


- (void)testNilSafe
{
    BackupDataStructure* dataStructure = [[BackupDataStructure alloc] initWithPrivateKeys:nil publicKeys:nil keyExpectations:nil version:nil];
    
    [dataStructure serialisedData];
}

@end
