//
//  SCVTransition.h
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCVState;

@interface SCVTransition : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) SCVState* sourceState;
@property (nonatomic, strong) SCVState* targetState;

@end
