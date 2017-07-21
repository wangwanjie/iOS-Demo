//
//  Target.h
//  MYUtilities
//
//  Created by Jens Alfke on 2/11/08.
//  Copyright 2008 Jens Alfke. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MYTarget : NSObject
{
    id _invocations;    // May be an NSInvocation, or an NSMutableArray of them
}

+ (MYTarget*) targetWithReceiver: (id)receiver action: (SEL)action;

- (void) addTarget: (MYTarget*)target;

- (id) invokeWithSender: (id)sender;

@end


#define $target(RCVR,METHOD)    [MYTarget targetWithReceiver: (RCVR) action: @selector(METHOD)]
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com