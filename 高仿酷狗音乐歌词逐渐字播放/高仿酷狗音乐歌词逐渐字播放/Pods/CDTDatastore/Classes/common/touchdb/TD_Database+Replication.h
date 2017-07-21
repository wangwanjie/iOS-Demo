//
//  TD_Database+Replication.h
//  TouchDB
//
//  Created by Jens Alfke on 1/18/12.
//  Copyright (c) 2012 Couchbase, Inc. All rights reserved.
//
//  Modifications for this distribution by Cloudant, Inc., Copyright (c) 2014 Cloudant, Inc.
//

#import "TD_Database.h"
@class TDReplicator;

@interface TD_Database (Replication)

@property (readonly) NSArray* activeReplicators;

- (TDReplicator*)activeReplicatorLike:(TDReplicator*)repl;

- (void)addActiveReplicator:(TDReplicator*)repl;

- (BOOL)findMissingRevisions:(TD_RevisionList*)revs;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com