//
//  ViewController.m
//  实用功能性测试
//
//  Created by apple on 16/3/29.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ViewController.h"
#import "ReplaceTextField.h"

@interface ViewController ()
<UITextFieldDelegate>
{
    NSString *rememberText;
    ReplaceTextField *myTextField;
}
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.inputTextField setDelegate:self];
    [self.inputTextField addTarget:self action:@selector(textHaveChange:) forControlEvents:UIControlEventAllEditingEvents];
    rememberText = @"";
    
    myTextField = [[ReplaceTextField alloc]initWithFrame:CGRectMake(40, 160, 240, 40)];
    [myTextField setBackgroundColor:[UIColor yellowColor]];
    myTextField.headLength = 3;
    myTextField.footLength = 2;
    [myTextField addTarget:self action:@selector(outPutText) forControlEvents:UIControlEventAllEditingEvents];
    [self.view addSubview:myTextField];
}
-(void)outPutText
{
    printf("%s\n",[myTextField.rememberText UTF8String]);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    rememberText = [rememberText stringByReplacingCharactersInRange:range withString:string];
    return YES;
}
-(void)textHaveChange:(UITextField*)textField
{
    
            if (rememberText.length > 4)
            {
                NSMutableString *returnText = [NSMutableString string];
                [returnText appendString:[rememberText substringToIndex:2]];
                for (NSInteger i=0; i<(rememberText.length-4); i++)
                {
                    [returnText appendString:@"*"];
                }
                [returnText appendString:[rememberText substringFromIndex:rememberText.length-2]];
                [self.inputTextField setText:returnText];
            }
    else
    {
        [self.inputTextField setText:rememberText];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
