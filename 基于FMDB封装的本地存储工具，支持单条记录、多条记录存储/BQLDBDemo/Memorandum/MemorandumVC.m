//
//  MemorandumVC.m
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "MemorandumVC.h"
#import "UITableView+EmptyData.h"
#import "MemorandumCell.h"
#import "BQLDBTool.h"
#import "MemorandumModel.h"
#import "MemorandumEditVC.h"

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kWindowWidth ([UIScreen mainScreen].bounds.size.width)
#define kWindowHeight ([UIScreen mainScreen].bounds.size.height)

@interface MemorandumVC () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView; // 主表格
    
    BQLDBTool *_tool;
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MemorandumVC

- (void)initialMemorandum {
    
    [self.dataSource removeAllObjects];
    if(!_tool) {
        _tool = [BQLDBTool instantiateTool];
    }
    // 字典key保持与模型一致,因为数据库是根据模型创建表结构(扩展:不一致的话数据库会认为是新增字段,所以你可以借此新增数据库字段)
    NSDictionary *memorandum = @{@"noteContent":@"",
                                 @"noteTime":@""};
    MemorandumModel *model = [MemorandumModel modelWithDictionary:memorandum];
    [_tool openDBWith:MemorandumFile Model:model];
    NSArray *array = [_tool queryDataWith:MemorandumFile];
    for(NSDictionary *dic in array) {
        
        MemorandumModel *dataModel = [MemorandumModel modelWithDictionary:dic];
        [self.dataSource addObject:dataModel];
    }
    if(_tableView) [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initialMemorandum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"备忘录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(253, 178, 50)}]; // 标题颜色
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    UIBarButtonItem *backBtn=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationController.navigationBar.tintColor = RGB(253, 178, 50); // 左右按钮颜色
    self.navigationItem.rightBarButtonItem=addBtn;
    self.navigationItem.leftBarButtonItem=backBtn;
    
    [self setTable];
}

- (void)setTable {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 65;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [tableView tableViewDisplayWitMsg:@"您还没有写备忘录" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemorandumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemorandumCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MemorandumCell class]) owner:self options:nil].lastObject;;
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemorandumEditVC *edit = [[MemorandumEditVC alloc] init];
    edit.type = EditTypeEdit;
    edit.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
}

#pragma cell编辑模式--------删除备忘录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){ //删除模式
        
        MemorandumModel *model = self.dataSource[indexPath.row];
        if([_tool deleteDataWith:MemorandumFile Identifier:@"customid" IdentifierValue:[NSString stringWithFormat:@"%lld",model.customID]]) {
            
            [self.dataSource removeObjectAtIndex:indexPath.row];
        }
    }
    [_tableView reloadData]; // 重新查询数据刷新表格
}


#pragma  自定义左滑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}


// 新建备忘录
- (void)addClick {
    
    MemorandumEditVC *edit = [[MemorandumEditVC alloc] init];
    edit.type = EditTypeAdd;
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)backClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
