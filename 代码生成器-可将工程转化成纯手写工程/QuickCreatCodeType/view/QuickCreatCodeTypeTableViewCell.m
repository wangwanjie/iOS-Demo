#import "QuickCreatCodeTypeTableViewCell.h"

@interface QuickCreatCodeTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak)QuickCreatCodeTypeCellModel *dataModel;
@end

@implementation QuickCreatCodeTypeTableViewCell


- (void)refreshUI:(QuickCreatCodeTypeCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.numberOfLines=0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}
@end
