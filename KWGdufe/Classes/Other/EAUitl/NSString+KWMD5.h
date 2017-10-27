//
//  NSString+KWMD5.h
//  KWGdufe
//
//  Created by korwin on 2017/10/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (KWMD5)
+ (NSString *)md5To32bit:(NSString *)str;
@end
