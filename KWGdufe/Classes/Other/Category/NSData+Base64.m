//
//  NSData+Base64.m
//  KWGdufe
//
//  Created by korwin on 2017/12/19.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "NSData+Base64.h"

@interface NSString (Base64)

- (NSString *) stringPaddedForBase64;

@end

@implementation NSString (Base64)

- (NSString *) stringPaddedForBase64 {
    NSUInteger paddedLength = self.length + (self.length % 3);
    return [self stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
}

@end

@implementation NSData (Base64)

- (instancetype) initWithBase64EncodedString:(NSString *)base64String {
    return [self initWithBase64EncodedString:[base64String stringPaddedForBase64] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
}

- (NSString *) base64EncodedString {
    return [self base64EncodedStringWithOptions:0];
}

@end
