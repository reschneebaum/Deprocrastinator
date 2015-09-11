//
//  ToDoObject.m
//  Deprocrastinator
//
//  Created by Rachel Schneebaum on 8/6/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@implementation ToDoItem

-(instancetype)initWithTitle:(NSString *)title {
    if (self) {
        self.title = title;
//        self.priority = priority;
    }
    return self;
}

@end
