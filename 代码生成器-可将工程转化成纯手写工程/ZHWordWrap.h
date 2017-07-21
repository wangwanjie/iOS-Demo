#import "CreatFatherFile.h"

/*这个类的作用是,类似于XCode全选代码,control+i自动帮你排版*/


@interface ZHWordWrap : CreatFatherFile

/**把你要排版的文件或工程进行排版*/
- (void)wordWrap:(NSString *)path;

/**把你要排版的代码进行排版*/
- (NSString *)wordWrapText:(NSString *)text;
@end