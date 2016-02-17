//
//  TodoDataManager.m
//  Calendar
//
//  Created by Josh Klobe on 7/11/14.
//
//

#import "TodoDataManager.h"
#import "GroupDiskManager.h"
#import "TodoBubbleView.h"
#define STORED_TODOS_KEY @"STORED_TODOS_KEY"


@implementation TodoDataManager


+(NSArray *)getAllTodos
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *storedArray = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_TODOS_KEY];
    if (storedArray != nil)
        [array addObjectsFromArray:storedArray];
    
    return array;
}

+(void)saveTodoWithString:(NSString *)theTodoString
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *storedArray = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_TODOS_KEY];
    if (storedArray != nil)
        [array addObjectsFromArray:storedArray];
    
    TodoObject *todoObject = [[TodoObject alloc] init];
    todoObject.todoIdentificationNumber = [NSNumber numberWithInteger:[self getNextID]];
    todoObject.todoString = theTodoString;
    
    [array addObject:todoObject];
    
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:array withKey:STORED_TODOS_KEY];
    
    [[TodoBubbleView sharedTodoBubbleView] updateTodoValue];
    
}

+(void)deleteTodo:(TodoObject *)theTodoObject
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *storedArray = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_TODOS_KEY];
    if (storedArray != nil)
        [array addObjectsFromArray:storedArray];

    TodoObject *deletableTodoObject = nil;
    
    for (int i = 0; i < [array count]; i++)
    {
        TodoObject *obj = [array objectAtIndex:i];
        if ([obj.todoIdentificationNumber integerValue] == [theTodoObject.todoIdentificationNumber integerValue])
            deletableTodoObject = obj;
    }
    if (deletableTodoObject != nil)
        [array removeObject:deletableTodoObject];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:array withKey:STORED_TODOS_KEY];
    
    [[TodoBubbleView sharedTodoBubbleView] updateTodoValue];
    
}


+(int)getNextID
{
    NSArray *storedArray = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_TODOS_KEY];
    if (storedArray != nil)
    {
        int nextID = 0;
        
        for (int i = 0; i < [storedArray count]; i++)
        {
            TodoObject *todoObject = [storedArray objectAtIndex:i];
            if ([todoObject.todoIdentificationNumber intValue] > nextID)
            {
                nextID = [todoObject.todoIdentificationNumber intValue];
            }
        }
        return ++nextID;
    }
    else return 1;
    
}

+(void)moveTodoFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *storedArray = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_TODOS_KEY];
    if (storedArray != nil)
        [array addObjectsFromArray:storedArray];
    
    TodoObject *theObject = [array objectAtIndex:fromIndex];
    [array removeObjectAtIndex:fromIndex];
    if (toIndex == [array count])
        [array addObject:theObject];
    else
        [array insertObject:theObject atIndex:toIndex];
    
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:array withKey:STORED_TODOS_KEY];
}

+(void)updateObjectWithTodo:(TodoObject *)theObject
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *storedArray = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_TODOS_KEY];
    if (storedArray != nil)
        [array addObjectsFromArray:storedArray];
    

    
    for (int i = 0; i < [array count]; i++)
    {
        TodoObject *obj = [array objectAtIndex:i];
        if ([obj.todoIdentificationNumber integerValue] == [theObject.todoIdentificationNumber integerValue])
        {
            [array replaceObjectAtIndex:i withObject:theObject];
        }
    }

    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:array withKey:STORED_TODOS_KEY];
}

@end

