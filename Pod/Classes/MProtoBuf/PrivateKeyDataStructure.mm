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

#import "PrivateKeyDataStructure.h"
#import "PublicKeyDataStructure.h"
#import "PrivateKeyDataStructure.h"




@implementation PrivateKeyDataStructure

- (instancetype)initWithPrivateKeyLabel:(NSString*)keyLabel encData:(NSData*)encData verData:(NSData*)verData decData:(NSData*)decData sigData:(NSData*)sigData dateAnchored:(NSDate*)dateAnchored isCompromised:(BOOL)isCompromised keyForEmails:(NSArray*)emails currentForEmails:(NSArray*)currentKeyForEmails datesCurrentKeysAnchored:(NSArray*)datesCurrentKeysAnchored keyForDevices:(NSArray*)deviceUUIDs version:(NSString*)version;
{
    self = [super init];
    if (self) {
        
        [self setKeyLabel:keyLabel];
        
        [self setEncrKeyData:encData];
        [self setVerKeyData:verData];

        [self setDecrKeyData:decData];
        [self setSignKeyData:sigData];
        
        [self setDateAnchored:dateAnchored];
        [self setIsCompromised:isCompromised];
        
        [self setKeyForEmails:emails];
        [self setCurrentKeyForEmails:currentKeyForEmails];
        [self setDatesCurrentKeysAnchored:datesCurrentKeysAnchored];
        
        [self setKeyForDevices:deviceUUIDs];
        
        [self setVersion:version];
    }
    return self;
}

//- (PrivateKeyData*)privateKeyData;
//{
//    PrivateKeyData* privateKeyData = [[PrivateKeyData alloc] initWithKeyLabel:self.keyLabel decData:self.decrKeyData sigData:self.signKeyData encData:self.encrKeyData verData:self.verKeyData];
//
//    return privateKeyData;
//}

+ (instancetype)deserialisedProtoBufStructure:(void*)protocPrivKeyParam
{
    mynigma::privateKey* protocPrivKey = (mynigma::privateKey*)protocPrivKeyParam;
    
    PrivateKeyDataStructure* newStructure = [PrivateKeyDataStructure new];
    
    NSString* keyLabel = [[NSString alloc] initWithBytes:protocPrivKey->keylabel().data() length:protocPrivKey->keylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setKeyLabel:keyLabel];

    NSData* decrKeyData = [[NSData alloc] initWithBytes:protocPrivKey->decrkeydata().data() length:protocPrivKey->decrkeydata().size()];
    [newStructure setDecrKeyData:decrKeyData];
    
    NSData* signKeyData = [[NSData alloc] initWithBytes:protocPrivKey->signkeydata().data() length:protocPrivKey->signkeydata().size()];
    [newStructure setSignKeyData:signKeyData];
   
    NSData* encrKeyData = [[NSData alloc] initWithBytes:protocPrivKey->encrkeydata().data() length:protocPrivKey->encrkeydata().size()];
    [newStructure setEncrKeyData:encrKeyData];
    
    NSData* verKeyData = [[NSData alloc] initWithBytes:protocPrivKey->verkeydata().data() length:protocPrivKey->verkeydata().size()];
    [newStructure setVerKeyData:verKeyData];
    
    NSString* versionString = [[NSString alloc] initWithBytes:protocPrivKey->version().data() length:protocPrivKey->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    

    
    NSMutableArray* emailStrings = [NSMutableArray new];
    
    for(int i = 0; i < protocPrivKey->keyforemails_size(); i++)
    {
        NSString* keyForEmailString = [[NSString alloc] initWithBytes:protocPrivKey->keyforemails(i).data() length:protocPrivKey->keyforemails(i).size() encoding:NSUTF8StringEncoding];
        
        if(keyForEmailString)
            [emailStrings addObject:keyForEmailString];
    }
    
    [newStructure setKeyForEmails:emailStrings];

    
    
    NSMutableArray* currentEmailStrings = [NSMutableArray new];
    
    for(int i = 0; i < protocPrivKey->currentkeyforemails_size(); i++)
    {
        NSString* currentKeyForEmailString = [[NSString alloc] initWithBytes:protocPrivKey->currentkeyforemails(i).data() length:protocPrivKey->currentkeyforemails(i).size() encoding:NSUTF8StringEncoding];
        
        if(currentKeyForEmailString)
            [currentEmailStrings addObject:currentKeyForEmailString];
    }
    
    [newStructure setCurrentKeyForEmails:currentEmailStrings];
  
    
    
    NSMutableArray* deviceUUIDStrings = [NSMutableArray new];
    
    for(int i = 0; i < protocPrivKey->keyfordeviceswithuuid_size(); i++)
    {
        NSString* deviceUUIDString = [[NSString alloc] initWithBytes:protocPrivKey->keyfordeviceswithuuid(i).data() length:protocPrivKey->keyfordeviceswithuuid(i).size() encoding:NSUTF8StringEncoding];
        
        if(deviceUUIDString)
            [deviceUUIDStrings addObject:deviceUUIDString];
    }
    
    [newStructure setKeyForDevices:deviceUUIDStrings];

    
    NSMutableArray* anchorDates = [NSMutableArray new];
    
    for(int i = 0; i < protocPrivKey->datescurrentkeysanchored_size(); i++)
    {
        NSDate* anchorDate = [NSDate dateWithTimeIntervalSince1970:protocPrivKey->datescurrentkeysanchored(i)];
        
        if(anchorDate)
            [anchorDates addObject:anchorDate];
    }
    
    [newStructure setDatesCurrentKeysAnchored:anchorDates];
    
    
    
    NSInteger UNIXDate = protocPrivKey->dateanchored();
    if(UNIXDate>0)
        [newStructure setDateAnchored:[NSDate dateWithTimeIntervalSince1970:UNIXDate]];
    
    return newStructure;
}

- (void)serialiseIntoProtoBufStructure:(void*)privKeyParam
{
    mynigma::privateKey* privKey = (mynigma::privateKey*)privKeyParam;

    privKey->set_keylabel([self.keyLabel?self.keyLabel:@"" UTF8String]);
    
    privKey->set_decrkeydata(self.decrKeyData.bytes, self.decrKeyData.length);
    
    privKey->set_signkeydata(self.signKeyData.bytes, self.signKeyData.length);
    
    privKey->set_encrkeydata(self.encrKeyData.bytes, self.encrKeyData.length);
    
    privKey->set_verkeydata(self.verKeyData.bytes, self.verKeyData.length);
    
    privKey->set_version([self.version?self.version:@"" UTF8String]);
    
    for(NSString* emailString in self.keyForEmails)
    {
        privKey->add_keyforemails([emailString?emailString:@"" UTF8String]);
    }

    for(NSString* currentEmailString in self.currentKeyForEmails)
    {
        privKey->add_currentkeyforemails([currentEmailString?currentEmailString:@"" UTF8String]);
    }
    
    for(NSString* deviceUUID in self.keyForDevices)
    {
        privKey->add_keyfordeviceswithuuid([deviceUUID UTF8String]);
    }
    
    for(NSDate* anchorDate in self.datesCurrentKeysAnchored)
    {
        privKey->add_datescurrentkeysanchored([anchorDate timeIntervalSince1970]);
    }
    
    privKey->set_dateanchored([self.dateAnchored timeIntervalSince1970]);
}


@end
