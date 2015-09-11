//
//  ToDoViewController.m
//  Deprocrastinator
//
//  Created by Rachel Schneebaum on 7/20/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoViewController.h"
#import "ToDoTableViewCell.h"
#import "ToDoItem.h"

@interface ToDoViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addItemTextField;
@property (weak, nonatomic) IBOutlet UITableView *toDoItemsTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property NSMutableArray *items;

@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = [[NSMutableArray alloc] init];
    // adds strings to objects array
    NSInteger numberOfItems = 30;
    for (NSInteger i = 1; i <= numberOfItems; i++) {
        NSString *title = [NSString stringWithFormat:@"Thing #%ld", (long)i];
        ToDoItem *item = [[ToDoItem alloc] initWithTitle:title];
        [self.items addObject:item];
    }
    self.addButton.enabled = false;

    //Add a right swipe gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleSwipeRight:)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.toDoItemsTableView addGestureRecognizer:recognizer];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.toDoItemsTableView];

    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.toDoItemsTableView indexPathForRowAtPoint:location];

    if (indexPath) {
        ToDoItem *item = self.items[indexPath.row];
        if (item.priority < 3) {
            item.priority++;
        } else {
            item.priority = 0;
        }
        NSLog(@"%d", item.priority);
    }
//    [self.toDoItemsTableView reloadData];
}

#pragma mark - UIGestureRecognizerDelegate
#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UITableView delegate methods
#pragma mark -

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(ToDoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell"];
    ToDoItem *item = self.items[indexPath.row];

    cell.textLabel.text = item.title;
    switch (item.priority) {
        case 1: {
            item.priority = 0;
            cell.textColor = [UIColor blackColor];
            cell.textLabel.textColor = cell.textColor;
            break;
        }
        case 2: {
            item.priority = 1;
            cell.textColor = [UIColor greenColor];
            cell.textLabel.textColor = cell.textColor;
        }
        case 3: {
            item.priority = 2;
            cell.textColor = [UIColor yellowColor];
            cell.textLabel.textColor = cell.textColor;
        }
        case 4: {
            item.priority = 3;
            cell.textColor = [UIColor redColor];
            cell.textLabel.textColor = cell.textColor;
        }
        default:
            break;
    }

    if (item.isChecked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
    }
    [self.toDoItemsTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoItem *item = self.items[indexPath.row];
    if (item.isChecked) {
        item.isChecked = false;
    } else {
        item.isChecked = true;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    [tableView reloadData];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *toDoItem = [self.items objectAtIndex:sourceIndexPath.row];
    [self.items removeObject:toDoItem];
    [self.items insertObject:toDoItem atIndex:destinationIndexPath.row];

    [self.toDoItemsTableView reloadData];
}

//-(void)didSetCellPriority:(ToDoTableViewCell *)cell withSwipe:(UISwipeGestureRecognizer *)sender {
//    cell.delegate = self;
//    ToDoObject *toDo = [ToDoObject new];
//    if ([toDo.priority isEqualToString:@"high"]) {
//        NSLog(@"this is already urgent! do it!");
//    } else if ([toDo.priority isEqualToString:@"medium"]) {
//        toDo.priority = @"high";
//        cell.backgroundColor = [UIColor redColor];
//    } else if ([toDo.priority isEqualToString:@"low"]) {
//        toDo.priority = @"medium";
//        cell.backgroundColor = [UIColor yellowColor];
//    } else {
//        toDo.priority = @"low";
//        cell.backgroundColor = [UIColor greenColor];
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
//}
//
//-(void)didChangeTextColorCell:(ToDoTableViewCell *)cell withTap:(UITapGestureRecognizer *)sender {
//    cell.delegate = self;
//    if (cell.textLabel.textColor == [UIColor blackColor]) {
//        cell.textLabel.textColor = [UIColor greenColor];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//}

#pragma mark - IBActions
#pragma mark -

- (IBAction)onAddButtonPressed:(UIButton *)sender {
    [self.items addObject:self.addItemTextField.text];
    [self.addItemTextField endEditing:YES];
    [self.addItemTextField resignFirstResponder];
    self.addItemTextField.text = @"";
    [self.toDoItemsTableView reloadData];
    self.addButton.enabled = false;
}

- (IBAction)onAddButtonTextFieldEdited:(UITextField *)sender {
    if ([self.addItemTextField hasText]) {
        self.addButton.enabled = true;
    } else {
        self.addButton.enabled = false;
    }
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    if (self.editing == true) {
        self.editButton.title = @"Edit";
        [self.toDoItemsTableView setEditing:false animated:true];
        self.editing = false;
    } else {
        self.editButton.title = @"Done";
        [self.toDoItemsTableView setEditing:true animated:true];
        self.editing = true;
    }
}

@end
