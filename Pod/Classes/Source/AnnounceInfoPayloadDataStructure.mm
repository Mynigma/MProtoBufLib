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

#import "deviceMessages.pb.h"

#import "AnnounceInfoPayloadDataStructure.h"





@implementation AnnounceInfoPayloadDataStructure


- (instancetype)initWithPublicKeyLabel:(NSString*)keyLabel encData:(NSData*)encData verData:(NSData*)verData hashData:(NSData*)hashData deviceDiscoveryPayloadData:(NSData*)deviceDiscoveryPayloadData version:(NSString*)version
{
    self = [super init];
    if (self) {
        
        if(!keyLabel || !encData || !verData || !hashData || !deviceDiscoveryPayloadData)
        {
            NSLog(@"Error creating announce info message: %@, %@, %@", keyLabel, hashData, deviceDiscoveryPayloadData);
            return nil;
        }
        
        [self setPublicKeyEncData:encData];
        [self setPublicKeyVerData:verData];
        [self setKeyLabel:keyLabel];
        [self setHashData:hashData];
        [self setDeviceDiscoveryPayloadData:deviceDiscoveryPayloadData];
        [self setVersion:version];
    }
    
    return self;
}

+ (instancetype)deserialiseData:(NSData*)data
{
    AnnounceInfoPayloadDataStructure* newStructure = [AnnounceInfoPayloadDataStructure new];
    
    mynigma::announceInfoMessagePayload* payload = new mynigma::announceInfoMessagePayload;
    
    payload->ParseFromArray([data bytes], (int)[data length]);
    
    NSData* publicKeyVerData = [[NSData alloc] initWithBytes:payload->publickeyverdata().data() length:payload->publickeyverdata().size()];
    [newStructure setPublicKeyVerData:publicKeyVerData];
    
    NSData* publicKeyEncData = [[NSData alloc] initWithBytes:payload->publickeyencdata().data() length:payload->publickeyencdata().size()];
    [newStructure setPublicKeyEncData:publicKeyEncData];
    
    NSString* keyLabel = [[NSString alloc] initWithBytes:payload->keylabel().data() length:payload->keylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setKeyLabel:keyLabel];
    
    NSData* hashData = [[NSData alloc] initWithBytes:payload->hashdata().data() length:payload->hashdata().size()];
    [newStructure setHashData:hashData];
    
    NSData* deviceDiscoveryData = [[NSData alloc] initWithBytes:payload->devicediscoverypayloaddata().data() length:payload->devicediscoverypayloaddata().size()];
    [newStructure setDeviceDiscoveryPayloadData:deviceDiscoveryData];
    
    NSString* versionString = [[NSString alloc] initWithBytes:payload->version().data() length:payload->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    if(payload)
        delete payload;

    return newStructure;
}


- (NSData*)serialisedData
{
    mynigma::announceInfoMessagePayload* payload = new mynigma::announceInfoMessagePayload;
    
    
    payload->set_publickeyverdata(self.publicKeyVerData.bytes, self.publicKeyVerData.length);
    
    payload->set_publickeyencdata(self.publicKeyEncData.bytes, self.publicKeyEncData.length);
    
    payload->set_keylabel([self.keyLabel UTF8String]);
    
    payload->set_hashdata(self.hashData.bytes, self.hashData.length);
    
    payload->set_devicediscoverypayloaddata(self.deviceDiscoveryPayloadData.bytes, self.deviceDiscoveryPayloadData.length);
    
    payload->set_version([self.version UTF8String]);
    
    
    int data_size = payload->ByteSize();
    void* data = malloc(data_size);
    payload->SerializeToArray(data, data_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:data length:data_size];;
    free(data);
    if(payload)
        delete payload;
    
    return returnData;
}




@end
