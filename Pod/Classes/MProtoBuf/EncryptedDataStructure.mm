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

#import "EncryptedDataStructure.h"
#import "encryption.pb.h"
#import "SessionKeyEntryDataStructure.h"



@implementation EncryptedDataStructure


//@property NSData* encrMessageData;
//@property NSArray* encrSessionKeyTable;
//@property NSString* info;
//@property NSArray* attachmentHMACs;
//@property NSData* messageHMAC;


- (instancetype)initWithEncrMessageData:(NSData*)encrMessageData encrSessionKeyTable:(NSArray*)encrSessionKeyTable info:(NSString*)info attachmentsHMACs:(NSArray*)attachmentHMACs messageHMAC:(NSData*)messageHMAC version:(NSString*)version
{
    self = [super init];
    if (self) {
        self.encrMessageData = encrMessageData;
        self.encrSessionKeyTable = encrSessionKeyTable;
        self.info = info;
        self.attachmentHMACs = attachmentHMACs;
        self.messageHMAC = messageHMAC;
        self.version = version;
    }
    return self;
}



+ (instancetype)deserialiseData:(NSData*)data
{
    EncryptedDataStructure* newStructure = [EncryptedDataStructure new];
        
    mynigma::encryptedData* encryptedData = new mynigma::encryptedData;
    
    encryptedData->ParseFromArray([data bytes], (int)[data length]);
    
    NSMutableArray* sessionKeyTable = [NSMutableArray new];
    
    for(int i=0;i<encryptedData->encrsessionkeytable_size();i++)
    {
        mynigma::encrSessionKeyEntry* entry = new mynigma::encrSessionKeyEntry;
        *entry = encryptedData->encrsessionkeytable(i);
        
        SessionKeyEntryDataStructure* sessionKeyEntry = [SessionKeyEntryDataStructure deserialisedProtoBufStructure:entry];
        
        if(entry)
            delete entry;
        
        if(sessionKeyEntry)
            [sessionKeyTable addObject:sessionKeyEntry];
    }
    
    [newStructure setEncrSessionKeyTable:sessionKeyTable];
    
    NSData* messageData = [[NSData alloc] initWithBytes:encryptedData->encrmessagedata().data() length:encryptedData->encrmessagedata().size()];
    [newStructure setEncrMessageData:messageData];

    NSData* messageHMACData = [[NSData alloc] initWithBytes:encryptedData->messagehmac().data() length:encryptedData->messagehmac().size()];
    [newStructure setMessageHMAC:messageHMACData];

    NSMutableArray* newAttachmentsHMACArray = [NSMutableArray new];
    
    for(int i=0;i<encryptedData->attachmentshmac_size();i++)
    {
        NSData* attachmentsHMACData = [[NSData alloc] initWithBytes:encryptedData->attachmentshmac(i).data() length:encryptedData->attachmentshmac(i).size()];
        
        if(attachmentsHMACData)
            [newAttachmentsHMACArray addObject:attachmentsHMACData];
    }
    
    [newStructure setAttachmentHMACs:newAttachmentsHMACArray];
    
    [newStructure setInfo:[[NSString alloc] initWithBytes:encryptedData->info().data() length:encryptedData->info().size() encoding:NSUTF8StringEncoding]];
    
    [newStructure setVersion:[[NSString alloc] initWithBytes:encryptedData->version().data() length:encryptedData->version().size() encoding:NSUTF8StringEncoding]];

    if(encryptedData)
        delete encryptedData;
    
    return newStructure;
}



- (NSData*)serialisedData
{
    mynigma::encryptedData* encryptedData = new mynigma::encryptedData;
    
    if(self.version)
        encryptedData->set_version(self.version.UTF8String);

    encryptedData->set_encrmessagedata(self.encrMessageData.bytes, self.encrMessageData.length);
    
    for(SessionKeyEntryDataStructure* sessionKeyEntry in self.encrSessionKeyTable)
    {
        mynigma::encrSessionKeyEntry* entry = encryptedData->add_encrsessionkeytable();
        
        [sessionKeyEntry serialiseIntoProtoBufStructure:entry];
    }
    
    if(self.info)
        encryptedData->set_info([self.info UTF8String]);
    
    for(NSData* attachmentHMACData in self.attachmentHMACs)
    {
        encryptedData->add_attachmentshmac(attachmentHMACData.bytes, attachmentHMACData.length);
    }
    
    if(self.version)
        encryptedData->set_version(self.version.UTF8String);
    
    encryptedData->set_messagehmac(self.messageHMAC.bytes, self.messageHMAC.length);
    
    int encrData_size = encryptedData->ByteSize();
    void* data = malloc(encrData_size);
    encryptedData->SerializeToArray(data, encrData_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:data length:encrData_size];;
    free(data);
    delete encryptedData;
    
    return returnData;
}

@end
