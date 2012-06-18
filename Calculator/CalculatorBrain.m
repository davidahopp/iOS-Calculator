//
//  CalculatorBrain.m
//  Calculator
//
//  Created by David Hopp on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

+ (double) pi{
    return 3.14159;
}

+ (BOOL) isVariable:(NSString *)value{
    NSSet *set = [NSSet setWithObjects:@"a", @"b", @"x", @"y", nil];
    if([set containsObject:value]){
        return YES;
    }
    return NO;
}

+ (BOOL) isOperation:(NSString *)value{
    NSSet *set = [NSSet setWithObjects:@"*", @"/", @"+", @"-", nil];
    if([set containsObject:value]){
        return YES;
    }
    return NO;
}

+ (BOOL) isFunction:(NSString *)value{
    NSSet *set = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", nil];
    if([set containsObject:value]){
        return YES;
    }
    return NO;
}

- (NSMutableArray *)programStack{
    if(_programStack == nil){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void) pushOperand:(double)operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushVariable:(NSString *)variable{
    [self.programStack addObject:variable];
}

- (void) clearStack{
    [self.programStack removeAllObjects];
}

- (double) performOperation:(NSString *)operation{
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program{
    
//    NSLog([program description]);
    
    int count = [program count];
    
    for (int i = 0; i < count; i++) {
        NSString *value = [program objectAtIndex:i];
//        NSLog(value);
        if ([CalculatorBrain isVariable:value]) {
            NSLog(@"is variable");
        } else if ([CalculatorBrain isOperation:value]){
            NSLog(@"is operation");
        } else if ([CalculatorBrain isFunction:value]){
            NSLog(@"is function");
        } else{
            NSLog(value);
        }
    }
    
    return @"hello";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack){
        [stack removeLastObject];
    }
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    } else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"-" isEqualToString:operation]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([@"/" isEqualToString:operation]){
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffStack:stack]);
        } else if ([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffStack:stack]);
        } else if ([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([@"log" isEqualToString:operation]){
            result = log([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
    
}


@end
