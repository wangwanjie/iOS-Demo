#import "PureHandProjectViewController.h"
#import "ZHStroyBoardToPureHandProject.h"

@interface PureHandProjectViewController ()

@property (weak, nonatomic) IBOutlet UIButton *importButton;

@property (weak, nonatomic) IBOutlet UIButton *OkButton;

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *viewControllerArrM;

@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;

@property (nonatomic,copy)NSString *path;
@end


@implementation PureHandProjectViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.OkButton cornerRadius];
    [self.importButton cornerRadiusWithFloat:25];
    self.promoteLabel.numberOfLines=0;
    self.promoteLabel.text=@"温馨提示:转换期间会复制一份备份(可能要花一定的时间)";
    
    [self.importButton addTarget:self action:@selector(importAction) forControlEvents:1<<6];
    [self.OkButton addTarget:self action:@selector(OkAction) forControlEvents:1<<6];
    
    self.OkButton.enabled=NO;
    self.OkButton.backgroundColor=[UIColor grayColor];
    
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"使用简介" TintColor:[UIColor redColor] target:self action:@selector(helpAction)];
    [TabBarAndNavagation setRightBarButtonItemTitle:@"更多功能" TintColor:[UIColor redColor] target:self action:@selector(moreFuncAction)];
    
    self.title=@"转换成纯手写工程";
}

- (void)helpAction{
    [TabBarAndNavagation pushViewController:@"HelpViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
}
- (void)moreFuncAction{
    [TabBarAndNavagation pushViewController:@"MoreFunctionViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
}

- (void)OkAction{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在检测工程...";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL result=[self checkProject];
        if (result) {
            hud.labelText = [NSString stringWithFormat:@"检测完成,正在备份(%@)...",[ZHFileManager fileSizeString:self.path]];
        }else{
            hud.labelText = @"无可视界面控件,为空工程,或纯手写工程";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            return ;
        }
        
        //备份工程
        //有后缀的文件名
        NSString *tempFileName=[ZHFileManager getFileNameFromFilePath:self.path];
        
        //无后缀的文件名
        NSString *fileName=[ZHFileManager getFileNameNoPathComponentFromFilePath:self.path];
        
        //获取无文件名的路径
        NSString *newFilePath=[self.path stringByReplacingOccurrencesOfString:tempFileName withString:@""];
        //拿到新的有后缀的文件名
        tempFileName=[tempFileName stringByReplacingOccurrencesOfString:fileName withString:[NSString stringWithFormat:@"%@备份",fileName]];
        
        newFilePath = [newFilePath stringByAppendingPathComponent:tempFileName];
        
        if([ZHFileManager fileExistsAtPath:newFilePath]){
            [ZHFileManager removeItemAtPath:newFilePath];
        }
        
        result=[ZHFileManager copyItemAtPath:self.path toPath:newFilePath];
        
        if (result) {
            hud.labelText = @"备份成功,正在转换工程...";
        }else{
            hud.labelText = @"备份失败!请先关闭工程(XCode)";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            return ;
        }
        
        // 处理耗时操作的代码块...
        [[ZHStroyBoardToPureHandProject new] transformProjectToPureHandProject:self.path];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.labelText=@"转换工程成功";
            
            [self.OkButton setTitle:@"转换成功" forState:(UIControlStateNormal)];
            self.OkButton.enabled=NO;
            self.OkButton.backgroundColor=[UIColor grayColor];
            
            //回调或者说是通知主线程刷新，
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        });
    });
}

- (BOOL)checkProject{
    
    NSMutableArray *viewControllerArrM=[NSMutableArray array];
    NSInteger viewCount=0;
    for (NSString *SBfileName in self.dataArr) {
        if ([ZHFileManager fileExistsAtPath:SBfileName]) {
            NSString *context=[NSString stringWithContentsOfFile:SBfileName encoding:NSUTF8StringEncoding error:nil];
            context=[ZHStoryboardTextManager addCustomClassToAllViews:context];
            ReadXML *xml=[ReadXML new];
            [xml initWithXMLString:context];
            NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
            NSArray *allViewControllers=[ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
            //    获取所有的ViewController名字
            NSArray *viewControllers=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
            for (NSString *viewController in viewControllers) {
                if ([viewControllerArrM containsObject:viewController]==NO) {
                    [viewControllerArrM addObject:viewController];
                }
            }
            
            NSDictionary *customAndId=[ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
            viewCount+=customAndId.count;
        }
    }
    
    NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:self.path hasPathExtension:@[@".m"]];
    
    NSArray *tempArr=[NSArray arrayWithArray:viewControllerArrM];
    
    for (NSString *fileName in tempArr) {
        BOOL exsit=NO;
        for (NSString *filePath in fileArr) {
            if ([[ZHFileManager getFileNameNoPathComponentFromFilePath:filePath]isEqualToString:fileName]) {
                exsit=YES;
                break;
            }
        }
        if (exsit==NO) {
            [viewControllerArrM removeObject:fileName];
        }
    }
    self.viewControllerArrM=viewControllerArrM;
    if (viewControllerArrM.count>0&&viewCount>0) {
        return YES;
    }
    return NO;
}

- (void)importAction{
    [self.dataArr removeAllObjects];
    
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    [ZHFileManager createFileAtPath:macDesktopPath];
    NSString *Msg=@"文件已经生成在桌面,名字为\"代码助手.m\",请填写要转换的工程路径";
    [ZHAlertAction alertWithTitle:@"导入工程" withMsg:Msg addToViewController:self withCancleBlock:nil withOkBlock:^{
        
        NSString *path=[NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
        
        if ([ZHFileManager fileExistsAtPath:path]==NO) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZHAlertAction alertWithMsg:@"路径不存在!请重新填写!" addToViewController:self ActionSheet:NO];
            });
            return ;
        }
        
        NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:path hasPathExtension:@[@".storyboard"]];
        
        if(fileArr.count==0){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZHAlertAction alertWithMsg:@"工程路径不存在storyboard文件!请重新填写工程路径!" addToViewController:self ActionSheet:NO];
            });
            return;
        }
        
        for (NSString *fileName in fileArr) {
            NSString *tempStr=[ZHFileManager getFileNameNoPathComponentFromFilePath:fileName];
            if ([tempStr rangeOfString:@"备份"].location!=NSNotFound||[tempStr isEqualToString:@"LaunchScreen"]) {
                continue;
            }
            
            [self.dataArr addObject:fileName];
        }
        
        if (self.dataArr.count>0) {
            self.path=path;
            [self.importButton setTitle:[ZHFileManager getFileNameNoPathComponentFromFilePath:path] forState:(UIControlStateNormal)];
            
            [self.OkButton setTitle:@"开始转换" forState:(UIControlStateNormal)];
            self.OkButton.enabled=YES;
            self.OkButton.backgroundColor=[UIColor blackColor];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ZHAlertAction alertWithMsg:@"工程路径不存在相关的storyboard文件!请重新填写工程路径!" addToViewController:self ActionSheet:NO];
            });
        }
    } cancelButtonTitle:@"取消" OkButtonTitle:@"已填写好,添加新工程" ActionSheet:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end