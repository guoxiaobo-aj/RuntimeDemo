//
//  Animal.h
//  RuntimeDemo
//
//  Created by Guoxb on 2019/12/3.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Animal : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;

- (instancetype)initWithDic:(NSDictionary *)dic;
- (NSDictionary *)convertModelToDic;

@end

NS_ASSUME_NONNULL_END
