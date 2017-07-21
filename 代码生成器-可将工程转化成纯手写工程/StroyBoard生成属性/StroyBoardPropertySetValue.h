#import <Foundation/Foundation.h>

@interface StroyBoardPropertySetValue : NSObject
/**根据property属性生成代码*/
+ (NSString *)getCodePropertysForViewName:(NSString *)viewName WithViewCategory:(NSString *)categoryView;
@end
