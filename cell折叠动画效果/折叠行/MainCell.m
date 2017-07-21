//
//  MainCell.m
//  折叠行
//
//  Created by yangyu on 16/4/1.
//  Copyright © 2016年 yangyu. All rights reserved.
//

#import "MainCell.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width

#define HEIGHT [UIScreen mainScreen].bounds.size.height


@implementation MainCell

- (void)awakeFromNib {
    
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, WIDTH, (HEIGHT-64-44)/4)];
        self.img =photoImageView;
        [self.contentView addSubview:self.img];
        
    }
    return self;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
