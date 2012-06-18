//
//  CalculatorViewController.m
//  Calculator
//
//  Created by David Hopp on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h" 

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL entertingSeries;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize programDisplay = _programDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize entertingSeries = _entertingSeries;

@synthesize brain = _brain;

- (CalculatorBrain *)brain{
    if(!_brain){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if([CalculatorBrain isVariable:digit]){
        [self.brain pushVariable:digit];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        [self displayProgram];
        return;
    }
    
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([digit isEqualToString:@"."]){
            if(NSNotFound == [self.display.text rangeOfString:@"."].location){
                self.display.text = [self.display.text stringByAppendingString:digit]; 
                //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:digit];

            }
        } else {
            self.display.text = [self.display.text stringByAppendingString:digit];
            //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:digit];

        }
            
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        if(!self.entertingSeries){
            //self.historyDisplay.text = digit;
            self.entertingSeries = YES;
        } else {
            //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
            //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:digit];
        }

    }
    [self displayProgram];

}

- (IBAction)enterPressed {

    if([@"π" isEqualToString:self.display.text]){
        [self.brain pushOperand:[CalculatorBrain pi]];
    } else {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:sender.currentTitle];
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    
    //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" = "];

    self.display.text = resultString;
    [self displayProgram];
    
}


- (IBAction)piPressed:(UIButton *)sender {
    
    [self.brain pushOperand:[CalculatorBrain pi] ];
    
    //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    //self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:sender.currentTitle];
                                
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    
    self.display.text = sender.currentTitle;
    [self displayProgram];
    
}

- (IBAction)delNumber:(id)sender {
    if ( [self.display.text length] > 0){
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
        //self.historyDisplay.text = [self.historyDisplay.text substringToIndex:[self.historyDisplay.text length] - 1];
    }
    [self displayProgram];

}

- (IBAction)clear:(id)sender {
    self.programDisplay.text = @"";
    self.display.text = @"0";
    [self.brain clearStack];
}

- (void)displayProgram {
    self.programDisplay .text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}

- (void)viewDidUnload {
    [self setProgramDisplay:nil];
    [super viewDidUnload];
}
@end
