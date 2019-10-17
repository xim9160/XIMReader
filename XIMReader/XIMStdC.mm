//
//  XIMStdC.m
//  XIMReader
//
//  Created by xiaofengmin on 2019/10/14.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

#import "XIMStdC.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>


@implementation XIMStdC

+ (void)loadBundle {
    

    NSBundle *bd1 = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Frameworks/ShiZhiFengYunForum.framework/ShiZhiFengYunBundle" ofType:@"bundle"]];
    NSBundle *bd2 = [XIMStdC bundleWithBundleName:@"ShiZhiFengYunBundle" podName:@"ShiZhiFengYunForum"];
//    NSBundle *bd3 = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Frameworks/ShiZhiFengYunForum.framework/ShiZhiFengYunBundle" ofType:@"bundle"]];
//    NSBundle *bd4 = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Frameworks/ShiZhiFengYunForum.framework/ShiZhiFengYunBundle" ofType:@"bundle"]];
    NSLog(@"666666");


}

+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    if (!associateBundleURL) {
//        [[NSBundle bundleForClass:[self class]] URLForResource:@"main" withExtension:@"jsbundle" subdirectory:@"xxx.bundle/source"];

//        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Pods" withExtension:nil];
//        //SZFYDependciesLib
//        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"SZFYDependciesLib"];
//        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"Frameworks"];
//        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
//        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
//        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
//        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

@end
