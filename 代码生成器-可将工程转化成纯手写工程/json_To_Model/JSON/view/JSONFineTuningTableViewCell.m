#import "JSONFineTuningTableViewCell.h"
#import "UIView+ZHView.h"

@interface JSONFineTuningTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (nonatomic,weak)JSONFineTuningCellModel *dataModel;
@end

@implementation JSONFineTuningTableViewCell


- (void)refreshUI:(JSONFineTuningCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
    self.rowLabel.text=[NSString stringWithFormat:@"%ld",dataModel.row];
    self.mySwitch.on=dataModel.isSelect;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.iconImageView.backgroundColor=[UIColor grayColor];
    [self.iconImageView cornerRadius];
    
    [self.mySwitch addTarget:self action:@selector(switchAction) forControlEvents:1<<12];
}

- (void)switchAction{
    self.dataModel.isSelect=self.mySwitch.on;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}
@end
