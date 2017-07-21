//
//  Home_ViewController.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/19.
//  Copyright (c) 2015年 虞海飞. All rights reserved.
//

#import "Home_ViewController.h"
#import "Love_CollectionViewController.h"
#import "Home_CollectionViewCell.h"
#import "HomeBean.h"
#import "ShaXiang_NSObject.h"

@interface Home_ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollisionBehaviorDelegate,UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *huangYiHuang;//换一换功能
@property (nonatomic,assign) int renwu ;
@property (nonatomic,strong) NSMutableArray *array;
@end

@implementation Home_ViewController

 static NSString *CellIdentifier = @"CollectionCell";
/**
 * 在plist里面拿数据 -》转化成字典 —》 转化成对象
 *  @return <#return value description#>
 */
- (NSMutableArray *)array{
    
    if(_array == nil){
        
        ShaXiang_NSObject *shaXiang = [[ShaXiang_NSObject alloc] init];
        
        NSString *dataFile=[[shaXiang docPath] stringByAppendingPathComponent:@"one.plist"];
        _array = [NSMutableArray arrayWithContentsOfFile:dataFile];

        //其实就是把“换一换”删除。不能用迭代
        for (int i = 0; i <_array.count ; i ++) {
            
            NSDictionary *dic = _array[i];
            
            if ([dic[@"text"] isEqualToString:@"换一换"]) {

                [self.array removeObject:dic];
                
                int a = (int)[_array count];
                self.array[a] = dic;
            }else{

                int a = (int)[_array count];
                NSDictionary *dic_01 = [NSDictionary dictionaryWithObjectsAndKeys:@"换一换",@"text",@"a16",@"image", nil];
                self.array[a] = dic_01;
            }
        }
        
    }
    
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.huangYiHuang.backgroundColor = [UIColor whiteColor];
    //自动布局，自己定义的高度
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //代理
    self.huangYiHuang.delegate = self;
    self.huangYiHuang.dataSource = self;
      [self.huangYiHuang registerClass:[Home_CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
//    //设置title的字体大小
//    CGRect rect = CGRectMake(0, 0, 200, 44);
//    UILabel *label = [[UILabel alloc] initWithFrame:rect];
//    label.text = @"常州市城乡建设局综合信息平台（移动端）";
//    label.font =  [UIFont fontWithName:@"Arial" size:14];
//    
//   self.navigationItem.titleView = label;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self.huangYiHuang reloadData];
}

#pragma mark -- 九宫格

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.array.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Home_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dic = self.array[indexPath.row];
    
    HomeBean *homeBean = [HomeBean homeBeanWithDict:dic];
    cell.homeBean = homeBean;//在cell里面已经封装
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.height;
    
    int width_int = (int) width;
    
    if(480 == width_int){
        
        return CGSizeMake(60, 70);
    }else{
        
        return CGSizeMake(60, 90);
    }
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 10, 10, 10);
    
}

/**
 *  点击单元格
 *
 *  @param collectionView <#collectionView description#>
 *  @param indexPath      <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int a = (int)indexPath.row;
    
    NSDictionary *dic = self.array[a];
    NSString *string_dic_text = dic[@"text"];

    if([string_dic_text isEqualToString:@"换一换"]){
        
        [self performSegueWithIdentifier:@"loveCollection" sender:nil];

    }else if ([string_dic_text isEqualToString:@"未读通知"]){
         _renwu = 0;
        [self performSegueWithIdentifier:@"lovecailiao" sender:nil];

    }else if ([string_dic_text isEqualToString:@"已读通知"]){
          _renwu = 1;
        [self performSegueWithIdentifier:@"lovecailiao" sender:nil];

    }else if ([string_dic_text isEqualToString:@"未读材料"]){
          _renwu = 2;
        [self performSegueWithIdentifier:@"lovecailiao" sender:nil];

    }else if ([string_dic_text isEqualToString:@"已读材料"]){
         _renwu = 3;
        [self performSegueWithIdentifier:@"lovecailiao" sender:nil];

    }else if ([string_dic_text isEqualToString:@"任务撰写"]){
        _renwu = 4;
        [self performSegueWithIdentifier:@"loverenwu" sender:nil];

    }else if ([string_dic_text isEqualToString:@"任务检索"]){
          _renwu = 5;
        [self performSegueWithIdentifier:@"loverenwu" sender:nil];

    }else if ([string_dic_text isEqualToString:@"收文待阅"]){
         _renwu = 0;
        [self performSegueWithIdentifier:@"loveshouwen" sender:nil];

    }else if ([string_dic_text isEqualToString:@"收文办理"]){
         _renwu = 1;
        [self performSegueWithIdentifier:@"loveshouwen" sender:nil];

    }else if ([string_dic_text isEqualToString:@"发文办理"]){
         _renwu = 1;
        [self performSegueWithIdentifier:@"lovefawen" sender:nil];

    }else if ([string_dic_text isEqualToString:@"请假审核"]){
        [self performSegueWithIdentifier:@"loveqingjia" sender:nil];

    }else if ([string_dic_text isEqualToString:@"离常检索"]){
        [self performSegueWithIdentifier:@"lovelichang" sender:nil];

    }
}

/**
 *  跳转后的方法
 //  y 0 材料  没
 //  y 1 材料  有
 //   y 2 通知  没
 //   y 3 通知  有
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSString *string_segue = segue.identifier;

    if ([string_segue isEqualToString:@"loveCollection"]) {
        Love_CollectionViewController *tr = segue.destinationViewController;
        tr.delegate = self;
    }
   }

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

#pragma mark -- Love_CollectionViewController的代理方法

- (void) reloadData_HomeArray:(NSMutableArray *)array{
    
    _array = array;

    //没有时，只有“换一换”
    if (_array.count == 0) {

        NSDictionary *dic_01 = [NSDictionary dictionaryWithObjectsAndKeys:@"换一换",@"text",@"a16",@"image", nil];
        self.array[0] = dic_01;
    }else{


        //其实就是把“换一换”删除。不能用迭代
        for (int i = 0; i <_array.count ; i ++) {

            NSDictionary *dic = _array[i];

            if ([dic[@"text"] isEqualToString:@"换一换"]) {

                  [self.array removeObject:dic];
            }
        }
        //其实就是把“换一换”删除。不能用迭代
        NSDictionary *dic_01 = [NSDictionary dictionaryWithObjectsAndKeys:@"换一换",@"text",@"a16",@"image", nil];
        //self.array[0] = dic_01;
        [self.array addObject:dic_01];
    }
    
       [self.huangYiHuang reloadData];
}



@end
