#import <UIKit/UIKit.h>

@interface JSONTypeCellModel : NSObject
@property (nonatomic,copy)NSString *iconImageName;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,assign)BOOL shouldShowImage;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,copy)NSString *autoWidthText;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end