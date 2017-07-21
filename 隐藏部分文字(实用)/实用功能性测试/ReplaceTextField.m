//
//  ReplaceTextField.m
//  实用功能性测试
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ReplaceTextField.h"

@implementation ReplaceTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        [self addTarget:self action:@selector(textEditEvent) forControlEvents:UIControlEventAllEditingEvents];
        _rememberText = [NSMutableString string];
    }
    return self;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![string isEqualToString:@"\n"])
    {
        [(NSMutableString*)_rememberText replaceCharactersInRange:range withString:string];
    }
    return YES;
}
-(void)setFootLength:(NSInteger)footLength
{
    if (_footLength == footLength)
    {
        return;
    }
    _footLength = footLength;
    [self textEditEvent];
}
-(void)setHeadLength:(NSInteger)headLength
{
    if (_headLength == headLength)
    {
        return;
    }
    _headLength = headLength;
    [self textEditEvent];
}
-(void)textEditEvent
{
    if (_rememberText.length > (self.headLength + self.footLength))
    {
        NSMutableString *returnText = [NSMutableString string];
        [returnText appendString:[_rememberText substringToIndex:self.headLength]];
        for (NSInteger i=0; i<(_rememberText.length-(self.headLength + self.footLength)); i++)
        {
            [returnText appendString:@"*"];
        }
        [returnText appendString:[_rememberText substringFromIndex:_rememberText.length-self.footLength]];
        [self setText:returnText];
    }
    else
    {
        [self setText:_rememberText];
    }
}
@end
