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

#import "DigestInfoPairDataStructure.h"
#import "DigestInfoPartDataStructure.h"
#import "deviceMessages.pb.h"





@implementation DigestInfoPairDataStructure


- (instancetype)initWithInitiatorDataStructure:(DigestInfoPartDataStructure*)initiatorDataStructure responderDataStructure:(DigestInfoPartDataStructure*)responderDataStructure
{
    self = [super init];
    if (self) {
        
        [self setInitiatorDataStructure:initiatorDataStructure];
        [self setResponderDataStructure:responderDataStructure];
    }
    return self;
}

+ (instancetype)deserialiseData:(NSData*)data
{
    mynigma::digestInfoPair* digestChunksProtoStructure = new mynigma::digestInfoPair;
    
    digestChunksProtoStructure->ParseFromArray([data bytes], (int)[data length]);
    
    DigestInfoPairDataStructure* newStructure = [DigestInfoPairDataStructure new];
        
    
    mynigma::digestInfoPart initiatorPartProtoData = digestChunksProtoStructure->initiatordigestdata();
    DigestInfoPartDataStructure* initiatorPart = [DigestInfoPartDataStructure deserialisedProtoBufStructure:&initiatorPartProtoData];
    [newStructure setInitiatorDataStructure:initiatorPart];
    
    mynigma::digestInfoPart responderPartProtoData = digestChunksProtoStructure->responderdigestdata();
    DigestInfoPartDataStructure* responderPart = [DigestInfoPartDataStructure deserialisedProtoBufStructure:&responderPartProtoData];
    [newStructure setResponderDataStructure:responderPart];
    
    
    if(digestChunksProtoStructure)
        delete digestChunksProtoStructure;
    
    return newStructure;
}

- (NSData*)serialisedData
{
    mynigma::digestInfoPair* digestDataProtoStructure = new mynigma::digestInfoPair;
    
    mynigma::digestInfoPart* initiatorPart = digestDataProtoStructure->mutable_initiatordigestdata();
    [self.initiatorDataStructure serialiseIntoProtoBufStructure:initiatorPart];
    
    mynigma::digestInfoPart* responderPart = digestDataProtoStructure->mutable_responderdigestdata();
    [self.responderDataStructure serialiseIntoProtoBufStructure:responderPart];

    int encrData_size = digestDataProtoStructure->ByteSize();
    void* encr_data = malloc(encrData_size);
    digestDataProtoStructure->SerializeToArray(encr_data, encrData_size);
    
    NSData* returnData = [[NSData alloc] initWithBytes:encr_data length:encrData_size];;
    free(encr_data);
    delete digestDataProtoStructure;
    
    return returnData;
}



@end
