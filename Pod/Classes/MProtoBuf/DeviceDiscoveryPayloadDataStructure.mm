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

#import "DeviceDiscoveryPayloadDataStructure.h"
#import "deviceMessages.pb.h"




@implementation DeviceDiscoveryPayloadDataStructure


- (instancetype)initWithUUID:(NSString*)UUID type:(NSString*)type name:(NSString*)name emailAddresses:(NSArray*)emailAddresses privateKeyLabels:(NSArray*)privateKeyLabels OSIdentifier:(NSString*)OSIdentifier version:(NSString*)version
{
    self = [super init];
    if (self) {
 
        [self setUUID:UUID];
    [self setType:type];
    [self setName:name];
    [self setEmailAddresses:emailAddresses];
    [self setPrivateKeyLabels:privateKeyLabels];
    [self setOSIdentifier:OSIdentifier];
    [self setVersion:version];
    }
    
    return self;
}


+ (instancetype)deserialiseData:(NSData*)data
{
    DeviceDiscoveryPayloadDataStructure* newStructure = [DeviceDiscoveryPayloadDataStructure new];
    
    mynigma::deviceDiscoveryPayload* payload = new mynigma::deviceDiscoveryPayload;
    
    payload->ParseFromArray([data bytes], (int)[data length]);
    
    
    NSString* UUID = [[NSString alloc] initWithBytes:payload->uuid().data() length:payload->uuid().size() encoding:NSUTF8StringEncoding];
    [newStructure setUUID:UUID];
    
    NSString* type = [[NSString alloc] initWithBytes:payload->type().data() length:payload->type().size() encoding:NSUTF8StringEncoding];
    [newStructure setType:type];
    
    NSString* name = [[NSString alloc] initWithBytes:payload->name().data() length:payload->name().size() encoding:NSUTF8StringEncoding];
    [newStructure setName:name];

    
    NSMutableArray* newEmailAddresses = [NSMutableArray new];
    
    for(int i = 0; i < payload->emailadresses_size(); i++)
    {
        NSString* email = [[NSString alloc] initWithBytes:payload->emailadresses(i).data() length:payload->emailadresses(i).size() encoding:NSUTF8StringEncoding];
    
        if(email)
            [newEmailAddresses addObject:email];
    }
    
    [newStructure setEmailAddresses:newEmailAddresses];
    
    
    NSMutableArray* newPrivateKeyLabels = [NSMutableArray new];
    
    for(int i = 0; i < payload->privatekeylabels_size(); i++)
    {
        NSString* keyLabel = [[NSString alloc] initWithBytes:payload->privatekeylabels(i).data() length:payload->privatekeylabels(i).size() encoding:NSUTF8StringEncoding];
        
        if(keyLabel)
            [newPrivateKeyLabels addObject:keyLabel];
    }
    
    [newStructure setPrivateKeyLabels:newPrivateKeyLabels];
    
    
    NSString* OSIdentifier = [[NSString alloc] initWithBytes:payload->osidentifier().data() length:payload->osidentifier().size() encoding:NSUTF8StringEncoding];
    [newStructure setOSIdentifier:OSIdentifier];
    
    NSString* versionString = [[NSString alloc] initWithBytes:payload->version().data() length:payload->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    if(payload)
        delete payload;
    
    return newStructure;
}


- (NSData*)serialisedData
{
    mynigma::deviceDiscoveryPayload* payload = new mynigma::deviceDiscoveryPayload;
    
    
    if(self.UUID)
        payload->set_uuid([self.UUID UTF8String]);
    
    if(self.type)
        payload->set_type([self.type UTF8String]);
    
    if(self.name)
        payload->set_name([self.name UTF8String]);
    
    for(NSString* emailAddress in self.emailAddresses)
    {
        payload->add_emailadresses([emailAddress UTF8String]);
    }
    
    for(NSString* privateKeyLabel in self.privateKeyLabels)
    {
        payload->add_privatekeylabels([privateKeyLabel UTF8String]);
    }
    
    if(self.OSIdentifier)
        payload->set_osidentifier([self.OSIdentifier UTF8String]);
    
    if(self.version)
        payload->set_version([self.version UTF8String]);
    
    
    int data_size = payload->ByteSize();
    void* backup_data = malloc(data_size);
    payload->SerializeToArray(backup_data, data_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:backup_data length:data_size];;
    free(backup_data);
    if(payload)
        delete payload;
    
    return returnData;
}




@end
