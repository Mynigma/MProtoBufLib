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

#import "PublicKeyDataStructure.h"



@implementation PublicKeyDataStructure


- (instancetype)initWithPublicKeyLabel:(NSString*)keyLabel encData:(NSData*)encData verData:(NSData*)verData introducesKeys:(NSArray*)introducesKeys isIntroducedByKeys:(NSArray*)isIntoducedByKeys dateAnchored:(NSDate*)dateAnchored keyForEmails:(NSArray*)emails currentForEmails:(NSArray*)currentKeyForEmails datesCurrentKeysAnchored:(NSArray*)datesCurrentKeysAnchored keyForDevices:(NSArray*)deviceUUIDs version:(NSString*)version;
{
    self = [super init];
    if (self) {
        
        [self setKeyLabel:keyLabel];
        
        [self setEncrKeyData:encData];
        [self setVerKeyData:verData];
        
        [self setIntroducesKeys:introducesKeys];
        [self setIsIntroducedByKeys:isIntoducedByKeys];
        
        [self setKeyForEmails:emails];
        [self setCurrentKeyForEmails:currentKeyForEmails];
        [self setDatesCurrentKeysAnchored:datesCurrentKeysAnchored];
        
        [self setKeyForDevices:deviceUUIDs];

        [self setDateAnchored:dateAnchored];
        
        [self setVersion:version];
    }
    return self;
}


//do this in a category instead
//don't want to have the PublicKeyData object in this library
//it belongs in the encryption lib
//- (PublicKeyData*)publicKeyData
//{
//    return [[PublicKeyData alloc] initWithKeyLabel:self.keyLabel encData:self.encrKeyData verData:self.verKeyData];
//}


+ (instancetype)deserialisedProtoBufStructure:(void*)protocPubKeyParam
{
    mynigma::publicKey* protocPubKey = (mynigma::publicKey*)protocPubKeyParam;
    
    PublicKeyDataStructure* newStructure = [PublicKeyDataStructure new];
    
    NSString* keyLabel = [[NSString alloc] initWithBytes:protocPubKey->keylabel().data() length:protocPubKey->keylabel().size() encoding:NSUTF8StringEncoding];
    [newStructure setKeyLabel:keyLabel];
    
    NSData* encrKeyData = [[NSData alloc] initWithBytes:protocPubKey->encrkeydata().data() length:protocPubKey->encrkeydata().size()];
    [newStructure setEncrKeyData:encrKeyData];
    
    NSData* verKeyData = [[NSData alloc] initWithBytes:protocPubKey->verkeydata().data() length:protocPubKey->verkeydata().size()];
    [newStructure setVerKeyData:verKeyData];
    
    NSString* versionString = [[NSString alloc] initWithBytes:protocPubKey->version().data() length:protocPubKey->version().size() encoding:NSUTF8StringEncoding];
    [newStructure setVersion:versionString];
    

    
    NSMutableArray* emailStrings = [NSMutableArray new];
    
    for(int i = 0; i < protocPubKey->keyforemails_size(); i++)
    {
        NSString* keyForEmailString = [[NSString alloc] initWithBytes:protocPubKey->keyforemails(i).data() length:protocPubKey->keyforemails(i).size() encoding:NSUTF8StringEncoding];
        
        if(keyForEmailString)
            [emailStrings addObject:keyForEmailString];
    }
    
    [newStructure setKeyForEmails:emailStrings];
    
    
    
    NSMutableArray* currentEmailStrings = [NSMutableArray new];
    
    for(int i = 0; i < protocPubKey->currentkeyforemails_size(); i++)
    {
        NSString* currentKeyForEmailString = [[NSString alloc] initWithBytes:protocPubKey->currentkeyforemails(i).data() length:protocPubKey->currentkeyforemails(i).size() encoding:NSUTF8StringEncoding];
        
        if(currentKeyForEmailString)
            [currentEmailStrings addObject:currentKeyForEmailString];
    }
    
    [newStructure setCurrentKeyForEmails:currentEmailStrings];
    
    
    
    NSMutableArray* deviceUUIDStrings = [NSMutableArray new];
    
    for(int i = 0; i < protocPubKey->keyfordeviceswithuuid_size(); i++)
    {
        NSString* deviceUUIDString = [[NSString alloc] initWithBytes:protocPubKey->keyfordeviceswithuuid(i).data() length:protocPubKey->keyfordeviceswithuuid(i).size() encoding:NSUTF8StringEncoding];
        
        if(deviceUUIDString)
            [deviceUUIDStrings addObject:deviceUUIDString];
    }
    
    [newStructure setKeyForDevices:deviceUUIDStrings];
    
    
    NSMutableArray* anchorDates = [NSMutableArray new];
    
    for(int i = 0; i < protocPubKey->datescurrentkeysanchored_size(); i++)
    {
        NSDate* anchorDate = [NSDate dateWithTimeIntervalSince1970:protocPubKey->datescurrentkeysanchored(i)];
        
        if(anchorDate)
            [anchorDates addObject:anchorDate];
    }
    
    [newStructure setDatesCurrentKeysAnchored:anchorDates];

    
    NSMutableArray* isIntroducedByKeys = [NSMutableArray new];
    
    for(int i = 0; i < protocPubKey->isintroducedbykeys_size(); i++)
    {
        NSString* introducedByKeyLabel = [[NSString alloc] initWithBytes:protocPubKey->isintroducedbykeys(i).data() length:protocPubKey->isintroducedbykeys(i).size() encoding:NSUTF8StringEncoding];
        
        if(introducedByKeyLabel)
            [isIntroducedByKeys addObject:introducedByKeyLabel];
    }
    
    [newStructure setIsIntroducedByKeys:isIntroducedByKeys];

    
    NSMutableArray* introducesKeys = [NSMutableArray new];
    
    for(int i = 0; i < protocPubKey->introduceskeys_size(); i++)
    {
        NSString* introducedKeyLabel = [[NSString alloc] initWithBytes:protocPubKey->introduceskeys(i).data() length:protocPubKey->introduceskeys(i).size() encoding:NSUTF8StringEncoding];
        
        if(introducedKeyLabel)
            [introducesKeys addObject:introducedKeyLabel];
    }
    
    [newStructure setIntroducesKeys:introducesKeys];

    [newStructure setDateAnchored:[NSDate dateWithTimeIntervalSince1970:protocPubKey->dateanchored()]];
    
    return newStructure;
}


- (void)serialiseIntoProtoBufStructure:(void*)pubKeyParam
{
    mynigma::publicKey* pubKey = (mynigma::publicKey*)pubKeyParam;
    
    if(self.keyLabel)
        pubKey->set_keylabel([self.keyLabel UTF8String]);
    
    pubKey->set_encrkeydata(self.encrKeyData.bytes, self.encrKeyData.length);
    
    pubKey->set_verkeydata(self.verKeyData.bytes, self.verKeyData.length);
    
    if(self.version)
        pubKey->set_version([self.version UTF8String]);
    
    
    for(NSString* emailString in self.keyForEmails)
    {
        pubKey->add_keyforemails([emailString?emailString:@"" UTF8String]);
    }
    
    for(NSString* currentEmailString in self.currentKeyForEmails)
    {
        pubKey->add_currentkeyforemails([currentEmailString?currentEmailString:@"" UTF8String]);
    }
    
    for(NSString* deviceUUID in self.keyForDevices)
    {
        pubKey->add_keyfordeviceswithuuid([deviceUUID UTF8String]);
    }
    
    for(NSDate* anchorDate in self.datesCurrentKeysAnchored)
    {
        pubKey->add_datescurrentkeysanchored([anchorDate timeIntervalSince1970]);
    }

    
    for(NSString* introducedKeyLabel in self.isIntroducedByKeys)
    {
        pubKey->add_isintroducedbykeys(introducedKeyLabel.UTF8String);
    }
    
    for(NSString* introducesKeyLabel in self.introducesKeys)
    {
        pubKey->add_introduceskeys(introducesKeyLabel.UTF8String);
    }
    
    pubKey->set_dateanchored(self.dateAnchored.timeIntervalSince1970);
}


@end
