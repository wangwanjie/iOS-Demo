//
//  PasswordKeyboard.m
//  willKeyboard
//
//  Created by 电脑的密码是admin on 15/12/3.
//  Copyright (c) 2015年 wille. All rights reserved.
//

#import "PasswordKeyboard.h"
@interface PasswordKeyboard()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
@end
@implementation PasswordKeyboard
- (void)viewDidLoad {
    
    [self textViewShouldBeginEditing:nil];
    self.myKeyboard.delegate = self;
    self.myKeyField.delegate = self;
    [self.myKeyboard becomeFirstResponder];
}
-(instancetype)init{
    if ([super init]) {
        self.myKeyboard.delegate = self;
        self.myKeyField.delegate = self;
        [self.myKeyboard becomeFirstResponder];
    }
    return self;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self textViewShouldBeginEditing:nil];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.titleArray = [NSMutableArray arrayWithCapacity:0];
    UIImageView * keyboard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    self.keyboard = keyboard;
    keyboard.userInteractionEnabled = YES;
    keyboard.backgroundColor = [UIColor colorWithRed:0.599 green:1.000 blue:0.705 alpha:1.000];
    self.myKeyboard.inputView  = keyboard;
    for (int i = 0; i<12; i++) {
        
        UIButton * btn = [[UIButton alloc]init];
        UIColor * mycolor =  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        [btn setBackgroundColor:mycolor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
        NSString * titleSTR = nil;
        
        for (int t = 0; 1; t++) {
            NSInteger titleNum = arc4random()%9+1;
            NSString *titltString = [NSString stringWithFormat:@"%ld",titleNum];
            
            if (![self.titleArray containsObject:titltString] ) {
                [self.titleArray addObject:titltString];
                break;
            }
            if (self.titleArray.count == 9) {
                break;
            }
        }
        
        switch (i) {
            case 9:
                titleSTR = @"完成";
                [btn setTitle: titleSTR forState:UIControlStateNormal];
                
                [ btn addTarget:self action:@selector(finishedBTN) forControlEvents:UIControlEventTouchUpInside];
                [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(finishlongpressGesture)]];
                break;
            case 10:
                titleSTR = @"0";
                [btn setTitle: titleSTR forState:UIControlStateNormal];
                
                [ btn addTarget:self action:@selector(BTNclick:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 11:
                titleSTR = @"回退";
                [btn setTitle: titleSTR forState:UIControlStateNormal];
                [ btn addTarget:self action:@selector(deleteBTN) forControlEvents:UIControlEventTouchUpInside];
                [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGesture)]];
                
                break;
            default:
                [ btn addTarget:self action:@selector(BTNclick:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        if (i < 9) {
            [btn setTitle: self.titleArray[i] forState:UIControlStateNormal];
        }
        CGFloat dis = 10;
        CGFloat btnW =(keyboard.frame.size.width - (4*dis))/3 ;
        CGFloat btnH =(keyboard.frame.size.height - (5*dis))/4 ;
        CGFloat btnY = (i/3)*(btnH + dis)+dis;
        CGFloat btnX = (i%3)*(btnW + dis)+dis;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [keyboard addSubview:btn];
        
    }
    return YES;
}
-(void)finishedBTN{
    
    [self.myKeyboard resignFirstResponder];
    
}
-(void)deleteBTN{
    
    [self.myKeyboard deleteBackward];
    
}

-(void)BTNclick:(UIButton *)btn{
    
    [self.myKeyboard insertText:btn.titleLabel.text];
    
}

-(void)longpressGesture{
    
    self.myKeyboard.text = nil;
    
}

-(void)finishlongpressGesture{
    
    //先判断source是不是可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * img =info[UIImagePickerControllerOriginalImage];
    self.keyboard.image = img;
    
}


@end
