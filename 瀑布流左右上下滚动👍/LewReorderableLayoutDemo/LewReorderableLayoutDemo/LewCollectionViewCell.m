//
//  LewReorderableLayout.h
//  LewPhotoBrowser
//
//  Created by Demo群号335930567 on 16/5/18.
//  Copyright (c) 2015年 Edison. All rights reserved.
//

#import "LewCollectionViewCell.h"

@implementation LewCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundColor = [self randomColor];
}
- (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.alpha = highlighted ? 0.7f : 1.0f;
}
@end
