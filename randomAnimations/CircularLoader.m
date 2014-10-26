//
//  CircularLoader.m
//  randomAnimations
//
//  Created by Pol Quintana on 26/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "CircularLoader.h"
#import <UIColor+FlatColors.h>

@interface CircularLoader ()

@property (nonatomic, strong) NSArray *balls;

@end

@implementation CircularLoader

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
    
    CGFloat diameter = 10.0;
    CGFloat margin = 8.0;
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:3];
    self.backgroundColor = [UIColor flatTurquoiseColor];
    
    for (int i = 0; i< 6; i++) {
        CALayer *ball = [CALayer layer];
        ball.bounds = CGRectMake(0, 0, 0 , 0);
        ball.borderWidth = 4.0;
        ball.borderColor = [UIColor flatCloudsColor].CGColor;
        ball.cornerRadius = diameter/2;
        
        switch (i) {
            case 0:
                ball.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 -margin);
                break;
            case 1:
                ball.position = CGPointMake(CGRectGetWidth(self.frame)/2 - margin, CGRectGetHeight(self.frame)/2 + margin);
                break;
            case 2:
                ball.position = CGPointMake(CGRectGetWidth(self.frame)/2 + margin, CGRectGetHeight(self.frame)/2 + margin);
                break;
            case 3:
                ball.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 -margin);
                break;
            case 4:
                ball.position = CGPointMake(CGRectGetWidth(self.frame)/2 - margin, CGRectGetHeight(self.frame)/2 + margin);
                break;
            case 5:
                ball.position = CGPointMake(CGRectGetWidth(self.frame)/2 + margin, CGRectGetHeight(self.frame)/2 + margin);
                break;
        }
        
        [self.layer addSublayer:ball];
        [temp addObject:ball];
    }
    
    self.balls = [temp copy];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self startAnimation];
}

- (void)startAnimation {
    for (int i = 0; i<3; i++) {
        CALayer *ball = [self.balls objectAtIndex:i];
        [self animateBall:ball atIndex:i withDelay:0];
    }
}

- (void)animateBall:(CALayer *)ball atIndex:(int)index withDelay:(CGFloat)delay {
    
    CGFloat maxDiam = 50;
    CGFloat duration = 2.0;
    CGFloat margin = 8.0;
    
    CAKeyframeAnimation *bounds1 = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    bounds1.duration = duration;
    bounds1.values = @[[NSValue valueWithCGSize:CGSizeMake(0, 0)],
                           [NSValue valueWithCGSize:CGSizeMake(maxDiam, maxDiam)]];
    bounds1.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    bounds1.beginTime = CACurrentMediaTime() + delay;
    
    
    CAKeyframeAnimation *radius = [CAKeyframeAnimation animationWithKeyPath:@"cornerRadius"];
    radius.duration = duration;
    radius.values = @[@(0), @(maxDiam/2)];
    radius.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    radius.beginTime = CACurrentMediaTime() + delay;
    
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position.duration = duration/2;
    CGPoint point;
    switch (index) {
        case 0:
            point = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 - margin);
            break;
        case 1:
            point = CGPointMake(CGRectGetWidth(self.frame)/2 - margin, CGRectGetHeight(self.frame)/2 + margin);
            break;
        case 2:
            point = CGPointMake(CGRectGetWidth(self.frame)/2 + margin, CGRectGetHeight(self.frame)/2 + margin);
            break;
            
        default:
            break;
    }
    
    position.values = @[[NSValue valueWithCGPoint:point],
                        [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)]];
    position.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    position.beginTime = CACurrentMediaTime() + duration/2 + delay;
    
    //Fade Out
    
    CAKeyframeAnimation *miniBounds = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    miniBounds.duration = duration/2;
    miniBounds.values = @[[NSValue valueWithCGSize:CGSizeMake(maxDiam, maxDiam)],
                           [NSValue valueWithCGSize:CGSizeMake(0, 0)]];
    miniBounds.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    miniBounds.beginTime = CACurrentMediaTime() + duration + delay;
    if (index == 2) {
        miniBounds.delegate = self;
    }
    
    CAKeyframeAnimation *radius2 = [CAKeyframeAnimation animationWithKeyPath:@"cornerRadius"];
    radius2.duration = duration/2;
    radius2.values = @[@(maxDiam/2), @(0)];
    radius2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    radius2.beginTime = CACurrentMediaTime() + duration + delay;
    
    CAKeyframeAnimation *position2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position2.duration = duration/2;
    position2.values = @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)],
                         [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)]];
    position2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    position2.beginTime = CACurrentMediaTime() + duration + delay;
    
    
    
    [ball addAnimation:bounds1 forKey:@"bounds1"];
    [ball addAnimation:radius forKey:@"radius"];
    [ball addAnimation:position forKey:@"position"];
    
    [ball addAnimation:miniBounds forKey:@"boundsFinal"];
    [ball addAnimation:radius2 forKey:@"radius2"];
    [ball addAnimation:position2 forKey:@"position2"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self startAnimation];
}









@end
