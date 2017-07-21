#import "MoreFunctionTableViewCell.h"
#import "UIView+ZHView.h"

@interface MoreFunctionTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,weak)MoreFunctionCellModel *dataModel;
@end

@implementation MoreFunctionTableViewCell


- (void)refreshUI:(MoreFunctionCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
	self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

@end
