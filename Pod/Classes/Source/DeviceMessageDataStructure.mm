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

#import "DeviceMessageDataStructure.h"
#import "deviceMessages.pb.h"





@implementation DeviceMessageDataStructure


- (instancetype)initWithMessageCommand:(NSString*)messageCommand payload:(NSData*)payload sentDate:(NSDate*)sentDate expiryDate:(NSDate*)expiryDate burnAfterReading:(BOOL)burnAfterReading threadID:(NSString*)threadID senderUUID:(NSString*)senderUUID recipientUUIDs:(NSArray*)recipientUUIDs version:(NSString*)version
{
    self = [super init];
    if (self) {
        
        [self setMessageCommand:messageCommand];
        [self setPayload:payload];
        [self setSentDate:sentDate];
        [self setExpiryDate:expiryDate];
        [self setBurnAfterReading:burnAfterReading];
        [self setThreadID:threadID];
        [self setSenderUUID:senderUUID];
        [self setRecipientUUIDs:recipientUUIDs];
        [self setVersion:version];
    }
    
    return self;
}


+ (instancetype)deserialiseData:(NSData*)data
{
    DeviceMessageDataStructure* newStructure = [DeviceMessageDataStructure new];
    
    mynigma::deviceMessage* deviceMessageProtoStructure = new mynigma::deviceMessage;
    
    deviceMessageProtoStructure->ParseFromArray([data bytes], (int)[data length]);
    
    
    NSString* messageCommand = [[NSString alloc] initWithBytes:deviceMessageProtoStructure->messagecommand().data() length:deviceMessageProtoStructure->messagecommand().size() encoding:NSUTF8StringEncoding];
    [newStructure setMessageCommand:messageCommand];
    
    NSData* payloadData = [[NSData alloc] initWithBytes:deviceMessageProtoStructure->payload().data() length:deviceMessageProtoStructure->payload().size()];
    [newStructure setPayload:payloadData];
    
    long long unixDate = deviceMessageProtoStructure->sentdate();
    if(unixDate>0)
        [newStructure setSentDate:[NSDate dateWithTimeIntervalSince1970:unixDate]];
    
    unixDate = deviceMessageProtoStructure->expirydate();
    if(unixDate>0)
        [newStructure setExpiryDate:[NSDate dateWithTimeIntervalSince1970:unixDate]];
    
    BOOL burnAfterReading = deviceMessageProtoStructure->burnafterreading();
    [newStructure setBurnAfterReading:burnAfterReading];
    
    NSString* threadID = [[NSString alloc] initWithBytes:deviceMessageProtoStructure->threadid().data() length:deviceMessageProtoStructure->threadid().size() encoding:NSUTF8StringEncoding];
    [newStructure setThreadID:threadID];
    
    NSString* senderUUID = [[NSString alloc] initWithBytes:deviceMessageProtoStructure->senderuuid().data() length:deviceMessageProtoStructure->senderuuid().size() encoding:NSUTF8StringEncoding];
    [newStructure setSenderUUID:senderUUID];
    
    
    NSMutableArray* newRecipientUUIDs = [NSMutableArray new];
    
    for(int i = 0; i < deviceMessageProtoStructure->recipientuuids_size(); i++)
    {
        NSString* UUID = [[NSString alloc] initWithBytes:deviceMessageProtoStructure->recipientuuids(i).data() length:deviceMessageProtoStructure->recipientuuids(i).size() encoding:NSUTF8StringEncoding];
        
        if(UUID)
            [newRecipientUUIDs addObject:UUID];
    }
    
    [newStructure setRecipientUUIDs:newRecipientUUIDs];
    
    
    NSString* version = [[NSString alloc] initWithBytes:deviceMessageProtoStructure->version().data() length:deviceMessageProtoStructure->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:version];
    
    if(deviceMessageProtoStructure)
        delete deviceMessageProtoStructure;
    
    return newStructure;
}


- (NSData*)serialisedData
{
    mynigma::deviceMessage* deviceMessageProtoStructure = new mynigma::deviceMessage;
    
    
    if(self.messageCommand)
        deviceMessageProtoStructure->set_messagecommand([self.messageCommand UTF8String]);
    
    deviceMessageProtoStructure->set_payload(self.payload.bytes, self.payload.length);
    
    deviceMessageProtoStructure->set_sentdate([self.sentDate timeIntervalSince1970]);
    
    deviceMessageProtoStructure->set_expirydate([self.expiryDate timeIntervalSince1970]);
    
    deviceMessageProtoStructure->set_burnafterreading(self.burnAfterReading);
    
    if(self.threadID)
        deviceMessageProtoStructure->set_threadid([self.threadID UTF8String]);
    
    if(self.senderUUID)
        deviceMessageProtoStructure->set_senderuuid([self.senderUUID UTF8String]);
    
    for(NSString* recipientUUID in self.recipientUUIDs)
    {
        deviceMessageProtoStructure->add_recipientuuids([recipientUUID UTF8String]);
    }
    
    if(self.version)
        deviceMessageProtoStructure->set_version([self.version UTF8String]);
    
    int data_size = deviceMessageProtoStructure->ByteSize();
    void* backup_data = malloc(data_size);
    deviceMessageProtoStructure->SerializeToArray(backup_data, data_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:backup_data length:data_size];;
    free(backup_data);
    if(deviceMessageProtoStructure)
        delete deviceMessageProtoStructure;
    
    return returnData;
}





@end
