//
//  AppDelegate.m
//  HYH
//
//  Created by 虞海飞 on 15/11/13.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "AppDelegate.h"
#import "ShaXiang_NSObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    ShaXiang_NSObject *shaXiang = [[ShaXiang_NSObject alloc] init];

    NSString *dataFile=[[shaXiang docPath] stringByAppendingPathComponent:@"one.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:dataFile];

    if(nil == array){

        [self doAdd];
    }

    // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:153/255.0 blue:204/255.0 alpha:1]];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:nil forKey:@"token"];
    [accountDefaults synchronize];

    // Override point for customization after application launch.
    //判断是否由远程消息通知触发应用程序启动
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }

    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];

        [application registerUserNotificationSettings:notiSettings];
        [application registerForRemoteNotifications];

    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge										 |UIRemoteNotificationTypeSound										 |UIRemoteNotificationTypeAlert)];
    }


    return YES;
}


/**
 *  添加数据
 */
-(void) doAdd{

    ShaXiang_NSObject *shaXiang = [[ShaXiang_NSObject alloc] init];
    NSString *docPath=[shaXiang docPath];
    NSLog(@"当前docment路径：\n%@",docPath);

    NSString *dataFile=[docPath stringByAppendingPathComponent:@"one.plist"];

    if (YES==[shaXiang isFileNeedCreate:dataFile]) {
        NSLog(@"文件原先不存在，现已新建空文件！");
    }else{
        NSLog(@"文件已存在，无需创建！");
    }

    NSMutableArray *plistDic = [[NSMutableArray alloc ] init];
    // 添加字典
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"未读通知",@"text",@"a5",@"image",nil]];
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"已读通知",@"text",@"a6",@"image",nil]];
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"未读材料",@"text",@"a7",@"image",nil]];
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"已读材料",@"text",@"a8",@"image",nil]];
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"任务撰写",@"text",@"a0",@"image",nil]];
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"任务检索",@"text",@"a1",@"image",nil]];
    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"收文待阅",@"text",@"a2",@"image",nil]];

    [plistDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"换一换",@"text",@"a16",@"image",nil]];

    [plistDic writeToFile:dataFile atomically:YES];//完全覆盖
    NSLog(@"添加内容完成！！");

    //添加第二个数据plist
    NSString *dataFile_02=[docPath stringByAppendingPathComponent:@"two.plist"];
    NSMutableArray *plistDic_02 = [[NSMutableArray alloc ] init];
    // 添加字典
    [plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"收文办理",@"text",@"a4",@"image",nil]];
    [plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"发文办理",@"text",@"a8",@"image",nil]];
    [plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"请假审核",@"text",@"a10",@"image",nil]];
    [plistDic_02 addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"离常检索",@"text",@"a9",@"image",nil]];

    [plistDic_02 writeToFile:dataFile_02 atomically:YES];//完全覆盖
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


//处理收到的消息推送
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    }

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
   }


@end
