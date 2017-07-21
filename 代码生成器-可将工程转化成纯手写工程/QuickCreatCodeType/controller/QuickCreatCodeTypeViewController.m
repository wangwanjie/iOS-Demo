#import "QuickCreatCodeTypeViewController.h"

#import "QuickCreatCodeTypeTableViewCell.h"

#import "ZHTableView.h"
#import "ZHCollectionView.h"
#import "tableViewContainColloectionView.h"

@interface QuickCreatCodeTypeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end


@implementation QuickCreatCodeTypeViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
        
        NSArray *arr=@[@"简单tableView",@"简单collectionView",@"tableView嵌套tableView或者collectionView"];
        
        for (NSInteger i=0; i<arr.count; i++) {
            @autoreleasepool {
                QuickCreatCodeTypeCellModel *QuickCreatCodeTypeModel=[QuickCreatCodeTypeCellModel new];
                QuickCreatCodeTypeModel.title=arr[i];
                [_dataArr addObject:QuickCreatCodeTypeModel];
            }
        }
	}
	return _dataArr;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
    self.tableView.tableFooterView=[UIView new];
	self.edgesForExtendedLayout=UIRectEdgeNone;
}

#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.row];
	if ([modelObjct isKindOfClass:[QuickCreatCodeTypeCellModel class]]){
		QuickCreatCodeTypeTableViewCell *QuickCreatCodeTypeCell=[tableView dequeueReusableCellWithIdentifier:@"QuickCreatCodeTypeTableViewCell"];
		QuickCreatCodeTypeCellModel *model=modelObjct;
		[QuickCreatCodeTypeCell refreshUI:model];
		return QuickCreatCodeTypeCell;
	}
	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    
    QuickCreatCodeTypeCellModel *model=self.dataArr[indexPath.row];
    NSString *Msg=@"文件已经生成在桌面,名字为\"代码助手.m\",请填写具体内容";
    
    ZHTableView *zhTableView;
    ZHCollectionView *zhCollectionView;
    tableViewContainColloectionView *tableViewContain;
    
    if (indexPath.row==0) {
        zhTableView=[ZHTableView new];
        [zhTableView creatFatherFile:@"代码助手" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)"]];
    }else if (indexPath.row==1) {
        zhCollectionView=[ZHCollectionView new];
        [zhCollectionView creatFatherFile:@"代码助手" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)"]];
    }else if (indexPath.row==2) {
        tableViewContain=[tableViewContainColloectionView new];
        [tableViewContain creatFatherFile:@"代码助手" andData:@[@"最大文件夹名字",@"ViewController的名字",@"自定义Cell,以逗号隔开",@"自定义Cell标识符:(无:0 TableView:1(子cell以;隔开) ColloectionView:2(子cell以;隔开)),以逗号隔开",@"例如cell有A,B  那么嵌套这一行为:1(A1;A2),2(B1;B2)",@"是否需要对应的Model 1:0 (不填写么默认为否)",@"是否需要对应的StroyBoard 1:0 (不填写么默认为否)",@"自定义cell可编辑(删除) 1:0 (不填写么默认为否)"]];
    }
    
    [ZHAlertAction alertWithTitle:model.title withMsg:Msg addToViewController:self withCancleBlock:nil withOkBlock:^{
        
        if (indexPath.row==0) {
            [zhTableView Begin:@"代码助手" toView:self.view];
        }else if (indexPath.row==1) {
            [zhCollectionView Begin:@"代码助手" toView:self.view];
        }else if (indexPath.row==2) {
            [tableViewContain Begin:@"代码助手" toView:self.view];
        }
    } cancelButtonTitle:@"取消" OkButtonTitle:@"已填写好,生成代码" ActionSheet:NO];
}

@end