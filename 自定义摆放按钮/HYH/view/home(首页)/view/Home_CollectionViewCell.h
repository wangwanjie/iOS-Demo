//
//  Home_CollectionViewCell.h
//  CZYTH_04
//
//  Created by yu on 15/9/6.
//  Copyright (c) 2015年 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeBean;

@interface Home_CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_Height;//图片高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_Width;//图片宽度

@property (weak, nonatomic) IBOutlet UIImageView *imageView_Cell;//图片
@property (weak, nonatomic) IBOutlet UILabel *text_Label;//字体

@property (nonatomic,strong)HomeBean *homeBean;


@end
