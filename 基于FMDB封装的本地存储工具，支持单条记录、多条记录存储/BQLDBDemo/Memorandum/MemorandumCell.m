//
//  MemorandumCell.m
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "MemorandumCell.h"
#import "MemorandumModel.h"
#import "BQLElseTool.h"

@implementation MemorandumCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)setModel:(MemorandumModel *)model {
    
    _model = model;
    self.noteContent.text = model.notecontent;
    NSString *timeStr = checkObjectNotNull(model.notetime)?[model.notetime substringToIndex:10]:@"";
    if(![timeStr isEqualToString:getTodayDate(@"YYYY/MM/dd")]){ // 昨天及之前的日期
        self.noteTime.text = timeStr;
    }
    else{ // 今日编辑
        NSString *todayTime = [model.notetime substringWithRange:NSMakeRange(11, 5)];
        self.noteTime.text = todayTime;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
