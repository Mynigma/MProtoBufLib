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


#import "BackupPasswordFileWrapperDataStructure.h"

#import "backupData.pb.h"





@implementation BackupPasswordFileWrapperDataStructure

- (instancetype)initWithPayloadData:(NSData*)payloadData hasPassword:(BOOL)hasPassword salt:(NSData*)salt version:(NSString*)version
{
    self = [super init];
    if(self)
    {
        self.payloadData = payloadData;
        self.hasPassword = hasPassword;
        self.passwordSalt = salt;
        self.version = version;
    }
    return self;
}

+ (instancetype)deserialiseData:(NSData*)data
{
    BackupPasswordFileWrapperDataStructure* newStructure = [BackupPasswordFileWrapperDataStructure new];
    
    mynigma::backupPasswordFileWrapper* protocBackupData = new mynigma::backupPasswordFileWrapper;
    
    protocBackupData->ParseFromArray([data bytes], (int)[data length]);
    
    NSData* versionStringData = [[NSData alloc] initWithBytes:protocBackupData->version().data() length:protocBackupData->version().size()];
    NSString* versionString = [[NSString alloc] initWithData:versionStringData encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    
    [newStructure setHasPassword:protocBackupData->haspassword()];
    
    [newStructure setPasswordSalt:[[NSData alloc] initWithBytes:protocBackupData->passwordsalt().data() length:protocBackupData->passwordsalt().size()]];
    
    [newStructure setPayloadData:[[NSData alloc] initWithBytes:protocBackupData->payloaddata().data() length:protocBackupData->payloaddata().size()]];
    
    if(protocBackupData)
        delete protocBackupData;
    
    return newStructure;
}

- (NSData*)serialisedData
{
    mynigma::backupPasswordFileWrapper* fileWrapper = new mynigma::backupPasswordFileWrapper;
    
    fileWrapper->set_haspassword(self.hasPassword);

    fileWrapper->set_passwordsalt(self.passwordSalt.bytes, self.passwordSalt.length);
    
    fileWrapper->set_payloaddata(self.payloadData.bytes, self.payloadData.length);
    
    if(self.version)
        fileWrapper->set_version([self.version UTF8String]);
    
    int data_size = fileWrapper->ByteSize();
    void* data_buffer = malloc(data_size);
    
    fileWrapper->SerializeToArray(data_buffer, data_size);
    
    NSData* confidentialAccountsData = [[NSData alloc] initWithBytes:data_buffer length:data_size];
    
    delete fileWrapper;
    free(data_buffer);
    
    return confidentialAccountsData;
}


@end
