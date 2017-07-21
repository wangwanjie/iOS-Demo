//
//  TDURLConnectionChangeTracker.h
//  
//
//  Created by Adam Cox on 1/5/15.
//
//

#import "TDChangeTracker.h"

@interface TDURLConnectionChangeTracker : TDChangeTracker <NSURLSessionTaskDelegate>

// used only for testing and debugging. counts the total number of retry attempts and
// is not reset to zero with each separate request (unlike TDChangeTracker retryCount).
@property (nonatomic, readonly) NSUInteger totalRetries;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com