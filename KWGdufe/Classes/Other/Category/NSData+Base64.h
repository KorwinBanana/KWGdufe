//
//  NSData+Base64.h
//  KWGdufe
//
//  Created by korwin on 2017/12/19.
//  Copyright © 2017年 korwin. All rights reserved.
//



@interface NSData (Base64)

/**
 Returns a data object initialized with the given Base-64 encoded string.
 @param base64String A Base-64 encoded NSString
 @returns A data object built by Base-64 decoding the provided string. Returns nil if the data object could not be decoded.
 */
- (instancetype) initWithBase64EncodedString:(NSString *)base64String;

/**
 Create a Base-64 encoded NSString from the receiver's contents
 @returns A Base-64 encoded NSString
 */
- (NSString *) base64EncodedString;

@end
