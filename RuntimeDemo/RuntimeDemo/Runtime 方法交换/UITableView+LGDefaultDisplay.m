//
//  UITableView+LGDefaultDisplay.m
//  RuntimeDemo
//
//  Created by Guoxb on 2019/12/3.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "UITableView+LGDefaultDisplay.h"
#import <objc/runtime.h>

const char *LGDefaultView;

static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UITableView (LGDefaultDisplay)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(reloadData));
        Method currentMethod = class_getInstanceMethod(self, @selector(lg_reloadData));
        if (!class_addMethod([self class], method_getName(originMethod), method_getImplementation(currentMethod), method_getTypeEncoding(currentMethod))) {
            method_exchangeImplementations(originMethod, currentMethod);
        } else {
            class_replaceMethod([self class], method_getName(currentMethod), method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
    });
}

- (void)lg_reloadData {
    [self lg_reloadData];
    [self fillDefaultView];
}

- (void)fillDefaultView {
    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger section = [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [dataSource numberOfSectionsInTableView:self] : 1;
    NSInteger rows = 0;
    for (NSInteger i = 0; i < section; i ++) {
        rows = [dataSource tableView:self numberOfRowsInSection:i];
    }
    
    if (!rows) {
        self.lgDefaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.lgDefaultView.backgroundColor = UIColor.redColor;
        [self addSubview:self.lgDefaultView];
    } else {
        self.lgDefaultView.hidden = YES;
    }
}

#pragma mark - Getter & Setter

- (void)setLgDefaultView:(UIView *)lgDefaultView {
    objc_setAssociatedObject(self, &LGDefaultView, lgDefaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)lgDefaultView {
    return objc_getAssociatedObject(self, &LGDefaultView);
}

@end
