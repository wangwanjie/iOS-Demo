//
//  TD_Database+LocalDocs.h
//  TouchDB
//
//  Created by Jens Alfke on 1/10/12.
//  Copyright (c) 2012 Couchbase, Inc. All rights reserved.
//
//  Modifications for this distribution by Cloudant, Inc., Copyright (c) 2014 Cloudant, Inc.
//

#import "TD_Database.h"

@interface TD_Database (LocalDocs)

- (TD_Revision *)getLocalDocumentWithID:(NSString *)docID revisionID:(NSString *)revID;

- (TD_Revision *)putLocalRevision:(TD_Revision *)revision
                   prevRevisionID:(NSString *)prevRevID
                           status:(TDStatus *)outStatus;

- (TDStatus)deleteLocalDocumentWithID:(NSString *)docID revisionID:(NSString *)revID;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com