//
//  MemorandumEditVC.m
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/8.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "MemorandumEditVC.h"
#import "MemorandumModel.h"
#import "BQLDBTool.h"
#import "BQLElseTool.h"

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface MemorandumEditVC () <UITextViewDelegate>
{
    UIBarButtonItem *_completeBtn;
    BQLDBTool *_tool;
}

@property (weak, nonatomic) IBOutlet UITextView *memorandumTextView;

@end

@implementation MemorandumEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _completeBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeClick)];
    self.navigationController.navigationBar.tintColor = RGB(253, 178, 50);
    
    [self setSubViews];
}

- (void)setSubViews {
    
    self.memorandumTextView.delegate = self;
    if(self.type == EditTypeAdd) {
        
        
    }
    else if(self.type == EditTypeEdit){
        
        self.memorandumTextView.text = self.model.notecontent;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = _completeBtn;
}

// 新增或者修改备忘录
- (void)completeClick {
    
    if(!_tool) {
        _tool = [BQLDBTool instantiateTool];
    }
    
    if(!checkObjectNotNull(self.memorandumTextView.text)) {
        
        return;
    }
    NSDictionary *add = @{@"noteContent":self.memorandumTextView.text,
                          @"noteTime":getTodayDate(@"YYYY/MM/dd HH:mm:ss")};
    MemorandumModel *model = [MemorandumModel modelWithDictionary:add];
    if(self.type == EditTypeAdd) {
        
        if([_tool insertDataWith:MemorandumFile Model:model]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else if(self.type == EditTypeEdit){
        
        if([_tool modifyDataWith:MemorandumFile Model:model Identifier:@"customid" IdentifierValue:[NSString stringWithFormat:@"%lld",self.model.customID]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
