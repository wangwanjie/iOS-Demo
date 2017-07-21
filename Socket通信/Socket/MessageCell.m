//
//  MessageCell.m
//  Socket
//
//  Created by beijingduanluo on 15/10/13.
//  Copyright (c) 2015年 beijingduanluo. All rights reserved.
//

#import "MessageCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation MessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *headImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        headImg.layer.cornerRadius = 10;
        headImg.layer.masksToBounds = YES;
        [self addSubview:headImg];
        self.headImg = headImg;
        headImg.backgroundColor =[UIColor redColor];
        
        _messageLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 0)];
        _messageLabel.layer.cornerRadius =5;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.layer.masksToBounds = YES;
        _messageLabel.backgroundColor =[UIColor colorWithRed:0.7741 green:0.9193 blue:1.0 alpha:1.0];
        [self addSubview:_messageLabel];
    }
    return self;
}
-(void)setMessageModel:(MessageModel *)messageModel
{
    if (_messageModel != messageModel) {
        _messageModel = messageModel;
    }
    _messageLabel.text = messageModel.message;
    CGRect rect = [_messageLabel.text boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    if ([_messageModel.state isEqualToString:@"0"]) {
        _messageLabel.frame = CGRectMake(SCREEN_WIDTH-rect.size.width-80, 10, rect.size.width+10, rect.size.height+15);
        CGFloat heigh = _messageLabel.center.y;
        
        _headImg.frame = CGRectMake(SCREEN_WIDTH-50, heigh-20, 40, 40);
        
    }
    if ([_messageModel.state isEqualToString:@"1"]){
        _messageLabel.frame = CGRectMake(60, 10,rect.size.width+10, rect.size.height+15);
        CGFloat heigh = _messageLabel.center.y;
        _headImg.frame = CGRectMake(10, heigh-20, 40, 40);
    }
    

}









@end
