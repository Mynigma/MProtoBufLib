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

#import "backupData.pb.h"

#import "PlainBackupDataStructure.h"
#import "PrivateKeyDataStructure.h"
#import "PublicKeyDataStructure.h"
#import "PublicKeyDataStructure.h"
#import "KeyExpectationDataStructure.h"





@implementation PlainBackupDataStructure

- (instancetype)initWithPrivateKeys:(NSArray*)privateKeys publicKeys:(NSArray*)publicKeys keyExpectations:(NSArray*)keyExpectations integrityCheck:(NSString *)integrityCheck version:(NSString*)version
{
    self = [super init];
    if (self) {
        
        [self setPrivateKeys:privateKeys];
        
        [self setPublicKeys:publicKeys];
        
        [self setKeyExpectations:keyExpectations];
        
        [self setIntegrityCheck:integrityCheck];

        [self setVersion:version];
    }
    return self;
}

+ (instancetype)deserialiseData:(NSData*)data
{    
    PlainBackupDataStructure* newStructure = [PlainBackupDataStructure new];
    
    mynigma::plainBackupData* protocBackupData = new mynigma::plainBackupData;
    
    protocBackupData->ParseFromArray([data bytes], (int)[data length]);
    
    NSData* versionStringData = [[NSData alloc] initWithBytes:protocBackupData->version().data() length:protocBackupData->version().size()];
    NSString* versionString = [[NSString alloc] initWithData:versionStringData encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    NSMutableArray* newPrivateKeys = [NSMutableArray new];
    
    for(int i = 0; i < protocBackupData->privkeys_size(); i++)
    {
        mynigma::privateKey privKey = protocBackupData->privkeys(i);
        
        PrivateKeyDataStructure* privateKeyDataStructure = [PrivateKeyDataStructure deserialisedProtoBufStructure:&privKey];
        
        [newPrivateKeys addObject:privateKeyDataStructure];
    }
    
    [newStructure setPrivateKeys:newPrivateKeys];
    
    NSMutableArray* newPublicKeys = [NSMutableArray new];
    
    for(int i = 0; i < protocBackupData->pubkeys_size(); i++)
    {
        mynigma::publicKey pubKey = protocBackupData->pubkeys(i);
        
        PublicKeyDataStructure* publicKeyDataStructure = [PublicKeyDataStructure deserialisedProtoBufStructure:&pubKey];
        
        [newPublicKeys addObject:publicKeyDataStructure];
    }
    
    [newStructure setPublicKeys:newPublicKeys];
    
    NSMutableArray* newKeyExpectations = [NSMutableArray new];
    
    for(int i = 0; i < protocBackupData->keyexpectations_size(); i++)
    {
        mynigma::keyExpectation keyExpectation = protocBackupData->keyexpectations(i);
        
        KeyExpectationDataStructure* publicKeyDataStructure = [KeyExpectationDataStructure deserialisedProtoBufStructure:&keyExpectation];
        
        [newKeyExpectations addObject:publicKeyDataStructure];
    }
    
    [newStructure setKeyExpectations:newKeyExpectations];
    
    [newStructure setIntegrityCheck:[NSString stringWithCString:protocBackupData->integritycheckstring().data() encoding:NSUTF8StringEncoding]];
    
    if(protocBackupData)
        delete protocBackupData;
    
    return newStructure;
}

- (NSData*)serialisedData
{
    mynigma::plainBackupData* protocBackupData = new mynigma::plainBackupData;
    
    if(self.version)
        protocBackupData->set_version([self.version UTF8String]);
    
    for(PrivateKeyDataStructure* privateKeyStructure in self.privateKeys)
    {
        mynigma::privateKey* privKey = protocBackupData->add_privkeys();
        
        [privateKeyStructure serialiseIntoProtoBufStructure:privKey];
    }
    
    for(PublicKeyDataStructure* publicKeyStructure in self.publicKeys)
    {
        mynigma::publicKey* pubKey = protocBackupData->add_pubkeys();
        
        [publicKeyStructure serialiseIntoProtoBufStructure:pubKey];
    }
    
    for(KeyExpectationDataStructure* keyExpectationStructure in self.keyExpectations)
    {
        mynigma::keyExpectation* keyExpect = protocBackupData->add_keyexpectations();
        
        [keyExpectationStructure serialiseIntoProtoBufStructure:keyExpect];
    }
    
    if(self.integrityCheck)
        protocBackupData->set_integritycheckstring([self.integrityCheck UTF8String]);
    
    int data_size = protocBackupData->ByteSize();
    void* backup_data = malloc(data_size);
    protocBackupData->SerializeToArray(backup_data, data_size);
    
    
    NSData* returnData = [[NSData alloc] initWithBytes:backup_data length:data_size];;
    free(backup_data);
    if(protocBackupData)
        delete protocBackupData;
    
    return returnData;
}

@end
