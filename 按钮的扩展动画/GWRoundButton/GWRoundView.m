//
//  GWRoundView.m
//  GWRoundButton
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GWRoundView.h"

@interface GWRoundView (){
    
    CGFloat _Width;
    CGFloat _Height;

}

//中心按钮中心点，中心圆和周围圆的圆心距，圆心夹角，
@property(nonatomic,assign)CGPoint btnCenter;
@property(nonatomic,assign)CGFloat R;
@property(nonatomic,assign)CGFloat angle;


@end

@implementation GWRoundView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setRoundButton];
    }
    return self;
}


-(void)setRoundButton{
    
    _Width = self.frame.size.width;
    _Height = self.frame.size.height;
    
    CGFloat n=7; //小圆的个数
    self.angle = 2*M_PI/n;
    CGFloat a = 10; //小圆的间距
    self.R = 90; //中心圆和周围圆的圆心距
    CGFloat r = self.R*sinf(self.angle/2.0)-a/2.0; //小圆的半径
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(_Width/2-40, _Width/2-40, 80, 80);
    button.tag = 300;
    button.layer.cornerRadius = 80/2;
    //button.backgroundColor = [UIColor redColor];
    [button setTitle:@"世界" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"earth"] forState:UIControlStateNormal];
    self.btnCenter = button.center;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    NSArray *array = @[@"亚洲",@"欧洲",@"北美",@"南美",@"大洋",@"非洲",@"南极"];
    for (int i=0; i<n; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 0, 2*r, 2*r);
        btn.center = self.btnCenter;
        btn.tag = 100+i;
        btn.alpha = 0;
        btn.layer.cornerRadius = r;
        //btn.backgroundColor = [UIColor yellowColor];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg1"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg2"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected = YES;
        }
        [self addSubview:btn];
    }
    
    //把中心按钮永远放在父视图最上层
    [self bringSubviewToFront:button];
    
    
}

//所有button的点击事件
-(void)buttonClick:(UIButton *)button{
    
    if (button.tag==300) {
        
        if (button.selected == NO) {
            [UIView animateWithDuration:0.3 animations:^{
                button.center = self.btnCenter;
            }];
            [UIView animateWithDuration:1 animations:^{
                for (int i=0; i<7; i++) {
                    UIButton *btn = (UIButton *)[self viewWithTag:i+100];
                    CGFloat x = self.R * cosf(self.angle * i) +self.btnCenter.x;
                    CGFloat y = self.R * sinf(self.angle * i) + self.btnCenter.y;
                    btn.center = CGPointMake(x ,y);
                    btn.alpha = 1;
                }
            }];
        }else{
            [UIView animateWithDuration:1 animations:^{
                for (int i=0; i<7; i++) {
                    UIButton *btn = (UIButton *)[self viewWithTag:i+100];
                    btn.center = self.btnCenter;
                    btn.alpha = 0;
                }
            }];
            //[self startTimer];
        }
        button.selected = !button.selected;
    }else if (button.tag>=100&&button.tag<107){
        button.selected = YES;
        [self selectChangedWithTag:button.tag];
        
        //
        [self selectDataWithNumber:button.tag-100.0];
    }
}

//点击按钮后，上一个按钮改变状态
-(void)selectChangedWithTag:(NSInteger)tag{
    for (int i=100; i<107; i++) {
        if (i==tag) {
            
        }else{
            UIButton *button = (UIButton *)[self viewWithTag:i];
            button.selected = NO;
        }
    }
}


//根据点击按钮的不同，进行不同的操作
-(void)selectDataWithNumber:(int)index{
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
