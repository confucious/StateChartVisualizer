//
//  SCVParser.h
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCVStatechart.h"
#import "CoreParse.h"

/*
 (state) { (substate1), (substate2), (substate3), ... };
 (sourceState) [transitionName]-> (targetState);
 The first substate in a list will be the default initial substate.
 (root) is starting state and all other states should have root as an eventual ancestor.
 (root) can not have any transitions leaving from it.

 */

@interface SCVParser : NSObject
@property (nonatomic, strong, readonly) SCVStatechart* statechart;
@property (nonatomic, strong) CPTokeniser* tokeniser;
@property (nonatomic, strong) CPParser* parser;

- (BOOL) parseStateRepresentation: (NSString*) stateString error: (NSError**) error;

@end
