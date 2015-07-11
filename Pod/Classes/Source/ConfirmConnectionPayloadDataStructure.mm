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

#import "ConfirmConnectionPayloadDataStructure.h"


@implementation ConfirmConnectionPayloadDataStructure


- (instancetype)initWithSecretKeyData:(NSData*)secretKeyData version:(NSString *)version
{
    self = [super init];
    if (self) {
        
        [self setSecretKeyData:secretKeyData];
        [self setVersion:version];
    }
    
    return self;
}


+ (instancetype)deserialiseData:(NSData*)data
{
    ConfirmConnectionPayloadDataStructure* newStructure = [ConfirmConnectionPayloadDataStructure new];
    
    mynigma::confirmConnectionMessagePayload* payload = new mynigma::confirmConnectionMessagePayload;
    
    payload->ParseFromArray([data bytes], (int)[data length]);
    
    NSData* secretKeyData = [[NSData alloc] initWithBytes:payload->secretkeydata().data() length:payload->secretkeydata().size()];
    [newStructure setSecretKeyData:secretKeyData];
    
    NSString* versionString = [[NSString alloc] initWithBytes:payload->version().data() length:payload->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    return newStructure;
}


- (NSData*)serialisedData
{
    mynigma::confirmConnectionMessagePayload* payload = new mynigma::confirmConnectionMessagePayload;
    
    payload->set_secretkeydata(self.secretKeyData.bytes, self.secretKeyData.length);
    
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
