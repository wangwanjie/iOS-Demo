//
//  Home_CollectionViewCell.m
//  CZYTH_04
//
//  Created by yu on 15/9/6.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import "Home_CollectionViewCell.h"
#import "HomeBean.h"

@implementation Home_CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

/**
 *  谁调用就，加载谁
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self){
            // 初始化时加载collectionCell.xib文件
            NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"Home_CollectionViewCell" owner:self options:nil];
        
           // 如果路径不存在，return nil
            if (arrayOfViews.count < 1){
                    return nil;
                      }
        
            // 如果xib中view不属于UICollectionViewCell类，return nil
            if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
                     return nil;
                      }
        
            // 加载nib
            self = [arrayOfViews objectAtIndex:0];
          }
    
       return self;
}

- (void)setHomeBean:(HomeBean *)homeBean{
    
    _homeBean = homeBean;
    
    [self addCellHomeBean:homeBean];
}

/**
 *  添加数据，修改cell
 */
- (void) addCellHomeBean:(HomeBean *)homeBean{
    
    NSString *image = homeBean.image;
    NSString *text = homeBean.text;
    self.imageView_Cell.image = [UIImage imageNamed:image];
    self.text_Label.text = text;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.height;
    
    int width_int = (int) width;
    
    if(480 == width_int){
        
        self.imageView_Width.constant = 46;
        self.image_Height.constant = 48;
    }
}

@end
