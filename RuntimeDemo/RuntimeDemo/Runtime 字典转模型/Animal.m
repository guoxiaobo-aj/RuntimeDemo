//
//  Animal.m
//  RuntimeDemo
//
//  Created by Guoxb on 2019/12/3.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "Animal.h"
#import <objc/message.h>

@implementation Animal

/*
 * 字典转模型
 */
// key - value
// 消息发送
// 函数指针格式
// 返回类型 (*函数名)(param1, param2)
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
//        for (NSString *key in dic.allKeys) {
//            id value = dic[key];
//            //objc_msgSend(id, sel, value)
//            NSString *methodName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
//            SEL sel = NSSelectorFromString(methodName);
//            if (sel) {
//                ((void(*)(id, SEL, id))objc_msgSend)(self, sel, value);
//            }
//        }
        
        unsigned int count = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i ++) {
            const char *propertyName = property_getName(propertyList[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            id value = [dic objectForKey:name];
            if (value) {
                [self setValue:value forKey:name];
            }
        }
    }
    return self;
}

/*
 * 模型转字典
 * key: class_getPropertyList()
 * value: get方法 objc_msgSend
 */
- (NSDictionary *)convertModelToDic {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count != 0) {
        NSMutableDictionary *tempDic = [@{} mutableCopy];
        for (int i = 0; i < count; i ++) {
            const void *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            SEL sel = NSSelectorFromString(name);
            
            if (sel) {
                id value = ((id(*)(id, SEL))objc_msgSend)(self, sel);
                if (value) {
                    tempDic[name] = value;
                } else {
                    tempDic[name] = @"";
                }
            }
        }
        free(properties);
        return tempDic;
    }
    free(properties);
    return nil;
}

@end
