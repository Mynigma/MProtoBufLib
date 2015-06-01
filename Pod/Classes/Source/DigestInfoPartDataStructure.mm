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

#import "DigestInfoPartDataStructure.h"

@implementation DigestInfoPartDataStructure

- (instancetype)initWithSyncKeyLabel:(NSString*)syncKeyLabel publicEncKeyData:(NSData*)publicKeyEncData publicVerKeyData:(NSData*)publicKeyVerData deviceUUID:(NSString*)deviceUUID secretData:(NSData*)secretData
{
    self = [super init];
    if (self) {
        
        [self setSyncKeyLabel:syncKeyLabel];
        [self setPublicEncKeyData:publicKeyEncData];
        [self setPublicVerKeyData:publicKeyVerData];
        [self setDeviceUUID:deviceUUID];
        [self setSecretData:secretData];
    }
    return self;
}

+ (instancetype)deserialisedProtoBufStructure:(void*)digestPartData
{
    DigestInfoPartDataStructure* newStructure = [DigestInfoPartDataStructure new];
    
    mynigma::digestInfoPart* digestPartProtoStructure = (mynigma::digestInfoPart*)digestPartData;
    
    NSString* syncKeyLabelString = [[NSString alloc] initWithBytes:digestPartProtoStructure->devicekeylabel().data() length:digestPartProtoStructure->devicekeylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setSyncKeyLabel:syncKeyLabelString];
    
    NSData* publicEncData = [[NSData alloc] initWithBytes:digestPartProtoStructure->publicenckeydata().data() length:digestPartProtoStructure->publicenckeydata().size()];
    [newStructure setPublicEncKeyData:publicEncData];
    
    NSData* publicVerData = [[NSData alloc] initWithBytes:digestPartProtoStructure->publicverkeydata().data() length:digestPartProtoStructure->publicverkeydata().size()];
    [newStructure setPublicVerKeyData:publicVerData];
    
    NSString* deviceUUID = [[NSString alloc] initWithBytes:digestPartProtoStructure->deviceuuid().data() length:digestPartProtoStructure->deviceuuid().size() encoding:NSUTF8StringEncoding];
    [newStructure setDeviceUUID:deviceUUID];
    
    NSData* secretData = [[NSData alloc] initWithBytes:digestPartProtoStructure->secretdata().data() length:digestPartProtoStructure->secretdata().size()];
    [newStructure setSecretData:secretData];
        
    return newStructure;
}

- (void)serialiseIntoProtoBufStructure:(void*)digestPartParam
{
    mynigma::digestInfoPart* digestDataPart = (mynigma::digestInfoPart*)digestPartParam;
    
    if(self.syncKeyLabel)
        digestDataPart->set_devicekeylabel([self.syncKeyLabel UTF8String]);
    digestDataPart->set_publicenckeydata(self.publicEncKeyData.bytes, self.publicEncKeyData.length);
    digestDataPart->set_publicverkeydata(self.publicVerKeyData.bytes, self.publicVerKeyData.length);
    if(self.deviceUUID)
        digestDataPart->set_deviceuuid([self.deviceUUID UTF8String]);
    digestDataPart->set_secretdata(self.secretData.bytes, self.secretData.length);
}




@end
