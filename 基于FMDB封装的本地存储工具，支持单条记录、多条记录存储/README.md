首先欢迎您使用BQLDB 如有任何问题请联系我QQ:931237936 (添加请注明iOS开发) 

广告:推荐另一个工具（原生SDK实现三方登陆与分享）https://github.com/biqinglin/BQLAuthEngineDemo  

(如果图片不显示可以看Demo中的Source文件)
![image](http://github.com/biqinglin/BQLDBDemo/raw/master/Source/bqldb1.png)
![image](http://github.com/biqinglin/BQLDBDemo/raw/master/Source/bqldb2.png)                                                
Demo中有两个场景：
1：存储单条信息（如APP中的用户信息包括姓名、性别、年龄etc）；
2：存储多条信息（备忘录应用）

首先你要创建一个模型例如Demo中的学生信息：

#define StudentFile @"student.sqlite"
@interface StudentModel : BQLDBModel

@property (nonatomic) NSInteger stuid;          // 学号
@property (nonatomic, copy) NSString *name;     // 姓名
@property (nonatomic, copy) NSString *sex;      // 性别
@property (nonatomic) NSInteger age;            // 年龄
@property (nonatomic) double height;            // 身高

@end
以及备忘录应用：
#define MemorandumFile @"Memorandum.sqlite"
@interface MemorandumModel : BQLDBModel

@property (nonatomic, copy) NSString *notecontent;  // 备忘录内容
@property (nonatomic, copy) NSString *notetime;     // 备忘录时间

@end

模型继承BQLDBModel，看例子应该知道这里定义的就是要存储的字段信息，并且模型定义的属性都应使用小写（会在数据库中根据这些字段建立表结构）
这里StudentFile以及MemorandumFile定义的就是数据库名

（一）学生信息
@interface ViewController ()
{
    BQLDBTool *tool;
    NSDictionary *student;
}
tool = [BQLDBTool instantiateTool];
    // 打开或者创建数据库(数据库要根据模型决定创建哪些字段)
    student = @{@"stuid":@"",
                @"name":@"",
                @"sex":@"",
                @"age":@"",
                @"height":@""};
    StudentModel *model = [StudentModel modelWithDictionary:student];
    [tool openDBWith:StudentFile Model:model];
1：打开数据库
使用BQLDB之前需要打开数据库、这里看到定义了student字典里面只需要填充key而不需要value就可以了，因为这一步只是打开数据，工具会根据key建表结构（第一次使用，后面有了表就可以直接使用无需再这么做，如果你每次使用这么写也不会错，因为sql语句做了判断不会重复建表）
说明一下：字典中的key最好是跟模型一致（大小写），当然也可以使用大写
2：插入数据
- (IBAction)insertData:(id)sender {
    
    // 保证唯一标示的学生id不能为空(其实姓名这种理应也不应为空,只是唯一标识是绝对不能为空的)
    if(!checkObjectNotNull(_stuID.text)) {
        [self showAlert:@"学生id不能为空!"];
        return;
    }
    
    StudentModel *model = [StudentModel modelWithDictionary:[self getStudent]];
    if([tool insertDataWith:StudentFile Model:model]) {
        [self showAlert:@"插入成功"];
    }
    else {
        [self showAlert:@"插入失败"];
    }
}
这里的[self getStudent]函数详见Demo，只为了获取学生信息字典
3：修改数据
// 修改整个模型中的差异数据
- (IBAction)updateData:(id)sender {
    
    StudentModel *model = [StudentModel modelWithDictionary:[self getStudent]];
    if([tool modifyDataWith:StudentFile Model:model]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}
/* 修改某个字段值 */
/* demo场景：学生表自定义伪主键:stuid,默认建表主键id也可使用,这里只插入一条数据时主键id值即为:1 还提供了一个customid，详见备忘录demo*/
- (IBAction)updateName:(id)sender {
    
    if([tool modifyDataWith:StudentFile Key:@"name" Value:_stuName.text Identifier:@"stuid" IdentifierValue:@"1001"]) {
        [self showAlert:@"修改成功"];
    }
    else {
        [self showAlert:@"修改失败"];
    }
}
在执行添加数据、修改某个字段、修改所有信息之后可看下图：三次查询结果差异
![image](http://github.com/biqinglin/BQLDBDemo/raw/master/Source/bqldb4.png)

（二）备忘录应用
存储多条记录不像单条记录那样，你设置一下标识ID就可以（如Demo中学号1001，我只要记住一个1001即可操作数据库）；多条记录需要主键来进行操作
（ps：可能有些不懂数据库的同学不明白为什么要加一个主键：主键就是为了区分每一条记录，例如我要删除学号是1001的学生sql语句就是：delete from 学生表 where stu_id = 1001，如果没有主键你就不知道怎么区分也就无法对记录进行操作）
工具中在建表的时候已经设置了一个主键叫做id（你可以改成其他的名字），但我还增加了一个和主键一样作用的customID，每条记录中customID的值与id一样
下面就备忘录应用说明：
1：添加一个备忘录记录：
（实例化工具类）
if(!_tool) {
        _tool = [BQLDBTool instantiateTool];
    }
    
    if(!checkObjectNotNull(self.memorandumTextView.text)) {
        
        return;
    }
    NSDictionary *add = @{@"noteContent":self.memorandumTextView.text,
                          @"noteTime":getTodayDate(@"YYYY/MM/dd HH:mm:ss")};
    MemorandumModel *model = [MemorandumModel modelWithDictionary:add];
    if(self.type == EditTypeAdd) {
        
        if([_tool insertDataWith:MemorandumFile Model:model]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
我例子插入了三条记录，查询结果：
![image](http://github.com/biqinglin/BQLDBDemo/raw/master/Source/bqldb3.png)
![image](http://github.com/biqinglin/BQLDBDemo/raw/master/Source/bqldb5.png)

2：编辑备忘录
else if(self.type == EditTypeEdit){
        
        if([_tool modifyDataWith:MemorandumFile Model:model Identifier:@"customid" IdentifierValue:[NSString stringWithFormat:@"%lld",self.model.customID]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
可以看到我在编辑这一条备忘录记录的时候可以拿到self.model.customID，可以用这个作为主键来进行删、改、查功能；
代码中Identifier传入的是字符串@“customid”，注意是小写字母，当然你可以自行修改customID名称，不过同时需要修改工具中其他地方，具体看工具中方法，也可直接加我问我

3：删除备忘录
MemorandumModel *model = self.dataSource[indexPath.row];
        if([_tool deleteDataWith:MemorandumFile Identifier:@"customid" IdentifierValue:[NSString stringWithFormat:@"%lld",model.customID]]) {
            
            [self.dataSource removeObjectAtIndex:indexPath.row];
        }

下面展示工具中一些核心方法：
/**
 *  实例化单例
 */
+ (instancetype)instantiateTool;

/**
 *  打开或者创建数据库
 *
 *  @param dbName 数据库名
 *  @param model 数据模型
 */
- (void)openDBWith:(NSString *)dbName Model:(BQLDBModel *)model;

/**
 *  插入模型数据
 *  本方法会检测模型是否变更(新增字段)
 *
 *  @param dbName 数据库名
 *  @param model  数据模型
 *
 *  @return 插入成功或者失败(YES or NO)
 */
- (BOOL)insertDataWith:(NSString *)dbName Model:(BQLDBModel *)model;

/**
 *  批量插入模型数据(可选择是否用事务处理)
 *  本方法会检测模型是否变更(新增字段)
 *
 *  @param dbName         数据库名
 *  @param dataArray      数据模型数组(注意数组元素是模型不是其他,大批量插入数据建议使用useTransaction加快速度)
 *  @param useTransaction 是否使用事务处理
 *
 *  @return 插入成功或者失败(YES or NO)
 */
- (BOOL)insertDataWithBatch:(NSString *)dbName
                  DataArray:(NSArray *)dataArray
             UseTransaction:(BOOL )useTransaction;

/**
 *  批量插入模型数据(可选择是否用事务处理)
 *  本方法会检测模型是否变更(新增字段)
 *
 *  @param dbName         数据库名
 *  @param dataArray      数据模型数组(注意数组元素是模型不是其他,大批量插入数据建议使用useTransaction加快速度)
 *  @param useTransaction 是否使用事务处理
 *  @param progress       进度显示:0.0->1.0
 *
 *  @return 插入成功或者失败(YES or NO)
 */
- (BOOL)insertDataWithBatch:(NSString *)dbName
                  DataArray:(NSArray *)dataArray
             UseTransaction:(BOOL )useTransaction
                   Progress:(void(^)(double progress))progress;



/*************************** ***************************
 
 数据操作注意:默认建表时有一个主键id,可以作为标示符,
 不过我建议你自己再创建一个伪主键作为标示符 如学生id、身份证id这种 
 因为删除了id,到时候你查表的时候会发现id不是连续的,不利于你统计数据
 当然你就用id为主键执行操作也是可以的~~~
 
 *************************** ***************************/

/**
 *  删除模型数据(删除整个表)
 *
 *  @param dbName 数据库名
 *
 *  @return 删除成功或者失败(YES or NO)
 */
- (BOOL)deleteDataWith:(NSString *)dbName;

/**
 *  删除模型数据(删除表中某条数据)
 *
 *  @param dbName           数据库名
 *  @param identifier       标示符(唯一区分表中多条记录(不传默认使用建表主键:id))
 *  @param identifierValue  标示符值
 *  (例如我要删除备忘录表中MemoId = 5的那条备忘录记录,这里MemoId代表identifiers,5代表identifierValue)
 *  (例如我要删除学生表表中StuId = 1002的那条学生记录(他被开除了~~~),这里StuId代表identifiers,1002代表identifierValue)
 *
 *  @return 删除成功或者失败(YES or NO)
 */
- (BOOL)deleteDataWith:(NSString *)dbName
            Identifier:(NSString *)identifier
       IdentifierValue:(NSString *)identifierValue;

/**
 *  批量删除模型数据(删除表中多条数据)
 *
 *  @param dbName           数据库名
 *  @param identifier       标示符(唯一区分表中多条记录(不传默认使用建表主键:id))
 *  @param identifierValues 标示符值数组
 *  (例如我要删除备忘录表中MemoId = 5、MemoId = 6的那两条备忘录记录,这里MemoId代表identifiers,5、6代表identifierValues数组)
 *  (例如我要删除学生表表中StuId = 1002、StuId = 1006、StuId = 1010的那三条学生记录(他们搞基被开除了~~~),这里StuId代表identifiers,1002、1006、1010代表identifierValues数组)
 *
 *  @return 删除成功或者失败(YES or NO)
 */
- (BOOL)delectDataWithBatch:(NSString *)dbName
                 Identifier:(NSString *)identifier
           IdentifierValues:(NSArray *)identifierValues;

/**
 *  修改模型数据(单条记录:修改模型中差异数据,注意:该方法只适用于单条数据,当用在多条数据情况下会把所有数据都变成一样,因此使用者应该特别注意,修改某条数据见下面带标示符的方法)
 *
 *  @param dbName 数据库名
 *  @param model  数据模型
 *
 *  @return 修改成功或者失败(YES or NO)
 */
- (BOOL)modifyDataWith:(NSString *)dbName Model:(BQLDBModel *)model;

/**
 *  修改模型数据(多条记录:根据标示符找到该条记录修改模型中差异数据)
 *  (例如我要修改学生表中张三(唯一标示id = 1003)的成绩(修改差异数据),这里identifier表示张三的学号(id),1003即identifierValue)
 *
 *  @param dbName           数据库名
 *  @param model            数据模型
 *  @param identifier       标示符(不传默认使用建表主键:id)
 *  @param identifierValue  标示符值
 *
 *  @return 修改成功或者失败(YES or NO)
 */
- (BOOL)modifyDataWith:(NSString *)dbName
                 Model:(BQLDBModel *)model
            Identifier:(NSString *)identifier
       IdentifierValue:(NSString *)identifierValue;

/**
 *  修改模型数据(单条记录:根据标示符找到记录再根据key修改其对应value,该方法使用默认建表的主键id,因此与下面一个方法区分)
 *  (单条记录使用默认建表主键id即等于1)
 *
 *  @param dbName           数据库名
 *  @param key              所修改的key值(这里如果你传了一个错的key不会crash,请自行查看错误打印,尽量避免传入错误key)
 *  @param value            所修改的value值
 *  @param identifier       标示符(不传默认使用建表主键:id)
 *  @param identifierValue  标示符值
 *
 *  @return 修改成功或者失败(YES or NO)
 */
- (BOOL)modifyDataWith:(NSString *)dbName
                   Key:(NSString *)key
                 Value:(id )value;

/**
 *  修改模型数据(单条记录:根据标示符找到记录再根据key修改其对应value,该方法使用自定义主键(stuid、bookid...),因此与上面一个方法区分)
 *  (例如我要修改学生表中张三(唯一标示stuid = 1003)的数学成绩,这里identifier表示张三的学号(stuid),1003即identifierValue)
 *
 *  @param dbName           数据库名
 *  @param key              所修改的key值(这里如果你传了一个错的key不会crash,请自行查看错误打印,尽量避免传入错误key)
 *  @param value            所修改的value值
 *  @param identifier       标示符(不传默认使用建表主键:id)
 *  @param identifierValue  标示符值
 *
 *  @return 修改成功或者失败(YES or NO)
 */
- (BOOL)modifyDataWith:(NSString *)dbName
                   Key:(NSString *)key
                 Value:(id )value
            Identifier:(NSString *)identifier
       IdentifierValue:(NSString *)identifierValue;

/**
 *  批量修改模型数据(多条记录:根据标示符找到记录再根据key修改其对应value)
 *  (若你把数组内key与value顺序搞错了就麻烦啦~~~,所以一定要注意哦!下面提供了字典方法,怕弄错顺序就用下面的方法!~)
 *  (例如我要修改学生表中张三(唯一标示id = 1003)的数学成绩和语文成绩分别为90分、99分,这里identifier表示张三的学号(id),1003即identifierValue,keys表示@[math,chinese],values表示@[@90,@99])
 *
 *  @param dbName           数据库名
 *  @param keys             所修改的key值数组
 *  @param values           所修改的value值数组
 *  @param identifier       标示符(不传默认使用建表主键:id)
 *  @param identifierValue  标示符值
 *
 *  @return 修改成功或者失败(YES or NO)
 */
- (BOOL)modifyDataWithBatch:(NSString *)dbName
                        Key:(NSArray *)keys
                      Value:(NSArray *)values
                 Identifier:(NSString *)identifier
            IdentifierValue:(NSString *)identifierValue;

/**
 *  批量修改模型数据(多条记录:根据标示符找到记录再根据key修改其对应value)
 *  (该方法与上面的一样,只不过用字典替换数组,上面数组方法若你把数组内key与value顺序搞错了就麻烦啦~~~)
 *
 *  @param dbName          数据库名
 *  @param keyValue        变更数据字典
 *  @param identifier      标示符(不传默认使用建表主键:id)
 *  @param identifierValue 标示符值
 *
 *  @return 修改成功或者失败(YES or NO)
 */
- (BOOL)modifyDataWithBatch:(NSString *)dbName
                   KeyValue:(NSDictionary *)keyValue
                 Identifier:(NSString *)identifier
            IdentifierValue:(NSString *)identifierValue;

/**
 *  查询数据
 *  (再次提醒注意:这里返回的数组内元素是字典类型,你可用对应模型进行转换)
 *  (建议一个做法:数据库名写在模型头文件,这个方法传的是数据库名,如果你有很多模型的话这样就可以快速知道你该用哪个模型类接收数据并转换为模型了)
    一般开发中用途:
                1:例如存储用户基本信息，这里基本是一张表一条记录，此时返回的数组中可以无数据,也可以有一条数据
                2:类似备忘录需求,这里是一张表但有多条记录，此时返回的数组中可以无数据,可以有一条数据,也可以有多条数据)
 *
 *  @param dbName 数据库名
 *
 *  @return 所查询的数据
 */
- (NSArray *)queryDataWith:(NSString *)dbName;
- 

小弟非大牛，虚心学习。如果有不好的地方需要改进可联系我。共勉！


