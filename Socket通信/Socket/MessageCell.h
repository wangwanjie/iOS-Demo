//
//  MessageCell.h
//  Socket
//
//  Created by beijingduanluo on 15/10/13.
//  Copyright (c) 2015年 beijingduanluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageCell : UITableViewCell
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)MessageModel *messageModel;
@end

