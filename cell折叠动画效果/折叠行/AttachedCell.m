//
//  AttachedCell.m
//  折叠行
//
//  Created by yangyu on 16/4/1.
//  Copyright © 2016年 yangyu. All rights reserved.
//

#import "AttachedCell.h"
#import "UIButton+create.h"

@implementation AttachedCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIButton *b1 = [UIButton createButtonWithFrame:CGRectMake (10, 10, 70, 30) Title:@"B1" Target:self Selector:@selector(Button:)];
        b1.tag = 1;
        
        UIButton *b2 = [UIButton createButtonWithFrame:CGRectMake (70, 10, 70, 30) Title:@"B2" Target:self Selector:@selector(Button:)];
        b2.tag = 2;
        
        UIButton *b3 = [UIButton createButtonWithFrame:CGRectMake(130, 10, 70, 30) Title:@"B3" Target:self Selector:@selector(Button:)];
        b3.tag = 3;
        
        UIButton *b4 = [UIButton createButtonWithFrame:CGRectMake(190, 10, 70, 30) Title:@"B4" Target:self Selector:@selector(Button:)];
        b4.tag = 4;
        
        UIButton *b5 = [UIButton createButtonWithFrame:CGRectMake(250, 10, 70, 30) Title:@"B5" Target:self Selector:@selector(Button:)];
        b5.tag = 5;
        
        UIButton *b6 = [UIButton createButtonWithFrame:CGRectMake(10, 30, 70, 30) Title:@"B6" Target:self Selector:@selector(Button:)];
        b6.tag = 6;

        UIButton *b7 = [UIButton createButtonWithFrame:CGRectMake(70, 30, 70, 30) Title:@"B7" Target:self Selector:@selector(Button:)];
        b7.tag = 7;

        UIButton *b8 = [UIButton createButtonWithFrame:CGRectMake(130, 30, 70, 30) Title:@"B8" Target:self Selector:@selector(Button:)];
        b8.tag = 8;

        UIButton *b9 = [UIButton createButtonWithFrame:CGRectMake(190, 30, 70, 30) Title:@"B9" Target:self Selector:@selector(Button:)];
        b9.tag = 9;

        UIButton *b10 = [UIButton createButtonWithFrame:CGRectMake(255, 30, 70, 30) Title:@"B10" Target:self Selector:@selector(Button:)];
        b10.tag = 10;

        
        [self.contentView addSubview:b1];
        [self.contentView addSubview:b2];
        [self.contentView addSubview:b3];
        [self.contentView addSubview:b4];
        [self.contentView addSubview:b5];
        [self.contentView addSubview:b6];
        [self.contentView addSubview:b7];
        [self.contentView addSubview:b8];
        [self.contentView addSubview:b9];
        [self.contentView addSubview:b10];
    
    
        
        
    
    
    
     }
    return self;
    
    
}
- (IBAction)Button:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
            case 2:
        {
            
        }
            break;
            case 3:
        {
            
        }
            break;
            case 4:
        {
            
        }
                    default:
            break;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
