//
//  Doctor.m
//  RuntimeDemo
//
//  Created by Guoxb on 2019/12/3.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "Doctor.h"
#import <objc/message.h>

@implementation Doctor

void setterMethod(id self, SEL _cmd, NSString *name){
    // 1. 调用父类方法
    // 2. 通知观察者调用 observeValue...
    struct objc_super superClass = {
        self,
        class_getSuperclass([self class])
    };
    objc_msgSendSuper(&superClass, _cmd, name);
    
    id observer = objc_getAssociatedObject(self, (__bridge const void *)@"objc");
    
    // 通知改变
    NSString *methodName = NSStringFromSelector(_cmd);
    NSString *key = getValueKey(methodName);
    objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), key, self, @{key: name}, nil);
}

NSString *getValueKey(NSString *setter) {
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    NSString *letter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:letter];
    return key;
}

- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    // 创建一个类
    NSString *oldName = NSStringFromClass([self class]);
    NSString *newName = [NSString stringWithFormat:@"CustomKVO_%@", oldName];
    
    Class customClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    objc_registerClassPair(customClass); // 注册类
    
    // 修改isa指针
    object_setClass(self, customClass);
    
    // 重写set方法
    NSString *methodName = [NSString stringWithFormat:@"set%@:", keyPath.capitalizedString];
    SEL sel = NSSelectorFromString(methodName);
    class_addMethod(customClass, sel, (IMP)setterMethod, @"v@:@");
    
    objc_setAssociatedObject(self, (__bridge const void *)@"objc", observer, OBJC_ASSOCIATION_ASSIGN);
}

@end
