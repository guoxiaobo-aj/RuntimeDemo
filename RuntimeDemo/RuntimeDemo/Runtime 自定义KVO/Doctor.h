//
//  Doctor.h
//  RuntimeDemo
//
//  Created by Guoxb on 2019/12/3.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Doctor : NSObject

@property (nonatomic, copy) NSString *name;

- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

NS_ASSUME_NONNULL_END
