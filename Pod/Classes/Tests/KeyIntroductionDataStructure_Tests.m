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
#import "KeyIntroductionDataStructure.h"
#import "TestHelper.h"





@interface KeyIntroductionDataStructure_Tests : XCTestCase

@end

@implementation KeyIntroductionDataStructure_Tests


- (void)testDataWrapping
{
    NSNumber* index = @1;
    
    NSString* newKeyLabel = @"TestKeyLabel1";
    
    NSData* encData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_EncKey%@", index?index:@""] ofType:@"txt"]];
    NSData* verData = [NSData dataWithContentsOfFile:[BUNDLE pathForResource:[NSString stringWithFormat:@"Sample_VerKey%@", index?index:@""] ofType:@"txt"]];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:12345678];
    
    NSString* version = @"testVersion";
    
    KeyIntroductionDataStructure* dataStructure = [[KeyIntroductionDataStructure alloc] initWithOldKeyLabel:@"TestKeyLabel1" newKeyLabel:newKeyLabel newEncData:encData newVerData:verData date:date version:version];
    
    NSData* parsedData = dataStructure.serialisedData;
    
    KeyIntroductionDataStructure* parsedDataStructure = [KeyIntroductionDataStructure deserialiseData:parsedData];
    
    XCTAssertNotNil(parsedDataStructure);
    
    XCTAssertEqualObjects(dataStructure.theOldKeyLabel, parsedDataStructure.theOldKeyLabel);
    XCTAssertEqualObjects(dataStructure.theNewKeyLabel, parsedDataStructure.theNewKeyLabel);
    XCTAssertEqualObjects(dataStructure.theNewEncKey, parsedDataStructure.theNewEncKey);
    XCTAssertEqualObjects(dataStructure.theNewVerKey, parsedDataStructure.theNewVerKey);
    XCTAssertEqualObjects(dataStructure.dateSigned, parsedDataStructure.dateSigned);
    XCTAssertEqualObjects(dataStructure.version, parsedDataStructure.version);
}

- (void)testNilSafe
{
    KeyIntroductionDataStructure* dataStructure = [[KeyIntroductionDataStructure alloc] initWithOldKeyLabel:nil newKeyLabel:nil newEncData:nil newVerData:nil date:nil version:nil];
    
    [dataStructure serialisedData];
}




@end
