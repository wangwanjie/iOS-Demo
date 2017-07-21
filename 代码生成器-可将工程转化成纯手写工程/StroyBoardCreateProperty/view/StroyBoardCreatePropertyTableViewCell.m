#import "StroyBoardCreatePropertyTableViewCell.h"

@interface StroyBoardCreatePropertyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (nonatomic,weak)StroyBoardCreatePropertyCellModel *dataModel;
@end

@implementation StroyBoardCreatePropertyTableViewCell


- (void)refreshUI:(StroyBoardCreatePropertyCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=[ZHFileManager getFileNameNoPathComponentFromFilePath:dataModel.title];
    self.subTitleLabel.text=[ZHFileManager getFileNameNoPathComponentFromFilePath:dataModel.subTitle];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.okButton addTarget:self action:@selector(okAction) forControlEvents:1<<6];
    
    [self.okButton cornerRadiusWithFloat:5];
    self.okButton.backgroundColor=[UIColor orangeColor];
}

- (void)okAction{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[self getViewController].view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在生成代码!";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 处理耗时操作的代码块...
        NSInteger count=[StroyBoardCreateProperty createPropertyWithStroyBoardPath:self.dataModel.title withProjectPath:self.dataModel.subTitle];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            if(count==-1){
                hud.labelText=[NSString stringWithFormat:@"工程路径已不存在"];
            }else if(count==0){
                hud.labelText=[NSString stringWithFormat:@"工程StroyBoard没有做自定义属性"];
            }else
                hud.labelText=[NSString stringWithFormat:@"处理了%ld个outlet属性",count];
            //回调或者说是通知主线程刷新，
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:[self getViewController].view animated:YES];
            });
        });
        
    });
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

@end