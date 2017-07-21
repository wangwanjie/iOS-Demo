//
//  GetHttp.h
//  CZJSJ
//
//  Created by 虞海飞 on 15/9/23.
//  Copyright © 2015年 虞海飞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  TongZhiBean;

@interface GetHttp : NSObject

/**
 *  访问http
 *
 *  @param tongzhi <#tongzhi description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) getHttpPinJie:(NSString *)pinJie Util:(NSString *)util;

/**
    访问http，不用显示加载框
 */
-(NSDictionary *) getHttpPinJie_JiaZai:(NSString *)pinJie Util:(NSString *)util;

/**
 *   访问http(材料Web)
 *
 *  @param gsUSERID <#gsUSERID description#>
 *  @param ID       <#ID description#>
 *  @param util     <#util description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) getHttpCaiLiao:(NSString *)gsUSERID ID:(NSString *)ID Util:(NSString *)util;

/**
 *  search(搜索拼)
 *
 *  @param pinJie <#pinJie description#>
 *  @param util   <#util description#>
 *
 *  @return <#return value description#>
 */
-(NSDictionary *) SearchPinJie:(NSString *)pinJie Util:(NSString *)util;
@end
