#import "JSONSourceTableViewCell.h"
#import "UIView+ZHView.h"

@interface JSONSourceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (nonatomic,weak)JSONSourceCellModel *dataModel;
@end

@implementation JSONSourceTableViewCell


- (void)refreshUI:(JSONSourceCellModel *)dataModel{
	_dataModel=dataModel;
	self.nameLabel.text=dataModel.title;
    
    if (dataModel.isSelect) {
        self.selectedImageView.hidden=NO;
    }else{
        self.selectedImageView.hidden=YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
	self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [self.iconImageView cornerRadius];
    
    self.iconImageView.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}
@end
