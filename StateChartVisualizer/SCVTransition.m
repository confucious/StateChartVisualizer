//
//  SCVTransition.m
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "SCVTransition.h"

@implementation SCVTransition

- (NSString*) description {
    if ( self.name ) {
        return [NSString stringWithFormat: @"%@ [%@]-> %@", self.sourceState, self.name, self.targetState];
    } else {
        return [NSString stringWithFormat: @"%@ -> %@", self.sourceState, self.targetState];
    }
}

@end
