//
//  UITableView+EmptyData.h
//  BQLDBDemo
//
//  Created by 毕青林 on 16/6/7.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
