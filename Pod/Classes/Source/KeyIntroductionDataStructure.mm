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

#import "KeyIntroductionDataStructure.h"
#import "encryption.pb.h"





@implementation KeyIntroductionDataStructure



- (instancetype)initWithOldKeyLabel:(NSString*)oldKeyLabel newKeyLabel:(NSString*)newKeyLabel newEncData:(NSData*)encData newVerData:(NSData*)verData date:(NSDate*)dateSigned version:(NSString*)version
{
    self = [super init];
    if (self) {
        self.theOldKeyLabel = oldKeyLabel;
        self.theNewKeyLabel = newKeyLabel;
        self.theNewEncKey = encData;
        self.theNewVerKey = verData;
        self.dateSigned = dateSigned;
        self.version = version;
    }
    return self;
}



+ (instancetype)deserialiseData:(NSData*)data
{
    KeyIntroductionDataStructure* newStructure = [KeyIntroductionDataStructure new];
    
    mynigma::keyIntroduction* keyIntroductionData = new mynigma::keyIntroduction;
    
    keyIntroductionData->ParseFromArray([data bytes], (int)[data length]);
    
    
    NSString* versionString = [[NSString alloc] initWithBytes:keyIntroductionData->version().data() length:keyIntroductionData->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    NSString* oldKeyLabel = [[NSString alloc] initWithBytes:keyIntroductionData->oldkeylabel().data() length:keyIntroductionData->oldkeylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setTheOldKeyLabel:oldKeyLabel];

    NSString* newKeyLabel = [[NSString alloc] initWithBytes:keyIntroductionData->newkeylabel().data() length:keyIntroductionData->newkeylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setTheNewKeyLabel:newKeyLabel];
    
    NSData* newEncKeyData = [[NSData alloc] initWithBytes:keyIntroductionData->newenckey().data() length:keyIntroductionData->newenckey().size()];
    [newStructure setTheNewEncKey:newEncKeyData];
    
    NSData* newVerKeyData = [[NSData alloc] initWithBytes:keyIntroductionData->newverkey().data() length:keyIntroductionData->newverkey().size()];
    [newStructure setTheNewVerKey:newVerKeyData];
    
//    NSData* signatureData = [[NSData alloc] initWithBytes:keyIntroductionData->signature().data() length:keyIntroductionData->signature().size()];
//    [newStructure setSignature:signatureData];

    [newStructure setDateSigned:[NSDate dateWithTimeIntervalSince1970:keyIntroductionData->datesigned()]];
    
    
    if(keyIntroductionData)
        delete keyIntroductionData;
    
    return newStructure;
}

- (NSData*)serialisedData
{
    mynigma::keyIntroduction* keyIntroductionProtoStructure = new mynigma::keyIntroduction;

    
    if(self.version)
        keyIntroductionProtoStructure->set_version(self.version.UTF8String);
    if(self.theOldKeyLabel)
        keyIntroductionProtoStructure->set_oldkeylabel(self.theOldKeyLabel.UTF8String);
    
    //this field is required
    if(self.theNewKeyLabel)
        keyIntroductionProtoStructure->set_newkeylabel(self.theNewKeyLabel.UTF8String);
    else
        return nil;
    
    keyIntroductionProtoStructure->set_newenckey(self.theNewEncKey.bytes, self.theNewEncKey.length);
    keyIntroductionProtoStructure->set_newverkey(self.theNewVerKey.bytes, self.theNewVerKey.length);
//    keyIntroductionProtoStructure->set_signature(self.signature.bytes, self.signature.length);
    keyIntroductionProtoStructure->set_datesigned(self.dateSigned.timeIntervalSince1970);

    
    int encrData_size = keyIntroductionProtoStructure->ByteSize();
    void* encr_data = malloc(encrData_size);
    keyIntroductionProtoStructure->SerializeToArray(encr_data, encrData_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:encr_data length:encrData_size];;
    free(encr_data);
    delete keyIntroductionProtoStructure;
    
    return returnData;
}


@end
