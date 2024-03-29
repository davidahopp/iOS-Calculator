//
//  CalculatorBrain.h
//  Calculator
//
//  Created by David Hopp on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (void) pushVariable:(NSString *)variable;
- (double) performOperation:(NSString *)operation;
- (void) clearStack;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)pi;
+ (BOOL)isVariable:(NSString *)value;

@end
