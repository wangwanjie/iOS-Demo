//
//  BIZGrid4plus1CollectionViewLayout.h
//  ExampleBIZGrid4plus1CollectionViewLayout
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BIZGrid4plus1CollectionViewLayout : UICollectionViewLayout
@property (nonatomic) CGFloat insetBetweenCells;
@property (nonatomic) NSInteger numberOfCellsInOneLineGroup;
@property (nonatomic) NSInteger numberOfCellsInTwoLineGroup;
//For subclasses
- (void)setup;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com