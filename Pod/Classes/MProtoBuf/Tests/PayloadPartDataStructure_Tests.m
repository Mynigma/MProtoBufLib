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
#import "EmailRecipientDataStructure.h"
#import "FileAttachmentDataStructure.h"
#import "PayloadPartDataStructure.h"

@interface PayloadPartDataStructure_Tests : XCTestCase

@end

@implementation PayloadPartDataStructure_Tests


//message payloadPart {
//    optional string body = 1;
//    optional string htmlBody = 2;
//    required string subject = 3;
//    optional int32 dateSent = 4;
//    optional bytes declaration = 7;
//
//    enum addresseeType {
//        T_FROM = 0;
//        T_REPLY_TO = 1;
//        T_TO = 2;
//        T_CC = 3;
//        T_BCC = 4;
//    }
//
//    repeated emailRecipient recipients = 5;
//
//    repeated fileAttachment attachments = 6;
//}


- (void)testDataWrapping
{
    NSString* body = @"Test body";
    NSString* HTMLBody = @"Test HTML body";
    NSString* subject = @"Test subject";
    NSDate* dateSent = [TestHelper sampleDate:@1];

    EmailRecipientDataStructure* emailRecipient = [[EmailRecipientDataStructure alloc] initWithName:@"Testina Testonia" emailAddress:@"testEmail327487@mynigma.org" addresseeType:AddresseeTypeBcc];
    
    FileAttachmentDataStructure* attachment = [[FileAttachmentDataStructure alloc] initWithFileName:@"testFileName.png" contentID:@"testContentID342643@mynigma.org" size:13 hashedValue:[TestHelper sampleData:@1] partID:@"1.7.3" remoteURL:@"test://testURL.mynigma.org" isInline:YES contentType:@"test/content-type"];
    
    PayloadPartDataStructure* dataStructure = [[PayloadPartDataStructure alloc] initWithBody:body HTMLBody:HTMLBody subject:subject dateSent:dateSent addressees:@[emailRecipient] attachments:@[attachment]];
    
    NSData* data = dataStructure.serialisedData;
    
    PayloadPartDataStructure* reparsedStructure = [PayloadPartDataStructure deserialiseData:data];
    
    XCTAssertEqualObjects(dataStructure.body, reparsedStructure.body);
    XCTAssertEqualObjects(dataStructure.HTMLBody, reparsedStructure.HTMLBody);
    XCTAssertEqualObjects(dataStructure.subject, reparsedStructure.subject);
    XCTAssertEqualObjects(dataStructure.dateSent, reparsedStructure.dateSent);
    
    EmailRecipientDataStructure* reparsedEmailRecipient = reparsedStructure.addressees.firstObject;
    
    XCTAssertEqualObjects(emailRecipient.name, reparsedEmailRecipient.name);
    XCTAssertEqualObjects(emailRecipient.email, reparsedEmailRecipient.email);
    XCTAssertEqual(emailRecipient.addresseeType, reparsedEmailRecipient.addresseeType);
    
    FileAttachmentDataStructure* reparsedAttachment = reparsedStructure.attachments.firstObject;
    
    XCTAssertEqualObjects(attachment.fileName, reparsedAttachment.fileName);
    XCTAssertEqualObjects(attachment.contentID, reparsedAttachment.contentID);
    XCTAssertEqual(attachment.size, reparsedAttachment.size);
    XCTAssertEqualObjects(attachment.hashedValue, reparsedAttachment.hashedValue);
    XCTAssertEqualObjects(attachment.partID, reparsedAttachment.partID);
    XCTAssertEqualObjects(attachment.remoteURL, reparsedAttachment.remoteURL);
    XCTAssertEqual(attachment.isInline, reparsedAttachment.isInline);
    XCTAssertEqualObjects(attachment.contentType, reparsedAttachment.contentType);
}

- (void)testNilSafe
{
    //subject is a required field
    PayloadPartDataStructure* dataStructure = [[PayloadPartDataStructure alloc] initWithBody:nil HTMLBody:nil subject:@"Test subject" dateSent:nil addressees:nil attachments:nil];
    
    [dataStructure serialisedData];
}


@end
