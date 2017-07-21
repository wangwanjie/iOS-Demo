#import "HelpViewController.h"

#import "HelpTableViewCell.h"

#import "TabBarAndNavagation.h"
#import "DetailViewController.h"

@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end


@implementation HelpViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
        
        NSArray *titles=@[@"StroyBoard生成Masonry简介",@"Xib生成Masonry简介",@"快速生成代码简介",@"JSON转模型简介",@"为什么代码里全是View1,label2之类的?",@"生成property outlet怎么用?",@"将非纯手写工程转换成纯手写简介"];
        
        for (NSInteger i=0; i<titles.count; i++) {
            HelpCellModel *HelpModel=[HelpCellModel new];
            HelpModel.title=titles[i];
            HelpModel.row=i+1;
            [_dataArr addObject:HelpModel];
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
    
    self.title=@"使用简介";
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
	if ([modelObjct isKindOfClass:[HelpCellModel class]]){
		HelpTableViewCell *HelpCell=[tableView dequeueReusableCellWithIdentifier:@"HelpTableViewCell"];
		HelpCellModel *model=modelObjct;
		[HelpCell refreshUI:model];
		return HelpCell;
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
    HelpCellModel *model=self.dataArr[indexPath.row];
    
    DetailViewController *vc=(DetailViewController *)[TabBarAndNavagation getViewControllerFromStoryBoardWithIdentity:@"DetailViewController"];
    vc.helpString=model.title;
    [TabBarAndNavagation pushViewControllerNoStroyBoard:vc toTarget:self pushHideTabBar:YES backShowTabBar:NO];
}

@end