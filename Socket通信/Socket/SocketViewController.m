//
//  SocketViewController.m
//  Socket
//
//  Created by beijingduanluo on 15/10/12.
//  Copyright (c) 2015年 beijingduanluo. All rights reserved.
//

#import "SocketViewController.h"
#import "MessageModel.h"
#import "MessageCell.h"



@interface SocketViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *messageArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MessageModel *messageModel;

@end

@implementation SocketViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    self.view.backgroundColor =[UIColor whiteColor];
    _messageArray =[NSMutableArray array];
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    backView.backgroundColor =[UIColor colorWithRed:0.777 green:0.777 blue:0.777 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    _tableView.delegate = self;
    _tableView.dataSource=self;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    
    
    
    
    [self.view addSubview:backView];
    
    _inputMsg =[[UITextField alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-40 , self.view.frame.size.width-100, 30)];
    _inputMsg.borderStyle =UITextBorderStyleRoundedRect;
    _inputMsg.delegate = self;
    _inputMsg.returnKeyType = UIReturnKeySend;
    _inputMsg.enablesReturnKeyAutomatically = YES;
    _inputMsg.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    _inputMsg.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_inputMsg];
  
    
    UIButton *send =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height-40, 70, 30)];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    send.layer.cornerRadius = 5;
    send.layer.masksToBounds=YES;
    send.backgroundColor=[UIColor colorWithRed:0.0 green:0.523 blue:0.003 alpha:1.0];
    [self.view addSubview:send];
    
    
    
    [self connectServer:HOST_IP port:HOST_PORT];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    self.client = nil;
    
}
//建立连接
- (int) connectServer: (NSString *) hostIP port:(int) hostPort{
    
    if (_client == nil) {
        _client = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *err = nil;
        //192.168.110.128
        if (![_client connectToHost:hostIP onPort:hostPort error:&err]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host "
                                                                     stringByAppendingString:hostIP]
                                                            message:[[[NSString alloc]initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //client = nil;
            return SRV_CONNECT_FAIL;
        } else {
            
            //用户名
            NSString *str = @"22222@连接成功\r\n";
            NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
//            NSMutableData *data =[NSMutableData data];
//            NSData *dat =[str dataUsingEncoding:NSUTF8StringEncoding];
//            NSData *datsas =[@" \r\n" dataUsingEncoding:NSUTF8StringEncoding];
//            [data appendData:dat];
//            [data appendData:datsas];
            
            
          //  [_client readDataWithTimeout:-1 tag:0];
            [_client writeData:data withTimeout:-1 tag:0];
            
          //  [_client writeData:data withTimeout:-1 tag:0];
            return SRV_CONNECT_SUC;
        }
    }
    else {
        [_client readDataWithTimeout:-1 tag:0];
        return SRV_CONNECTED;
    }
    
}

- (void) reConnect{
    int stat = [self connectServer:HOST_IP port:HOST_PORT];
    switch (stat) {
        case SRV_CONNECT_SUC:
            [self showMessage:@"connect success"];
            break;
        case SRV_CONNECTED:
            [self showMessage:@"It's connected,don't agian"];
            break;
        default:
            break;
    }
}

-(void)sendMessage
{
    //发送消息需要确定的协议号
//    NSMutableData *sendData=[NSMutableData data];
//    NSMutableData *proctolData=[self intWithByteData:100111];
//    [sendData appendData:proctolData];
//    
//    //需要给谁发消息
//    NSString *name = @"123456";
//    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
//    //用户名长度
//    NSInteger nameC = [nameData length];
//    NSMutableData *nameLength =[self intWithByteData:nameC];
//    [sendData appendData:nameLength];
//    [sendData appendData:nameData];
//    
//    //发送的消息
//    NSString *str = self.inputMsg.text;
//    NSData *messageData = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSInteger message = [messageData length];
//    NSMutableData *messageLength =[self intWithByteData:message];
//    [sendData appendData:messageLength];
//    [sendData appendData:messageData];
    NSString *str = [NSString stringWithFormat:@"22222@11111@%@\r\n",_inputMsg.text];
    NSMutableData *data =[NSMutableData data];
    NSData *dat =[str dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *datsas =[@" \r\n" dataUsingEncoding:NSUTF8StringEncoding];
//    [data appendData:dat];
//    [data appendData:datsas];
    
    
   // NSData *sendData =[_inputMsg.text dataUsingEncoding:NSUTF8StringEncoding];
    [_client writeData:dat withTimeout:-1 tag:0];
}
//发送数据
- (void) sendMsg{
    
    [self sendMessage];
    
    MessageModel *mModel =[[MessageModel alloc]init];
    mModel.name = @"123456";
    mModel.message = self.inputMsg.text;
    mModel.state = @"0";
    [_messageArray addObject:mModel];
    [self.tableView reloadData];
    self.inputMsg.text = @"";
   
}
-(NSMutableData *)intWithByteData:(long)data
{
    Byte result[4];
    result[3]=data & 0xff;
    result[2]=(data>>8) & 0xff;
    result[1]=(data>>16) & 0xff;
    result[0]=(data>>24) & 0xff;
    NSMutableData *oneD=[[NSMutableData alloc]initWithBytes:result length:4];
    return oneD;
}

//连接成功后，会回调的函数
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [_client readDataWithTimeout:-1 tag:0];
    
    
}
//接收数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
     NSLog(@"%@",data);
    NSMutableString* aStr = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"===========%@",aStr);

    
    [_client readDataWithTimeout:-1 tag:0];
    
}
//断开连接
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
     NSLog(@"Error");
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //[self showAlert];
    
     [self connectServer:HOST_IP port:HOST_PORT];
   // _client = nil;
}


#pragma mark -
#pragma mark close Keyboard
- (void) textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (void) backgroundTouch:(id)sender{
    [_inputMsg resignFirstResponder];
}

#pragma mark socket uitl

- (void) showMessage:(NSString *) msg{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert!"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}


#pragma TableView Delegate&dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.messageModel = self.messageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *messModel =self.messageArray[indexPath.row];
    CGRect rect = [messModel.message boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return 50+rect.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_messageArray.count - 1 inSection:0];
   
    [self sendMessage];
    if (self.messageArray.count != 0) {
         [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    MessageModel *mModel =[[MessageModel alloc]init];
    mModel.name = @"123456";
    mModel.message = self.inputMsg.text;
    mModel.state = @"0";
    [_messageArray addObject:mModel];
    [self.tableView reloadData];
    
    textField.text = @"";
    
    return YES;
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

///**
// *  键盘发生改变执行
// */
- (void)keyboardWillChange:(NSNotification *)note
{
    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}








@end
