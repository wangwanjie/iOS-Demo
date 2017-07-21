#import "tableViewContainColloectionView.h"

@implementation tableViewContainColloectionView
- (NSString *)description{
    
    NSString *filePath=[self creatFatherFile:@"tableViewContainColloectionView" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"自定义Cell标识符:(无:0 TableView:1(子cell以;隔开) ColloectionView:2(子cell以;隔开)),以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)",@"是否需要titleForSection 1:0 (不填写么默认为否)",@"是否需要heightForSection 1:0 (不填写么默认为否)",@"是否需要右边的滑栏 1:0 (不填写么默认为否)",@"是否需要按拼音排序 1:0 (不填写么默认为否)",@"是否需要滑动滑栏显示提示 1:0 (不填写么默认为否)",@"是否需要检测网络和请求数据 1:0 (不填写么默认为否)"]];
    
    [self openFile:filePath];
    
    return @"指导文件已经创建在桌面上: tableViewContainColloectionView指导文件.m  ,请勿修改指定内容,否则格式不对将无法生成tableViewContainColloectionView的ViewController";
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
    
    
    [self insertValueAndNewlines:@[@"\n- (void)viewDidLoad{",@"[super viewDidLoad];",@"self.tableView.delegate=self;",@"self.tableView.dataSource=self;",@"//self.edgesForExtendedLayout=UIRectEdgeNone;"] ToStrM:textStrM];
    
    
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:textStrM];
    
    
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
    
    NSString *cellsContains=dic[@"自定义Cell标识符:(无:0 TableView:1(子cell以;隔开) ColloectionView:2(子cell以;隔开)),以逗号隔开"];
    NSArray *arrCellsContains=[cellsContains componentsSeparatedByString:@","];
    NSMutableArray *ContainArrM=[NSMutableArray array];
    BOOL hasContain=NO;//判断是否有嵌套
    if (arrCellsContains.count==arrCells.count) {
        hasContain=YES;
        
        for (NSString *str in arrCellsContains) {
            if ([str isEqualToString:@"0"]) {
                [ContainArrM addObject:@"0"];
            }else if ([str hasPrefix:@"1"]){
                NSMutableArray *tableViewCells=[NSMutableArray array];
                
                [tableViewCells addObject:@"1"];
                NSString *subStr=[str substringFromIndex:1];
                if ([subStr hasPrefix:@"("]) {
                    subStr=[subStr substringFromIndex:1];
                }
                if ([subStr hasSuffix:@")"]) {
                    subStr=[subStr substringToIndex:subStr.length-1];
                }
                if ([subStr rangeOfString:@";"].location!=NSNotFound) {
                    NSArray *subArr=[subStr componentsSeparatedByString:@";"];
                    [tableViewCells addObjectsFromArray:subArr];
                }else{
                    [tableViewCells addObject:subStr];
                }
                
                [ContainArrM addObject:tableViewCells];
            }else if ([str hasPrefix:@"2"]){
                NSMutableArray *collectionViewCells=[NSMutableArray array];
                
                [collectionViewCells addObject:@"2"];
                NSString *subStr=[str substringFromIndex:1];
                if ([subStr hasPrefix:@"("]) {
                    subStr=[subStr substringFromIndex:1];
                }
                if ([subStr hasSuffix:@")"]) {
                    subStr=[subStr substringToIndex:subStr.length-1];
                }
                if ([subStr rangeOfString:@";"].location!=NSNotFound) {
                    NSArray *subArr=[subStr componentsSeparatedByString:@";"];
                    [collectionViewCells addObjectsFromArray:subArr];
                }else{
                    [collectionViewCells addObject:subStr];
                }
                
                [ContainArrM addObject:collectionViewCells];
            }
        }
    }
    
    if ([self judge:cells]) {
        NSInteger count=0;
        for (NSString *cell in arrCells) {
            [self createTableViewCell:cell withStrM:textStrM withInfoDic:dic withContainArrM:ContainArrM withhasContain:hasContain withIndex:count];
            count++;
        }
    }
    
    if (hasContain) {
        for (id obj in ContainArrM) {
            if ([obj isKindOfClass:[NSString class]]) {
                if ([obj isEqualToString:@"0"]) {
                    continue;
                }
            }else if ([obj isKindOfClass:[NSArray class]]){
                BOOL isTableView=NO;
                for (NSString *subStr in (NSArray *)obj) {
                    if ([subStr isEqualToString:@"1"]) {
                        isTableView=YES;
                        continue;
                    }else if ([subStr isEqualToString:@"2"]){
                        isTableView=NO;
                        continue;
                    }
                    
                    if (isTableView==YES) {
                        [self createTableViewCell:subStr withStrM:textStrM withInfoDic:dic withContainArrM:arrCellsContains withhasContain:NO withIndex:-1];
                    }else{
                        [self createCollectionViewCell:subStr withStrM:textStrM withInfoDic:dic withContainArrM:arrCellsContains withhasContain:NO];
                    }
                    
                }
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

- (void)createTableViewCell:(NSString *)cell withStrM:(NSMutableString *)textStrM withInfoDic:(NSDictionary *)dic withContainArrM:(NSArray *)ContainArrM withhasContain:(BOOL)hasContain withIndex:(NSInteger)index{
    
    
    //TableViewCell.h
    
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
    
    
    
    //TableViewCell.m
    
    [textStrM setString:@""];
    
    NSMutableArray *arrTableViewCells=[NSMutableArray array];
    NSMutableArray *arrCollectionViewCells=[NSMutableArray array];
    BOOL isTableView=NO;
    if (hasContain) {
        if (ContainArrM.count>index) {
            if ([ContainArrM[index] isKindOfClass:[NSArray class]]) {
                for (NSString *str in ContainArrM[index]) {
                    if ([str isEqualToString:@"1"]) {
                        isTableView=YES;
                        continue;
                    }
                    else if ([str isEqualToString:@"2"]) {
                        isTableView=NO;
                        continue;
                    }
                    if (isTableView==YES) {
                        [arrTableViewCells addObject:str];
                    }else{
                        [arrCollectionViewCells addObject:str];
                    }
                }
            }else if([ContainArrM[index] isKindOfClass:[NSString class]]){
                if ([ContainArrM[index] isEqualToString:@"0"]) {
                    hasContain=NO;
                }
            }
        }
    }
    
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@TableViewCell.h\"\n",cell]] ToStrM:textStrM];
    
    if (hasContain){
        if (isTableView) {
            for (NSString *str in arrTableViewCells) {
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@TableViewCell.h\"",str]] ToStrM:textStrM];
            }
        }else{
            for (NSString *str in arrCollectionViewCells) {
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@CollectionViewCell.h\"",str]] ToStrM:textStrM];
            }
        }
    }
    
    if (hasContain){
        if (isTableView) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell ()<UITableViewDataSource,UITableViewDelegate>",cell],@"",@"@property (nonatomic,strong)NSMutableArray *dataArr;",@"@property (weak, nonatomic) IBOutlet UITableView *tableView;"] ToStrM:textStrM];
        }else{
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>",cell],@"",@"@property (nonatomic,strong)NSMutableArray *dataArr;",@"@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;"] ToStrM:textStrM];
            
        }
    }else{
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"@interface %@TableViewCell ()",cell]] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIButton *iconImageView;",@"//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;",@"@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;",@"@property (weak, nonatomic) IBOutlet UIView *hotKeyArea;",[NSString stringWithFormat:@"@property (nonatomic,weak)%@CellModel *dataModel;",cell]] ToStrM:textStrM];
    
    
    [self insertValueAndNewlines:@[@"@end\n",[NSString stringWithFormat:@"@implementation %@TableViewCell",cell],@"\n"] ToStrM:textStrM];
    
    if (hasContain){
        [self insertValueAndNewlines:@[@"- (NSMutableArray *)dataArr{\n\
                                       if (!_dataArr) {\n\
                                       _dataArr=[NSMutableArray array];\n\
                                       }\n\
                                       return _dataArr;\n\
                                       }"] ToStrM:textStrM];
    }
    if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        [self insertValueAndNewlines:@[[NSString stringWithFormat:@"- (void)refreshUI:(%@CellModel *)dataModel{",cell],@"_dataModel=dataModel;",@"self.nameLabel.text=dataModel.title;\n\
                                       self.iconImageView.image=[UIImage imageNamed:dataModel.iconImageName];\n\
                                       //[self.iconImageView imageWithURLString:dataModel.iconImageName];"] ToStrM:textStrM];
        if (hasContain){
            if (isTableView) {
                [self insertValueAndNewlines:@[@"[self.dataArr removeAllObjects];",@"[self.tableView reloadData];"] ToStrM:textStrM];
            }else{
                [self insertValueAndNewlines:@[@"[self.dataArr removeAllObjects];",@"[self.collectionView reloadData];"] ToStrM:textStrM];
            }
        }
        
        [self insertValueAndNewlines:@[@"}\n"] ToStrM:textStrM];
    }
    
    [self insertValueAndNewlines:@[@"- (void)awakeFromNib {",@"// Initialization code",@"//self.selectionStyle=UITableViewCellSelectionStyleNone;\n\
                                   //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;",@"//[self addUILongPressGestureRecognizerWithTarget:self withAction:@selector(longPress:) withMinimumPressDuration:0.5];"] ToStrM:textStrM];
    if (hasContain){
        if (isTableView==NO) {
            [self insertValueAndNewlines:@[@"[self addFlowLayoutToCollectionView:self.collectionView];"] ToStrM:textStrM];
        }
    }
    
    [self insertValueAndNewlines:@[@"}\n"] ToStrM:textStrM];
    
    [self insertValueAndNewlines:@[@"- (void)setSelected:(BOOL)selected animated:(BOOL)animated {",@"[super setSelected:selected animated:animated];",@"// Configure the view for the selected state",@"//[self.hotKeyArea addUITapGestureRecognizerWithTarget:self withAction:@selector(hotKeyAreaAction:)];",@"}\n"] ToStrM:textStrM];
    
    if (hasContain){
        if (isTableView==NO) {
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
            
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"])[self insertValueAndNewlines:@[@"id modelObjct=self.dataArr[indexPath.row];"] ToStrM:textStrM];
            
            for (NSString *cellCollectionView in arrCollectionViewCells) {
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"if ([modelObjct isKindOfClass:[%@CellModel class]]){",cellCollectionView],[NSString stringWithFormat:@"%@CollectionViewCell *%@Cell=[collectionView dequeueReusableCellWithReuseIdentifier:@\"%@CollectionViewCell\" forIndexPath:indexPath];",cellCollectionView,cellCollectionView,cellCollectionView]] ToStrM:textStrM];
                
                if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@CellModel *model=modelObjct;",cellCollectionView],[NSString stringWithFormat:@"[%@Cell refreshUI:model];",cellCollectionView]] ToStrM:textStrM];
                }
                [self insertValueAndNewlines:@[[NSString stringWithFormat:@"return %@Cell;\n}\n",cellCollectionView]] ToStrM:textStrM];
                
            }
            [self insertValueAndNewlines:@[@"//随便给一个cell\nUICollectionViewCell *cell=[UICollectionViewCell new];",@"return cell;",@"}"] ToStrM:textStrM];
            
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
            
        }
        else{
            
            [self insertValueAndNewlines:@[@"#pragma mark - 必须实现的方法:",@"- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{",@"return 1;",@"}"] ToStrM:textStrM];
            
            [self insertValueAndNewlines:@[@"- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{",@"return self.dataArr.count;",@"}",@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{"] ToStrM:textStrM];
            
            if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"])[self insertValueAndNewlines:@[@"id modelObjct=self.dataArr[indexPath.row];"] ToStrM:textStrM];
            
            for (NSString *cell in arrTableViewCells) {
                if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
                    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"if ([modelObjct isKindOfClass:[%@CellModel class]]){",cell],[NSString stringWithFormat:@"%@TableViewCell *%@Cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];",cell,cell,cell],[NSString stringWithFormat:@"%@CellModel *model=modelObjct;",cell],[NSString stringWithFormat:@"[%@Cell refreshUI:model];",cell],[NSString stringWithFormat:@"return %@Cell;",cell],@"}"] ToStrM:textStrM];
                }else{
                    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"%@TableViewCell *%@Cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];",cell,cell,cell]] ToStrM:textStrM];
                }
            }
            
            [self insertValueAndNewlines:@[@"//随便给一个cell\nUITableViewCell *cell=[UITableViewCell new];",@"return cell;",@"}"] ToStrM:textStrM];
            
            [self insertValueAndNewlines:@[@"- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{",@"return 44.0f;",@"}",@"- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{",@"[tableView deselectRowAtIndexPath:indexPath animated:YES];",@"NSLog(@\"选择了某一行\");",@"}",@"\n"] ToStrM:textStrM];
        }
    }
    
    [self insertValueAndNewlines:@[@"@end"] ToStrM:textStrM];
    
    [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"view",[NSString stringWithFormat:@"%@TableViewCell.m",cell]]];
    
    
    
    
    if([dic[@"是否需要对应的Model 1:0 (不填写么默认为否)"] isEqualToString:@"1"]){
        
        
        //CellModel.h
        [textStrM setString:@""];
        
        [self insertValueAndNewlines:@[@"#import <UIKit/UIKit.h>\n",[NSString stringWithFormat:@"@interface %@CellModel : NSObject",cell],@"@property (nonatomic,copy)NSString *iconImageName;",@"@property (nonatomic,assign)BOOL isSelect;",@"@property (nonatomic,assign)BOOL shouldShowImage;",@"@property (nonatomic,copy)NSString *name;",@"@property (nonatomic,copy)NSString *title;",@"@property (nonatomic,assign)CGFloat width;",@"@property (nonatomic,copy)NSString *autoWidthText;",@"@property (nonatomic,strong)NSMutableArray *dataArr;",@"@end"] ToStrM:textStrM];
        
        [self saveText:textStrM toFileName:@[dic[@"最大文件夹名字"],@"model",[NSString stringWithFormat:@"%@CellModel.h",cell]]];
        
        
        //CellModel.m
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

- (void)createCollectionViewCell:(NSString *)cell withStrM:(NSMutableString *)textStrM withInfoDic:(NSDictionary *)dic withContainArrM:(NSArray *)ContainArrM withhasContain:(BOOL)hasContain{
    
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

@end