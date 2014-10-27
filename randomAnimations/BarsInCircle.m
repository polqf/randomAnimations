//
//  BarsInCircle.m
//  randomAnimations
//
//  Created by Pol Quintana on 27/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "BarsInCircle.h"
#import <UIColor+FlatColors.h>

#define degreesToRadians(x) (M_PI * x /180.0)

@interface BarsInCircle ()

@property (nonatomic, strong) NSArray *bars;
@property (nonatomic, strong) NSMutableArray *widthsArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic) CALayer *loaderLayer;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) NSInteger numberOfBars;
@property (nonatomic) CGFloat barWidthMax;
@property (nonatomic) CGFloat barHeightMax;
@property (nonatomic) CGFloat barWidthMin;
@property (nonatomic) CGFloat barHeightMin;
@property (nonatomic) CGFloat angleInRad;

@end

@implementation BarsInCircle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self generateLoader];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self generateLoader];
    }
    return self;
}

- (void)generateLoader {
    self.numberOfBars = 100;
    self.backgroundColor = [UIColor flatTurquoiseColor];
    self.color = [UIColor flatCloudsColor];
    self.barHeightMin = 20;
    self.barHeightMax = 100;
    self.barWidthMin = 2;
    self.barWidthMax = 5;
    self.angleInRad = degreesToRadians(0);
    
    self.widthsArray = [[NSMutableArray alloc] initWithCapacity:self.numberOfBars];
    self.heightArray = [[NSMutableArray alloc] initWithCapacity:self.numberOfBars];
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:self.numberOfBars];
    self.loaderLayer = [CALayer layer];
    self.loaderLayer.bounds = self.bounds;
    self.loaderLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    [self.layer addSublayer:self.loaderLayer];
    
    for (int i = 0 ; i < self.numberOfBars ; i++) {
        CALayer *bar = [CALayer layer];
        bar.backgroundColor = self.color.CGColor;
        CGFloat randomWidth = 0;
        CGFloat randomHeight = 0;
        [self.heightArray addObject:[NSNumber numberWithFloat:randomHeight]];
        [self.widthsArray addObject:[NSNumber numberWithFloat:randomWidth]];
        bar.bounds = CGRectMake(0, 0, 0, 0);
        bar.anchorPoint = CGPointMake(0.5, 1.0);
        bar.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        CGFloat angle = degreesToRadians(360/self.numberOfBars*(i+1));
        CATransform3D rotate = CATransform3DMakeRotation(angle, 0, 0, 1);
        bar.transform = rotate;
        [temp addObject:bar];
        [self.loaderLayer addSublayer:bar];
    }
    
    self.bars = [temp copy];
}

- (CGFloat)randomFloatBetween:(CGFloat)a and:(CGFloat)b {
    CGFloat random = ((CGFloat) rand()) / (CGFloat) RAND_MAX;
    CGFloat diff = b - a;
    CGFloat r = random * diff;
    return a + r;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self startAnimation];
    [self animateRotation];
}

- (void)startAnimation {
    for (int i = 0; i < self.numberOfBars; i++) {
        CALayer *bar = [self.bars objectAtIndex:i];
        [self animateBar:bar atIndex:i];
    }
}

- (void)animateBar:(CALayer *)bar atIndex:(NSInteger)index {
    
    NSNumber *widthInArray = [self.widthsArray objectAtIndex:index];
    CGFloat width = [widthInArray floatValue];
    CGFloat width2 = [self randomFloatBetween:self.barWidthMin and:self.barWidthMax];
    [self.widthsArray replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:width2]];
    
    NSNumber *heightInArray = [self.heightArray objectAtIndex:index];
    CGFloat height = [heightInArray floatValue];
    CGFloat height2 = [self randomFloatBetween:self.barHeightMin and:self.barHeightMax];
    [self.heightArray replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:height2]];
    
    CAKeyframeAnimation *heightMoving = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    heightMoving.duration = 0.5;
#warning property
    heightMoving.values = @[[NSValue valueWithCGSize:CGSizeMake(width, height)],
                          [NSValue valueWithCGSize:CGSizeMake(width2, height2)]];
    heightMoving.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    heightMoving.fillMode = kCAFillModeForwards;
    heightMoving.removedOnCompletion = NO;
    
    if (index == self.numberOfBars -1) {
        heightMoving.delegate = self;
        [heightMoving setValue:@"anim1" forKey:@"animation"];
    }
    
    [bar addAnimation:heightMoving forKey:@"height"];
}

- (void)animateRotation {
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.duration = 2.0;
#warning property
    rotate.additive = YES;
    rotate.values = @[[NSNumber numberWithFloat:self.angleInRad], [NSNumber numberWithFloat:(self.angleInRad + M_PI_4)]];
    rotate.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    rotate.delegate = self;
    
    [rotate setValue:@"anim2" forKey:@"animation"];
    
    self.angleInRad = self.angleInRad + M_PI_4;
    
    [self.loaderLayer addAnimation:rotate forKey:@"rotation"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([@"anim1" isEqualToString:[anim valueForKey:@"animation"]]) {
        [self startAnimation];
    }
    if ([@"anim2" isEqualToString:[anim valueForKey:@"animation"]]) {
        [self animateRotation];
    }
}











@end
