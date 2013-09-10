//
//  SCVState.m
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "SCVState.h"

@implementation SCVState

- (NSUInteger)hash {
    return [self.name hash];
}

- (BOOL)isEqual:(id)object {
    if ( [object isKindOfClass: [SCVState class]] ) {
        SCVState* otherState = object;
        return [self.name isEqualToString: otherState.name];
    } else {
        return NO;
    }
}

- (NSString*) description {
    if ( [self.subStates count] > 0 ) {
        return [NSString stringWithFormat: @"State: %@, Substates: %@", self.name, [self.subStates valueForKey: @"name"]];
    } else {
        return [NSString stringWithFormat: @"State: %@", self.name];
    }
}

@end
