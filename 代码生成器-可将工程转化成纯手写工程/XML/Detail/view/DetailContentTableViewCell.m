#import "DetailContentTableViewCell.h"
#import "UIView+ZHView.h"

@interface DetailContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak)DetailContentCellModel *dataModel;
@end

@implementation DetailContentTableViewCell


- (void)refreshUI:(DetailContentCellModel *)dataModel{
	_dataModel=dataModel;
    
    self.nameLabel.text=dataModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.numberOfLines=0;
    [self.bgView cornerRadiusWithFloat:5 borderColor:[UIColor grayColor] borderWidth:1];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}
@end
