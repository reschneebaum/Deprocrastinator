//
//  ToDoObject.h
//  Deprocrastinator
//
//  Created by Rachel Schneebaum on 8/6/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ToDoItemDelegate <NSObject>

-(void)didChangePriorityOfItem:(id)item;

@end

@interface ToDoItem : NSObject

@property (assign, nonatomic) id <ToDoItemDelegate> delegate;
@property NSString *title;
@property int priority;
@property BOOL isChecked;

-(instancetype)initWithTitle:(NSString *)title;

@end
