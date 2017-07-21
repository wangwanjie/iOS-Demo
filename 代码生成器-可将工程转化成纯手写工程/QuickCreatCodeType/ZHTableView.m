//
//  ZHTableView.m
//  代码助手
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 com/ZQ/mac. All rights reserved.
//

#import "ZHTableView.h"
#import "Auto_Father.h"

@implementation ZHTableView
- (NSString *)description{
    
    NSString *filePath=[self creatFatherFile:@"TableViewViewController" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)",@"是否需要titleForSection 1:0 (不填写么默认为否)",@"是否需要heightForSection 1:0 (不填写么默认为否)",@"是否需要右边的滑栏 1:0 (不填写么默认为否)",@"是否需要按拼音排序 1:0 (不填写么默认为否)",@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)",@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"]];
    
    [self openFile:filePath];
    
    return @"指导文件已经创建在桌面上: TableViewViewController指导文件.m  ,请勿修改指定内容,否则格式不对将无法生成TableView的ViewController";
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
    
    //创建ViewController.m
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@ViewController.h\"",dic[@"ViewController的名字"]],@""] ToStrM:textStrM];
    
    NSString *cells=dic[@"自定义Cell,以逗号隔开"];
    NSArray *arrCells=[cells componentsSeparatedByString:@","];
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@TableViewCell.h\"",cell]] ToStrM:textStrM];
        }
    }
    
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\n@interface %@ViewController ()<UITableViewDataSource,UITableViewDelegate>\n",dic[@"ViewController的名字"]],@"@property (weak, nonatomic) IBOutlet UITableView *tableView;\n"] ToStrM:textStrM];
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"@property (weak, nonatomic) IBOutlet UIView *MI_View;",@"@property (weak, nonatomic) IBOutlet UILabel *MI_Label;",@"@property (nonatomic,assign)NSInteger time_count;//这个属性是为了让MI_View消失"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"@property (nonatomic,strong)NSMutableArray *dataArr;",@""] ToStrM:textStrM];
    
    
    if ([dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"@property (nonatomic,strong)NSMutableArray *sectionDataArr;"] ToStrM:textStrM];
    }

    
    [self insertValueAndNewlines:@[@"@end",@"\n",[NSString stringWithFormat:@"@implementation %@ViewController",dic[@"ViewController的名字"]]] ToStrM:textStrM];
    
    //假数据
    NSMutableString *fakeDataStrM=[NSMutableString string];
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [fakeDataStrM appendFormat:@"%@CellModel *%@Model=[%@CellModel new];\n%@Model.title=@\"\";\n%@Model.iconImageName=@\"\";\n[_dataArr addObject:%@Model];\n//[self.dataArr addObject:%@Model];\n",cell,cell,cell,cell,cell,cell,cell];
            }
        }
    }
    if (fakeDataStrM.length==0)[fakeDataStrM setString:@""];;
    [self insertValueAndNewlines:@[@"- (NSMutableArray *)dataArr{",@"if (!_dataArr) {",@"_dataArr=[NSMutableArray array];",fakeDataStrM,@"}",@"return _dataArr;",@"}"] ToStrM:textStrM];
    
    if ([dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (NSMutableArray *)sectionDataArr{\n\
                                       if (!_sectionDataArr) {\n\
                                       _sectionDataArr=[NSMutableArray array];\n\
                                       }\n"] ToStrM:textStrM];
        
        if (![dic[@"是否需要按拼音排序 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
            [self insertValueAndNewlines:@[@"for (NSInteger i=0; i<26; i++) {\n\
                                           [_sectionDataArr addObject:[NSString stringWithFormat:@\"%C\",(unichar)('A'+i)]];\n\
                                           }\n"] ToStrM:textStrM];
        }
        
        [self insertValueAndNewlines:@[@"return _sectionDataArr;\n}"] ToStrM:textStrM];
    }
    
    
    [self insertValueAndNewlines:@[@"\n- (void)viewDidLoad{",@"[super viewDidLoad];",@"self.tableView.delegate=self;",@"self.tableView.dataSource=self;",@"//self.edgesForExtendedLayout=UIRectEdgeNone;"] ToStrM:textStrM];
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"self.MI_View.hidden=YES;\n\
                                       self.MI_Label.textColor=[UIColor whiteColor];\n\
                                       self.MI_View.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];\n\
                                       [self.MI_View cornerRadius];"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:textStrM];
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (void)setMI_labelText:(NSString *)text{\n\
                                       if ([self.MI_Label.text isEqualToString:text]||[text isEqualToString:@\"_\"]) {\n\
                                       return;\n\
                                       }\n\
                                       \n\
                                       self.MI_View.hidden=NO;\n\
                                       self.MI_Label.text=text;\n\
                                       \n\
                                       [UIView animateWithDuration:0.25 animations:^{\n\
                                       self.MI_View.alpha=1.0;\n\
                                       _time_count++;\n\
                                       NSLog(@\"+++%ld\",_time_count);\n\
                                       } completion:^(BOOL finished) {\n\
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\n\
                                       NSLog(@\"%ld\",_time_count);\n\
                                       if (_time_count>1) {\n\
                                       _time_count--;\n\
                                       }\n\
                                       if (_time_count==1) {\n\
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\n\
                                       [UIView animateWithDuration:0.5 animations:^{\n\
                                       self.MI_View.alpha=0.0;\n\
                                       } completion:^(BOOL finished) {\n\
                                       self.MI_View.hidden=YES;\n\
                                       }];\n\
                                       });\n\
                                       }\n\
                                       });\n\
                                       }];\n\
                                       }\n- (UIView *)MI_View{\n\
                                       if (!_MI_View) {\n\
                                       \n\
                                       CGFloat centerY=self.view.centerY-40;\n\
                                       if (self.navigationController.navigationBar.hidden==NO) {\n\
                                       centerY-=64;\n\
                                       }\n\
                                       _MI_View=[[UIView alloc]initWithFrame:CGRectMake(self.view.centerX-40, centerY, 80, 80)];\n\
                                       \n\
                                       _MI_Label=[[UILabel alloc]initWithFrame:_MI_View.bounds];\n\
                                       _MI_Label.font=[UIFont systemFontOfSize:30];\n\
                                       _MI_Label.textAlignment=NSTextAlignmentCenter;\n\
                                       \n\
                                       [_MI_View addSubview:_MI_Label];\n\
                                       \n\
                                       [self.view addSubview:_MI_View];\n\
                                       }\n\
                                       return _MI_View;\n\
                                       }\n\
                                       \n\
                                       - (UILabel *)MI_Label{\n\
                                       if (!_MI_Label) {\n\
                                       [self MI_View];\n\
                                       }\n\
                                       return _MI_Label;\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [Auto_Father requestData:textStrM];
    }
    
    
    if ([dic[@"是否需要按拼音排序 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        //显示假数据
        [self insertValueAndNewlines:@[@"//- (void)getData1{\n\
                                       //    NSArray *relatedArr=@[@40,@50,@80,@80,@40,@10,@40,@50,@70,@50,@80,@10,@10,@80,@40,@40,@40,@50,@40,@70];\n\
                                       //    NSArray *FamilyArr=@[@0,@1,@0,@1,@0,@1,@0,@1,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];\n\
                                       //    NSArray *arrName=@[@\"_陈宇\",@\"_陈轩\",@\"阿宇数学老师\",@\"鲍思远爸爸\",@\"董晓妈妈\",@\"陈宇语文老师\",@\"方玉军爸爸\",@\"高欢\",@\"郝向锋\",@\"杰克\",@\"庖轩\",@\"钱宇数学老师\",@\"爱思远爸爸\",@\"妲晓妈妈\",@\"陈宇语文老师\",@\"黄玉军爸爸\",@\"张欢\",@\"石向锋\"];\n\
                                       //    NSArray *imageNameArr=@[@\"JiazhangQinyouhaoImg1\",@\"JiazhangQinyouhaoImg2\",@\"JiazhangQinyouhaoImg3\",@\"JiazhangQinyouhaoImg4\",@\"JiazhangQinyouhaoImgXitong1\",@\"JiazhangQinyouhaoImgXitong2\",@\"JiazhangQinyouhaoImgXitong3\",@\"JiazhangQinyouhaoImgXitong4\"];\n\
                                       //    \n\
                                       //    for (NSInteger i=0; i<arrName.count; i++) {\n\
                                       //        FriendsAndFamilyCellModel *model=[FriendsAndFamilyCellModel new];\n\
                                       //        model.iconImageName=imageNameArr[arc4random()%8];\n\
                                       //        model.isFamily=[FamilyArr[i] boolValue];\n\
                                       //        model.relatedDigital=[relatedArr[i] floatValue];\n\
                                       //        model.title=arrName[i];\n\
                                       //        [self.dataArr addObject:model];\n\
                                       //    }\n\
                                       //    \n\
                                       //    \n\
                                       //    self.dataArr=[self sortArrByChineseNames:self.dataArr];\n\
                                       //}\n"] ToStrM:textStrM];
        
        //进行排序
        [Auto_Father sortArrByChineseNames:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"#pragma mark - 必须实现的方法:",@"- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{",@"return 1;",@"}"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{",@"return self.dataArr.count;",@"}",@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{"] ToStrM:textStrM];

    if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"])[self insertValueAndNewlines:@[@"id modelObjct=self.dataArr[indexPath.row];"] ToStrM:textStrM];
    
    if ([self judge:cells]) {
        for (NSString *cell in arrCells) {
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"if ([modelObjct isKindOfClass:[%@CellModel class]]){",cell],[NSString stringWithFormat:@"%@TableViewCell *%@Cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];",cell,cell,cell],[NSString stringWithFormat:@"%@CellModel *model=modelObjct;",cell],[NSString stringWithFormat:@"[%@Cell refreshUI:model];",cell],[NSString stringWithFormat:@"return %@Cell;",cell],@"}"] ToStrM:textStrM];
            }else{
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@TableViewCell *%@Cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];",cell,cell,cell]] ToStrM:textStrM];
            }
        }
    }
    [self insertValueAndNewlines:@[@"//随便给一个cell\nUITableViewCell *cell=[UITableViewCell new];",@"return cell;",@"}"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{",@"return 44.0f;",@"}",@"- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{",@"[tableView deselectRowAtIndexPath:indexPath animated:YES];",@"NSLog(@\"选择了某一行\");",@"}",@"\n"] ToStrM:textStrM];
    
    
    if ([dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{\n\
                                       return self.sectionDataArr;\n\
                                       }\n\
                                       - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{\n\
                                       if(section==0)\n\
                                       return @\"\";\n\
                                       return self.sectionDataArr[section];\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要titleForSection 1:0 (不填写么默认为否)"] isEqualToString:@"1"]&&[dic[@"是否需要右边的滑栏 1:0 (不填写么默认为否)"] isEqualToString:@"0"]) {
        [self insertValueAndNewlines:@[@"- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{\n\
                                       return @\"\";\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要heightForSection 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        [self insertValueAndNewlines:@[@"- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{\n\
                                       return 40.0f;\n\
                                       }\n\
                                       - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{\n\
                                       return 0.001f;\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        [self insertValueAndNewlines:@[@"-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{\n\
                                       [self setMI_labelText:title];\n\
                                       return [self.sectionDataArr indexOfObject:title];\n\
                                       }"] ToStrM:textStrM];
    }
    
    if ([dic[@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)"] isEqualToString:@"1"]) {
        
        [self insertValueAndNewlines:@[@"/**是否可以编辑*/\n- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{\nif (indexPath.row==self.dataArr.count) {\nreturn NO;\n}\nreturn YES;\n}\n\n/**编辑风格*/\n- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{\nreturn UITableViewCellEditingStyleDelete;\n}\n\n",@"/**设置编辑的控件  删除,置顶,收藏*/\n- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n//设置删除按钮\n\
                                       UITableViewRowAction *deleteRowAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@\"删除\" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {\n\
            [self.dataArr removeObjectAtIndex:indexPath.row];\n\
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:\(UITableViewRowAnimationAutomatic)];\n\
        }];\n\
                                       return  @[deleteRowAction];\n\
                                       }\n\n"
                                       ] ToStrM:textStrM];
    }
    
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
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell : UITableViewCell",cell]] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel;",cell]] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@TableViewCell.h",cell]]];
            
            [textStrM setString:@""];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@TableViewCell.h\"\n",cell]] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell ()",cell],@"@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIButton *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"@property (weak, nonatomic) IBOutlet UIView *hotKeyArea;",[NSString stringWithFormat:@"@property (nonatomic,weak)%@CellModel *dataModel;",cell],@"@end\n"] ToStrM:textStrM];
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@implementation %@TableViewCell",cell],@"\n"] ToStrM:textStrM];
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel{",cell],@"_dataModel=dataModel;",@"self.nameLabel.text=dataModel.title;\n\
                                               self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];\n\
                                               //[self.iconImageView imageWithURLString:dataModel.iconImageName];",@"}\n"] ToStrM:textStrM];
            }
            [self insertValueAndNewlines:@[@"- (void)awakeFromNib {",@"[super awakeFromNib];",@"//self.selectionStyle=UITableViewCellSelectionStyleNone;\n\
                                           //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;",@"//[self addUILongPressGestureRecognizerWithTarget:self withAction:@selector(longPress:) withMinimumPressDuration:0.5];",@"}\n\n",@"- (void)setSelected:(BOOL)selected animated:(BOOL)animated {",@"[super setSelected:selected animated:animated];",@"// Configure the view for the selected state",@"//[self.hotKeyArea addUITapGestureRecognizerWithTarget:self withAction:@selector(hotKeyAreaAction:)];",@"}\n",@"//点击热区触发该方法\n- (void)hotKeyAreaAction:(UITapGestureRecognizer *)tap{\n//[ZHBlockSingleCategroy runBlockNSStringIdentity:@\"deleteMesssge\" Str1:_dataModel.messageId];\n}",@"@end"] ToStrM:textStrM];
            
            [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@TableViewCell.m",cell]]];
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                [textStrM setString:@""];
                
                [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@CellModel : NSObject",cell],@"@property (nonatomic,copy)NSString *iconImageName;",@"@property (nonatomic,assign)BOOL isSelect;",@"@property (nonatomic,assign)BOOL shouldShowImage;",@"@property (nonatomic,copy)NSString *name;",@"@property (nonatomic,copy)NSString *title;",@"@property (nonatomic,assign)CGFloat width;",@"@property (nonatomic,copy)NSString *autoWidthText;",@"@property (nonatomic,strong)NSMutableArray *dataArr;",@"@end"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.h",cell]]];
                
                [textStrM setString:@""];
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CellModel.h\"",cell],@"\n",[NSString stringWithFormat:@"@implementation %@CellModel",cell],@"- (NSMutableArray *)dataArr{\n\
                                               if (!_dataArr) {\n\
                                               _dataArr=[NSMutableArray array];\n\
                                               }\n\
                                               return _dataArr;\n\
                                               }",@"- (void)setAutoWidthText:(NSString *)autoWidthText{\n\
                                               _autoWidthText=autoWidthText;\n\
                                               self.width=[autoWidthText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width;\n\
                                               }",@"\n@end"] ToStrM:textStrM];
                
                [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.m",cell]]];
            }
        }
    }
    
    //如果需要StroyBoard
    if([dic[@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        //这里有较多需要判断的情况
        //1.假如  ViewController的名字 不存在
        if (![self judge:dic[@"ViewController的名字"]]) {
            [self saveStoryBoard:@"" TableViewCells:nil toFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
        }else{
            //没有cells
            if (![self judge:dic[@"自定义Cell,以逗号隔开"]]) {
                [self saveStoryBoard:dic[@"ViewController的名字"] TableViewCells:nil toFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
            }else{//有cells
                NSArray *arr=[dic[@"自定义Cell,以逗号隔开"] componentsSeparatedByString:@","];
                NSMutableArray *arrM=[NSMutableArray array];
                for (NSString *str in arr) {
                    [arrM addObject:[str stringByAppendingString:@"TableViewCell"]];
                }
                [self saveStoryBoard:dic[@"ViewController的名字"] TableViewCells:arrM toFileName:@[dic[@"最大文件夹名字"],[NSString stringWithFormat:@"MainStroyBoard.storyboard"]]];
            }
        }
    }
    
    [[ZHWordWrap new]wordWrap:[self getDirectoryPath:dic[@"最大文件夹名字"]]];
    
    [MBProgressHUD showHUDAddedTo:view withText:@"生成成功!" withDuration:1];
}
@end