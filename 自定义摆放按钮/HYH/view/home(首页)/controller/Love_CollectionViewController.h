//
//  Love_CollectionViewController.h
//  CZYTH_04
//
//  Created by yu on 15/9/7.
//  Copyright (c) 2015年 yu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol Love_CollectionViewControllerDelegate <NSObject>

/**
 *  刷新homg的数据
 */
- (void) reloadData_HomeArray:(NSMutableArray *)array;

@end
@interface Love_CollectionViewController : UICollectionViewController
//添加代理方法
@property (nonatomic,weak) id delegate;
@end
