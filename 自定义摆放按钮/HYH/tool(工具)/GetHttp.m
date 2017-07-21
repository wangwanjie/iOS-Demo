//
//  GetHttp.m
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import "GetHttp.h"
#import "IanAlert.h"
#import "MBProgressHUD+Add.h"

@implementation GetHttp

/**
 *   访问http
 *  [NSString stringWithFormat:@"gsUSERID=%@&PageIndex=%@&type=%@&TITLE=%@",
 *    tongzhi.gsUSERID,tongzhi.PageIndex,tongzhi.state,tongzhi.TITLE]
 *
 *  @param pinJie <#pinJie description#>
 *  @param util   <#util description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) getHttpPinJie:(NSString *)pinJie Util:(NSString *)util{

    //添加一个遮罩，禁止用户操作
    [MBProgressHUD showMessage:@"正在努力加载中...."];

    //NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置请求路径
    NSString *tongZhi = util;
    NSURL *dataUrl = [NSURL URLWithString:tongZhi];

    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:dataUrl];//默认为get请求

    //coo的内容
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    //把cookie加到里面去
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //替换coo里面的内容
    [request setAllHTTPHeaderFields:sheaders];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法

    //设置请求体
    NSString *param= pinJie;
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    //客户端类型，只能写英文
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    //    3.发送请求

    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    //当请求结束的时候调用（有两种结果，一个是成功拿到数据，也可能没有拿到数据，请求失败）
    [MBProgressHUD hideHUD];

    NSDictionary *dict = nil;
    if (data) {

        //请求成功
        dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        return dict;
    }else {

        //请求失败
        // [self performSegueWithIdentifier:@"menuindex" sender:self];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }
    
    return dict;
}

/**
 *   访问http(直接加载，没有等待提示)
 *  [NSString stringWithFormat:@"gsUSERID=%@&PageIndex=%@&type=%@&TITLE=%@",
 *    tongzhi.gsUSERID,tongzhi.PageIndex,tongzhi.state,tongzhi.TITLE]
 *
 *  @param pinJie <#pinJie description#>
 *  @param util   <#util description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) getHttpPinJie_JiaZai:(NSString *)pinJie Util:(NSString *)util{

    //NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置请求路径
    NSString *tongZhi = util;
    NSURL *dataUrl = [NSURL URLWithString:tongZhi];

    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:dataUrl];//默认为get请求

    //coo的内容
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    //把cookie加到里面去
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //替换coo里面的内容
    [request setAllHTTPHeaderFields:sheaders];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法

    //设置请求体
    NSString *param= pinJie;
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    //客户端类型，只能写英文
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    //    3.发送请求

    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSDictionary *dict = nil;
    if (data) {

        //请求成功
        dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        return dict;
    }else {

        //请求失败
        // [self performSegueWithIdentifier:@"menuindex" sender:self];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }

    return dict;
}


/**
 *  search(搜索拼)
 *  @param gsUSERID <#gsUSERID description#>
 *  @param ID       <#ID description#>
 *  @param util     <#util description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) SearchPinJie:(NSString *)pinJie Util:(NSString *)util{
    //添加一个遮罩，禁止用户操作

    //NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置请求路径
    NSString *tongZhi = util;
    NSURL *dataUrl = [NSURL URLWithString:tongZhi];

    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:dataUrl];//默认为get请求

    //coo的内容
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    //把coo加到里面去
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //替换coo里面的内容
    [request setAllHTTPHeaderFields:sheaders];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法

    //设置请求体
    NSString *param= pinJie;
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    //客户端类型，只能写英文
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    //    3.发送请求

    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSDictionary *dict = nil;
    if (data) {

        //请求成功
        dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        return dict;
    }else {

        //请求失败
        // [self performSegueWithIdentifier:@"menuindex" sender:self];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }
    
    return dict;

}

-(NSDictionary *) getHttpCaiLiao:(NSString *)gsUSERID ID:(NSString *)ID Util:(NSString *)util{

    //添加一个遮罩，禁止用户操作
    [MBProgressHUD showMessage:@"正在努力加载中...."];

    //NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    // 1.设置请求路径
    NSString *tongZhi = util;
    NSURL *dataUrl = [NSURL URLWithString:tongZhi];

    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:dataUrl];//默认为get请求

    //coo的内容
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }
    //把coo加到里面去
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
    NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //替换coo里面的内容
    [request setAllHTTPHeaderFields:sheaders];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法

    //设置请求体
    NSString *param=[NSString stringWithFormat:@"gsUSERID=%@&ID=%@",gsUSERID,ID];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];

    //客户端类型，只能写英文
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    //    3.发送请求

    //发送同步请求，在主线程执行
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    //当请求结束的时候调用（有两种结果，一个是成功拿到数据，也可能没有拿到数据，请求失败）
    [MBProgressHUD hideHUD];

    NSDictionary *dict = nil;
    if (data) {

        //请求成功
        dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

        return dict;
    }else {

        //请求失败
        // [self performSegueWithIdentifier:@"menuindex" sender:self];
        NSTimeInterval abcd = 1.0;
        [IanAlert alertError:@"网络异常" length:abcd];
    }
    
    return dict;
}


@end
