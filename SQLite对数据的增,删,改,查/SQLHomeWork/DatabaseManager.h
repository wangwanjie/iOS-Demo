//
//  DatabaseManager.h
//  SQLHomeWork
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"



@interface DatabaseManager : NSObject

+(instancetype) shareManager;

- (BOOL) addUserModel:(UserModel *) model;

- (NSArray *) queryAllModel;

- (BOOL) updateUserModel:(UserModel *) model;

- (NSArray *) queryAllModelWithName:(NSString *)username;
@end
