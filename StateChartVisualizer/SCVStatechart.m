//
//  SCVStatechart.m
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/9/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "SCVStatechart.h"

@implementation SCVStatechart

- (NSString *)description {
    return [NSString stringWithFormat: @"rootState: %@\ntransitions: %@", self.rootState, self.transitions];
}

@end
