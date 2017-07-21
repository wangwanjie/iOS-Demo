// Software License Agreement (BSD License)
//
// Copyright (c) 2010-2015, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Neither the name of Deusty nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission of Deusty, LLC.

/**
 * NSAsset replacement that will output a log message even when assertions are disabled.
 **/
#define DDAssert(condition, frmt, ...)                                                \
        if (!(condition)) {                                                           \
            NSString *description = [NSString stringWithFormat:frmt, ## __VA_ARGS__]; \
            DDLogError(@"%@", description);                                           \
            NSAssert(NO, description);                                                \
        }
#define DDAssertCondition(condition) DDAssert(condition, @"Condition not satisfied: %s", #condition)

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com