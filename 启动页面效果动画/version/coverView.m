//
//  coverView.m
//  version
//
//  Created by zhou on 16/6/14.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import "coverView.h"

@interface coverView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//更新的内容

@end

@implementation coverView

+ (instancetype)coverLoad
{
    return [[[NSBundle mainBundle] loadNibNamed:@"cover" owner:nil options:nil] lastObject];
}

- (void)contentUpdateUI:(NSString *)content
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5.0f];
    CGFloat textWidth = self.contentLabel.bounds.size.width;
    NSInteger leng = textWidth;
    if (attStr.length < textWidth) {
        leng = attStr.length;
    }
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng)];
    //Label获取attStr式样
    self.contentLabel.attributedText = attStr;
    [self.contentLabel sizeToFit];
    
//    NSLog(@"%lf",self.contentLabel.bounds.size.height);
    
    CGFloat h = 115 + self.contentLabel.bounds.size.height;
    
    if ([self.delegate respondsToSelector:@selector(coverView:andWithHegiht:)]) {
        [self.delegate coverView:self andWithHegiht:h];
    }
}
//关闭
- (IBAction)close:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(closeCoverView:)]) {
        [self.delegate closeCoverView:self];
    }
}
//更新
- (IBAction)updateBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(updateCoverView:)]) {
        [self.delegate updateCoverView:self];
    }
}

@end
