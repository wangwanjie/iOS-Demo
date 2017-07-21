#import "DetailViewController.h"

#import "DetailStepTableViewCell.h"
#import "DetailContentTableViewCell.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation DetailViewController
- (NSMutableArray *)dataArr{
	if (!_dataArr) {
		_dataArr=[NSMutableArray array];
	}
	return _dataArr;
}

/**StroyBoard生成Masonry简介*/
- (void)StroyBoard_Masonry{
    NSArray *details=@[@"将 StroyBoard 放在您的MAC电脑的桌面上",
                       @"返回模拟器,就会看到您刚刚放的文件",
                       @"点击右边的生成代码到桌面",
                       @"桌面上会生成一个以当前时间命名的文件夹,里面就是您要的代码",
                       @"如果找不到Main.StroyBoard,可以使用该工程文件的Main.StroyBoard测试"
                       ];
    
    [self addData:details];
}

/**Xib生成Masonry简介*/
- (void)Xib_Masonry{
    NSArray *details=@[@"将 Xib 文件放在您的MAC电脑的桌面上",
                       @"返回模拟器,就会看到您刚刚放的文件",
                       @"点击右边的生成代码到桌面",
                       @"桌面上会生成一个以当前时间命名的文件夹,里面就是您要的代码",
                       @"如果您的Xib文件里面有ViewController,或者说你的Xib内容复杂(相当于几个xib文件合成一个,用下标取其对应对象),那么还会生成新的对应的文件夹,里面存放的是对应的代码"
                       ];
    
    [self addData:details];
}

/**快速生成代码简介*/
- (void)QuickCreatCode{
    NSArray *details=@[@"我们基本上每一个界面都会有tableView或者collectionView",
                       @"我们添加它们时都发现很有规律,很无聊,尤其是写代理方法",
                       @"这个快速生成代码是你只需要填写少部分信息,就能根据你的这些信息帮你生成重复代码",
                       @"其实最麻烦的就是 代码助手.m文件里的格式怎么填,注意,这个文件的数据格式是Json,所以请不要打乱格式",
                       @"示例1:简单tableView",
                       @"{\n\
                       \"最大文件夹名字\":\"CocoaChina(随便给)\",\n\
                       \"ViewController的名字\":\"Set\",\n\
                       \"自定义Cell,以逗号隔开\":\"Set1,Set2,Set3\",\n\
                       \"是否需要对应的Model 1:0 (不填写么默认为否)\":\"1\",\n\
                       \"是否需要对应的StroyBoard 1:0 (不填写么默认为否)\":\"1\",\n\
                       \"自定义cell可编辑(删除) 1:0 (不填写么默认为否)\":\"1\"\n\
                       }",
                       @"简单collectionView",
                       @"{\n\
                       \"最大文件夹名字\":\"GitHub(随便给)\",\n\
                       \"ViewController的名字\":\"Chat\",\n\
                       \"自定义Cell,以逗号隔开\":\"ChatMeText,ChatOtherText,ChatMeImage,ChatOtherImage\",\n\
                       \"是否需要对应的Model 1:0 (不填写么默认为否)\":\"1\",\n\
                       \"是否需要对应的StroyBoard 1:0 (不填写么默认为否)\":\"1\"\n\
                       }",
                       @"tableView嵌套tableView或者collectionView",
                       @"{\n\
                       \"最大文件夹名字\":\"Code4App(随便给)\",\n\
                       \"ViewController的名字\":\"Code\",\n\
                       \"自定义Cell,以逗号隔开\":\"Code1,Code2,Code3,Code4,Code5\",\n\
                       \"自定义Cell标识符:(无:0 TableView:1(子cell以;隔开) ColloectionView:2(子cell以;隔开)),以逗号隔开\":\"0,1(Code2_1;Code2_2),2(Code3_1;Code3_2;Code3_3),2(Code4_1;Code4_2;Code4_3),0\",\n\
                       \"例如cell有A,B  那么嵌套这一行为:1(A1;A2),2(B1;B2)\":\"请填写\",\n\
                       \"是否需要对应的Model 1:0 (不填写么默认为否)\":\"1\",\n\
                       \"是否需要对应的StroyBoard 1:0 (不填写么默认为否)\":\"1\",\n\
                       \"自定义cell可编辑(删除) 1:0 (不填写么默认为否)\":\"1\"\n\
                       }\n\n注意这个格式稍微复杂,要注意,有以逗号\",\"分隔的,有以分号\";\"分隔的",
                       @"最后有一点,就是因为电脑的复制粘贴板和模拟器的复制粘贴板不是同一个,所以无法支持跨模拟器复制粘贴,所以才用 代码助手.m这个文件来输入数据源"
                       ];
    
    [self addData:details];
}

/**JSON转模型简介*/
- (void)Json_To_Model{
    NSArray *details=@[@"我们在网上看到很多JSON转模型的,包括很多插件,不过它们很多都是要么没有支持点语法,要么就是.m文件里还是需要我们自己去写某些第三方重写方法",
                       @"我这个是结合了这两个问题做的JSON转模型",
                       @"数据来源有3个,url,json字符串,plist文件",
                       @"url注意点,post的url本身是不带 \"?\",但是填写的时候要把参数写成和get一样的url格式,程序会把 \"?\" 后面的参数变成字典参数的",
                       @"如果有些url需要带额外头,那么建议使用json字符串,因为你只需要拿到json字符串就行了",
                       @"测试示例 url:  http://seecsee.com/index/getRecommendAndroid",
                       @"最后有一点,就是因为电脑的复制粘贴板和模拟器的复制粘贴板不是同一个,所以无法支持跨模拟器复制粘贴,所以才用 \"代码助手.m\" 这个文件来输入数据源"
                       ];
    
    [self addData:details];
}
/**@"为什么生成的代码里全是View1,label2之类的"*/
- (void)ViewAddNum{
    NSArray *details=@[@"在生成代码后,我们会发现,有很多控件的名字是升序命名的,这看起来不符合命名规范",
                       @"原因就是我们没有给这个控件一个名字,那如何给这个控件一个名字呢?",
                       @"我们在ViewController里面都会设置CustomClass,那个是用来关联代码文件的,而且是每个控件都有的属性之一",
                       @"所以,我们可以把控件的名字填在那里,注意,填完后,按Enter键,才算赋值好了",
                       @"但是这样有个问题,就是,我们一般不习惯在那里(CustomClass)填值,而且后面想要这个XIB,或者StroyBoard原文件时,还得一个一个删除CustomClass里面的值",
                       @"所以请大家复制一份出来,拿着复制的那份进行赋值",
                       @"给大家造成麻烦,实在不好意思"
                       ];
    
    [self addData:details];
}

/**@"生成property outlet怎么用?"*/
- (void)propertyOutlet{
    NSArray *details=@[@"你有没有觉得,在用StroyBoard搭完界面后,每个控件需要拉线是件很痛苦的事,尤其是你的屏幕不够大的情况下,再加上你还要找到对应的文件,再加上你连好线了,不知道取什么英文名字,再去查字典,白拉出一条线",
                       @"可能拉一两条线,没什么关系,但是十几条而且还是不同文件(Cell),有点麻烦",
                       @"这个时候,最需的是,假如我在拖出这个控件时,有个属性值可以填个值,可以自动帮我们找到文件位置做拉线处理,没错,这个小功能就是帮你做这个事的",
                       @"好了,开始讲怎么用了,很简单",
                       @"点击添加工程,在Mac桌面上会有一个 代码助手.m 文件,把你的工程拖到里面,就会有你工程的路径,确定添加",
                       @"接下来你会发现里面有你工程的所有StroyBoard文件(除了LaunchScreen.stroyboard这个)",
                       @"右边的 OK 你应该看得到,对就是点击那个就可以了,简单吧! 但是注意,你还没给控件设置属性呢!",
                       @"只要你找到像拖线的控件,在它的customClass里,填写你想给它取得名字,但是前面要加一个 \"_\" 并且按Enter就设置好了,例如 \"_MyLabel1\" ,因为你的关联文件应该不会有 \"_\" 开头的",
                       @"好了,把你所需要拉线的控件都这样赋值好,就点击前面说的 OK 就可以了,试试吧,挺爽的",
                       @"你添加的工程会一直存在哦,下次进来不用再添加,如果想删除,侧滑就会有删除",
                       @"如果你想恢复原来,有个备份StroyBoard文件,侧滑就会看到有备份路径",
                       @"如果给某个控件赋值之前,1.要确定已关联对应的ViewController文件或者是TableViewCell或者是CollectionViewCell文件,要不然找不到对应的文件,线白拉了. 2.确定它没有拉过线,有要删除,要不然有两条线,总感觉不好."
                       ];
    
    [self addData:details];
}

/**将非纯手写工程转换成纯手写简介*/
- (void)pureHandProject{
    NSArray *details=@[@"我和我周边开发iOS的朋友经常碰到一个问题,老板要把一个非纯手写工程给我们一个月时间转换成纯手写,虽然没什么太多技术难点,但是new一个一个控件,并且凭空想象设置约束,有点抽象,有点小麻烦",
                       @"做久了会发现,好像就是把StroyBoard上的控件不要用它来帮你生成,而是自己来生成并且布局,其它代码基本不变,这就有点小规律了",
                       @"于是我决定做这个小功能,就是用来把StroyBoard上的控件自动生成,并且生成并且布局,其它代码照旧",
                       @"好了,说了这么多,开始说怎么使用吧(我觉得基本上不用说,一看就能知道怎么用,但还是讲点注意点吧)",
                       @"导入工程(在桌面的 代码助手.m 中填写)",
                       @"导入完成后就可以开始转换了,为了保险起见,它会帮你备份一份,放在你原先工程的文件夹中,所以不用担心损坏原来的工程",
                       @"如果您实在担心损坏以前的工程,请你先自己备份一份",
                       @"因为有时你的工程比较大,所以备份所花的时间很长",
                       @"好了,备份完成后,你基本上可以看到你的工程已经转换成纯手写工程了,但是还不是真正的纯手写,因为纯手写是没有StroyBoard的(假装这样认为吧)",
                       @"除了push和跳转页面的代码需要修改以外,基本上其它代码好像可以原封不动了",
                       @"如果其它代码仍然有许多需要改动的或者里面不尽如意的,请提下建议(1141039693@qq.com),非常感谢,一切只是为了少写代码"
                       ];
    
    [self addData:details];
}

/**获取指定长度的文字(数字,字母随机)*/
- (NSString *)getRandomStringWithLenth:(NSInteger)len{
    NSMutableString *strM=[NSMutableString string];
    NSInteger sj;
    unichar ch=0;
    while (strM.length<len) {
        sj=arc4random()%3+1;
        if (sj==1) {
            ch=arc4random()%26+'a';
        }else if (sj==2){
            ch=arc4random()%26+'A';
        }else if (sj==3){
            ch=arc4random()%10+'0';
        }
        [strM appendFormat:@"%C",ch];
    }
    return strM;
}

- (void)addData:(NSArray *)details{
    for (NSInteger i=0; i<details.count; i++) {
        DetailStepCellModel *DetailStepModel=[DetailStepCellModel new];
        DetailStepModel.title=[NSString stringWithFormat:@"第 %ld 步",i+1];
        [self.dataArr addObject:DetailStepModel];
        
        DetailContentCellModel *DetailContentModel=[DetailContentCellModel new];
        DetailContentModel.width=self.view.frame.size.width-32-16;
        DetailContentModel.title=details[i];
        [self.dataArr addObject:DetailContentModel];
    }
}

- (void)loadData{
    if ([_helpString isEqualToString:@"Xib生成Masonry简介"]) {
        [self Xib_Masonry];
    }else if ([_helpString isEqualToString:@"StroyBoard生成Masonry简介"]){
        [self StroyBoard_Masonry];
    }else if ([_helpString isEqualToString:@"快速生成代码简介"]){
        [self QuickCreatCode];
    }else if ([_helpString isEqualToString:@"JSON转模型简介"]){
        [self Json_To_Model];
    }else if ([_helpString isEqualToString:@"为什么代码里全是View1,label2之类的?"]){
        [self ViewAddNum];
    }else if ([_helpString isEqualToString:@"生成property outlet怎么用?"]){
        [self propertyOutlet];
    }else if ([_helpString isEqualToString:@"将非纯手写工程转换成纯手写简介"]){
        [self pureHandProject];
    }
    
    
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
    
    self.tableView.tableFooterView=[UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
	self.edgesForExtendedLayout=UIRectEdgeNone;

    [self loadData];
}

#pragma mark - 必须实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	id modelObjct=self.dataArr[indexPath.row];
	if ([modelObjct isKindOfClass:[DetailStepCellModel class]]){
		DetailStepTableViewCell *DetailStepCell=[tableView dequeueReusableCellWithIdentifier:@"DetailStepTableViewCell"];
		DetailStepCellModel *model=modelObjct;
		[DetailStepCell refreshUI:model];
		return DetailStepCell;
	}
	if ([modelObjct isKindOfClass:[DetailContentCellModel class]]){
		DetailContentTableViewCell *DetailContentCell=[tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
		DetailContentCellModel *model=modelObjct;
		[DetailContentCell refreshUI:model];
		return DetailContentCell;
	}
	//随便给一个cell
	UITableViewCell *cell=[UITableViewCell new];
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id modelObjct=self.dataArr[indexPath.row];
    if ([modelObjct isKindOfClass:[DetailStepCellModel class]]){
        return 28.0f;
    }
    if ([modelObjct isKindOfClass:[DetailContentCellModel class]]){
        DetailContentCellModel *model=modelObjct;
        return model.size.height+30+20;
    }
	return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"选择了某一行");
}


@end
