//
//  SCVState.h
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVState : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, copy) NSSet* subStates;
@property (nonatomic, strong) SCVState* initialSubState;
@property (nonatomic, weak) SCVState* parentState;

@end
