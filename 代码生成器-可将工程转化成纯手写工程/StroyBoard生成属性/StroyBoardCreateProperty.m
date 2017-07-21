#import "StroyBoardCreateProperty.h"
#import "StroyBoardPropertySetValue.h"

static NSMutableDictionary *ZHStroyBoardCreateProperty;
static NSMutableDictionary *ZHStroyBoardCreateCategory;
static NSMutableDictionary *ZHStroyBoardCreateId;
static NSMutableDictionary *ZHStroyBoardCreateFile;
static NSMutableDictionary *ZHStroyBoardCreateContent;

@interface StroyBoardCreateProperty ()

@end

@implementation StroyBoardCreateProperty

+ (NSMutableDictionary *)defalutCreateProperty{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardCreateProperty==nil) {
            ZHStroyBoardCreateProperty=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardCreateProperty;
}
+ (NSMutableDictionary *)defalutCreateCategory{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardCreateCategory==nil) {
            ZHStroyBoardCreateCategory=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardCreateCategory;
}
+ (NSMutableDictionary *)defalutCreateFile{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardCreateFile==nil) {
            ZHStroyBoardCreateFile=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardCreateFile;
}
+ (NSMutableDictionary *)defalutCreateContent{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardCreateContent==nil) {
            ZHStroyBoardCreateContent=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardCreateContent;
}
+ (NSMutableDictionary *)defalutCreateId{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ZHStroyBoardCreateId==nil) {
            ZHStroyBoardCreateId=[NSMutableDictionary dictionary];
        }
    });
    return ZHStroyBoardCreateId;
}

+ (NSInteger)createPropertyWithStroyBoardPath:(NSString *)stroyBoardPath withProjectPath:(NSString *)projectPath{
    if ([ZHFileManager fileExistsAtPath:stroyBoardPath]==NO||[ZHFileManager fileExistsAtPath:projectPath]==NO) {
        return -1;
    }
    
    //开始备份一份StroyBoard
    [self backupNewStroyBoard:stroyBoardPath];
    
    //开始查找出自定义属性
    NSString *text=[NSString stringWithContentsOfFile:stroyBoardPath encoding:NSUTF8StringEncoding error:nil];
    
    text=[self getCustomClassFromAllViews:text];
    
    NSInteger count=[self defalutCreateCategory].count;
    
    if (count==0) {
        return 0;
    }
    
    text=[self addOutletProperty:text];
    
    NSArray *files=[ZHFileManager subPathFileArrInDirector:projectPath hasPathExtension:@[@".m"]];
    
    for (NSString *fileName in [self defalutCreateProperty]) {
        for (NSString *realFileName in files) {
            NSString *tempFileName=[ZHFileManager getFileNameNoPathComponentFromFilePath:realFileName];
            if ([tempFileName isEqualToString:fileName]) {
                [[self defalutCreateFile]setValue:realFileName forKey:fileName];
                [[self defalutCreateContent]setValue:[NSMutableString stringWithString:[NSString stringWithContentsOfFile:realFileName encoding:NSUTF8StringEncoding error:nil]] forKey:realFileName];
                break;
            }
        }
    }
    //开始真正的插入代码
    [self insertCode];
    
    //这个要放在最后面在运行,因为如果这个StroyBoard是XCode正在打开的文件,那么一旦改变,Xcode会重新加载一遍,StroyBoard文件比较大,加载时间会有点长,导致有点卡,担心影响执行再下面的代码
    [text writeToFile:stroyBoardPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    [self done];
    return count;
}

/**获取所有控件自己打上的标识符*/
+ (NSString *)getCustomClassFromAllViews:(NSString *)text{
    NSArray *arr=[text componentsSeparatedByString:@"\n"];
    NSMutableArray *arrM=[NSMutableArray array];
    NSString *rowStr,*viewIdenity;
    NSString *ViewControllerFileName=@"noExsit",*CellFileName=@"noExsit";  //要么是ViewController 要么是tableViewCell或者collectionViewCell
    
    for (NSInteger i=0; i<arr.count; i++) {
        rowStr=arr[i];
        
        viewIdenity=[ZHStoryboardTextManager isView:rowStr];
        
        //如果这一行代表的是控件
        if (viewIdenity.length>0) {
            if ([viewIdenity isEqualToString:@"<view "]&&i>0&&([arr[i-1] rangeOfString:@"key=\""].location!=NSNotFound||[arr[i-1] rangeOfString:@"</layoutGuides>"].location!=NSNotFound)) {
                
                //为了后面好设置约束,需要将这类view的id值设成特殊可识别的标识符
                //取出id值
                if ([rowStr rangeOfString:@"customClass=\""].location!=NSNotFound) {
                    NSString *customStr=[rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location+13];
                    customStr=[customStr substringToIndex:[customStr rangeOfString:@"\""].location];
                    
                    if ([customStr hasPrefix:@"_"]) {
                        
                        NSString *idStr=[rowStr substringFromIndex:[rowStr rangeOfString:@"id=\""].location+4];
                        idStr=[idStr substringToIndex:[idStr rangeOfString:@"\""].location];
                        
                        [[self defalutCreateId]setValue:idStr forKey:customStr];
                        
                        [self addCustomClassProperty:customStr withCellFileName:CellFileName withViewControllerFileName:ViewControllerFileName];
                        [[self defalutCreateCategory]setValue:[viewIdenity substringFromIndex:1] forKey:customStr];//<view <label <button <imageView
                        
                        NSString *removeCustom=[NSString stringWithFormat:@" customClass=\"%@\"",customStr];
                        [arrM addObject:[rowStr stringByReplacingOccurrencesOfString:removeCustom withString:@""]];
                        
                        continue;
                    }
                }
            }
            
            //判断是不是Cell
            if ([self isCell:rowStr]) {
                NSString *customClass;
                if ([rowStr rangeOfString:@"customClass=\""].location!=NSNotFound) {
                    customClass=[rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location+13];
                    customClass=[customClass substringToIndex:[customClass rangeOfString:@"\""].location];
                }
                if (customClass.length>0) {
                    CellFileName=customClass;
                }else{
                    CellFileName=@"noExsit";
                }
            }else{
            
                //如果这一行里面有标识符CustomClass
                if ([rowStr rangeOfString:@" customClass=\""].location!=NSNotFound&&[rowStr rangeOfString:@" id=\""].location!=NSNotFound) {
                    NSString *customClass=[rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location+13];
                    customClass=[customClass substringToIndex:[customClass rangeOfString:@"\""].location];
                    
                    if ([customClass hasPrefix:@"_"]) {
                        
                        NSString *idStr=[rowStr substringFromIndex:[rowStr rangeOfString:@"id=\""].location+4];
                        idStr=[idStr substringToIndex:[idStr rangeOfString:@"\""].location];
                        
                        [[self defalutCreateId]setValue:idStr forKey:customClass];
                        
                        [self addCustomClassProperty:customClass withCellFileName:CellFileName withViewControllerFileName:ViewControllerFileName];
                        [[self defalutCreateCategory]setValue:[viewIdenity substringFromIndex:1] forKey:customClass];//<view <label <button <imageView
                        
                        NSString *removeCustom=[NSString stringWithFormat:@" customClass=\"%@\"",customClass];
                        [arrM addObject:[rowStr stringByReplacingOccurrencesOfString:removeCustom withString:@""]];
                        
                        continue;
                    }
                }
            }
        }else{
            
            NSString *tempStr=[ZHNSString removeSpaceBeforeAndAfterWithString:rowStr];
            if([tempStr hasPrefix:@"<viewController "]){
                if([tempStr rangeOfString:@" customClass=\""].location!=NSNotFound){
                    NSString *customClass=[rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location+13];
                    customClass=[customClass substringToIndex:[customClass rangeOfString:@"\""].location];
                    if (customClass.length>0) {
                        ViewControllerFileName=customClass;
                    }else{
                        ViewControllerFileName=@"noExsit";
                    }
                }
            }
            
            if ([tempStr hasPrefix:@"</tableViewCell"]) {
                CellFileName=@"noExsit";
            }
        }
        [arrM addObject:rowStr];
    }
    
    return [arrM componentsJoinedByString:@"\n"];
}

/**为StroyBoard添加真的outlet property*/
+ (NSString *)addOutletProperty:(NSString *)text{
    NSArray *arr=[text componentsSeparatedByString:@"\n"];
    NSMutableArray *arrM=[NSMutableArray array];
    NSString *rowStr,*viewIdenity;
    
    NSArray *cellPropertys,*viewControllerPropertys;
    
    NSInteger isTableViewCell=0;
    
    for (NSInteger i=0; i<arr.count; i++) {
        rowStr=arr[i];
        
        viewIdenity=[ZHStoryboardTextManager isView:rowStr];
        
        //如果这一行代表的是控件
        if (viewIdenity.length>0) {
            //判断是不是Cell
            if ([self isCell:rowStr]) {
                NSString *customClass;
                if ([rowStr rangeOfString:@"customClass=\""].location!=NSNotFound) {
                    customClass=[rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location+13];
                    customClass=[customClass substringToIndex:[customClass rangeOfString:@"\""].location];
                }
                if (customClass.length>0) {
                    if ([self defalutCreateProperty][customClass]!=nil) {
                        cellPropertys =[self defalutCreateProperty][customClass];
                    }
                }else{
                    cellPropertys=nil;
                }
                
                if ([rowStr rangeOfString:@"<tableViewCell"].location!=NSNotFound) {
                    isTableViewCell=1;
                }else if([rowStr rangeOfString:@"<collectionViewCell"].location!=NSNotFound){
                    isTableViewCell=2;
                }
            }
        }else{
            
            NSString *tempStr=[ZHNSString removeSpaceBeforeAndAfterWithString:rowStr];
            if([tempStr hasPrefix:@"<viewController "]){
                if([tempStr rangeOfString:@" customClass=\""].location!=NSNotFound){
                    NSString *customClass=[rowStr substringFromIndex:[rowStr rangeOfString:@"customClass=\""].location+13];
                    customClass=[customClass substringToIndex:[customClass rangeOfString:@"\""].location];
                    
                    if (customClass.length>0) {
                        if ([self defalutCreateProperty][customClass]!=nil) {
                            viewControllerPropertys =[self defalutCreateProperty][customClass];
                        }
                    }else{
                        viewControllerPropertys=nil;
                    }
                }
            }
            
            if ([tempStr hasPrefix:@"</tableViewCell>"]) {
                if(isTableViewCell==1){
                    //说明这个cell之前没有拉过约束
                    if (i>0&&[arr[i-1] rangeOfString:@"</connections>"].location==NSNotFound) {
                        NSMutableString *connections=[NSMutableString string];
                        [connections appendString:@"<connections>\n"];
                        for (NSString *property in cellPropertys) {
                            NSString *newProperty=property;
                            if ([newProperty hasPrefix:@"_"]) {
                                newProperty=[newProperty substringFromIndex:1];
                            }
                            NSString *storyBoardIdString=[self getStoryBoardIdString];
                            while ([text rangeOfString:storyBoardIdString].location!=NSNotFound) {
                                storyBoardIdString=[self getStoryBoardIdString];
                            }
                            NSString *outlet=[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\" id=\"%@\"/>\n",newProperty,[self defalutCreateId][property],storyBoardIdString];
                            if ([text rangeOfString:[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\"",newProperty,[self defalutCreateId][property]]].location==NSNotFound) {
                                [connections appendString:outlet];
                            }
                        }
                        [connections appendString:@"</connections>"];
                        if (cellPropertys.count>0) {
                            [arrM insertObject:connections atIndex:arrM.count];
                        }
                    }
                    //说明这个cell之前有拉过约束
                    else if(i>0&&[arr[i-1] rangeOfString:@"</connections>"].location!=NSNotFound){
                        for (NSString *property in cellPropertys) {
                            NSString *newProperty=property;
                            if ([newProperty hasPrefix:@"_"]) {
                                newProperty=[newProperty substringFromIndex:1];
                            }
                            NSString *storyBoardIdString=[self getStoryBoardIdString];
                            while ([text rangeOfString:storyBoardIdString].location!=NSNotFound) {
                                storyBoardIdString=[self getStoryBoardIdString];
                            }
                            NSString *outlet=[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\" id=\"%@\"/>",newProperty,[self defalutCreateId][property],storyBoardIdString];
                            if ([text rangeOfString:[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\"",newProperty,[self defalutCreateId][property]]].location==NSNotFound) {
                                [arrM insertObject:outlet atIndex:arrM.count-1];
                            }
                        }
                    }
                    
                    cellPropertys=nil;
                    isTableViewCell=0;
                }
            }
            if ([tempStr hasPrefix:@"</collectionViewCell>"]) {
                if (isTableViewCell==2) {
                    //说明这个cell之前没有拉过约束
                    if (i>0&&[arr[i-1] rangeOfString:@"</connections>"].location==NSNotFound) {
                        NSMutableString *connections=[NSMutableString string];
                        [connections appendString:@"<connections>\n"];
                        for (NSString *property in cellPropertys) {
                            NSString *newProperty=property;
                            if ([newProperty hasPrefix:@"_"]) {
                                newProperty=[newProperty substringFromIndex:1];
                            }
                            NSString *storyBoardIdString=[self getStoryBoardIdString];
                            while ([text rangeOfString:storyBoardIdString].location!=NSNotFound) {
                                storyBoardIdString=[self getStoryBoardIdString];
                            }
                            NSString *outlet=[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\" id=\"%@\"/>\n",newProperty,[self defalutCreateId][property],storyBoardIdString];
                            if ([text rangeOfString:[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\"",newProperty,[self defalutCreateId][property]]].location==NSNotFound) {
                                [connections appendString:outlet];
                            }
                        }
                        [connections appendString:@"</connections>"];
                        if (cellPropertys.count>0) {
                            [arrM insertObject:connections atIndex:arrM.count];
                        }
                    }
                    //说明这个cell之前有拉过约束
                    else if(i>0&&[arr[i-1] rangeOfString:@"</connections>"].location!=NSNotFound){
                        for (NSString *property in cellPropertys) {
                            NSString *newProperty=property;
                            if ([newProperty hasPrefix:@"_"]) {
                                newProperty=[newProperty substringFromIndex:1];
                            }
                            NSString *storyBoardIdString=[self getStoryBoardIdString];
                            while ([text rangeOfString:storyBoardIdString].location!=NSNotFound) {
                                storyBoardIdString=[self getStoryBoardIdString];
                            }
                            NSString *outlet=[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\" id=\"%@\"/>",newProperty,[self defalutCreateId][property],storyBoardIdString];
                            if ([text rangeOfString:[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\"",newProperty,[self defalutCreateId][property]]].location==NSNotFound) {
                                [arrM insertObject:outlet atIndex:arrM.count-1];
                            }
                        }
                    }
                    
                    cellPropertys=nil;
                    isTableViewCell=0;
                }
            }
            if ([tempStr hasPrefix:@"</viewController>"]) {
                //说明这个viewController之前没有拉过约束
                if (i>0&&[arr[i-1] rangeOfString:@"</connections>"].location==NSNotFound) {
                    NSMutableString *connections=[NSMutableString string];
                    [connections appendString:@"<connections>\n"];
                    for (NSString *property in viewControllerPropertys) {
                        NSString *newProperty=property;
                        if ([newProperty hasPrefix:@"_"]) {
                            newProperty=[newProperty substringFromIndex:1];
                        }
                        NSString *storyBoardIdString=[self getStoryBoardIdString];
                        while ([text rangeOfString:storyBoardIdString].location!=NSNotFound) {
                            storyBoardIdString=[self getStoryBoardIdString];
                        }
                        NSString *outlet=[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\" id=\"%@\"/>\n",newProperty,[self defalutCreateId][property],storyBoardIdString];
                        if ([text rangeOfString:[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\"",newProperty,[self defalutCreateId][property]]].location==NSNotFound) {
                            [connections appendString:outlet];
                        }
                    }
                    [connections appendString:@"</connections>"];
                    if (viewControllerPropertys.count>0) {
                        [arrM insertObject:connections atIndex:arrM.count];
                    }
                }
                //说明这个viewController之前有拉过约束
                else if(i>0&&[arr[i-1] rangeOfString:@"</connections>"].location!=NSNotFound){
                    for (NSString *property in viewControllerPropertys) {
                        NSString *newProperty=property;
                        if ([newProperty hasPrefix:@"_"]) {
                            newProperty=[newProperty substringFromIndex:1];
                        }
                        NSString *storyBoardIdString=[self getStoryBoardIdString];
                        while ([text rangeOfString:storyBoardIdString].location!=NSNotFound) {
                            storyBoardIdString=[self getStoryBoardIdString];
                        }
                        NSString *outlet=[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\" id=\"%@\"/>",newProperty,[self defalutCreateId][property],storyBoardIdString];
                        if ([text rangeOfString:[NSString stringWithFormat:@"<outlet property=\"%@\" destination=\"%@\"",newProperty,[self defalutCreateId][property]]].location==NSNotFound) {
                            [arrM insertObject:outlet atIndex:arrM.count-1];
                        }
                    }
                }
                
                viewControllerPropertys=nil;
            }
        }
        [arrM addObject:rowStr];
    }
    
    return [arrM componentsJoinedByString:@"\n"];
}

+ (void)insertCode{
    for (NSString *fileName in [self defalutCreateProperty]) {
        [self insertCodePropertys:[self defalutCreateProperty][fileName] toStrM:[self defalutCreateContent][[self defalutCreateFile][fileName]] withFileName:fileName];
    }
}

+ (void)insertCodePropertys:(NSArray *)propertys toStrM:(NSMutableString *)strM withFileName:(NSString *)fileName{
    //首先判断里面有没有类扩展
//    @interface
    if ([strM rangeOfString:@"@interface"].location==NSNotFound) {
        NSString *interface=[NSString stringWithFormat:@"@interface %@ ()\n\
                             \n\
                             @end",fileName];
        [ZHStoryboardTextManager addCodeText:interface andInsertType:ZHAddCodeType_Import toStrM:strM insertFunction:nil];
    }
    
    for (NSString *property in propertys) {
        NSString *newProperty=[self getPropertyCode:property];
        if ([strM rangeOfString:newProperty].location==NSNotFound) {
            [ZHStoryboardTextManager addCodeText:newProperty andInsertType:ZHAddCodeType_Interface toStrM:strM insertFunction:nil];
        }
    }
    
    //本来是要插入函数的,这里暂时不要了
    if(propertys.count>0){
        if ([strM rangeOfString:@"- (void)setPropertyValues{"].location!=NSNotFound) {
            NSString *setValue=[self getSetValueFunc:propertys isExsitFunc:YES];
            setValue=[@"\n" stringByAppendingString:setValue];
            [ZHStoryboardTextManager addCodeText:setValue andInsertType:ZHAddCodeType_InsertFunction toStrM:strM insertFunction:@"- (void)setPropertyValues{"];
        }else{
            NSString *setValue=[self getSetValueFunc:propertys isExsitFunc:NO];
            [ZHStoryboardTextManager addCodeText:setValue andInsertType:ZHAddCodeType_Implementation toStrM:strM insertFunction:nil];
        }
    }
}

+ (NSString *)getPropertyCode:(NSString *)property{
    NSString *category=[self defalutCreateCategory][property];
    category=[ZHNSString removeSpaceBeforeAndAfterWithString:category];
    
    if ([property hasPrefix:@"_"]) {
        property=[property substringFromIndex:1];
    }
    
    NSString *viewCategory;
    if ([category hasPrefix:@"mapView"]) {
        viewCategory=@"MKMapView";
    }
    
    viewCategory=[@"UI" stringByAppendingString:[ZHStoryboardTextManager upFirstCharacter:category]];
    return [NSString stringWithFormat:@"@property (weak, nonatomic) IBOutlet %@ *%@;",viewCategory,property];
}

+ (NSString *)getSetValueFunc:(NSArray *)propertys isExsitFunc:(BOOL)isExsitFunc{
    NSMutableString *codeFunc=[NSMutableString string];
    
    if (isExsitFunc==NO) {
        [codeFunc appendString:@"- (void)setPropertyValues{\n"];
    }
    
    for (NSString *property in propertys) {
        NSString *category=[self defalutCreateCategory][property];
        category=[ZHNSString removeSpaceBeforeAndAfterWithString:category];
        
        NSString *propertyTemp=property;
        if ([propertyTemp hasPrefix:@"_"]) {
            propertyTemp=[propertyTemp substringFromIndex:1];
        }
        
        NSString *code=[StroyBoardPropertySetValue getCodePropertysForViewName:propertyTemp WithViewCategory:category];
        
        if(code.length>0)
            [codeFunc appendFormat:@"\t%@\n",code];
    }
    
    if (isExsitFunc==NO) {
        [codeFunc appendString:@"}"];
    }
    
    return codeFunc;
}
+ (BOOL)isCell:(NSString *)rowStr{
    if ([rowStr rangeOfString:@"<tableViewCell"].location!=NSNotFound||[rowStr rangeOfString:@"<collectionViewCell"].location!=NSNotFound) {
        return YES;
    }
    return NO;
}

+ (void)addCustomClassProperty:(NSString *)customClass withCellFileName:(NSString *)cellFileName withViewControllerFileName:(NSString *)viewControllerFileName{
    if ([cellFileName isEqualToString:@"noExsit"]) {
        if ([viewControllerFileName isEqualToString:@"noExsit"]==NO) {
            NSMutableArray *propertyArrM=[self defalutCreateProperty][viewControllerFileName];
            if (propertyArrM==nil) {
                propertyArrM=[NSMutableArray array];
            }
            [propertyArrM addObject:customClass];
            [[self defalutCreateProperty]setValue:propertyArrM forKey:viewControllerFileName];
        }
    }else{
        NSMutableArray *propertyArrM=[self defalutCreateProperty][cellFileName];
        if (propertyArrM==nil) {
            propertyArrM=[NSMutableArray array];
        }
        [propertyArrM addObject:customClass];
        [[self defalutCreateProperty]setValue:propertyArrM forKey:cellFileName];
    }
}

+ (void)backupNewStroyBoard:(NSString *)filePath{
    //有后缀的文件名
    NSString *tempFileName=[ZHFileManager getFileNameFromFilePath:filePath];
    
    //无后缀的文件名
    NSString *fileName=[ZHFileManager getFileNameNoPathComponentFromFilePath:filePath];
    
    //获取无文件名的路径
    NSString *newFilePath=[filePath stringByReplacingOccurrencesOfString:tempFileName withString:@""];
    
    //拿到新的有后缀的文件名
    tempFileName=[tempFileName stringByReplacingOccurrencesOfString:fileName withString:[NSString stringWithFormat:@"%@备份",fileName]];
    
    newFilePath = [newFilePath stringByAppendingPathComponent:tempFileName];
    
    [ZHFileManager copyItemAtPath:filePath toPath:newFilePath];
}

+ (void)done{
    //开始保存所有编程文件
    [[self defalutCreateCategory]removeAllObjects];
    [[self defalutCreateProperty]removeAllObjects];
    
    for (NSString *filePath in [self defalutCreateContent]) {
        NSString *text=[self defalutCreateContent][filePath];
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    [[self defalutCreateFile]removeAllObjects];
    [[self defalutCreateContent]removeAllObjects];
    [[self defalutCreateId]removeAllObjects];
}

+ (NSString *)getStoryBoardIdString{
    //    gSS-Oy-SNc
    NSMutableString *idText=[NSMutableString string];
    while (idText.length<3) {
        [idText appendString:[self getCharacter]];
    }
    [idText appendString:@"-"];
    while (idText.length<6) {
        [idText appendString:[self getCharacter]];
    }
    [idText appendString:@"-"];
    while (idText.length<10) {
        [idText appendString:[self getCharacter]];
    }
    return idText;
}
+ (NSString *)getCharacter{
    NSInteger count=arc4random()%3+1;
    
    unichar ch;
    if (count==1) {
        ch='0'+arc4random()%10;
    }else if (count==2){
        ch='A'+arc4random()%26;
    }else if (count==3){
        ch='a'+arc4random()%26;
    }
    return [NSString stringWithFormat:@"%C",ch];
}
@end