//
//  ZHStoryboardPropertyManager.m
//  XML
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZHStoryboardPropertyManager.h"

@implementation ZHStoryboardPropertyManager
/**为获取每个view的property属性*/
+ (NSDictionary *)getPropertysForView:(NSDictionary *)idAndViewDic withCustomAndName:(NSDictionary *)customAndNameDic andXMLHandel:(ReadXML *)xml{
    NSMutableDictionary *idAndPropertyDicM=[NSMutableDictionary dictionary];
    for (NSString *viewName in idAndViewDic) {
        [self recursiveGetPropertysForViewName:viewName withViewDic:idAndViewDic[viewName] withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    return idAndPropertyDicM;
}

+ (void)recursiveGetPropertysForViewName:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    NSString *categoryView=customAndNameDic[viewName];
    if ([categoryView isEqualToString:@"label"]) {
        [self setPropertysForLabel:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"button"]) {
        [self setPropertysForButton:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"imageView"]) {
        [self setPropertysForImageView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"tableView"]) {
        [self setPropertysForTableView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"tableViewCell"]) {
        [self setPropertysForTableViewCell:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"collectionView"]) {
        [self setPropertysForCollectionView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"collectionViewCell"]) {
        [self setPropertysForCollectionViewCell:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"view"]) {
        [self setPropertysForView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"segmentedControl"]) {
        [self setPropertysForSegmentedControl:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"textField"]) {
        [self setPropertysForTextField:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"switch"]) {
        [self setPropertysForSwitch:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"activityIndicatorView"]) {
        [self setPropertysForActivityIndicatorView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"progressView"]) {
        [self setPropertysForProgressView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"pageControl"]) {
        [self setPropertysForPageControl:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"stepper"]) {
        [self setPropertysForStepper:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"textView"]) {
        [self setPropertysForTextView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"scrollView"]) {
        [self setPropertysForScrollView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"datePicker"]) {
        [self setPropertysForDatePicker:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"pickerView"]) {
        [self setPropertysForPickerView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"mapView"]) {
        [self setPropertysForMapView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"searchBar"]) {
        [self setPropertysForSearchBar:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"webView"]) {
        [self setPropertysForWebView:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    if ([categoryView isEqualToString:@"slider"]) {
        [self setPropertysForSlider:viewName withViewDic:viewDic withCustomAndName:customAndNameDic toIdAndPropertyDicM:idAndPropertyDicM andXMLHandel:xml];
    }
    
}

+ (void)setPropertysForLabel:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    //获取text
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"text",@"textAlignment",@"adjustsFontSizeToFit",@"numberOfLines",@"pointSize"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForButton:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"title",@"pointSize"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
    
    NSDictionary *titleColorDic=[xml getOneDegreeChildWithName:@"state" withDic:viewDic];
    NSDictionary *colorDic=[xml getOneDegreeChildWithName:@"color" withDic:titleColorDic];
    if ([colorDic[@"key"] isEqualToString:@"titleColor"]){
        property.titleColor_red=[xml getPropertyWithName:@"red" withDic:colorDic needInChild:NO];
        property.titleColor_green=[xml getPropertyWithName:@"green" withDic:colorDic needInChild:NO];
        property.titleColor_blue=[xml getPropertyWithName:@"blue" withDic:colorDic needInChild:NO];
        property.titleColor_alpha=[xml getPropertyWithName:@"alpha" withDic:colorDic needInChild:NO];
    }
}
+ (void)setPropertysForImageView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"image",@"contentMode"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForTableView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"style",@"rowHeight"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForTableViewCell:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"reuseIdentifier"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForCollectionView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForCollectionViewCell:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"reuseIdentifier"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSegmentedControl:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
    
    NSDictionary *segmentsDic=[xml getOneDegreeChildWithName:@"segments" withDic:viewDic];
    if (segmentsDic!=nil) {
        property.segment=@"";
        
        NSInteger count=1;
        NSArray *arrTemp=[xml childDic:segmentsDic];
        for (id obj in arrTemp) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subDic=obj;
                if (subDic) {
                    NSString *segment=[xml getPropertyWithName:@"title" withDic:subDic needInChild:NO];
                    property.segment = [property.segment stringByAppendingString:segment];
                    if (count!=arrTemp.count) {
                        property.segment = [property.segment stringByAppendingString:@"_$_"];
                    }
                }
                count++;
            }
        }
    }
}
+ (void)setPropertysForTextField:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"textAlignment",@"clearButtonMode",@"pointSize"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSlider:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSwitch:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"on"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForActivityIndicatorView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForProgressView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForPageControl:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForStepper:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForTextView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"textAlignment",@"pointSize"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForScrollView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForDatePicker:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForPickerView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForMapView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForSearchBar:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[@"placeholder",@"backgroundImage"] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}
+ (void)setPropertysForWebView:(NSString *)viewName withViewDic:(NSDictionary *)viewDic withCustomAndName:(NSDictionary *)customAndNameDic toIdAndPropertyDicM:(NSMutableDictionary *)idAndPropertyDicM andXMLHandel:(ReadXML *)xml{
    ViewProperty *property=[ViewProperty new];
    [self setPropertysForPropertyNames:@[] withViewDic:viewDic toProperty:property andXMLHandel:xml];
    [idAndPropertyDicM setValue:property forKey:viewName];
}

/**根据字符串数组去拿去对应的属性字段*/
+ (void)setPropertysForPropertyNames:(NSArray *)Propertys withViewDic:(NSDictionary *)viewDic toProperty:(ViewProperty *)property andXMLHandel:(ReadXML *)xml{
    [self setPropertysForPublicWithViewDic:viewDic toProperty:property andXMLHandel:xml];
    
    for (NSString *propertyName in Propertys) {
        NSString *tempResult=[xml getPropertyWithName:propertyName withDic:viewDic needInChild:YES];
        if (tempResult.length>0) {
            if ([property hasProperty:propertyName]) {
                [property setValue:tempResult forKey:propertyName];
            }else{
                NSLog(@"%@",@"有的属性没有赋到值");
            }
        }
    }
}

/**设置公共属性*/
+ (void)setPropertysForPublicWithViewDic:(NSDictionary *)viewDic toProperty:(ViewProperty *)property andXMLHandel:(ReadXML *)xml{
    //1.rect
    NSDictionary *rectDic=[xml getOneDegreeChildWithName:@"rect" withDic:viewDic];
    if (rectDic!=nil) {
        property.rect_x=[xml getPropertyWithName:@"x" withDic:rectDic needInChild:NO];
        property.rect_y=[xml getPropertyWithName:@"y" withDic:rectDic needInChild:NO];
        property.rect_w=[xml getPropertyWithName:@"width" withDic:rectDic needInChild:NO];
        property.rect_h=[xml getPropertyWithName:@"height" withDic:rectDic needInChild:NO];
    }
    
    //2.Color
    NSDictionary *colorDic=[xml getOneDegreeChildWithName:@"color" withDic:viewDic];
    if (colorDic) {
        if ([colorDic[@"key"] isEqualToString:@"textColor"]) {
            property.textColor_red=[xml getPropertyWithName:@"red" withDic:colorDic needInChild:NO];
            property.textColor_green=[xml getPropertyWithName:@"green" withDic:colorDic needInChild:NO];
            property.textColor_blue=[xml getPropertyWithName:@"blue" withDic:colorDic needInChild:NO];
            property.textColor_alpha=[xml getPropertyWithName:@"alpha" withDic:colorDic needInChild:NO];
            
        }else if ([colorDic[@"key"] isEqualToString:@"backgroundColor"]){
            property.backgroundColor_red=[xml getPropertyWithName:@"red" withDic:colorDic needInChild:NO];
            property.backgroundColor_green=[xml getPropertyWithName:@"green" withDic:colorDic needInChild:NO];
            property.backgroundColor_blue=[xml getPropertyWithName:@"blue" withDic:colorDic needInChild:NO];
            property.backgroundColor_alpha=[xml getPropertyWithName:@"alpha" withDic:colorDic needInChild:NO];
            //            NSLog(@"%@:%@:%@:%@",property.backgroundColor_red,property.backgroundColor_green,property.backgroundColor_blue,property.backgroundColor_alpha);
        }
    }
    
    //action
    NSDictionary *connectionsDic=[xml getOneDegreeChildWithName:@"connections" withDic:viewDic];
    NSArray *subConnectionsArr=[xml childDic:connectionsDic];
    for (id obj in subConnectionsArr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subConnectionsDic=obj;
            if ([[xml dicNodeName:subConnectionsDic] isEqualToString:@"action"]) {
                property.selector=[xml getPropertyWithName:@"selector" withDic:subConnectionsDic needInChild:NO];
                property.eventType=[xml getPropertyWithName:@"eventType" withDic:subConnectionsDic needInChild:NO];
            }
        }
    }
}



/**根据property属性生成代码*/
+ (void)getCodePropertysForViewName:(NSString *)viewName WithidAndViewDic:(NSDictionary *)idAndViewDic withCustomAndName:(NSDictionary *)customAndNameDic withProperty:(ViewProperty *)property toCodeText:(NSMutableString *)codeText{
    [self recursiveGetPropertysCodeForViewName:viewName withProperty:property withIdAndName:idAndViewDic withCustomAndName:customAndNameDic toCodeText:codeText];
    [codeText appendString:@"\n"];
}
+ (void)recursiveGetPropertysCodeForViewName:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic withCustomAndName:(NSDictionary *)customAndNameDic toCodeText:(NSMutableString *)codeText{
    NSString *categoryView=customAndNameDic[viewName];
    
    if ([categoryView isEqualToString:@"label"]) {
        [self getPropertyCodeForLabel:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"button"]) {
        [self getPropertyCodeForButton:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"imageView"]) {
        [self getPropertyCodeForImageView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"tableView"]) {
        [self getPropertyCodeForTableView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"collectionView"]) {
        [self getPropertyCodeForCollectionView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"view"]) {
        [self getPropertyCodeForView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"segmentedControl"]) {
        [self getPropertyCodeForSegmentedControl:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"textField"]) {
        [self getPropertyCodeForTextField:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"switch"]) {
        [self getPropertyCodeForSwitch:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"activityIndicatorView"]) {
        [self getPropertyCodeForActivityIndicatorView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"progressView"]) {
        [self getPropertyCodeForProgressView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"pageControl"]) {
        [self getPropertyCodeForPageControl:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"stepper"]) {
        [self getPropertyCodeForStepper:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"textView"]) {
        [self getPropertyCodeForTextView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"scrollView"]) {
        [self getPropertyCodeForScrollView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"datePicker"]) {
        [self getPropertyCodeForDatePicker:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"pickerView"]) {
        [self getPropertyCodeForPickerView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"mapView"]) {
        [self getPropertyCodeForMapView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"searchBar"]) {
        [self getPropertyCodeForSearchBar:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
    if ([categoryView isEqualToString:@"webView"]) {
        [self getPropertyCodeForWebView:viewName withProperty:property withIdAndName:idAndNameDic toCodeText:codeText];
    }
}

+ (void)getPropertyCodeForLabel:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"text",@"textAlignment",@"adjustsFontSizeToFit",@"numberOfLines",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.text.length>0) [codeText appendFormat:@"%@.text=@\"%@\";\n",viewName,property.text];
    if (property.textAlignment.length>0&&[property.textAlignment isEqualToString:@"natural"]==NO) [codeText appendFormat:@"%@.textAlignment=NSTextAlignment%@;\n",viewName,[self upFirstCharacter:property.textAlignment]];
    if (property.adjustsFontSizeToFit.length>0&&[property.adjustsFontSizeToFit isEqualToString:@"NO"]==NO) [codeText appendFormat:@"%@.adjustsFontSizeToFitWidth=YES;\n",viewName];
    if (property.numberOfLines.length>0) [codeText appendFormat:@"%@.numberOfLines=%@;\n",viewName,property.numberOfLines];
    if (property.pointSize.length>0&&[property.pointSize isEqualToString:@"17"]==NO) [codeText appendFormat:@"%@.font=[UIFont systemFontOfSize:%@];\n",viewName,property.pointSize];
    
    if (property.textColor_red.length>0||property.textColor_green.length>0||property.textColor_blue.length>0) {
        if(![property.textColor_red isEqualToString:@"0.0"]&&[property.textColor_green isEqualToString:@"0.0"]&&[property.textColor_blue isEqualToString:@"0.0"]){
            [codeText appendFormat:@"%@.textColor=[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@];\n",viewName,[self getThreedigits:property.textColor_red],[self getThreedigits:property.textColor_green],[self getThreedigits:property.textColor_blue],property.textColor_alpha];
        }
    }
}
+ (void)getPropertyCodeForButton:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"title",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.title.length>0) [codeText appendFormat:@"[%@ setTitle:@\"%@\" forState:(UIControlStateNormal)];\n",viewName,property.title];
    if (property.pointSize.length>0&&[property.pointSize isEqualToString:@"15"]==NO)[codeText appendFormat:@"%@.titleLabel.font=[UIFont systemFontOfSize:%@];\n",viewName,property.pointSize];
    
    if (property.titleColor_red.length>0||property.titleColor_green.length>0||property.titleColor_blue.length>0) {
        [codeText appendFormat:@"[%@ setTitleColor:[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@] forState:(UIControlStateNormal)];\n",viewName,[self getThreedigits:property.titleColor_red],[self getThreedigits:property.titleColor_green],[self getThreedigits:property.titleColor_blue],property.titleColor_alpha];
    }
}
+ (void)getPropertyCodeForImageView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"image",@"contentMode"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.image.length>0)[codeText appendFormat:@"%@.image=[UIImage imageNamed:@\"%@\"];\n",viewName,property.image];
    if (property.contentMode.length>0&&[property.contentMode isEqualToString:@"scaleToFill"]==NO)[codeText appendFormat:@"%@.contentMode=UIViewContentMode%@;\n",viewName,[self upFirstCharacter:property.contentMode]];
}
+ (void)getPropertyCodeForTableView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"style",@"rowHeight"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.style.length>0&&[property.style isEqualToString:@"plain"]==NO)
        [codeText setString:[codeText stringByReplacingOccurrencesOfString:@"UITableViewStylePlain" withString:@"UITableViewStyleGrouped"]];
//    if (property.rowHeight.length>0)[codeText appendFormat:@"%@.rowHeight=%@;\n",viewName,property.rowHeight];
}
+ (void)getPropertyCodeForCollectionView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForSegmentedControl:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.segment.length>0){
        NSArray *tempArr=[property.segment componentsSeparatedByString:@"_$_"];
        if (tempArr.count>0) {
            NSMutableString *segments=[NSMutableString string];
            for (NSInteger i=0; i<tempArr.count; i++) {
                NSString *str=tempArr[i];
                [segments appendFormat:@"@\"%@\"",str];
                if (i<tempArr.count-1) {
                    [segments appendString:@","];
                }
            }
            [codeText setString:[codeText stringByReplacingOccurrencesOfString:@"[UISegmentedControl new]" withString:[NSString stringWithFormat:@"[[UISegmentedControl alloc]initWithItems:@[%@]]",segments]]];
        }
    }
//    segments
}
+ (void)getPropertyCodeForTextField:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"textAlignment",@"clearButtonMode",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.textAlignment.length>0&&[property.textAlignment isEqualToString:@"natural"]==NO) [codeText appendFormat:@"%@.textAlignment=NSTextAlignment%@;\n",viewName,[self upFirstCharacter:property.textAlignment]];
    if (property.pointSize.length>0&&[property.pointSize isEqualToString:@"14"]==NO) [codeText appendFormat:@"%@.font=[UIFont systemFontOfSize:%@];\n",viewName,property.pointSize];
    if (property.clearButtonMode.length>0) [codeText appendFormat:@"%@.clearButtonMode=UITextFieldViewMode%@;\n",viewName,[self upFirstCharacter:property.clearButtonMode]];
    if (property.textColor_red.length>0||property.textColor_green.length>0||property.textColor_blue.length>0) {
        [codeText appendFormat:@"%@.textColor=[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@];\n",viewName,[self getThreedigits:property.textColor_red],[self getThreedigits:property.textColor_green],[self getThreedigits:property.textColor_blue],property.textColor_alpha];
    }
}
+ (void)getPropertyCodeForSlider:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForSwitch:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"on"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.on.length>0) [codeText appendFormat:@"%@.on=%@;\n",viewName,property.on];
}
+ (void)getPropertyCodeForActivityIndicatorView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForProgressView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForPageControl:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForStepper:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForTextView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"textAlignment",@"pointSize"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.textAlignment.length>0&&[property.textAlignment isEqualToString:@"natural"]==NO) [codeText appendFormat:@"%@.textAlignment=NSTextAlignment%@;\n",viewName,[self upFirstCharacter:property.textAlignment]];
    if (property.pointSize.length>0&&[property.pointSize isEqualToString:@"14"]==NO) [codeText appendFormat:@"%@.font=[UIFont systemFontOfSize:%@];\n",viewName,property.pointSize];
    if (property.textColor_red.length>0||property.textColor_green.length>0||property.textColor_blue.length>0) {
        [codeText appendFormat:@"%@.textColor=[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@];\n",viewName,[self getThreedigits:property.textColor_red],[self getThreedigits:property.textColor_green],[self getThreedigits:property.textColor_blue],property.textColor_alpha];
    }
}
+ (void)getPropertyCodeForScrollView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForDatePicker:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForPickerView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForMapView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}
+ (void)getPropertyCodeForSearchBar:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
//    @"placeholder",@"backgroundImage"
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
    if (property.placeholder.length>0) [codeText appendFormat:@"%@.placeholder=@\"%@\";\n",viewName,property.placeholder];
    if (property.backgroundImage.length>0) [codeText appendFormat:@"%@.backgroundImage=[UIImage imageNamed:@\"%@\"];\n",viewName,property.backgroundImage];
}
+ (void)getPropertyCodeForWebView:(NSString *)viewName withProperty:(ViewProperty *)property withIdAndName:(NSDictionary *)idAndNameDic toCodeText:(NSMutableString *)codeText{
    [self getPublicPropertyCodeForView:viewName WithProperty:property toCodeText:codeText];
}

/**如果没有添加约束,就按照默认frame设置约束*/
+ (NSString *)getConstraintIfNotGiveConstraintsForViewName:(NSString *)viewName withProperty:(ViewProperty *)property withFatherView:(NSString *)fatherView{
//    NSLog(@"%@:%@:%@:%@",property.rect_x,property.rect_y,property.rect_w,property.rect_h);
    if (property.rect_x.length>0||property.rect_y.length>0||property.rect_w>0||property.rect_h>0) {
        NSMutableString *rectConstraint=[NSMutableString string];
        [rectConstraint appendFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",viewName];
        [rectConstraint appendFormat:@"make.leading.equalTo(%@.mas_leading).with.offset(%@);\n",fatherView,property.rect_x];
        [rectConstraint appendFormat:@"make.top.equalTo(%@.mas_top).with.offset(%@);\n",fatherView,property.rect_y];
        [rectConstraint appendFormat:@"make.width.equalTo(@(%@));\n",property.rect_w];
        [rectConstraint appendFormat:@"make.height.equalTo(@(%@));\n",property.rect_h];
        [rectConstraint appendString:@"}];\n"];
        return rectConstraint;
    }
    return @"";
}
/**获取事件代码*/
+ (NSString *)getSelectorEventTypeForViewName:(NSString *)viewName withProperty:(ViewProperty *)property{
    if (property.selector.length>0&&property.eventType.length>0){
        if ([property.selector hasSuffix:@":"]) {
            return [NSString stringWithFormat:@"- (void)%@(id)sender{\n\
                    \n\
                    }\n",property.selector];
        }else{
            return [NSString stringWithFormat:@"- (void)%@{\n\
                    \n\
                    }\n",property.selector];
        }
    }
    return @"";
}

/**根据公共属性生成代码*/
+ (void)getPublicPropertyCodeForView:(NSString *)viewName WithProperty:(ViewProperty *)property toCodeText:(NSMutableString *)codeText{
    //1.Color
    if (property.backgroundColor_red.length>0||property.backgroundColor_green.length>0||property.backgroundColor_blue.length>0) {
        [codeText appendFormat:@"%@.backgroundColor=[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@];\n",viewName,[self getThreedigits:property.backgroundColor_red],[self getThreedigits:property.backgroundColor_green],[self getThreedigits:property.backgroundColor_blue],property.backgroundColor_alpha];
    }
    
    //2.action
    if (property.selector.length>0&&property.eventType.length>0) {
        [codeText appendFormat:@"[%@ addTarget:self action:@selector(%@) forControlEvents:UIControlEvent%@];\n",viewName,property.selector,[self upFirstCharacter:property.eventType]];
    }
}

/**获取字符串三位小数*/
+ (NSString *)getThreedigits:(NSString *)str{
    if (str.length<=5) {
        return str;
    }
    return [str substringToIndex:5];
}

+ (NSString *)upFirstCharacter:(NSString *)text{
    if (text.length<=0) {
        return @"";
    }
    NSString *firstCharacter=[text substringToIndex:1];
    return [[firstCharacter uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
}
@end