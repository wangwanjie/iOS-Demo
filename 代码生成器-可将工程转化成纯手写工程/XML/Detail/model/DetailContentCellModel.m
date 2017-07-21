#import "DetailContentCellModel.h"


@implementation DetailContentCellModel

- (void)setTitle:(NSString *)title{
    _title=title;
    
    if (self.width==0) {
        self.width=375-32;
    }
    self.size=[title boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
}

@end