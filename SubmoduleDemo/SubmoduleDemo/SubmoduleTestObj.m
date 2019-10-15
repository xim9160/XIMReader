//
//  SubmoduleTestObj.m
//  SubmoduleDemo
//
//  Created by xiaofengmin on 2019/10/12.
//  Copyright © 2019 xiaofengmin. All rights reserved.
//

#import "SubmoduleTestObj.h"

@implementation SubmoduleTestObj

- (void)print:(NSString *)string {
    NSLog(@"submodule test class:%@", NSStringFromClass(self.class));
}

@end
