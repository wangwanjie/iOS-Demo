#import "DetailStepTableViewCell.h"
#import "UIView+ZHView.h"

@interface DetailStepTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak)DetailStepCellModel *dataModel;
@end

@implementation DetailStepTableViewCell


- (void)refreshUI:(DetailStepCellModel *)dataModel{
	_dataModel=dataModel;
    self.nameLabel.text=dataModel.title;
    self.iconImageView.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
}

- (void)awakeFromNib {
	// Initialization code
    [super awakeFromNib];
    [self.iconImageView cornerRadius];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}
@end
