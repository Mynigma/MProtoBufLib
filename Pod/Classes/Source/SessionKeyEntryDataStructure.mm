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

#import "SessionKeyEntryDataStructure.h"
#import "encryption.pb.h"


@implementation SessionKeyEntryDataStructure


- (instancetype)initWithKeyLabel:(NSString*)keyLabel encrSessionKeyEntry:(NSData*)encrSessionKey introductionData:(NSData*)introductionData emailAddress:(NSString*)emailAddress
{
    self = [super init];
    if (self) {
        self.keyLabel = keyLabel;
        self.encrSessionKey = encrSessionKey;
        self.introductionData = introductionData;
        self.emailAddress = emailAddress;
    }
    return self;
}


+ (instancetype)deserialisedProtoBufStructure:(void*)protoBufStructure
{
    mynigma::encrSessionKeyEntry* entry = (mynigma::encrSessionKeyEntry*)protoBufStructure;
    
    NSData* keyLabelData = [[NSData alloc] initWithBytes:entry->keylabel().data() length:entry->keylabel().size()];
    NSData* foundEncrSessionKeyData = [[NSData alloc] initWithBytes:entry->encrsessionkey().data() length:entry->encrsessionkey().size()];
    
    NSData* foundEncrIntroData = [[NSData alloc] initWithBytes:entry->introductiondata().data() length:entry->introductiondata().size()];
    
    NSString* keyLabel = [[NSString alloc] initWithData:keyLabelData encoding:NSUTF8StringEncoding];
    
    NSString* emailAddress = [[NSString alloc] initWithBytes:entry->emailaddress().data() length:entry->emailaddress().size() encoding:NSUTF8StringEncoding];
    
    SessionKeyEntryDataStructure* sessionKeyEntry = [SessionKeyEntryDataStructure new];
    
    [sessionKeyEntry setKeyLabel:keyLabel];
    [sessionKeyEntry setEncrSessionKey:foundEncrSessionKeyData];
    [sessionKeyEntry setIntroductionData:foundEncrIntroData];
    [sessionKeyEntry setEmailAddress:emailAddress];

    return sessionKeyEntry;
}

- (void)serialiseIntoProtoBufStructure:(void*)protoBufStructure
{
    mynigma::encrSessionKeyEntry* sessionKey = (mynigma::encrSessionKeyEntry*)protoBufStructure;
    
//    sessionKey->set_version([self.version UTF8String]);
    sessionKey->set_encrsessionkey(self.encrSessionKey.bytes, self.encrSessionKey.length);
    sessionKey->set_introductiondata(self.introductionData.bytes, self.introductionData.length);
    if(self.keyLabel)
        sessionKey->set_keylabel([self.keyLabel UTF8String]);
    if(self.emailAddress)
        sessionKey->set_emailaddress(self.emailAddress.UTF8String);
}



@end
