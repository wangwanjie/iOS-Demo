//
//  ViewController.m
//  willKeyboard
//
//  Created by Willee on 15/11/26.
//  Copyright (c) 2015年 wille. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *myKeyboard;
@property (nonatomic,strong) UIImageView * keyboard;
@property(nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [self textViewShouldBeginEditing:nil];
    self.myKeyboard.delegate = self;
    self.myTextField.delegate = self;
  [self.myKeyboard becomeFirstResponder];
   
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self createView:textField];

    return   YES;
    
}
-(void)createView:(UIView*)myView{
    self.titleArray = [NSMutableArray arrayWithCapacity:0];
    UIImageView * keyboard = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    self.keyboard = keyboard;
    keyboard.userInteractionEnabled = YES;
    keyboard.backgroundColor = [UIColor colorWithRed:0.599 green:1.000 blue:0.705 alpha:1.000];
    if ([myView isKindOfClass:[UITextField class]]) {
        UITextField *m =  (UITextField *)  myView;
       m.inputView  = keyboard;
    }
    if ([myView isKindOfClass:[UITextView class]]) {
        UITextView *m =  (UITextView *)  myView;
        m.inputView  = keyboard;
    }
  
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
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   [self createView:textView];
    return YES;
}
-(void)finishedBTN{
    
    [self.view endEditing:YES];
}
-(void)deleteBTN{
    if ([self.myTextField isFirstResponder]) {
        [self.myTextField deleteBackward];
    }else
    [self.myKeyboard deleteBackward];
}

-(void)BTNclick:(UIButton *)btn{
    if ([self.myTextField isFirstResponder]) {
        [self.myTextField insertText:btn.titleLabel.text];
    }else
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

