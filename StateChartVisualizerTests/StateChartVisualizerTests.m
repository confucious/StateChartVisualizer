//
//  StateChartVisualizerTests.m
//  StateChartVisualizerTests
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "StateChartVisualizerTests.h"
#import "SCVParser.h"

@implementation StateChartVisualizerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    SCVParser* parser = [[SCVParser alloc] init];
    [parser parseStateRepresentation: @"(root) {(b),(c),(d)};" error: nil];
//    NSLog(@"root = %@", parser.statechart.rootState);
//    NSLog(@"root initialSubstate = %@", parser.rootState.initialSubState);
//    NSLog(@"root substates = %@", parser.rootState.subStates);
//
    [parser parseStateRepresentation: @"(b) -> (c);(c) -> (d);" error: nil];
//    [parser parseStateRepresentation: @"(e) [someReason]-> (f);" error: nil];
//    NSLog(@"transitions = %@", parser.transitions);
}

@end
