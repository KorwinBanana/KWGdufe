//
//  KeychainWrapper.h
//  KWGdufe
//
//  Created by korwin on 2017/10/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

//Define an Objective-C wrapper class to hold Keychain Services code.
@interface KeychainWrapper : NSObject {
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
}

@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end

/* ********************************************************************** */
//Unique string used to identify the keychain item:
static const UInt8 kKeychainItemIdentifier[]    = "com.apple.dts.KeychainUI\0";

@interface KeychainWrapper (PrivateMethods)


//The following two methods translate dictionaries between the format used by
// the view controller (NSString *) and the Keychain Services API:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;
// Method used to write data to the keychain:
- (void)writeToKeychain;

@end

