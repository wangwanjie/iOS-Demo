#import "JSONViewController.h"

#import "JSONSourceTableViewCell.h"
#import "JSONTypeTableViewCell.h"
#import "JSONFineTuningTableViewCell.h"


@interface JSONViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (weak, nonatomic) IBOutlet UITextField *modelName;

@property (weak, nonatomic) IBOutlet UITextView *dataTextView;
@property (nonatomic,copy)NSString *oldTextViewString;

@property (weak, nonatomic) IBOutlet UIButton *importDataButton;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (weak, nonatomic) IBOutlet UILabel *promoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreDetail;

@property (weak, nonatomic) IBOutlet UIView *dataSourceView;

@property (nonatomic,strong)UIView *tempView;
@property (nonatomic,assign)BOOL fold;
@property (nonatomic,assign)BOOL isPost;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

- (IBAction)sureAction:(id)sender;
- (IBAction)cancleAction:(id)sender;


@property (nonatomic,retain)NSDictionary *dict;
@property (nonatomic,retain)NSArray *arr;

@property (nonatomic,copy)NSString *filePath;
@property (nonatomic,copy)NSString *savaPath;

@end


@implementation JSONViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}

- (void)setData{
    
    [self.dataArr removeAllObjects];
    
    NSArray *sources=@[@"url",@"json字符串",@"plist文件"];
    NSMutableArray *JSONSourceModels=[NSMutableArray array];
    for (NSInteger i=0; i<sources.count; i++) {
        JSONSourceCellModel *JSONSourceModel=[JSONSourceCellModel new];
        JSONSourceModel.title=sources[i];
        [JSONSourceModels addObject:JSONSourceModel];
    }
    [self.dataArr addObject:JSONSourceModels];
    
    
    JSONTypeCellModel *JSONTypeModel=[JSONTypeCellModel new];
    JSONTypeModel.selectIndex=0;
    [self.dataArr addObject:@[JSONTypeModel]];
    
    NSArray *fineTunings=@[@"NSNull转NSString",@"NSNumber转NSString",@"NSDate转NSString"];
    NSMutableArray *JSONFineTuningModels=[NSMutableArray array];
    for (NSInteger i=0; i<fineTunings.count; i++) {
        JSONFineTuningCellModel *JSONFineTuningModel=[JSONFineTuningCellModel new];
        JSONFineTuningModel.title=fineTunings[i];
        JSONFineTuningModel.row=i+1;
        JSONFineTuningModel.isSelect=YES;
        [JSONFineTuningModels addObject:JSONFineTuningModel];
    }
    [self.dataArr addObject:JSONFineTuningModels];
    
    fineTunings=@[@"自动归档"];
    JSONFineTuningModels=[NSMutableArray array];
    for (NSInteger i=0; i<fineTunings.count; i++) {
        JSONFineTuningCellModel *JSONFineTuningModel=[JSONFineTuningCellModel new];
        JSONFineTuningModel.title=fineTunings[i];
        JSONFineTuningModel.row=i+1;
        JSONFineTuningModel.isSelect=YES;
        [JSONFineTuningModels addObject:JSONFineTuningModel];
    }
    [self.dataArr addObject:JSONFineTuningModels];
    
}
- (void)viewDidLoad{
	[super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
	self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self setData];
    
    [self.createButton cornerRadiusWithFloat:10 borderColor:[UIColor whiteColor] borderWidth:1];
    
    self.fold=YES;
    [TabBarAndNavagation setLeftBarButtonItemTitle:@"<返回" TintColor:[UIColor blackColor] target:self action:@selector(backAction)];
    self.title=@"Json转model";
    
    [self.modelName cornerRadiusWithFloat:8 borderColor:[UIColor grayColor] borderWidth:1];
    
    _moreDetail.numberOfLines=0;
    
    [self.dataSourceView cornerRadiusWithFloat:20];
    [self.importDataButton cornerRadiusWithFloat:10];
    [self.dataTextView cornerRadiusWithFloat:10 borderColor:[UIColor blackColor] borderWidth:1];
    [self.sureButton cornerRadiusWithFloat:5];
    [self.cancleButton cornerRadiusWithFloat:5];
    
    [self.importDataButton addTarget:self action:@selector(importDataAction) forControlEvents:1<<6];
}

- (void)setFold:(BOOL)fold{
    _fold=fold;
    if (fold) {
        [TabBarAndNavagation setRightBarButtonItemTitle:@"展开" TintColor:[UIColor blackColor] target:self action:@selector(foldAction)];
    }else{
        [TabBarAndNavagation setRightBarButtonItemTitle:@"收拢" TintColor:[UIColor blackColor] target:self action:@selector(foldAction)];
    }
    
    [self.tableView reloadData];
    
    self.dataSourceView.hidden=YES;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)foldAction{
    self.fold=!self.fold;
}

- (IBAction)creatAction:(id)sender {
    if (self.modelName.text.length<=0) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请赋值Model的名字!" withDuration:1];
        return;
    }
    
    NSInteger selectIndex=-1;
    NSInteger index=0;
    for (JSONSourceCellModel * JSONSourceModel in self.dataArr[0]) {
        if (JSONSourceModel.isSelect) {
            selectIndex=index;
            break;
        }
        index++;
    }
    
    if (selectIndex==-1) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请选择数据来源!" withDuration:1];
        return;
    }
    
    //加载一些初始化数据
    NSString *macPath=[ZHFileManager getMacDesktop];
    NSString *fileDirectory=[ZHStroyBoardFileManager getCurDateString];
    fileDirectory = [fileDirectory stringByAppendingString:@"代码生成"];
    macPath = [macPath stringByAppendingPathComponent:fileDirectory];
    self.filePath=[macPath stringByAppendingPathComponent:[self.modelName.text stringByAppendingString:@".plist"]];
    self.savaPath=macPath;
    
    self.arr=[NSArray array];
    self.dict=[NSDictionary dictionary];
    
    BOOL NSNULL,NSNUMBER,NSDATE,guidang;
    JSONFineTuningCellModel *model_NSNULL=self.dataArr[2][0];
    NSNULL=model_NSNULL.isSelect;
    JSONFineTuningCellModel *model_NSNUMBER=self.dataArr[2][1];
    NSNUMBER=model_NSNUMBER.isSelect;
    JSONFineTuningCellModel *model_NSDATE=self.dataArr[2][2];
    NSDATE=model_NSDATE.isSelect;
    
    JSONFineTuningCellModel *model_guidang=self.dataArr[3][0];
    guidang=model_guidang.isSelect;
    
    if (selectIndex==0) {//url
        [self auto_creat:self.dataTextView.text NSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
    }else if (selectIndex==1){//json
        [self JsonAction:self.dataTextView.text NSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
    }else if(selectIndex==2){//plist
        [self localFileToModelWithFilePath:self.dataTextView.text NSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
    }
    
}

#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.fold) {
        return 2;
    }
	return self.dataArr.count;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.dataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.section][indexPath.row];
	if ([modelObjct isKindOfClass:[JSONSourceCellModel class]]){
		JSONSourceTableViewCell *JSONSourceCell=[tableView dequeueReusableCellWithIdentifier:@"JSONSourceTableViewCell"];
		JSONSourceCellModel *model=modelObjct;
		[JSONSourceCell refreshUI:model];
		return JSONSourceCell;
	}
	if ([modelObjct isKindOfClass:[JSONTypeCellModel class]]){
		JSONTypeTableViewCell *JSONTypeCell=[tableView dequeueReusableCellWithIdentifier:@"JSONTypeTableViewCell"];
		JSONTypeCellModel *model=modelObjct;
		[JSONTypeCell refreshUI:model];
		return JSONTypeCell;
	}
	if ([modelObjct isKindOfClass:[JSONFineTuningCellModel class]]){
		JSONFineTuningTableViewCell *JSONFineTuningCell=[tableView dequeueReusableCellWithIdentifier:@"JSONFineTuningTableViewCell"];
		JSONFineTuningCellModel *model=modelObjct;
		[JSONFineTuningCell refreshUI:model];
		return JSONFineTuningCell;
	}
	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id modelObjct=self.dataArr[indexPath.section][indexPath.row];
    if ([modelObjct isKindOfClass:[JSONSourceCellModel class]]){
        return 50;
    }
    if ([modelObjct isKindOfClass:[JSONTypeCellModel class]]){
        return 100;
    }
    if ([modelObjct isKindOfClass:[JSONFineTuningCellModel class]]){
        return 50;
    }
	return 0.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        JSONSourceCellModel *model=self.dataArr[indexPath.section][indexPath.row];
        _promoteLabel.text=[NSString stringWithFormat:@"数据来源方式:%@",model.title];
        _moreDetail.text=@"文件已经生成在桌面,名字为\"代码助手.m\"";
        NSString *macDesktopPath=[ZHFileManager getMacDesktop];
        macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
        if ([ZHFileManager fileExistsAtPath:macDesktopPath]==NO) {
            [ZHFileManager createFileAtPath:macDesktopPath];
        }
        
        if([model.title isEqualToString:@"url"]){
            _moreDetail.text = [_moreDetail.text stringByAppendingString:@",请把 网络url 填写在文件中"];
        }else if([model.title isEqualToString:@"json字符串"]){
            _moreDetail.text = [_moreDetail.text stringByAppendingString:@",请把 json字符串 填写在文件中"];
        }else if([model.title isEqualToString:@"plist文件"]){
            _moreDetail.text = [_moreDetail.text stringByAppendingString:@",请把 plist文件路径 填写在文件中"];
        }
        
        self.dataSourceView.hidden=NO;
        UIView *tempView=[[UIView alloc]initWithFrame:self.view.bounds];
        tempView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
        [tempView addUITapGestureRecognizerWithTarget:self withAction:@selector(hide)];
        self.tempView=tempView;
        [self.view addSubview:tempView];
        [self.view bringSubviewToFront:self.dataSourceView];
        
        self.oldTextViewString=self.dataTextView.text;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"数据来源方式(必填)";
    }else if (section==1) {
        return @"Model模式";
    }else if (section==2) {
        return @"强转调控(默认为打开,不建议关闭)";
    }else if (section==3) {
        return @"是否归档";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)hide{
    [self cancleAction:nil];
}

- (IBAction)sureAction:(id)sender{
    
    if (self.dataTextView.text.length<=0) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"没有 填写数据 或者 导入数据!" withDuration:1];
        return;
    }
    
    if([_promoteLabel.text rangeOfString:@"json"].location!=NSNotFound){
        //检验这个json格式数据
        NSString *strJson=self.dataTextView.text;
        NSDictionary *dictTemp;
        NSArray *arrTemp;
        dictTemp=[NSJSONSerialization JSONObjectWithData:[strJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if(dictTemp==nil){
            arrTemp=[NSJSONSerialization JSONObjectWithData:[strJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if(arrTemp==nil){
                [MBProgressHUD showHUDAddedTo:self.view withText:@"Json数据有误!" withDuration:1];
                return;
            }
        }
        for (JSONSourceCellModel * JSONSourceModel in self.dataArr[0]) {
            if ([JSONSourceModel.title isEqual:@"json字符串"]) {
                JSONSourceModel.isSelect=YES;
            }else{
                JSONSourceModel.isSelect=NO;
            }
        }
    }else if([_promoteLabel.text rangeOfString:@"plist"].location!=NSNotFound){
        //检验这个plist文件路径
        if ([ZHFileManager fileExistsAtPath:self.dataTextView.text]==NO) {
            [MBProgressHUD showHUDAddedTo:self.view withText:@"plist文件路径不存在!" withDuration:1];
            return;
        }
        for (JSONSourceCellModel * JSONSourceModel in self.dataArr[0]) {
            if ([JSONSourceModel.title isEqual:@"plist文件"]) {
                JSONSourceModel.isSelect=YES;
            }else{
                JSONSourceModel.isSelect=NO;
            }
        }
    }
    
    self.dataSourceView.hidden=YES;
    [self.tempView removeFromSuperview];
    self.tempView=nil;
    
    if ([_promoteLabel.text rangeOfString:@"url"].location!=NSNotFound) {
        [ZHAlertAction alertWithTitle:@"请求方式" withMsg:nil addToViewController:self withCancleBlock:^{
            //GET
            self.isPost=NO;
            for (JSONSourceCellModel * JSONSourceModel in self.dataArr[0]) {
                if ([JSONSourceModel.title isEqual:@"url"]) {
                    JSONSourceModel.isSelect=YES;
                }else{
                    JSONSourceModel.isSelect=NO;
                }
            }
            [self.tableView reloadData];
        } withOkBlock:^{
            //POST
            self.isPost=YES;
            for (JSONSourceCellModel * JSONSourceModel in self.dataArr[0]) {
                if ([JSONSourceModel.title isEqual:@"url"]) {
                    JSONSourceModel.isSelect=YES;
                }else{
                    JSONSourceModel.isSelect=NO;
                }
            }
            [self.tableView reloadData];
        } cancelButtonTitle:@"GET" OkButtonTitle:@"POST" ActionSheet:NO];
    }else{
        [self.tableView reloadData];
    }
}

- (IBAction)cancleAction:(id)sender {
    self.dataSourceView.hidden=YES;
    [self.tempView removeFromSuperview];
    self.tempView=nil;
    
    if([self.dataTextView.text isEqualToString:self.oldTextViewString]==NO){
        for (JSONSourceCellModel * JSONSourceModel in self.dataArr[0]) {
            JSONSourceModel.isSelect=NO;
        }
        [self.tableView reloadData];
    }
}

- (void)importDataAction{
    NSString *macDesktopPath=[ZHFileManager getMacDesktop];
    macDesktopPath = [macDesktopPath stringByAppendingPathComponent:@"代码助手.m"];
    NSString *text=[NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
    if (text.length>0) {
        self.dataTextView.text=text;
    }
}

#pragma mark --相关操作函数
- (void)JsonAction:(NSString *)JsonDataStr NSNULL:(BOOL)NSNULL NSNUMBER:(BOOL)NSNUMBER NSDATE:(BOOL)NSDATE guidang:(BOOL)guidang{
    //判断保存路径是否存在
    if(self.savaPath.length>0){
        //判断用户是否直接保存到了桌面
        if([self.savaPath isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop/"]]||[self.savaPath isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop"]]){
            [MBProgressHUD showHUDAddedTo:self.view withText:@"请不要文件直接存在桌面上!" withDuration:1];
            return;
        }
        if([self.savaPath hasSuffix:@"/"]==NO){
            NSString *tmp=self.savaPath;
            self.savaPath=[tmp stringByAppendingString:@"/"];
        }
        NSString *strJson=JsonDataStr;
        _dict=[NSJSONSerialization JSONObjectWithData:[strJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if(_dict==nil){
            _arr=[NSJSONSerialization JSONObjectWithData:[strJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if(_arr==nil){
                [MBProgressHUD showHUDAddedTo:self.view withText:@"Json数据有误" withDuration:1];
                return;
            }
        }
        [self succeesNSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
        if(_dict!=nil){
            [self JsonToPlistWithFilePath:self.filePath withDicOrArr:_dict];
        }else if(_arr!=nil){
            [self JsonToPlistWithFilePath:self.filePath withDicOrArr:_arr];
        }
    }else{
        [MBProgressHUD showHUDAddedTo:self.view withText:@"保存路径不能为空" withDuration:1];
    }
    [self removeData];
}
- (void)JsonToPlistWithFilePath:(NSString *)FilepPath withDicOrArr:(id)dicOrArr{
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm createFileAtPath:FilepPath contents:nil attributes:nil];
    if([fm fileExistsAtPath:FilepPath]){
        if([dicOrArr isKindOfClass:[NSArray class]]){
            NSArray *arr=(NSArray *)dicOrArr;
            [arr writeToFile:FilepPath atomically:YES];
        }else if([dicOrArr isKindOfClass:[NSDictionary class]]){
            NSDictionary *dicM=(NSDictionary *)dicOrArr;
            [dicM writeToFile:FilepPath atomically:YES];
        }
    }
}

- (void)auto_creat:(NSString *)url NSNULL:(BOOL)NSNULL NSNUMBER:(BOOL)NSNUMBER NSDATE:(BOOL)NSDATE guidang:(BOOL)guidang{
    [MBProgressHUD showHUDAddedTo:self.view withText:@"正在生成中..." withDuration:1];
    
    if([self judgURL:url]==NO){
        [MBProgressHUD showHUDAddedTo:self.view withText:@"网址存在%?控制符" withDuration:1];
        return;
    }
    //判断保存路径是否存在
    if(self.savaPath.length>0){
        //判断用户是否直接保存到了桌面
        if([self.savaPath isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop/"]]||[self.savaPath isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop"]]){
            [MBProgressHUD showHUDAddedTo:self.view withText:@"请不要文件直接存在桌面上" withDuration:1];
            return;
        }
        if([self.savaPath hasSuffix:@"/"]==NO){
            NSString *tmp=self.savaPath;
            self.savaPath=[tmp stringByAppendingString:@"/"];
        }
        
        //GET请求
        if (self.isPost==NO) {
            //开始请求数据
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *chineseUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //GET请求
            [manager GET:chineseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                _dict=responseObject;
                if([responseObject isKindOfClass:[NSDictionary class]]){
                    _dict=responseObject;
                    if(_dict==nil){
                        [MBProgressHUD showHUDAddedTo:self.view withText:@"请求的网路数据有误" withDuration:1];
                        return ;
                    }
                }
                else if([responseObject isKindOfClass:[NSArray class]]){
                    _arr=responseObject;
                    if(_arr==nil){
                        [MBProgressHUD showHUDAddedTo:self.view withText:@"请求的网路数据有误" withDuration:1];
                        return ;
                    }
                }
                [self succeesNSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD showHUDAddedTo:self.view withText:@"请检查网址" withDuration:1];
                return;
            }];
        }
        //POST请求
        else if (self.isPost==YES){
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            if ([url rangeOfString:@"?"].location!=NSNotFound) {
                NSString *realUrl=[url substringToIndex:[url rangeOfString:@"?"].location];
                NSString *chineseUrl=[realUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *parameters=[self getDicParameters:[url substringFromIndex:[url rangeOfString:@"?"].location+1]];
                //POST请求
                [manager POST:chineseUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    _dict=responseObject;
                    if([responseObject isKindOfClass:[NSDictionary class]]){
                        _dict=responseObject;
                        if(_dict==nil){
                            [MBProgressHUD showHUDAddedTo:self.view withText:@"请求的网路数据有误" withDuration:1];
                            return ;
                        }
                    }
                    else if([responseObject isKindOfClass:[NSArray class]]){
                        _arr=responseObject;
                        if(_arr==nil){
                            [MBProgressHUD showHUDAddedTo:self.view withText:@"请求的网路数据有误" withDuration:1];
                            return ;
                        }
                    }
                    [self succeesNSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD showHUDAddedTo:self.view withText:@"请检查网址" withDuration:1];
                    return;
                }];
            }else{
                NSString *chineseUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //GET请求
                [manager GET:chineseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    _dict=responseObject;
                    if([responseObject isKindOfClass:[NSDictionary class]]){
                        _dict=responseObject;
                        if(_dict==nil){
                            [MBProgressHUD showHUDAddedTo:self.view withText:@"请求的网路数据有误" withDuration:1];
                            return ;
                        }
                    }
                    else if([responseObject isKindOfClass:[NSArray class]]){
                        _arr=responseObject;
                        if(_arr==nil){
                            [MBProgressHUD showHUDAddedTo:self.view withText:@"请求的网路数据有误" withDuration:1];
                            return ;
                        }
                    }
                    [self succeesNSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD showHUDAddedTo:self.view withText:@"请检查网址" withDuration:1];
                    return;
                }];
            }
        }
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view withText:@"保存路径不能为空" withDuration:1];
    }
    [self removeData];
}

- (NSDictionary *)getDicParameters:(NSString *)Parameters{
    //例如:   username=ceshi&password=123456
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    NSArray *parametersArr=[Parameters componentsSeparatedByString:@"&"];
    
    for (NSString *eachParameters in parametersArr) {
        NSArray *subParametersArr=[eachParameters componentsSeparatedByString:@"="];
        [dicM setValue:subParametersArr[1] forKey:subParametersArr[0]];
    }
    NSLog(@"dicM=%@",dicM);
    return dicM;
}

- (NSInteger)returnModelTypeNSInteger{
    JSONTypeCellModel * JSONSourceModel=self.dataArr[1][0];
    return JSONSourceModel.selectIndex+1;
}

- (BOOL)exsistStr:(NSString *)str InURL:(NSString *)url{
    if([url rangeOfString:str].location!=NSNotFound)
        return YES;
    else return NO;
}
- (BOOL)judgURL:(NSString *)url{
    if([self exsistStr:@"%d" InURL:url]||[self exsistStr:@"%s" InURL:url]||[self exsistStr:@"%c" InURL:url]||[self exsistStr:@"%f" InURL:url]||[self exsistStr:@"%hhd" InURL:url]||[self exsistStr:@"%ld" InURL:url])//等等,可以加
        return NO;
    return YES;
}

- (void) deleteOldDirectory{
    //删除原先的文件夹
    BOOL yes=YES;
    if([[NSFileManager defaultManager]fileExistsAtPath:self.savaPath isDirectory:&yes]){
        [[NSFileManager defaultManager]removeItemAtPath:self.savaPath error:nil];
    }
}
- (void)succeesNSNULL:(BOOL)NSNULL NSNUMBER:(BOOL)NSNUMBER NSDATE:(BOOL)NSDATE guidang:(BOOL)guidang{
    if(_dict!=nil){
        //删除原先的文件夹
        [self deleteOldDirectory];
        [CreatPropert clearTextWithModelName:self.modelName.text withGiveData:[self returnModelTypeNSInteger]];
        [CreatPropert creatProperty:_dict fileName:self.modelName.text WithContext:@"" savePath:self.savaPath withNSNULL:NSNULL withNSDATE:NSDATE withNSNUMBER:NSNUMBER withGiveData:[self returnModelTypeNSInteger] withModelName:self.modelName.text withFatherClass:@"" needEcoding:guidang];
        [CreatPropert saveTextWithModelName:self.modelName.text savePath:self.savaPath];
        [MBProgressHUD showHUDAddedTo:self.view withText:@"生成成功,请打开文件夹" withDuration:1];
        [self JsonToPlistWithFilePath:self.filePath];
    }
    else if(_arr!=nil){
        //删除原先的文件夹
        [self deleteOldDirectory];
        [CreatPropert clearTextWithModelName:self.modelName.text withGiveData:[self returnModelTypeNSInteger]];
        [CreatPropert creatProperty:_arr fileName:self.modelName.text WithContext:@"" savePath:self.savaPath withNSNULL:NSNULL withNSDATE:NSDATE withNSNUMBER:NSNUMBER withGiveData:[self returnModelTypeNSInteger] withModelName:self.modelName.text withFatherClass:@"" needEcoding:guidang];
        [CreatPropert saveTextWithModelName:self.modelName.text savePath:self.savaPath];
        [MBProgressHUD showHUDAddedTo:self.view withText:@"生成成功,请打开文件夹" withDuration:1];
        [self JsonToPlistWithFilePath:self.filePath];
    }
    else [MBProgressHUD showHUDAddedTo:self.view withText:@"生成失败" withDuration:1];
    
//    [FMDBCreat writeToFileWithFilePath:self.savaPath];
}

- (void)localFileToModelWithFilePath:(NSString *)filePath NSNULL:(BOOL)NSNULL NSNUMBER:(BOOL)NSNUMBER NSDATE:(BOOL)NSDATE guidang:(BOOL)guidang{
    //删除原先的文件夹
    [self deleteOldDirectory];
    
    //判断保存路径是否存在
    if(self.savaPath.length>0){
        //判断用户是否直接保存到了桌面
        if([self.savaPath isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop/"]]||[self.savaPath isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop"]]){
            [MBProgressHUD showHUDAddedTo:self.view withText:@"请不要文件直接存在桌面上!" withDuration:1];
            return;
        }
        if([self.savaPath hasSuffix:@"/"]==NO){
            NSString *tmp=self.savaPath;
            self.savaPath=[tmp stringByAppendingString:@"/"];
        }
        _dict=[NSDictionary dictionaryWithContentsOfFile:filePath];;
        if(_dict==nil){
            _arr=[NSArray arrayWithContentsOfFile:filePath];
            if(_arr==nil){
                [MBProgressHUD showHUDAddedTo:self.view withText:@"Json数据有误" withDuration:1];
                return;
            }
        }
        [self succeesNSNULL:NSNULL NSNUMBER:NSNUMBER NSDATE:NSDATE guidang:guidang];
        if(_dict!=nil){
            [self JsonToPlistWithFilePath:self.filePath withDicOrArr:_dict];
        }else if(_arr!=nil){
            [self JsonToPlistWithFilePath:self.filePath withDicOrArr:_arr];
        }
    }else{
        [MBProgressHUD showHUDAddedTo:self.view withText:@"保存路径不能为空" withDuration:1];
    }
    [self removeData];
}

- (void)JsonToPlistWithFilePath:(NSString *)FilepPath{
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm createFileAtPath:FilepPath contents:nil attributes:nil];
    if ([fm fileExistsAtPath:FilepPath]) {
        if (_dict!=nil) {
            NSMutableDictionary *temp_dic=[NSMutableDictionary dictionaryWithDictionary:_dict];
            [[self getUseableObjectWithOldObject:temp_dic] writeToFile:FilepPath atomically:YES];
        }else if(_arr!=nil){
            NSMutableArray *temp_arr=[NSMutableArray arrayWithArray:_arr];
            [[self getUseableObjectWithOldObject:temp_arr] writeToFile:FilepPath atomically:YES];
        }
    }
}
/**因为有的字段为NULL导致数组或者字典不能正常的保存*/
- (id)getUseableObjectWithOldObject:(id)oldObj{
    
    if([oldObj isKindOfClass:[NSDictionary class]]){//如果obj对象是字典
        oldObj=[NSMutableDictionary dictionaryWithDictionary:oldObj];
        id objtemp;
        for (NSInteger i=0; i<[oldObj allKeys].count; i++) {//开始遍历字典里面的键值对
            objtemp=[oldObj allKeys][i];
            
            if ([oldObj[objtemp] isKindOfClass:[NSString class]]) {
                if (((NSString *)oldObj[objtemp]).length==0) {
                    [oldObj setValue:@"" forKey:objtemp];
                }
            }
            else if([oldObj[objtemp] isKindOfClass:[NSArray class]]){//如果字典里面是数组
                
                oldObj[objtemp]=[self getUseableObjectWithOldObject:oldObj[objtemp]];
            }
            else if ([oldObj[objtemp] isKindOfClass:[NSDictionary class]]){//如果字典里面是字典
                oldObj[objtemp]=[self getUseableObjectWithOldObject:oldObj[objtemp]];
            }
            else if ([oldObj[objtemp] isKindOfClass:[NSNull class]]){//如果字典里面是nsnull
                [oldObj setValue:@"" forKey:objtemp];
            }
            else if([oldObj[objtemp] isKindOfClass:[NSData class]]){//如果字典里面是NSData
                [oldObj setValue:@"NSData" forKey:objtemp];
            }
            else if([oldObj[objtemp] isKindOfClass:[NSDate class]]){//如果字典里面是NSDate
                [oldObj setValue:[NSString stringWithFormat:@"NSDate:%@",oldObj[objtemp]] forKey:objtemp];
                
            }
        }
    }
    else if([oldObj isKindOfClass:[NSArray class]]){//如果obj对象是数组
        oldObj=[NSMutableArray arrayWithArray:oldObj];
        id objtemp;
        for (NSInteger i=0; i<[oldObj count]; i++) {
            @autoreleasepool {
                objtemp=oldObj[i];
                objtemp=[self getUseableObjectWithOldObject:objtemp];
            }
        }
    }
    return oldObj;
}
- (void)removeData{
    self.arr=[NSArray array];
    self.dict=[NSDictionary dictionary];
}
@end