//
//  RKTagsMenuView.m
//  RKTopTagsMenu
//
//  Created by Roki Liu on 16/3/8.
//  Copyright © 2016年 Snail. All rights reserved.
//  KMJ二次加工

#import "RKTagsMenuView.h"

#define TextWitdh(text,textHeight,font) [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.width;

#define TextHeight(text,textWidth,font) [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface RKTagsMenuView () <UIScrollViewDelegate>
{
    UIScrollView    *_scrollView;
    UILabel         *_lineLbl;
    
    NSArray         *_disposeAry;
    
    BOOL            _isOverFull;    //判断标签是否超出父视图的长度
}

@property (nonatomic,strong) UIButton *button;
/** 记录标签的数组*/
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation RKTagsMenuView


/*代码控制*/
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleArray = [NSMutableArray array];
        _tagSpace = 10.0;
        _tagOriginX = 10.0;
        
        _tagHorizontalSpace = 10.0;
        _titleSize = 17;
        _titleColor = RGBCOLOR(95, 241, 228);
        
        // 视图内容布局
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        
        //        NSLog(@" ®self.frame.size.width-------%f, self.frame.size.height------%f", self.frame.size.width, self.frame.size.height);
        
        //        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        //        NSLog(@"view");
        
    }
    return self;
}

//设置标签数组
- (void)setTagsArray:(NSArray *)tagsAry {
    
    //    NSLog(@"setTagsArray");
    
    //预先计算每个标签的宽度
    [self disposeTagsWithData:tagsAry];
    
    if (!_isOverFull) {
        //加载不可滑动的顶部标签视图
        [self loadNormalTopTagsMenuView];
        
        
    }else {
        //加载顶部标签菜单
        [self loadTagsMenuViewWithScrollView];
        
    }
}

//预先计算每个标签的宽度
- (void)disposeTagsWithData:(NSArray *)dataAry {
    
    NSMutableArray *subTags = [NSMutableArray new];//横向数组
    
    CGFloat originX = _tagOriginX;
    for (NSString *tagTitle in dataAry) {
        
        //计算每个tag的宽度
        CGSize contentSize = [tagTitle fdd_sizeWithFont:[UIFont systemFontOfSize:_titleSize] constrainedToSize:CGSizeMake(self.frame.size.width-_tagOriginX*2, MAXFLOAT)];
        
        //记录标签宽度，最后一个
        _flagLastTitleWidth = contentSize.width;
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"tagTitle"]    = tagTitle;//标签标题
        dict[@"buttonWith"]  = [NSString stringWithFormat:@"%f",contentSize.width+_tagSpace];//标签的宽度
        
        dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
        [subTags addObject:dict];
        
        _disposeAry = subTags;
        
        //标签的X坐标每次都是前一个标签的宽度+标签左右空隙+标签距下个标签的距离
        originX += contentSize.width+_tagHorizontalSpace+_tagSpace;
    }
    
    //记录标签是否超出父视图的长度
    _isOverFull = (originX  > self.frame.size.width);
    
}

#pragma mark ---加载可滑动的顶部标签菜单
- (void)loadTagsMenuViewWithScrollView {
    
    NSLog(@"加载多少次");
    
    //遍历标签数组,将标签显示在界面上,并给每个标签打上tag加以区分
    for (NSDictionary *tagDic in _disposeAry) {
        
        NSUInteger index = [_disposeAry indexOfObject:tagDic];
        
        NSString *tagTitle = tagDic[@"tagTitle"];
        CGFloat originX = [tagDic[@"originX"] floatValue];
        
        //        XTLog(@"orginX-----%f",originX);
        
        CGFloat buttonWith = [tagDic[@"buttonWith"] floatValue];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, 0, buttonWith, self.frame.size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
        [button setTitle:tagTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = _disposeAry.count+index;
        [button addTarget:self action:@selector(clickedTagBtn_Pressed:) forControlEvents:UIControlEventTouchUpInside];
        self.button = button;
        [self.titleArray addObject:self.button];
        [_scrollView addSubview:button];
        
        if (0 == index) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, self.frame.size.height-2, button.frame.size.width, 2)];
            _lineLbl.backgroundColor = [UIColor redColor];
            [_scrollView addSubview:_lineLbl];
        }
    }
    //根据最后一个标签的位置设置scrollview的contentSize
    if (_disposeAry.count > 0) {
        
        NSDictionary *tagDic = [_disposeAry lastObject];
        float originX = [tagDic[@"originX"] floatValue];
        float buttonWith = [tagDic[@"buttonWith"] floatValue];
        _scrollView.contentSize = CGSizeMake(originX+buttonWith+_tagOriginX,self.frame.size.height);
    }
    
    NSLog(@"加载顶部盗汗菜单");
    //注册接收通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //接收通知
    [center addObserver:self selector:@selector(receiveNotification:) name:@"tag" object:nil];
    
}
#pragma mark --- 通知来了
- (void)receiveNotification:(NSNotification *)notification{
    
    NSInteger num = [[notification.userInfo valueForKey:@"tag"] integerValue];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = _disposeAry.count + num;
    NSLog(@"通知来啦啦啦啦啦啦啦啦啦----®num===%ld-----%@",_disposeAry.count + num ,notification.object);
    
    //    XTLog(@"title----%@",self.titleArray);
    //
    //    self.button.tag = _disposeAry.count + num;
    
    [self clickedTagBtn_Pressed:[self.titleArray objectAtIndex:num]];
    
}

#pragma mark --- 加载不可滑动的顶部标签视图
- (void)loadNormalTopTagsMenuView {
    
    //平分的宽度
    CGFloat avgWidth = (self.frame.size.width/_disposeAry.count);
    
    for (NSDictionary *tagDic in _disposeAry) {
        
        NSUInteger index = [_disposeAry indexOfObject:tagDic];
        
        NSString *tagTitle = tagDic[@"tagTitle"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(index*avgWidth, 0, avgWidth, self.frame.size.height);
        //        button.layer.borderColor = _borderColor.CGColor;
        //        button.layer.borderWidth = _borderWidth;
        //        button.layer.masksToBounds = _masksToBounds;
        //        button.layer.cornerRadius = _cornerRadius;
        button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
        [button setTitle:tagTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = _disposeAry.count+index;
        [button addTarget:self action:@selector(clickedTagBtn_Pressed:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
        if (0 == index) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(index*avgWidth, self.frame.size.height-2, button.frame.size.width, 2)];
            _lineLbl.backgroundColor = [UIColor redColor];
            [_scrollView addSubview:_lineLbl];
        }
    }
}

#pragma mark ---点击标签按钮触发事件
- (void)clickedTagBtn_Pressed:(UIButton *)sender {
    
    NSLog(@"sender----%@",sender);
    
    if (_isOverFull) {
        
        NSLog(@"_isOverFull----%d",_isOverFull);
        
        [self adjustScrollViewContentX:sender];
    }
    
    //重置所有标签按钮的选中状态
    [self resetButtonSelectStatus];
    sender.selected = YES;
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self moveSelectStatusLineAtBtn:sender];
    
    if (self.didSelectTagBlock) {
        
        self.didSelectTagBlock(sender.tag - _disposeAry.count);
        
    }
}

#pragma mark --- 将点击的标签显示到视图中间（边上的除外）

#pragma mark --- 改变点击标签将要显示的位置
- (void)adjustScrollViewContentX:(UIButton *)sender {
    
    NSLog(@"sender--adjustScrollViewContentX--%@",sender);
    
    
    //判断点击的标签位置与之前选中的标签之间距离是否超过半屏
    if (sender.frame.origin.x - _scrollView.contentOffset.x > self.frame.size.width/2.0f) {
        
        if (_scrollView.contentSize.width - sender.frame.origin.x-sender.frame.size.width/2.0f > self.frame.size.width/2.0f) {
            [_scrollView setContentOffset:CGPointMake(sender.frame.origin.x-(self.frame.size.width -sender.frame.size.width)/2.0, 0)  animated:YES];
        } else {
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width-self.frame.size.width, 0)  animated:YES];
        }
    }
    
    if (sender.frame.origin.x - _scrollView.contentOffset.x < self.frame.size.width/2.0f) {
        
        if (sender.frame.origin.x + sender.frame.size.width/2.0f > self.frame.size.width/2.0f) {
            [_scrollView setContentOffset:CGPointMake(sender.frame.origin.x-(self.frame.size.width -sender.frame.size.width)/2.0, 0)  animated:YES];
        }else {
            [_scrollView setContentOffset:CGPointMake(0, 0)  animated:YES];
        }
    }
}

#pragma mark - 设置按钮的点击状态

//取消标签按钮的选中状态
- (void)setButtonUnSelect:(UIButton *)sender {
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:sender.tag];
    lastButton.selected = NO;
}

//设置标签按钮的选中状态
- (void)moveSelectStatusLineAtBtn:(UIButton *)sender {
    //滑动选中按钮
    [UIView animateWithDuration:0.25 animations:^{
        
        [_lineLbl setFrame:CGRectMake(sender.frame.origin.x, self.frame.size.height-2, sender.frame.size.width, 2)];
        [_lineLbl bringSubviewToFront:self];
        
    } completion:^(BOOL finished) {
        
        NSLog(@"finish----sender.tag--%ld",(long)sender.tag);
    }];
}

//重置所有标签按钮的选中状态
- (void)resetButtonSelectStatus {
    
    for(UIView*view in _scrollView.subviews){
        
        if([view isKindOfClass:[UIButton class]]){
            UIButton*tempBtn = (UIButton*)view;
            [tempBtn setSelected:NO];
            [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
#pragma mark --- 移除通知
-(void)dealloc
{
    //移除通知中心
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end

#pragma mark - 扩展方法

@implementation NSString (FDDExtention)

- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    return resultSize;
}

@end
