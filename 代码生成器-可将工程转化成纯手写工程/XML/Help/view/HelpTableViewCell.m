#import "HelpTableViewCell.h"
#import "UIView+ZHView.h"

@interface HelpTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (nonatomic,weak)HelpCellModel *dataModel;
@end

@implementation HelpTableViewCell


- (void)refreshUI:(HelpCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
    self.numLabel.text=[NSString stringWithFormat:@"%ld",dataModel.row];
}

- (void)awakeFromNib {
	// Initialization code
    [super awakeFromNib];
    [self.iconImageView cornerRadius];
    self.iconImageView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    self.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.numLabel.textColor=[UIColor whiteColor];
    self.numLabel.backgroundColor=[UIColor clearColor];
    self.nameLabel.backgroundColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
	self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}
@end