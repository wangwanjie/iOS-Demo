//
//  MessageModel.h
//  Socket
//
//  Created by beijingduanluo on 15/10/13.
//  Copyright (c) 2015年 beijingduanluo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *date;
@end
