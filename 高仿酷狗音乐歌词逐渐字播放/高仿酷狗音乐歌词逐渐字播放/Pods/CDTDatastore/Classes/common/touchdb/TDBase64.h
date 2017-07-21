//
//  TDBase64.h
//  TouchDB
//
//  Created by Jens Alfke on 9/14/11.
//  Copyright (c) 2011 Couchbase, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDBase64 : NSObject
+ (NSString *)encode:(const void *)input length:(size_t)length;
+ (NSString *)encode:(NSData *)rawBytes;
+ (NSData *)decode:(const char *)string length:(size_t)inputLength;
+ (NSData *)decode:(NSString *)string;

/** Decodes the URL-safe Base64 variant that uses '-' and '_' instead of '+' and '/', and omits
 * trailing '=' characters. */
+ (NSData *)decodeURLSafe:(NSString *)string;
+ (NSData *)decodeURLSafe:(const char *)string length:(size_t)inputLength;
@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com