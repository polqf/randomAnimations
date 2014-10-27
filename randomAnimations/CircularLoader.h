//
//  CircularLoader.h
//  randomAnimations
//
//  Created by Pol Quintana on 26/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularLoader : UIView

@property (nonatomic) NSInteger numberOfCircles;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat maxDiam;
@property (nonatomic) CGFloat separation;
@property (nonatomic) CGFloat duration;
@property (nonatomic, strong) UIColor *color;

@end
