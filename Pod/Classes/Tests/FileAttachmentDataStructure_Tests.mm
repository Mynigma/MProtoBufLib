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
#import "FileAttachmentDataStructure.h"
#import "encryption.pb.h"



@interface FileAttachmentDataStructure_Tests : XCTestCase

@end

@implementation FileAttachmentDataStructure_Tests


//message fileAttachment
//{
//    optional string filename = 1;
//    optional string contentID = 2;
//    optional int32 size = 3;
//    optional bytes hashedValue = 4;
//    optional string partID = 5;
//    optional string remoteURL = 6;
//    optional bool isInline = 7 [default = false];
//    optional string contentType = 8;
//}


- (void)testDataWrapping
{
    NSString* fileName = @"dfhhe31eqwdaWDwds.txt";
    NSString* contentID = @"dfhsfh34234251u@mynigma.org";
    NSInteger size = 13;
    NSData* hashedValue = [TestHelper sampleData:@1];
    NSString* partID = @"1.3.5";
    NSString* remoteURL = @"test://mynigma.org";
    BOOL isInline = YES;
    NSString* contentType = @"application/mynigma-test";
    
    FileAttachmentDataStructure* originalStructure = [[FileAttachmentDataStructure alloc] initWithFileName:fileName contentID:contentID size:size hashedValue:hashedValue partID:partID remoteURL:remoteURL isInline:isInline contentType:contentType];
    
    mynigma::payloadPart_fileAttachment* protoStructure = new mynigma::payloadPart_fileAttachment;
    
    [originalStructure serialiseIntoProtoBufStructure:protoStructure];
    
    FileAttachmentDataStructure* reparsedStructure = [FileAttachmentDataStructure deserialisedProtoBufStructure:protoStructure];
    
    XCTAssertEqualObjects(originalStructure.fileName, reparsedStructure.fileName);
    XCTAssertEqualObjects(originalStructure.contentID, reparsedStructure.contentID);
    XCTAssertEqual(originalStructure.size, reparsedStructure.size);
    XCTAssertEqualObjects(originalStructure.hashedValue, reparsedStructure.hashedValue);
    XCTAssertEqualObjects(originalStructure.partID, reparsedStructure.partID);
    XCTAssertEqualObjects(originalStructure.remoteURL, reparsedStructure.remoteURL);
    XCTAssertEqual(originalStructure.isInline, reparsedStructure.isInline);
    XCTAssertEqualObjects(originalStructure.contentType, reparsedStructure.contentType);
    
    delete protoStructure;
}

- (void)testNilSafe
{
    FileAttachmentDataStructure* dataStructure = [[FileAttachmentDataStructure alloc] initWithFileName:nil contentID:nil size:0 hashedValue:nil partID:nil remoteURL:nil isInline:NO contentType:nil];
    
    mynigma::payloadPart_fileAttachment* protoStructure = new mynigma::payloadPart_fileAttachment;
    
    [dataStructure serialiseIntoProtoBufStructure:protoStructure];
    
    delete protoStructure;
}



@end
