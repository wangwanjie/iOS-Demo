//
//  GQTopSegView.h
//  iGuiQuan
//
//  Created by jintang on 15/5/5.
//  Copyright (c) 2015年 iMiner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGMenuSegViewDelegate <NSObject>

@optional
-(void)clickButton :(NSInteger)clickIndex;

@end
@interface LGMenuSegView : UIView
{
    NSInteger currentIndex;
    NSArray *_titleArray;
}

@property(nonatomic,assign) id <LGMenuSegViewDelegate> delegate;
-(id)initWithFrame : (CGRect)frame  TitleArray :(NSArray *)titleArray;
-(void)clickButton:(int)scrollIndex;
@end
