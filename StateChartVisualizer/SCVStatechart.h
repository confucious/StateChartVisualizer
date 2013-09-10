//
//  SCVStatechart.h
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/9/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCVState.h"
#import "SCVTransition.h"

@interface SCVStatechart : NSObject

@property (nonatomic, strong) SCVState* rootState;
@property (nonatomic, copy) NSArray* transitions;

@end
