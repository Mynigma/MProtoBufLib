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

#import "FileAttachmentDataStructure.h"
#import "encryption.pb.h"

@implementation FileAttachmentDataStructure

- (instancetype)initWithFileName:(NSString*)fileName contentID:(NSString*)contentID size:(NSInteger)size hashedValue:(NSData*)hashedValue partID:(NSString*)partID remoteURL:(NSString*)remoteURL isInline:(BOOL)isInline contentType:(NSString*)contentType
{
    self = [super init];
    if (self) {
        
        self.fileName = fileName;
        self.contentID = contentID;
        self.size = size;
        self.hashedValue = hashedValue;
        self.partID = partID;
        self.remoteURL = remoteURL;
        self.isInline = isInline;
        self.contentType = contentType;
    }
    return self;
}

+ (instancetype)deserialisedProtoBufStructure:(void*)protoStructure
{
    FileAttachmentDataStructure* newStructure = [FileAttachmentDataStructure new];
    
    mynigma::payloadPart_fileAttachment* attachmentProtoStructure = (mynigma::payloadPart_fileAttachment*)protoStructure;
    
    [newStructure setFileName:[[NSString alloc] initWithBytes:attachmentProtoStructure->filename().data() length:attachmentProtoStructure->filename().size() encoding:NSUTF8StringEncoding]];
    
    [newStructure setContentID:[[NSString alloc] initWithBytes:attachmentProtoStructure->contentid().data() length:attachmentProtoStructure->contentid().size() encoding:NSUTF8StringEncoding]];
    
    [newStructure setSize:attachmentProtoStructure->size()];
   
    [newStructure setHashedValue:[[NSData alloc] initWithBytes:attachmentProtoStructure->hashedvalue().data() length:attachmentProtoStructure->hashedvalue().size()]];
    
    [newStructure setPartID:[[NSString alloc] initWithBytes:attachmentProtoStructure->partid().data() length:attachmentProtoStructure->partid().size() encoding:NSUTF8StringEncoding]];
    
    [newStructure setRemoteURL:[[NSString alloc] initWithBytes:attachmentProtoStructure->remoteurl().data() length:attachmentProtoStructure->remoteurl().size() encoding:NSUTF8StringEncoding]];

    [newStructure setIsInline:attachmentProtoStructure->isinline()];

    [newStructure setContentType:[[NSString alloc] initWithBytes:attachmentProtoStructure->contenttype().data() length:attachmentProtoStructure->contenttype().size() encoding:NSUTF8StringEncoding]];
    
    return newStructure;
}

- (void)serialiseIntoProtoBufStructure:(void*)protoStructure
{
    mynigma::payloadPart_fileAttachment* fileAttachment = (mynigma::payloadPart_fileAttachment*)protoStructure;
    
    if(self.fileName)
        fileAttachment->set_filename(self.fileName.UTF8String);
    if(self.contentID)
        fileAttachment->set_contentid(self.contentID.UTF8String);
    fileAttachment->set_size((int)self.size);
    fileAttachment->set_hashedvalue(self.hashedValue.bytes, self.hashedValue.length);
    if(self.partID)
        fileAttachment->set_partid(self.partID.UTF8String);
    if(self.remoteURL)
        fileAttachment->set_remoteurl(self.remoteURL.UTF8String);
    fileAttachment->set_isinline(self.isInline);
    if(self.contentType)
        fileAttachment->set_contenttype(self.contentType.UTF8String);
}


@end
