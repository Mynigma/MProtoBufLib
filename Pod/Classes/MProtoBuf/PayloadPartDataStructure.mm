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

#import "PayloadPartDataStructure.h"
#import "encryption.pb.h"
#import "EmailRecipientDataStructure.h"
#import "FileAttachmentDataStructure.h"



@implementation PayloadPartDataStructure

- (instancetype)initWithBody:(NSString*)body HTMLBody:(NSString*)HTMLBody subject:(NSString*)subject dateSent:(NSDate*)dateSent addressees:(NSArray*)addressees attachments:(NSArray*)attachments
{
    self = [super init];
    if (self) {
        
        self.body = body;
        self.HTMLBody = HTMLBody;
        self.subject = subject;
        self.dateSent = dateSent;
        self.addressees = addressees;
        self.attachments = attachments;
    }
    return self;
}

+ (instancetype)deserialiseData:(NSData*)data
{
    mynigma::payloadPart* payloadPartProtoStructure = new mynigma::payloadPart;
    
    payloadPartProtoStructure->ParseFromArray([data bytes], (int)[data length]);
    
    PayloadPartDataStructure* newStructure = [PayloadPartDataStructure new];
    
    [newStructure setBody:[[NSString alloc] initWithBytes:payloadPartProtoStructure->body().data() length:payloadPartProtoStructure->body().size() encoding:NSUTF8StringEncoding]];
    [newStructure setHTMLBody:[[NSString alloc] initWithBytes:payloadPartProtoStructure->htmlbody().data() length:payloadPartProtoStructure->htmlbody().size() encoding:NSUTF8StringEncoding]];
    [newStructure setSubject:[[NSString alloc] initWithBytes:payloadPartProtoStructure->subject().data() length:payloadPartProtoStructure->subject().size() encoding:NSUTF8StringEncoding]];
    
    NSInteger UNIXDate = payloadPartProtoStructure->datesent();
    if(UNIXDate > 0)
        [newStructure setDateSent:[NSDate dateWithTimeIntervalSince1970:UNIXDate]];
    
    NSMutableArray* newAddressees = [NSMutableArray new];
    for(int i = 0; i < payloadPartProtoStructure->recipients_size(); i++)
    {
        mynigma::payloadPart_emailRecipient recipient = payloadPartProtoStructure->recipients(i);
        
        EmailRecipientDataStructure* newRecipientStructure = [EmailRecipientDataStructure deserialisedProtoBufStructure:&recipient];
        
        [newAddressees addObject:newRecipientStructure];
    }
    [newStructure setAddressees:newAddressees];
    
    
    NSMutableArray* newAttachments = [NSMutableArray new];
    for(int i = 0; i < payloadPartProtoStructure->attachments_size(); i++)
    {
        mynigma::payloadPart_fileAttachment attachment = payloadPartProtoStructure->attachments(i);
        
        FileAttachmentDataStructure* attachmentDataStructure = [FileAttachmentDataStructure deserialisedProtoBufStructure:&attachment];
        
        [newAttachments addObject:attachmentDataStructure];
    }
    [newStructure setAttachments:newAttachments];
    
    
    if(payloadPartProtoStructure)
        delete payloadPartProtoStructure;
    
    return newStructure;
}

- (NSData*)serialisedData
{
    mynigma::payloadPart* payloadPartProtoStructure = new mynigma::payloadPart;
    
    if(self.body)
        payloadPartProtoStructure->set_body(self.body.UTF8String);
    if(self.HTMLBody)
        payloadPartProtoStructure->set_htmlbody(self.HTMLBody.UTF8String);
    if(self.subject)
        payloadPartProtoStructure->set_subject(self.subject.UTF8String);
    if(self.dateSent)
        payloadPartProtoStructure->set_datesent(self.dateSent.timeIntervalSince1970);
    
    for(EmailRecipientDataStructure* addresseeDataStructure in self.addressees)
    {
        mynigma::payloadPart_emailRecipient* newRecipient = payloadPartProtoStructure->add_recipients();
        
        [addresseeDataStructure serialiseIntoProtoBufStructure:newRecipient];
    }
    
    for(FileAttachmentDataStructure* attachmentDataStructure in self.attachments)
    {
        mynigma::payloadPart_fileAttachment* newAttachment = payloadPartProtoStructure->add_attachments();
        
        [attachmentDataStructure serialiseIntoProtoBufStructure:newAttachment];
    }
     
    int encrData_size = payloadPartProtoStructure->ByteSize();
    void* encr_data = malloc(encrData_size);
    payloadPartProtoStructure->SerializeToArray(encr_data, encrData_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:encr_data length:encrData_size];;
    free(encr_data);
    delete payloadPartProtoStructure;
    
    return returnData;
}


@end
