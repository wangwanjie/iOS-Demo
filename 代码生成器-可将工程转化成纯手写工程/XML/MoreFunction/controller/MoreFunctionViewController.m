#import "MoreFunctionViewController.h"

#import "MoreFunctionTableViewCell.h"

#import "TabBarAndNavagation.h"

@interface MoreFunctionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end


@implementation MoreFunctionViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
        
        NSArray *titles=@[@"快速生成代码(常用)",@"JSON转模型(Model)",@"生成property outlet,不用自己拉线",@"StroyBoard或Xib生成Masonry约束代码"];
        
        for (NSInteger i=0; i<titles.count; i++) {
            @autoreleasepool {
                MoreFunctionCellModel *MoreFunctionModel=[MoreFunctionCellModel new];
                MoreFunctionModel.title=titles[i];
                [_dataArr addObject:MoreFunctionModel];
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
    
    self.title=@"更多功能";
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(backAction)];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
	if ([modelObjct isKindOfClass:[MoreFunctionCellModel class]]){
		MoreFunctionTableViewCell *MoreFunctionCell=[tableView dequeueReusableCellWithIdentifier:@"MoreFunctionTableViewCell"];
		MoreFunctionCellModel *model=modelObjct;
		[MoreFunctionCell refreshUI:model];
		return MoreFunctionCell;
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
    MoreFunctionCellModel *model=self.dataArr[indexPath.row];
    if ([model.title isEqualToString:@"快速生成代码(常用)"]) {
        [TabBarAndNavagation pushViewController:@"QuickCreatCodeTypeViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
    }else if ([model.title isEqualToString:@"JSON转模型(Model)"]) {
        [TabBarAndNavagation pushViewController:@"JSONViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
    }else if ([model.title isEqualToString:@"生成property outlet,不用自己拉线"]) {
        [TabBarAndNavagation pushViewController:@"StroyBoardCreatePropertyViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
    }else if ([model.title isEqualToString:@"StroyBoard或Xib生成Masonry约束代码"]) {
        [TabBarAndNavagation pushViewController:@"GetSBViewController" toTarget:self pushHideTabBar:YES backShowTabBar:NO];
    }
}


@end
