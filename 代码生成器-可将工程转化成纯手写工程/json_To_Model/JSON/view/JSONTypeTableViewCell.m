#import "JSONTypeTableViewCell.h"

@interface JSONTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UISwitch *kvcSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jsmodelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *noneSwitch;
@property (nonatomic,weak)JSONTypeCellModel *dataModel;
@end

@implementation JSONTypeTableViewCell


- (void)refreshUI:(JSONTypeCellModel *)dataModel{
	_dataModel=dataModel;
    
    if (dataModel.selectIndex==0) {
        self.kvcSwitch.on=YES;
        self.jsmodelSwitch.on=NO;
        self.noneSwitch.on=NO;
    }else if (dataModel.selectIndex==1) {
        self.jsmodelSwitch.on=YES;
        self.kvcSwitch.on=NO;
        self.noneSwitch.on=NO;
    }else if (dataModel.selectIndex==2) {
        self.noneSwitch.on=YES;
        self.kvcSwitch.on=NO;
        self.jsmodelSwitch.on=NO;
    }
}

- (void)awakeFromNib {
	// Initialization code
    [super awakeFromNib];
	self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.kvcSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.jsmodelSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.noneSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction:(id)sender{
    
    if ([sender isEqual:self.kvcSwitch]) {
        if (_dataModel.selectIndex==0) {
            self.kvcSwitch.on=YES;
            return;
        }
        _dataModel.selectIndex=0;
    }else if ([sender isEqual:self.jsmodelSwitch]){
        if (_dataModel.selectIndex==1) {
            self.jsmodelSwitch.on=YES;
            return;
        }
        _dataModel.selectIndex=1;
    }else if ([sender isEqual:self.noneSwitch]){
        if (_dataModel.selectIndex==2) {
            self.noneSwitch.on=YES;
            return;
        }
        _dataModel.selectIndex=2;
    }
    
    if (_dataModel.selectIndex==0) {
        self.kvcSwitch.on=YES;
        self.jsmodelSwitch.on=NO;
        self.noneSwitch.on=NO;
    }else if (_dataModel.selectIndex==1) {
        self.jsmodelSwitch.on=YES;
        self.kvcSwitch.on=NO;
        self.noneSwitch.on=NO;
    }else if (_dataModel.selectIndex==2) {
        self.noneSwitch.on=YES;
        self.kvcSwitch.on=NO;
        self.jsmodelSwitch.on=NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

@end
