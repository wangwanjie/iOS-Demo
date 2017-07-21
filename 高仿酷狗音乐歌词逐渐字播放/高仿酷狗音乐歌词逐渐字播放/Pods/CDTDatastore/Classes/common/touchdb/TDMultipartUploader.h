//
//  TDMultipartUploader.h
//  TouchDB
//
//  Created by Jens Alfke on 2/5/12.
//  Copyright (c) 2012 Couchbase, Inc. All rights reserved.
//

#import "TDRemoteRequest.h"
#import "TDMultipartWriter.h"

@interface TDMultipartUploader : TDRemoteRequest {
   @private
    TDMultipartWriter *_multipartWriter;
}

- (instancetype)initWithSession:(CDTURLSession*) session URL:(NSURL *)url
                       streamer:(TDMultipartWriter *)writer
                 requestHeaders:(NSDictionary *)requestHeaders
                   onCompletion:(TDRemoteRequestCompletionBlock)onCompletion;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com