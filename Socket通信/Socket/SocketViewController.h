//
//  SocketViewController.h
//  Socket
//
//  Created by beijingduanluo on 15/10/12.
//  Copyright (c) 2015年 beijingduanluo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#define SRV_CONNECTED 0
#define SRV_CONNECT_SUC 1
#define SRV_CONNECT_FAIL 2
#define HOST_IP @"123.57.209.236"
#define HOST_PORT 2015
@interface SocketViewController : UIViewController{
//    UITextField *inputMsg;
//    UILabel *outputMsg;
//    AsyncSocket *client;
}
@property (nonatomic, retain) AsyncSocket *client;
@property (nonatomic, retain)  UITextField *inputMsg;
@property (nonatomic, retain)  UILabel *outputMsg;
- (int) connectServer: (NSString *) hostIP port:(int) hostPort;
- (void) reConnect;

- (void) showMessage:(NSString *) msg;
- (void) sendMsg;
- (void) textFieldDoneEditing:(id)sender;
- (void) backgroundTouch:(id)sender;
@end
