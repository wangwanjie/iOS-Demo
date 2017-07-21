#import "StroyBoardPropertySetValue.h"

@implementation StroyBoardPropertySetValue
/**根据property属性生成代码*/
+ (NSString *)getCodePropertysForViewName:(NSString *)viewName WithViewCategory:(NSString *)categoryView{
    if ([categoryView isEqualToString:@"label"]){
        return [self getPropertyCodeForLabel:viewName];
    }
    if ([categoryView isEqualToString:@"button"]){
        return [self getPropertyCodeForButton:viewName];
    }
    if ([categoryView isEqualToString:@"imageView"]){
        return [self getPropertyCodeForImageView:viewName];
    }
    if ([categoryView isEqualToString:@"tableView"]){
        return [self getPropertyCodeForTableView:viewName];
    }
    if ([categoryView isEqualToString:@"collectionView"]){
        return [self getPropertyCodeForCollectionView:viewName];
    }
    if ([categoryView isEqualToString:@"view"]){
        return [self getPropertyCodeForView:viewName];
    }
    if ([categoryView isEqualToString:@"segmentedControl"]){
        return [self getPropertyCodeForSegmentedControl:viewName];
    }
    if ([categoryView isEqualToString:@"textField"]){
        return [self getPropertyCodeForTextField:viewName];
    }
    if ([categoryView isEqualToString:@"switch"]){
        return [self getPropertyCodeForSwitch:viewName];
    }
    if ([categoryView isEqualToString:@"activityIndicatorView"]){
        return [self getPropertyCodeForActivityIndicatorView:viewName];
    }
    if ([categoryView isEqualToString:@"progressView"]){
        return [self getPropertyCodeForProgressView:viewName];
    }
    if ([categoryView isEqualToString:@"pageControl"]){
        return [self getPropertyCodeForPageControl:viewName];
    }
    if ([categoryView isEqualToString:@"stepper"]){
        return [self getPropertyCodeForStepper:viewName];
    }
    if ([categoryView isEqualToString:@"textView"]){
        return [self getPropertyCodeForTextView:viewName];
    }
    if ([categoryView isEqualToString:@"scrollView"]){
        return [self getPropertyCodeForScrollView:viewName];
    }
    if ([categoryView isEqualToString:@"datePicker"]){
        return [self getPropertyCodeForDatePicker:viewName];
    }
    if ([categoryView isEqualToString:@"pickerView"]){
        return [self getPropertyCodeForPickerView:viewName];
    }
    if ([categoryView isEqualToString:@"mapView"]){
        return [self getPropertyCodeForMapView:viewName];
    }
    if ([categoryView isEqualToString:@"searchBar"]){
        return [self getPropertyCodeForSearchBar:viewName];
    }
    if ([categoryView isEqualToString:@"webView"]){
        return [self getPropertyCodeForWebView:viewName];
    }
    return nil;
}

+ (NSString *)getPropertyCodeForLabel:(NSString *)viewName{
    return [NSString stringWithFormat:@"self.%@.text=@\"\";",viewName];
}


+ (NSString *)getPropertyCodeForButton:(NSString *)viewName{
    return [NSString stringWithFormat:@"[%@ setTitle:@"" forState:(UIControlStateNormal)];",viewName];
}


+ (NSString *)getPropertyCodeForImageView:(NSString *)viewName{
    return [NSString stringWithFormat:@"self.%@.image=[UIImage imageNamed:@\"\"];",viewName];
}


+ (NSString *)getPropertyCodeForTableView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForCollectionView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForSegmentedControl:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForTextField:(NSString *)viewName{
    return [NSString stringWithFormat:@"self.%@.text=@\"\";",viewName];
}


+ (NSString *)getPropertyCodeForSlider:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForSwitch:(NSString *)viewName{
    return [NSString stringWithFormat:@"self.%@.on=YES;",viewName];
}


+ (NSString *)getPropertyCodeForActivityIndicatorView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForProgressView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForPageControl:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForStepper:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForTextView:(NSString *)viewName{
    return [NSString stringWithFormat:@"self.%@.text=@\"\";",viewName];
    return nil;
}


+ (NSString *)getPropertyCodeForScrollView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForDatePicker:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForPickerView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForMapView:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForSearchBar:(NSString *)viewName{
    return nil;
}


+ (NSString *)getPropertyCodeForWebView:(NSString *)viewName{
    return nil;
}


@end