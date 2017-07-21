//
//  ZHCollectionView.m
//  代码助手
//
//  Created by mac on 16/5/13.
//  Copyright © 2016年 com/qianfeng/mac. All rights reserved.
//

#import "ZHCollectionView.h"

@implementation ZHCollectionView
- (NSString *)description{
    
    NSString *filePath=[self creatFatherFile:@"CollectionViewController" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"]];
    
    [self openFile:filePath];
    
    return @"指导文件已经创建在桌面上: CollectionViewController指导文件.m  ,请勿修改指定内容,否则格式不对将无法生成CollectionView的ViewController";
}
- (void)Begin:(NSString *)str toView:(UIView *)view{
    
    NSDictionary *dic=[self getDicFromFileName:str];
    
    if(![self judge:dic[@"最大文件夹名字"]]){
        [MBProgressHUD showHUDAddedTo:view withText:@"没有填写文件夹名字,创建MVC失败!" withDuration:1];
        return;
    }
    
    NSString *fatherDirector=[self creatFatherFileDirector:dic[@"最大文件夹名字"] toFatherDirector:nil];
    [self creatFatherFileDirector:@"controller" toFatherDirector:fatherDirector];
    [self creatFatherFileDirector:@"view" toFatherDirector:fatherDirector];
    [self creatFatherFileDirector:@"model" toFatherDirector:fatherDirector];
    
    //如果没有填写dic[@"ViewController的名字"]那么就默认只生成MVC文件夹
    if (![self judge:dic[@"ViewController的名字"]]) {
        [MBProgressHUD showHUDAddedTo:view withText:@"没有填写 ViewController的名字 那么就默认只生成MVC文件夹!" withDuration:1];
        return;
    }
    //1.创建ViewController.h
    
    NSMutableString *textStrM=[NSMutableString string];
    
    [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@ViewController : UIViewController",dic[@"ViewController的名字"]],@"",@"@end",@""] ToStrM:textStrM];
    
    [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"controller",[NSString stringWithFormat:@"%@ViewController.h",dic[@"ViewController的名字"]]]];
    
    [textStrM setString:@""];
    
    
    //2.创建ViewController.m
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@ViewController.h\"",dic[@"ViewController的名字"]],@""] ToStrM:textStrM];
    
    NSString *cells=dic[@"自定义Cell,以逗号隔开"];
    NSArray *arrCells=[cells componentsSeparatedByString:@","];
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CollectionViewCell.h\"",cell]] ToStrM:textStrM];
        }
    }
    
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\n@interface %@ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>\n",dic[@"ViewController的名字"]],@"@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;\n"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"@property (nonatomic,strong)NSMutableArray *dataArr;",@""] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"@end",@"\n",[NSString stringWithFormat:@"@implementation %@ViewController",dic[@"ViewController的名字"]]] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (NSMutableArray *)dataArr{",@"if (!_dataArr) {",@"_dataArr=[NSMutableArray array];",@"}",@"return _dataArr;",@"}"] ToStrM:textStrM];
    
    
    [self insertValueAndNewlines:@[@"\n- (void)viewDidLoad{",@"[super viewDidLoad];",@"[self addFlowLayoutToCollectionView:self.collectionView];",@"//self.edgesForExtendedLayout=UIRectEdgeNone;"] ToStrM:textStrM];
    
//    [self insertViewDidLoad^{
//        [self setTableViewDelegate];
//    }];
    
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"/**为collectionView添加布局*/\n\
                                   - (void)addFlowLayoutToCollectionView:(UICollectionView *)collectionView{\n\
                                   UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];\n\
                                   \n\
                                   flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平\n\
                                   //    flow.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直\n\
                                   \n\
                                   flow.minimumInteritemSpacing = 10;\n\
                                   \n\
                                   flow.minimumLineSpacing = 10;\n\
                                   \n\
                                   collectionView.collectionViewLayout=flow;\n\
                                   \n\
                                   // 设置代理:\n\
                                   self.collectionView.delegate=self;\n\
                                   self.collectionView.dataSource=self;\n\
                                   \n\
                                   collectionView.backgroundColor=[UIColor whiteColor];//背景颜色\n\
                                   \n\
                                   collectionView.contentInset=UIEdgeInsetsMake(20, 20, 20, 20);//内嵌值\n\
                                   }\n"] ToStrM:textStrM];
    
    
    
    
    if ([dic[@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (void)requestData{\n\
                                       \n\
                                       //解析数据\n\
                                       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];\n\
                                       \n\
                                       [manager GET:@\"URL\" parameters:@{@\"p\":[NSString stringWithFormat:@\"%ld\",self.page]} success:^(AFHTTPRequestOperation *operation, id responseObject) {\n\
                                       \n\
                                       <#Model#> *model=[<#Model#> new];\n\
                                       [model setValuesForKeysWithDictionary:responseObject];\n\
                                       \n\
                                       if(self.page==1){\n\
                                       [self.dataArr removeAllObjects];\n\
                                       }\n\
                                       \n\
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {\n\
                                       NSLog(@\"网络出错\");\n\
                                       }];\n\
                                       }",@"\n//检查网络状态\n- (void)updateInternetStatus\n\
                                       {\n\
                                       AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];\n\
                                       [manager startMonitoring];\n\
                                       [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {\n\
                                       if (status == AFNetworkReachabilityStatusNotReachable) {\n\
                                       \n\
                                       }else{\n\
                                       //请求数据\n\
                                       [self requestData];\n\
                                       }\n\
                                       }];\n\
                                       }"] ToStrM:textStrM];
    }
    
    
    [self insertValueAndNewlines:@[@"#pragma mark - collectionView的代理方法:\n\
                                   // 1.返回组数:\n\
                                   - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView\n\
                                   {\n\
                                   return 1;\n\
                                   }"] ToStrM:textStrM];
    
    
    
    [self insertValueAndNewlines:@[@"// 2.返回每一组item的个数:\n\
                                   - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section\n\
                                   {\n\
                                   return self.dataArr.count;\n\
                                   }"] ToStrM:textStrM];
    
    
    [self insertValueAndNewlines:@[@"// 3.返回每一个item（cell）对象;\n\
                                   - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath\n\
                                   {"] ToStrM:textStrM];
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@\"%@CollectionViewCell\" forIndexPath:indexPath];",cell,cell]] ToStrM:textStrM];
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@CellModel *model=self.dataArr[indexPath.row];",cell]] ToStrM:textStrM];
                [self insertValueAndNewlines:@[@"[cell refreshUI:model];"] ToStrM:textStrM];
            }
        }
        [self insertValueAndNewlines:@[@"return cell;"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"}"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"//4.每一个item的大小:\n\
                                   - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath\n\
                                   {\n\
                                   return CGSizeMake(100, 140);\n\
                                   }"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"// 5.选择某一个cell:\n\
                                   - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath\n\
                                   {\n\
                                   [collectionView deselectItemAtIndexPath:indexPath animated:YES];\n\
                                   NSLog(@\"选择了某个cell\");\n\
                                   }",@"\n"] ToStrM:textStrM];
    
    
    [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
    [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"controller",[NSString stringWithFormat:@"%@ViewController.m",dic[@"ViewController的名字"]]]];
    
    //3.创建cells 和models
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>"] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@CollectionViewCell : UICollectionViewCell",cell]] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel;",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@CollectionViewCell.h",cell]]];
            
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CollectionViewCell.h\"\n",cell]] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@CollectionViewCell ()",cell],@"@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIButton *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"@end\n"] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@implementation %@CollectionViewCell",cell],@"\n"] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel{",cell],@"self.nameLabel.text=dataModel.title;\n\
                                               self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];\n\
                                               //    [self.iconImageView imageWithURLString:dataModel.iconImageName];",@"}\n\n"] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"- (void)awakeFromNib {",@"// Initialization code",@"}\n",@"- (void)setSelected:(BOOL)selected{\n\
                                           [super setSelected:selected];\n\
                                           }\n\
                                           - (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView{\n\
                                           [super setSelectedBackgroundView:selectedBackgroundView];\n\
                                           }",@"@end\n"] ToStrM:textStrM];
            
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@CollectionViewCell.m",cell]]];
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@CellModel : NSObject",cell],@"@property (nonatomic,copy)NSString *iconImageName;",@"//@property (nonatomic,copy)NSString *<#ImageView#>;",@"//@property (nonatomic,copy)NSString *<#ImageView#>;",@"@property (nonatomic,copy)NSString *title;",@"//@property (nonatomic,copy)NSString *<#titleName#>;",@"//@property (nonatomic,copy)NSString *<#titleName#>;",@"@end\n"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.h",cell]]];
                
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell],@"\n",[NSString stringWithFormat:@"@implementation %@CellModel",cell],@"\n@end\n"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.m",cell]]];
            }
        }
    }
    
    [self creatFatherFile:@"CollectionViewController" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"]];
    
    //如果需要StroyBoard
    if([dic[@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        //这里有较多需要判断的情况
        //1.假如  ViewController的名字 不存在
        
        [self saveStoryBoardCollectionViewToFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
    }
    
    [[ZHWordWrap new]wordWrap:[self getDirectoryPath:dic[@"最大文件夹名字"]]];
    
    [MBProgressHUD showHUDAddedTo:view withText:@"生成成功!" withDuration:1];
}
@end