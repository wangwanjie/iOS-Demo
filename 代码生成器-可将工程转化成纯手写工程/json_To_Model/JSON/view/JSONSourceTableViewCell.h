#import <UIKit/UIKit.h>
#import "JSONSourceCellModel.h"
@interface JSONSourceTableViewCell : UITableViewCell
- (void)refreshUI:(JSONSourceCellModel *)dataModel;
@end
