//
//  ViewController.m
//  CaiDanTest
//
//  Created by KMJ on 16/8/4.
//  Copyright © 2016年 XT. All rights reserved.
//  KMJ二次加工

#define XTScreen_Height   [[UIScreen mainScreen] bounds].size.height
#define XTScreen_Width    [[UIScreen mainScreen] bounds].size.width

// 颜色
#define XTARGBColor(a, r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define XTColor(r, g, b) XTARGBColor(255, (r), (g), (b))
#define XTGrayColor(v) XTColor((v), (v), (v))
#define XTCommonBgColor XTGrayColor(215)
#define XTRandomColor XTColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#import "ViewController.h"
#import "RKTagsMenuView.h"


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) RKTagsMenuView *tagMenuView;
/** menuData */
@property (nonatomic, strong)  NSArray *tagsAry;



/** bigSV */
@property (nonatomic, weak) UIScrollView *bigSV;

/** 标记是否是第一次进入页面*/
@property (nonatomic,assign) int firstLoadPageYorN;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _firstLoadPageYorN = 12345;
    
    self.tagsAry = @[@"全部", @"市政工程", @"建设工程法规相关知识", @"建设工程经济", @"建设工程与实务", @"财经", @"科技", @"社会", @"军事", @"时尚", @"汽车", @"游戏", @"图片", @"股票"];
    
    
    [self setupMenuSv];
    
    [self setupBigScrollView];
    

    
}
/**  设置顶部滚动菜单栏*/
- (void)setupMenuSv{
    
    _tagMenuView = [[RKTagsMenuView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 40)];
    
    _tagMenuView.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    
    [_tagMenuView setTagsArray:self.tagsAry];
    [_tagMenuView setDidSelectTagBlock:^(NSInteger clickedRow) {
        NSLog(@"点击了 %@", weakSelf.tagsAry[clickedRow]);
        
        /* 根据点击的标签tag值来切换bigSV */
        CGPoint offset = weakSelf.bigSV.contentOffset;
        offset.x = [self.tagsAry indexOfObject: weakSelf.tagsAry[clickedRow]] * XTScreen_Width;
        [weakSelf.bigSV setContentOffset:offset animated:YES];
        
    }];
    
    [self.view addSubview:_tagMenuView];
    
    
    NSLog(@"Controller");
}

/** 设置大背景（ScrollView）*/
- (void)setupBigScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, XTScreen_Width, XTScreen_Height - 20 - 46)];
    scrollView.contentSize = CGSizeMake(self.tagsAry.count * XTScreen_Width, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.backgroundColor = XTRandomColor;
    self.bigSV = scrollView;
    [self.view addSubview:scrollView];
    [self scrollViewDidEndDecelerating:scrollView];
    
    /** 在这哩添加几个label 在SV上， 滑动时可以区分是否成功滑动----也可以在下面的scrollViewDidEndScrollingAnimation方法里 根据SV的contentSize的偏移量去添加控制器展示*/
    
    for (int i = 0;i<self.tagsAry.count;i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * XTScreen_Width + 30, 100, 200, 100)];
        label.backgroundColor = [UIColor yellowColor];
        label.text = self.tagsAry[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:25];
        [scrollView addSubview:label];
    }
}
/**
 *  手指拖动，减速完成时候调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        [self scrollViewDidEndScrollingAnimation:scrollView];
    
    int i = self.bigSV.contentOffset.x / XTScreen_Width;
    
    NSLog(@"i-------%d",i);
    
    if(_firstLoadPageYorN == 12345){
        
        NSLog(@"初来乍到，不用通知");
        _firstLoadPageYorN = 0;
        return;
    }
    /*用通知传值*/
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"tag":[NSString stringWithFormat:@"%d",i]};
    [center postNotificationName:@"tag" object:@"menuTitle" userInfo:dict];
    
    //    [self titleClick:self.buttons[index]];
}
/**
 *  点击指示器，动画停止时候调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    //让按钮指示器跟着走
    int index = self.bigSV.contentOffset.x / XTScreen_Width;
    NSLog(@"让指示器跟着走，gogogo");
    
    /* 预留位置--给你sv的每个分页加载控制器，可以做到预加载数据 */
    //    UIViewController *vc = self.childViewControllers[i];
    //    // bouns的x等于偏移量
    //    //    view.frame = CGRectMake(i * ScreenWidth, 0, self.scrollView.width, self.scrollView.height);
    //    //
    //    if([vc isViewLoaded]) return;
    //    vc.view.frame = self.bigSV.bounds;
    //
    //    [self.bigSV addSubview:vc.view];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
