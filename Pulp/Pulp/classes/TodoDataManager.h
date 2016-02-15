//
//  TodoDataManager.h
//  Calendar
//
//  Created by Josh Klobe on 7/11/14.
//
//

#import <Foundation/Foundation.h>
#import "TodoObject.h"
@interface TodoDataManager : NSObject


+(NSArray *)getAllTodos;
+(void)saveTodoWithString:(NSString *)theTodoString;
+(void)deleteTodo:(TodoObject *)theTodoObject;
+(void)moveTodoFrom:(NSInteger)fromIndex to:(NSInteger)toIndex;
+(void)updateObjectWithTodo:(TodoObject *)theObject;
@end
