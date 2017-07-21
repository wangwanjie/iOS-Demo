//
//  ViewController.m
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/5.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "ViewController.h"
#import "BQLDBTool.h"
#import "StudentModel.h"
#import "BQLElseTool.h"
#import "MemorandumVC.h"

@interface ViewController ()
{
    BQLDBTool *tool;
    NSDictionary *student;
}

@property (weak, nonatomic) IBOutlet UITextField *stuID;
@property (weak, nonatomic) IBOutlet UITextField *stuName;
@property (weak, nonatomic) IBOutlet UITextField *stuSex;
@property (weak, nonatomic) IBOutlet UITextField *stuAge;
@property (weak, nonatomic) IBOutlet UITextField *stuHeight;
@property (weak, nonatomic) IBOutlet UILabel *show;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tool = [BQLDBTool instantiateTool];
    // 打开或者创建数据库(数据库要根据模型决定创建哪些字段)
    student = @{@"stuid":@"",
                @"name":@"",
                @"sex":@"",
                @"age":@"",
                @"height":@""};
    StudentModel *model = [StudentModel modelWithDictionary:student];
    [tool openDBWith:StudentFile Model:model];
}

- (IBAction)insertData:(id)sender {
    
    // 保证唯一标示的学生id不能为空(其实姓名这种理应也不应为空,只是唯一标识是绝对不能为空的)
    if(!checkObjectNotNull(_stuID.text)) {
        [self showAlert:@"学生id不能为空!"];
        return;
    }
    
    StudentModel *model = [StudentModel modelWithDictionary:[self getStudent]];
    if([tool insertDataWith:StudentFile Model:model]) {
        [self showAlert:@"插入成功"];
    }
    else {
        [self showAlert:@"插入失败"];
    }
}

- (IBAction)deleteData:(id)sender {
    
    if([tool deleteDataWith:StudentFile]) {
        [self showAlert:@"删除成功"];
    }
    else {
        [self showAlert:@"删除失败"];
    }
}

// 修改整个模型中的差异数据
- (IBAction)updateData:(id)sender {
    
    StudentModel *model = [StudentModel modelWithDictionary:[self getStudent]];
    if([tool modifyDataWith:StudentFile Model:model]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}

- (IBAction)searchData:(id)sender {
    
    _show.text = @"学生数据:\n";
    NSArray *array = [tool queryDataWith:StudentFile];
    for(NSDictionary *dic in array) {
        
        _show.text = [_show.text stringByAppendingString:changeToTextWithDictionary(dic)];
    }
}

/* 修改某个字段值 */
/* demo场景：学生表自定义伪主键:stuid,默认建表主键id也可使用,这里只插入一条数据时主键id值即为:1 还提供了一个customid，详见备忘录demo*/
- (IBAction)updateName:(id)sender {
    
    if([tool modifyDataWith:StudentFile Key:@"name" Value:_stuName.text Identifier:@"stuid" IdentifierValue:@"1001"]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}

- (IBAction)updateSex:(id)sender {
    
    if([tool modifyDataWith:StudentFile Key:@"sex" Value:_stuSex.text Identifier:@"stuid" IdentifierValue:@"1001"]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}

- (IBAction)updateAge:(id)sender {
    
    if([tool modifyDataWith:StudentFile Key:@"age" Value:_stuAge.text Identifier:@"stuid" IdentifierValue:@"1001"]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}

- (IBAction)updateHeight:(id)sender {
    
    if([tool modifyDataWith:StudentFile Key:@"height" Value:_stuHeight.text Identifier:@"stuid" IdentifierValue:@"1001"]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}

- (IBAction)gotoMemorandum:(id)sender {
    
    MemorandumVC *memorandumVC = [MemorandumVC new];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:memorandumVC];
    [self presentViewController:nav animated:YES completion:nil];
}






- (NSDictionary *)getStudent {
    
    return @{@"stuid":_stuID.text,
             @"name":checkObjectNotNull(_stuName.text)?_stuName.text:@"",
             @"sex":checkObjectNotNull(_stuSex.text)?_stuSex.text:@"",
             @"age":checkObjectNotNull(_stuAge.text)?_stuAge.text:@"",
             @"height":checkObjectNotNull(_stuHeight.text)?_stuHeight.text:@""};
}

- (void)showAlert:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
