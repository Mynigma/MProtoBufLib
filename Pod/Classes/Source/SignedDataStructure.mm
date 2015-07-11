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

#import "SignedDataStructure.h"
#import "encryption.pb.h"





@implementation SignedDataStructure



- (instancetype)initWithDataToBeSigned:(NSData *)dataToBeSigned signature:(NSData *)signature keyLabel:(NSString*)keyLabel version:(NSString *)version
{
    self = [super init];
    if (self) {
        self.dataToBeSigned = dataToBeSigned;
        self.signature = signature;
        self.version = version;
        self.keyLabel = keyLabel;
    }
    return self;
}



+ (instancetype)deserialiseData:(NSData*)data
{
    SignedDataStructure* newStructure = [SignedDataStructure new];
    
    mynigma::signedData* signedData = new mynigma::signedData;
    
    signedData->ParseFromArray([data bytes], (int)[data length]);
    
 
    
    NSString* versionString = [[NSString alloc] initWithBytes:signedData->version().data() length:signedData->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    NSData* signatureData = [[NSData alloc] initWithBytes:signedData->signature().data() length:signedData->signature().size()];
    [newStructure setSignature:signatureData];
    
    NSData* dataToBeSigned = [[NSData alloc] initWithBytes:signedData->data().data() length:signedData->data().size()];
    [newStructure setDataToBeSigned:dataToBeSigned];
    
    NSString* keyLabel = [[NSString alloc] initWithBytes:signedData->keylabel().data() length:signedData->keylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setKeyLabel:keyLabel];
    
    
    
    if(signedData)
        delete signedData;
    
    return newStructure;
}

- (NSData*)serialisedData
{
    mynigma::signedData* signedDataProtoStructure = new mynigma::signedData;
    
    
    if(self.version)
        signedDataProtoStructure->set_version(self.version.UTF8String);
    signedDataProtoStructure->set_signature(self.signature.bytes, self.signature.length);
    signedDataProtoStructure->set_data(self.dataToBeSigned.bytes, self.dataToBeSigned.length);
    if(self.keyLabel)
        signedDataProtoStructure->set_keylabel(self.keyLabel.UTF8String);
    
    
    int dataSize = signedDataProtoStructure->ByteSize();
    void* data = malloc(dataSize);
    signedDataProtoStructure->SerializeToArray(data, dataSize);
    
    NSData* returnData = [[NSData alloc] initWithBytes:data length:dataSize];;
    free(data);
    delete signedDataProtoStructure;
    
    return returnData;
}



@end
