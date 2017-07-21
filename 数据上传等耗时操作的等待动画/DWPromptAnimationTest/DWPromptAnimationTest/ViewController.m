//
//  ViewController.m
//  DWPromptAnimationTest
//
//  Created by dwang_sui on 16/8/26.
//  Copyright © 2016年 dwang_sui. All rights reserved.
//

#import "ViewController.h"
#import "DWPromptAnimation.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) DWPromptAnimation *animation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    table.delegate = self;
    
    table.dataSource = self;
    
    table.tableHeaderView = view;
    
    [self.view addSubview:table];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Sources1.gif";
        
    }
    if (indexPath.row == 1) {
        
        cell.textLabel.text = @"Sources2.gif";
        
    }
    if (indexPath.row == 2) {
        
        cell.textLabel.text = @"Sources3.gif";
        
    }
    if (indexPath.row == 3) {
        
        cell.textLabel.text = @"Sources4.gif";
        
    }
    if (indexPath.row == 4) {
        
        cell.textLabel.text = @"Sources5.gif";
        
    }
    if (indexPath.row == 5) {
        
        cell.textLabel.text = @"Sources6.gif";
        
    }
    if (indexPath.row == 6) {
        
        cell.textLabel.text = @"Sources7.gif";
        
    }
    if (indexPath.row == 7) {
        
        cell.textLabel.text = @"序列帧-Sources1";
        
    }
    if (indexPath.row == 8) {
        
        cell.textLabel.text = @"序列帧-Sources2";
        
    }
    if (indexPath.row == 9) {
        
        cell.textLabel.text = @"序列帧-Sources3";
        
    }
    if (indexPath.row == 10) {
        
        cell.textLabel.text = @"序列帧-Sources4";
        
    }
    if (indexPath.row == 11) {
        
        cell.textLabel.text = @"序列帧-Sources5";
        
    }
    if (indexPath.row == 12) {
        
        cell.textLabel.text = @"序列帧-Sources6";
        
    }
    if (indexPath.row == 13) {
        
        cell.textLabel.text = @"序列帧-Sources7";
        
    }
    if (indexPath.row == 14) {
        
        cell.textLabel.text = @"自定义加载动画frame";
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.animation.animationPicturesRect = CGRectMake(self.view.center.x-self.view.frame.size.width/4, self.view.center.y-self.view.frame.size.width/4, self.view.frame.size.width/2, self.view.frame.size.width/2);
    
    self.animation.clipsToBounds = YES;
    
    if (indexPath.row == 0) {
        
        self.animation.alpha = 0.8;
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources1];
        
    }
    if (indexPath.row == 1) {
        
        self.animation.alpha = 0;
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources2];
        
    }
    if (indexPath.row == 2) {
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources3];
        
    }
    if (indexPath.row == 3) {
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources4];
        
    }
    if (indexPath.row == 4) {
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources5];
        
    }
    if (indexPath.row == 5) {
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources6];
        
    }
    if (indexPath.row == 6) {
        
        self.animation.animationPicturesViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFSources:sources7];
        
    }
    if (indexPath.row == 7) {
        
        self.animation.alpha = 0.8;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence1];
        
    }
    if (indexPath.row == 8) {
        
        self.animation.alpha = 0;
        
        self.animation.animationDuration = 0.1;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence2];
        
    }
    if (indexPath.row == 9) {
        
        self.animation.alpha = 0.8;
        
        self.animation.animationDuration = 0.2;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence3];
        
    }
    if (indexPath.row == 10) {
        
        self.animation.animationPicturesViewColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        
        self.animation.animationDuration = 0.1;
        
        self.animation.promptWords = @"我是提示文字!!!";
        
        self.animation.textColor = [UIColor blackColor];
        
        self.animation.font = 23;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence4];
        
    }
    if (indexPath.row == 11) {
        
        self.animation.alpha = 0.8;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence5];
        
    }
    if (indexPath.row == 12) {
        
        self.animation.alpha = 0.8;
        
        self.animation.animationDuration = 0.03;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence6];
        
    }
    if (indexPath.row == 13) {
        
        self.animation.alpha = 0.8;
        
        self.animation.animationDuration = 0.03;
        
        [self.animation dw_ShowPromptAnimation:self.view SequenceSources:sequence7];
        
    }
    if (indexPath.row == 14) {
        
        self.animation.animationPicturesRect = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 150);
        
        self.animation.clipsToBounds = NO;
        
        [self.animation dw_ShowPromptGIFAnimation:self.view GIFName:@"CustomSources14.gif"];
        
    }
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:3.25];
}

- (DWPromptAnimation *)animation {
    
    if (!_animation) {
        
        _animation = [[DWPromptAnimation alloc] init];
        
    }
    
    return _animation;
}


- (void)dismiss {
    
    [DWPromptAnimation dw_stopPromptAnimation];
    
    
}

@end
