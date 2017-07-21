//
//  TDMultipartDownloader.h
//  TouchDB
//
//  Created by Jens Alfke on 1/31/12.
//  Copyright (c) 2012 Couchbase, Inc. All rights reserved.
//

#import "TDRemoteRequest.h"
@class TDMultipartDocumentReader, TD_Database;

/** Downloads a remote CouchDB document in multipart format.
    Attachments are added to the database, but the document body isn't. */
@interface TDMultipartDownloader : TDRemoteRequest {
   @private
    TD_Database* _db;
    TDMultipartDocumentReader* _reader;
}

- (instancetype)initWithSession:(CDTURLSession*) session
                            URL:(NSURL *)url
                       database:(TD_Database *)database
                 requestHeaders:(NSDictionary *)requestHeaders
                   onCompletion:(TDRemoteRequestCompletionBlock)onCompletion;

@property (readonly) NSDictionary* document;

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com