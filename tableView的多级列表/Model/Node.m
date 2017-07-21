//
//  Node.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 majunjie. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand{
    self = [self init];
    if (self) {
        self.parentId = parentId; //  父节点的id， 如果伟－1表示该节点为根节点
        self.nodeId = nodeId;  // 本节点的id
        self.name = name; // 本节点的名字
        self.depth = depth;  // 该节点的深度
        self.expand = expand;  // 该节点现在是否处于展开状态
    }
    return self;
}

@end
