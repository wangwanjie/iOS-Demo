#import <Foundation/Foundation.h>

@interface CreatPropert : NSObject
@property (nonatomic,assign) BOOL NSNULL;
@property (nonatomic,assign) BOOL NSDATE;
@property (nonatomic,assign) BOOL NSNUMBER;
@property (nonatomic,assign) BOOL BOOLEAN;
+ (void)creatProperty:(id)obj fileName:(NSString *)fileName WithContext:(NSString *)context savePath:(NSString *)savePath withNSNULL:(BOOL)NSNULL withNSDATE:(BOOL)NSDATE withNSNUMBER:(BOOL)NSNUMBER withGiveData:(NSInteger)category withModelName:(NSString *)modelName withFatherClass:(NSString *)className needEcoding:(BOOL)ecoding;
+ (void)creatCoreOperationWithSavaPath:(NSString *)savePath;
+ (void)clearTextWithModelName:(NSString *)modelName withGiveData:(NSInteger)category;
+ (void)saveTextWithModelName:(NSString *)modelName savePath:(NSString *)savePath;
@end