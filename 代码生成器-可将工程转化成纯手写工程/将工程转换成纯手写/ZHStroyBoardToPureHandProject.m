#import "ZHStroyBoardToPureHandProject.h"

@interface ZHStroyBoardToPureHandProject ()
@property (nonatomic,strong)NSDictionary *customAndId;
@property (nonatomic,strong)NSDictionary *customAndName;
@property (nonatomic,strong)NSDictionary *idAndViewPropertys;
@property (nonatomic,strong)NSDictionary *idAndOutletViews;
@property (nonatomic,strong)NSDictionary *idAndViews;
@property (nonatomic,copy)NSString *projectPath;
@property (nonatomic,strong) NSMutableDictionary *ZHStroyBoardCreateFile;
@property (nonatomic,strong) NSMutableDictionary *ZHStroyBoardCreateContent;

@property (nonatomic,strong)NSMutableArray *didDoneDataArr;

@end

@implementation ZHStroyBoardToPureHandProject

- (NSMutableArray *)didDoneDataArr{
    if (!_didDoneDataArr) {
        _didDoneDataArr=[NSMutableArray array];
    }
    return _didDoneDataArr;
}
- (NSMutableDictionary *)ZHStroyBoardCreateFile{
    if (!_ZHStroyBoardCreateFile) {
        _ZHStroyBoardCreateFile=[NSMutableDictionary dictionary];
    }
    return _ZHStroyBoardCreateFile;
}

- (NSMutableDictionary *)ZHStroyBoardCreateContent{
    if (!_ZHStroyBoardCreateContent) {
        _ZHStroyBoardCreateContent=[NSMutableDictionary dictionary];
    }
    return _ZHStroyBoardCreateContent;
}

- (void)transformProjectToPureHandProject:(NSString *)projectPath{
    
    self.projectPath=projectPath;
    
    NSMutableArray *dataArr=[NSMutableArray array];
    
    NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:projectPath hasPathExtension:@[@".storyboard"]];
    
    for (NSString *fileName in fileArr) {
        NSString *tempStr=[ZHFileManager getFileNameNoPathComponentFromFilePath:fileName];
        if ([tempStr rangeOfString:@"备份"].location!=NSNotFound||[tempStr isEqualToString:@"LaunchScreen"]) {
            continue;
        }
        
        [dataArr addObject:fileName];
    }
    
    NSMutableArray *viewControllerArrM=[NSMutableArray array];
    NSMutableArray *cellArrM=[NSMutableArray array];
    
    for (NSString *SBfileName in dataArr) {
        if ([ZHFileManager fileExistsAtPath:SBfileName]) {
            NSString *context=[NSString stringWithContentsOfFile:SBfileName encoding:NSUTF8StringEncoding error:nil];
            ReadXML *xml=[ReadXML new];
            [xml initWithXMLString:context];
            NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
            NSArray *allViewControllers=[ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
            for (NSDictionary *viewControllerDic in allViewControllers) {
                [ZHStoryboardXMLManager getAllTableViewCellNamesWithConditionDic:viewControllerDic andXMLHandel:xml toArrM:cellArrM];
                [ZHStoryboardXMLManager getAllCollectionViewCellNamesWithConditionDic:viewControllerDic andXMLHandel:xml toArrM:cellArrM];
            }
            
            //    获取所有的ViewController名字
            NSArray *viewControllers=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
            for (NSString *viewController in viewControllers) {
                if ([viewControllerArrM containsObject:viewController]==NO) {
                    [viewControllerArrM addObject:viewController];
                }
            }
        }
    }
    
    NSArray *fileArrViewController=[ZHFileManager subPathFileArrInDirector:projectPath hasPathExtension:@[@".m"]];
    
    for (NSString *fileName in viewControllerArrM) {
        for (NSString *filePath in fileArrViewController) {
            if ([[ZHFileManager getFileNameNoPathComponentFromFilePath:filePath]isEqualToString:fileName]) {
                [self.ZHStroyBoardCreateFile setValue:filePath forKey:fileName];
                [self.ZHStroyBoardCreateContent setValue:[NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] forKey:filePath];
                break;
            }
        }
    }
    
    for (NSString *fileName in cellArrM) {
        for (NSString *filePath in fileArrViewController) {
            if ([[ZHFileManager getFileNameNoPathComponentFromFilePath:filePath]isEqualToString:fileName]) {
                [self.ZHStroyBoardCreateFile setValue:filePath forKey:fileName];
                [self.ZHStroyBoardCreateContent setValue:[NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] forKey:filePath];
                break;
            }
        }
    }
    
    NSArray *fileArrViewController_H=[ZHFileManager subPathFileArrInDirector:projectPath hasPathExtension:@[@".h"]];
    for (NSString *fileName in cellArrM) {
        for (NSString *filePath in fileArrViewController_H) {
            if ([[ZHFileManager getFileNameNoPathComponentFromFilePath:filePath]isEqualToString:fileName]) {
                NSString *text=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                text=[text stringByReplacingOccurrencesOfString:@"@property (weak, nonatomic) IBOutlet" withString:@"@property (strong, nonatomic)"];
                [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                break;
            }
        }
    }
    
    for (NSString *sbFileName in dataArr) {
        [self StroyBoard_To_Masonry:sbFileName];
    }
    
    [self done];
    
    for (NSString *filePath in fileArrViewController) {
        NSString *text=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        text=[self layoutIfNeededAnnotation:text];
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    for (NSString *filePath in fileArrViewController_H) {
        NSString *text=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        text=[self layoutIfNeededAnnotation:text];
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
- (void)done{
    
    //这句话一定要加
    [ZHStroyBoardFileManager done];
    [ZHStoryboardTextManager done];
    
    for (NSString *filePath in self.ZHStroyBoardCreateContent) {
        NSString *text=self.ZHStroyBoardCreateContent[filePath];
        text=[text stringByReplacingOccurrencesOfString:@"@property (weak, nonatomic) IBOutlet" withString:@"@property (strong, nonatomic)"];
        text=[text stringByReplacingOccurrencesOfString:@"IBOutlet" withString:@""];
        text=[text stringByReplacingOccurrencesOfString:@"(IBAction)" withString:@"(void)"];
        
        text=[[ZHWordWrap new] wordWrapText:text];
        
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

/**给layoutIfNeeded 这句代码注释掉*/
- (NSString *)layoutIfNeededAnnotation:(NSString *)text{
    NSMutableArray *arrM=[NSMutableArray array];
    NSArray *arr=[text componentsSeparatedByString:@"\n"];
    for (NSString *str in arr) {
        if (str.length>0) {
            if([str rangeOfString:@"layoutIfNeeded"].location!=NSNotFound){
                [arrM addObject:[NSString stringWithFormat:@"//%@",str]];
            }else{
                [arrM addObject:str];
            }
        }else{
            [arrM addObject:@""];
        }
    }
    
    text=[arrM componentsJoinedByString:@"\n"];
    return text;
}

- (void)StroyBoard_To_Masonry:(NSString *)stroyBoard{
    
    NSString *filePath=stroyBoard;
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return;
    }
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[ZHStoryboardTextManager addCustomClassToAllViewsForPureHandProject:context];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViewControllers=[ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
    
    //获取所有View的CustomClass与对应的id
    NSDictionary *customAndId=[ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndId=customAndId;
    //获取所有View的CustomClass与对应的真实控件类型名字
    NSDictionary *customAndName=[ZHStoryboardXMLManager getAllViewCustomAndNameWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndName=customAndName;
    
    NSDictionary *idAndViews=[ZHStoryboardXMLManager getAllViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndViews=idAndViews;
    
    NSDictionary *idAndViewPropertys=[ZHStoryboardPropertyManager getPropertysForView:idAndViews withCustomAndName:customAndName andXMLHandel:xml];
    self.idAndViewPropertys=idAndViewPropertys;
    
    NSDictionary *idAndOutletViews=[ZHStoryboardXMLManager getAllOutletViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndOutletViews=idAndOutletViews;
    
    //开始操作所有ViewController
    for (NSDictionary *dic in allViewControllers) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                if ([[self.ZHStroyBoardCreateFile allKeys]containsObject:viewController]==NO) {
                    continue;
                }
                if ([self.didDoneDataArr containsObject:viewController]) {
                    continue;
                }else{
                    [self.didDoneDataArr addObject:viewController];
                }
                
                //获取这个ViewController的所有tableView ,其中每个tableView都对应其所有的tableViewCell
                NSDictionary *tableViewCellDic=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                
                NSDictionary *allTableViewCellsAndId=[ZHStoryboardXMLManager getAllTableViewCellAndIdWithViewControllerDic:dic andXMLHandel:xml];
                NSMutableDictionary *customAndNameTemp=[NSMutableDictionary dictionary];
                for (NSString *customName in allTableViewCellsAndId) {
                    [customAndNameTemp setValue:@"tableViewCell" forKey:customName];
                }
                NSDictionary *idAndViewPropertysTemp1=[ZHStoryboardPropertyManager getPropertysForView:allTableViewCellsAndId withCustomAndName:customAndNameTemp andXMLHandel:xml];
                
                //获取这个ViewController的所有collectionView ,其中每个collectionView都对应其所有的collectionViewCell
                NSDictionary *collectionViewCellDic=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                
                NSDictionary *allCollectionViewCellsAndId=[ZHStoryboardXMLManager getAllCollectionViewCellAndIdWithViewControllerDic:dic andXMLHandel:xml];
                customAndNameTemp=[NSMutableDictionary dictionary];
                for (NSString *customName in allCollectionViewCellsAndId) {
                    [customAndNameTemp setValue:@"collectionViewCell" forKey:customName];
                }
                NSDictionary *idAndViewPropertysTemp2=[ZHStoryboardPropertyManager getPropertysForView:allCollectionViewCellsAndId withCustomAndName:customAndNameTemp andXMLHandel:xml];
                
                NSMutableDictionary *idAndViewPropertys_My=[NSMutableDictionary dictionary];
                for (NSString *idStr in idAndViewPropertysTemp1) {
                    [idAndViewPropertys_My setValue:idAndViewPropertysTemp1[idStr] forKey:idStr];
                }
                for (NSString *idStr in idAndViewPropertysTemp2) {
                    [idAndViewPropertys_My setValue:idAndViewPropertysTemp2[idStr] forKey:idStr];
                }
                
                //插入属性property
                NSArray *views=[ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                //获取特殊的View --- >self.view
                [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:@"self.view" withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                
                
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里,取出拉线出来的约束,并且拿到当为这个约束赋值时的代码改成masonry对应的代码
                NSDictionary *updataMasonryDic=[ZHStoryboardTextManager getUpdataMasonryCodeWithViewConstraintDic:viewConstraintDicM_Self_NEW withOutletView:self.idAndOutletViews];
                NSArray *shouldOutlet=updataMasonryDic[@"shouldOutlet"];
                NSDictionary *replaceMasonry=updataMasonryDic[@"replaceMasonry"];
                
                for (NSString *viewStr in shouldOutlet) {
                    [ZHStoryboardTextManager addCodeText:[ZHStoryboardTextManager getOutletViewCodeWithView:viewStr withViewCategoryName:self.customAndName[viewStr]] andInsertType:ZHAddCodeType_Interface toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]] insertFunction:nil];
                }
                
                //替换所有的约束的.constant=;
                [ZHStoryboardTextManager replaceConstantToMasonry:replaceMasonry ToStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]]];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [ZHStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止又一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
                
                for (NSString *idStr in views) {
                    NSString *fatherView=[ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    NSString *creatCode=[ZHStoryboardTextManager getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] withOutletView:self.idAndOutletViews addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:NO];
                    
                    if ([shouldOutlet containsObject:idStr]) {
                        creatCode=[creatCode stringByAppendingFormat:@"self.%@=%@;\n",self.customAndId[idStr],self.customAndId[idStr]];
                    }
                    
                    NSMutableString *propertyCode=[NSMutableString string];
                    [propertyCode setString:creatCode];
                    
                    [ZHStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:customAndId withCustomAndName:customAndName withProperty:idAndViewPropertys[idStr] toCodeText:propertyCode];
                    
                    [creatCodeStrM appendString:propertyCode];
                    
                    NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
                    [ZHStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
                    
                    //创建约束
                    NSString *constraintCode=[ZHStoryboardTextManager getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:self.idAndOutletViews isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:NO];
                    
                    //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
                    if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                        
                        NSString *constraintCodeDefualt=[ZHStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                        constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                        constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
                    }
                    
                    [creatCodeStrM appendString:constraintCode];
                }
                
                //解决self.tableView3=tableView3;的问题 但是实际上这个viewcontroller只有一个tableView
                [ZHStoryboardTextManager dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:NO];
                
                for (NSString *tableView in tableViewCellDic) {
                    [creatCodeStrM appendFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;\n",self.idAndOutletViews[tableView],self.idAndOutletViews[tableView]];
                }
                
                
                for (NSString *collectionView in collectionViewCellDic) {
                    [creatCodeStrM appendFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;\n",self.idAndOutletViews[collectionView],self.idAndOutletViews[collectionView]];
                }
                
                [creatCodeStrM appendString:@"}\n"];
                
                [ZHStoryboardTextManager addCodeText:creatCodeStrM andInsertType:ZHAddCodeType_Implementation toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]] insertFunction:nil];
                
                //解决UIMapView *mapView1;的问题
                [ZHStoryboardTextManager dealWith_UIMapView:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]] needInserFramework:NO];
                
                NSString *tempCode=self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]];
                tempCode=[tempCode stringByReplacingOccurrencesOfString:@"viewDidLoad " withString:@"viewDidLoad"];
                self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]]=[NSMutableString stringWithString:tempCode];
                
                //注册cell
                NSMutableString *registerClassText=[NSMutableString string];
                
                for (NSString *tableView in tableViewCellDic) {
                    NSArray *cells=tableViewCellDic[tableView];
                    for (NSString *cell in cells) {
                        //有时候tableViewCell的关联文件和复用标识不一样
                        ViewProperty *property=idAndViewPropertys_My[cell];
                        if (property.reuseIdentifier.length<=0) property.reuseIdentifier=cell;
                        [registerClassText appendFormat:@"[self.%@ registerClass:[%@ class] forCellReuseIdentifier:@\"%@\"];\n",self.idAndOutletViews[tableView],cell,property.reuseIdentifier];
                    }
                }
                
                for (NSString *collectionView in collectionViewCellDic) {
                    NSArray *cells=collectionViewCellDic[collectionView];
                    for (NSString *cell in cells) {
                        //有时候collectionViewCell的关联文件和复用标识不一样
                        ViewProperty *property=idAndViewPropertys_My[cell];
                        if (property.reuseIdentifier.length<=0) property.reuseIdentifier=cell;
                        [registerClassText appendFormat:@"[self.%@ registerClass:[%@ class] forCellWithReuseIdentifier:@\"%@\"];\n",self.idAndOutletViews[collectionView],cell,property.reuseIdentifier];
                    }
                }
                
                if(registerClassText.length>0){
                    [ZHStoryboardTextManager addCodeText:[NSString stringWithFormat:@"\n%@",registerClassText] andInsertType:ZHAddCodeType_InsertFunction toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]] insertFunction:@"viewDidLoad{"];
                }
                
                BOOL result=[ZHStoryboardTextManager addCode:@"[self addSubViews];" ToTargetAfter:@"[super viewDidLoad];" toText:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]]];
                if (result==NO) {
                    [ZHStoryboardTextManager addCode:@"[self addSubViews];" ToTargetAfter:@"viewDidLoad{" toText:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[viewController]]];
                }
            }
            
            NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            
            [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
            [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        }
    }
    
    NSInteger count=0;
    
    count=[ZHStoryboardTextManager getAllViewCount];
    
    customAndId=nil;
    customAndName=nil;
    xml=nil;
}

/**递归继续子cell的代码生成*/
- (void)detailSubCells:(NSArray *)subCells andXMLHandel:(ReadXML *)xml withFatherViewController:(NSString *)viewController{
    for (NSDictionary *subDic in subCells) {
        
        NSString *fatherCellName=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
        
        if ([[self.ZHStroyBoardCreateFile allKeys]containsObject:fatherCellName]==NO) {
            continue;
        }
        if ([self.didDoneDataArr containsObject:fatherCellName]) {
            continue;
        }else{
            [self.didDoneDataArr addObject:fatherCellName];
        }
        
        NSDictionary *allTableViewCellsAndId=[ZHStoryboardXMLManager getAllTableViewCellAndIdWithViewControllerDic:subDic andXMLHandel:xml];
        NSMutableDictionary *customAndNameTemp=[NSMutableDictionary dictionary];
        for (NSString *customName in allTableViewCellsAndId) {
            [customAndNameTemp setValue:@"tableViewCell" forKey:customName];
        }
        NSDictionary *idAndViewPropertysTemp1=[ZHStoryboardPropertyManager getPropertysForView:allTableViewCellsAndId withCustomAndName:customAndNameTemp andXMLHandel:xml];
        
        NSDictionary *allCollectionViewCellsAndId=[ZHStoryboardXMLManager getAllCollectionViewCellAndIdWithViewControllerDic:subDic andXMLHandel:xml];
        customAndNameTemp=[NSMutableDictionary dictionary];
        for (NSString *customName in allCollectionViewCellsAndId) {
            [customAndNameTemp setValue:@"collectionViewCell" forKey:customName];
        }
        NSDictionary *idAndViewPropertysTemp2=[ZHStoryboardPropertyManager getPropertysForView:allCollectionViewCellsAndId withCustomAndName:customAndNameTemp andXMLHandel:xml];
        
        NSMutableDictionary *idAndViewPropertys_My=[NSMutableDictionary dictionary];
        for (NSString *idStr in idAndViewPropertysTemp1) {
            [idAndViewPropertys_My setValue:idAndViewPropertysTemp1[idStr] forKey:idStr];
        }
        for (NSString *idStr in idAndViewPropertysTemp2) {
            [idAndViewPropertys_My setValue:idAndViewPropertysTemp2[idStr] forKey:idStr];
        }
        
        NSDictionary *subTableViewCells=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        NSDictionary *subCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        //插入属性property
        NSArray *views=[ZHStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:subDic andXMLHandel:xml];
        
        //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
        NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
        NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
        
        
        //获取特殊的View --- >self.view
        [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:fatherCellName withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        
        
        for (NSString *idStr in views) {
            
            //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
            [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        }
        
        NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
        NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
        
        
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        
        
        
        //在这里,取出拉线出来的约束,并且拿到当为这个约束赋值时的代码改成masonry对应的代码
        NSDictionary *updataMasonryDic=[ZHStoryboardTextManager getUpdataMasonryCodeWithViewConstraintDic:viewConstraintDicM_Self_NEW withOutletView:self.idAndOutletViews];
        NSArray *shouldOutlet=updataMasonryDic[@"shouldOutlet"];
        NSDictionary *replaceMasonry=updataMasonryDic[@"replaceMasonry"];
        for (NSString *viewStr in shouldOutlet) {
            [ZHStoryboardTextManager addCodeText:[ZHStoryboardTextManager getOutletViewCodeWithView:viewStr withViewCategoryName:self.customAndName[viewStr]] andInsertType:ZHAddCodeType_Interface toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]] insertFunction:nil];
        }
        
        //替换所有的约束的.constant=;
        [ZHStoryboardTextManager replaceConstantToMasonry:replaceMasonry ToStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]]];
        
        //在这里插入所有view的创建和约束
        
        //开始建立一个父子和兄弟关系的链表
        NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
        [ZHStoryboardXMLManager createRelationShipWithControllerDic:subDic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:YES];
        
        //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
        NSMutableArray *brotherOrderArrM=[NSMutableArray array];
        
        //1.首先开始创建控件  从父亲的subViews开始
        NSMutableString *creatCodeStrM=[NSMutableString string];
        [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
        for (NSString *idStr in views) {
            NSString *fatherView=[ZHStoryboardTextManager getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];

            NSString *creatCode=[ZHStoryboardTextManager getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] withOutletView:self.idAndOutletViews addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:NO];
            
            if ([shouldOutlet containsObject:idStr]) {
                creatCode=[creatCode stringByAppendingFormat:@"self.%@=%@;\n",self.customAndId[idStr],self.customAndId[idStr]];
            }
            
            NSMutableString *propertyCode=[NSMutableString string];
            [propertyCode setString:creatCode];
            
            [ZHStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:self.customAndId withCustomAndName:self.customAndName withProperty:self.idAndViewPropertys[idStr] toCodeText:propertyCode];
            
            [creatCodeStrM appendString:propertyCode];
            
            NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
            [ZHStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
            
            //创建约束
            NSString *constraintCode=[ZHStoryboardTextManager getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:self.idAndOutletViews isCell:YES withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:NO];
            
            //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
            if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                
                NSString *constraintCodeDefualt=[ZHStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
            }
            
            [creatCodeStrM appendString:constraintCode];
        }
        
        //解决self.tableView3=tableView3;的问题
        [ZHStoryboardTextManager dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:NO];
        
        //注册cell
        NSMutableString *registerClassText=[NSMutableString string];
        
        for (NSString *tableView in subTableViewCells) {
            NSArray *cells=subTableViewCells[tableView];
            for (NSString *cell in cells) {
                //有时候tableViewCell的关联文件和复用标识不一样
                ViewProperty *property=idAndViewPropertys_My[cell];
                if (property.reuseIdentifier.length<=0) property.reuseIdentifier=cell;
                [registerClassText appendFormat:@"[self.%@ registerClass:[%@ class] forCellReuseIdentifier:@\"%@\"];\n",self.idAndOutletViews[tableView],cell,property.reuseIdentifier];
            }
        }
        
        for (NSString *collectionView in subCollectionViewCells) {
            NSArray *cells=subCollectionViewCells[collectionView];
            for (NSString *cell in cells) {
                //有时候collectionViewCell的关联文件和复用标识不一样
                ViewProperty *property=idAndViewPropertys_My[cell];
                if (property.reuseIdentifier.length<=0) property.reuseIdentifier=cell;
                [registerClassText appendFormat:@"[self.%@ registerClass:[%@ class] forCellWithReuseIdentifier:@\"%@\"];\n",self.idAndOutletViews[collectionView],cell,property.reuseIdentifier];
            }
        }
        
        if(registerClassText.length>0){
            [creatCodeStrM appendFormat:@"%@\n",registerClassText];
        }
        
        for (NSString *tableView in subTableViewCells) {
            [creatCodeStrM appendFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;\n",self.idAndOutletViews[tableView],self.idAndOutletViews[tableView]];
        }
        
        
        for (NSString *collectionView in subCollectionViewCells) {
            [creatCodeStrM appendFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;\n",self.idAndOutletViews[collectionView],self.idAndOutletViews[collectionView]];
        }
        
        NSString *tempCode=self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]];
        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"awakeFromNib " withString:@"awakeFromNib"];
        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"-(void)" withString:@"- (void)"];
        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"- (void) " withString:@"- (void)"];
        self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]]=[NSMutableString stringWithString:tempCode];
        
        NSString *funcTemp=[ZHStoryboardTextManager findCodeFunctionWithIdentity:@"- (void)awakeFromNib{" WithText:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]]];
        
        NSString *tempCodeNew=self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]];
        tempCodeNew=[tempCodeNew stringByReplacingOccurrencesOfString:funcTemp withString:@""];
        self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]]=[NSMutableString stringWithString:tempCodeNew];
        
        if (funcTemp.length>0) {
            funcTemp=[funcTemp substringToIndex:funcTemp.length-1];
            funcTemp=[funcTemp stringByReplacingOccurrencesOfString:@"- (void)awakeFromNib{" withString:@""];
            funcTemp=[funcTemp stringByReplacingOccurrencesOfString:@"[super awakeFromNib];" withString:@""];
            funcTemp=[funcTemp stringByReplacingOccurrencesOfString:@"// Initialization code" withString:@""];
            funcTemp=[funcTemp stringByReplacingOccurrencesOfString:@"Initialization code" withString:@""];
            [creatCodeStrM appendFormat:@"%@\n",funcTemp];
        }
        
        
        [creatCodeStrM appendString:@"}"];
        
        [ZHStoryboardTextManager addCodeText:creatCodeStrM andInsertType:ZHAddCodeType_Implementation toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]] insertFunction:nil];
        
        //解决UIMapView *mapView1;的问题
        [ZHStoryboardTextManager dealWith_UIMapView:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]] needInserFramework:NO];
        
        
        NSString *h_filePath=self.ZHStroyBoardCreateFile[fatherCellName];
        if ([h_filePath hasSuffix:@".m"]) {
            h_filePath=[h_filePath stringByReplacingOccurrencesOfString:@".m" withString:@".h"];
            NSString *text=[NSString stringWithContentsOfFile:h_filePath encoding:NSUTF8StringEncoding error:nil];
            if ([text rangeOfString:@"UICollectionViewCell"].location!=NSNotFound) {
                [ZHStoryboardTextManager addCodeText:@"- (instancetype)initWithFrame:(CGRect)frame{\n\
                 if (self=[super initWithFrame:frame]) {\n\
                 [self addSubViews];\n\
                 }\n\
                 return self;\n\
                 }" andInsertType:ZHAddCodeType_Implementation toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]] insertFunction:nil];
            }else if ([text rangeOfString:@"UITableViewCell"].location!=NSNotFound){
                [ZHStoryboardTextManager addCodeText:@"- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{\n\
                 if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {\n\
                 [self addSubViews];\n\
                 }\n\
                 return self;\n\
                 }" andInsertType:ZHAddCodeType_Implementation toStrM:self.ZHStroyBoardCreateContent[self.ZHStroyBoardCreateFile[fatherCellName]] insertFunction:nil];
            }
        }
        
        NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
    }
}
@end