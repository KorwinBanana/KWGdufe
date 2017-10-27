//
//  NSData+KWAES.h
//  KWGdufe
//
//  Created by korwin on 2017/10/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (KWAES)

- (NSData*) EncryptAES: (NSString *) key;
- (NSData *) DecryptAES: (NSString *) key;

@end
