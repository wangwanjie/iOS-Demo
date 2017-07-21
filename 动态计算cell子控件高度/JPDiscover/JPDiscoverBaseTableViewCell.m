//
//  JPDiscoverBaseTableViewCell.m
//  JPDiscover
//
//  Created by Jasper on 16/3/27.
//  Copyright © 2016年 Jasper. All rights reserved.
//

#import "JPDiscoverBaseTableViewCell.h"

@implementation JPDiscoverBaseTableViewCell

-(void)loadDataSourceWithIndexPath:(NSIndexPath *)indexPath{
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

+ (CGFloat)countHeightWithGroupCellModel:(JPDiscoverModel *)model width:(CGFloat)width{
    return 0.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //自动布局
    CGFloat maxYOrigin = 0;
    for (JPDiscoverCellBaseModule *currModule in _modules) {
        currModule.frame = CGRectMake(0, maxYOrigin, CGRectGetWidth(self.frame), currModule.height);
        maxYOrigin = CGRectGetMaxY(currModule.frame);
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com