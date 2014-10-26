
//
//  RollingCube.m
//  Inclass_ironhackBCN
//
//  Created by Pol Quintana on 24/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "RollingCube.h"
#import <UIColor+FlatColors.h>

@interface RollingCube ()

@property (nonatomic, strong) CALayer *cube;
@property (nonatomic, strong) CALayer *shadow;
@property (nonatomic, strong) CALayer *mini;
@property (nonatomic) int count;

@end

@implementation RollingCube

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createCube];
        _count = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCube];
        _count = 0;
    }
    return self;
}

- (void)createCube {
    self.backgroundColor = [UIColor flatEmeraldColor];
    
    CGFloat side = 80;
    CGFloat ovalWidht = 90;
    CGFloat ovalHeigh = 6;
    self.cube = [CALayer layer];
    self.cube.bounds = CGRectMake(0, 0, side, side);
    self.cube.backgroundColor = [UIColor flatCarrotColor].CGColor;
    self.cube.position = CGPointMake(-40, CGRectGetHeight(self.frame)/2);
//    self.cube.borderWidth = 4.0;
//    self.cube.borderColor = [UIColor blackColor].CGColor;
    
    
    self.shadow = [CALayer layer];
    self.shadow.frame = self.cube.frame;
    self.shadow.shadowColor = [UIColor blackColor].CGColor;
    self.shadow.shadowOpacity = 0.7;
    self.shadow.shadowOffset = CGSizeMake(0.0, 10.0);
    self.shadow.shadowRadius = 3.0;
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(side/2-ovalWidht/2, side -12, ovalWidht, ovalHeigh)];

    self.shadow.shadowPath = ovalPath.CGPath;
    
    self.mini = [CALayer layer];
    self.mini.bounds = CGRectMake(0, 0, side/4, side/4);
    self.mini.position = CGPointMake(-30, CGRectGetHeight(self.frame)/2 - side/2-side/4/2);
    self.mini.backgroundColor = [UIColor flatAsbestosColor].CGColor;
    
    [self.layer addSublayer:self.mini];
    
    [self.layer addSublayer:self.shadow];
    
    [self.layer addSublayer:self.cube];
    
}

- (void)animateCube:(CALayer *)cubeLayer andShadow:(CALayer *)shadowLayer {
    CGFloat jumpAmount = sqrtf(cubeLayer.frame.size.height/2)*2.0;
    CGFloat side = 80;
    
    //Y Position and Rotation of the Cube
    
    CAKeyframeAnimation *jump = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    jump.duration = 2.0;
    jump.values = @[@(cubeLayer.position.y), @(cubeLayer.position.y - jumpAmount), @(cubeLayer.position.y), @(cubeLayer.position.y - jumpAmount), @(cubeLayer.position.y)];
    jump.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0]];
    
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.duration = 2.0;
    rotate.values = @[@0, @(M_PI_2/2), @(M_PI/2), @(3*M_PI_2/2), @(M_PI - 0.0000000000000001)];
    rotate.delegate = self;
    rotate.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0]];
    
    CAAnimationGroup *cube = [CAAnimationGroup animation];
    cube.duration = 2.0;
    cube.fillMode = kCAFillModeForwards;
    cube.removedOnCompletion = NO;
    cube.animations = @[jump, rotate];
    [self.cube addAnimation:cube forKey:@"group"];
    
    //Move shape and shadow
    
    CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    move.duration = 2.0;
    move.values = @[@(cubeLayer.position.x), @(cubeLayer.position.x + 40), @(cubeLayer.position.x + 80), @(cubeLayer.position.x + 120), @(cubeLayer.position.x + 160)];
    move.timingFunctions =  @[[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0]];
    
    CAAnimationGroup *movement = [CAAnimationGroup animation];
    movement.duration = 2.0;
    movement.fillMode = kCAFillModeForwards;
    movement.removedOnCompletion = NO;
    movement.animations = @[move];
    movement.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.cube addAnimation:movement forKey:@"movement"];
    [self.shadow addAnimation:movement forKey:@"movement"];
    //[self.mini addAnimation:movement forKey:@"movement"];
    
    //Move minisquare
    CAKeyframeAnimation *miniLayer = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    miniLayer.duration = 2.0;
    miniLayer.values = @[@(CGRectGetHeight(self.frame)/2 - side/2-side/4/2),
                         @(CGRectGetHeight(self.frame)/2 - side/2-side/4/2 - 140),
                         @(CGRectGetHeight(self.frame)/2 - side/2-side/4/2),
                         @(CGRectGetHeight(self.frame)/2 - side/2-side/4/2 - 140),
                         @(CGRectGetHeight(self.frame)/2 - side/2-side/4/2)];
    miniLayer.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [self.mini addAnimation:miniLayer forKey:@"mini"];
    
    CAKeyframeAnimation *moveMini = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    moveMini.duration = 2.0;
    moveMini.values = @[@(cubeLayer.position.x), @(cubeLayer.position.x + 60), @(cubeLayer.position.x + 80), @(cubeLayer.position.x + 140), @(cubeLayer.position.x + 160)];
    moveMini.timingFunctions =  @[[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0],[CAMediaTimingFunction functionWithControlPoints:0.0 :1.0 :0.0 :1.0]];
    
    [self.mini addAnimation:moveMini forKey:@"miniMove2"];
    
    CAKeyframeAnimation *rotate2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate2.duration = 2.0;
    rotate2.additive = YES;
    rotate2.values = @[@0, @(-M_PI_2), @(-M_PI), @(-M_PI_2*3), @(-M_PI*2)];
    rotate2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [self.mini addAnimation:rotate2 forKey:@"rotate mini"];
    
    CAKeyframeAnimation *miniBounds = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    miniBounds.duration = 2.0;
    miniBounds.values = @[[NSValue valueWithCGSize:CGSizeMake(self.mini.frame.size.width, self.mini.frame.size.height)],
                          [NSValue valueWithCGSize:CGSizeMake(self.mini.frame.size.width +20, self.mini.frame.size.height +20)],
                          [NSValue valueWithCGSize:CGSizeMake(self.mini.frame.size.width , self.mini.frame.size.height)],
                          [NSValue valueWithCGSize:CGSizeMake(self.mini.frame.size.width +20, self.mini.frame.size.height +20)],
                          [NSValue valueWithCGSize:CGSizeMake(self.mini.frame.size.width, self.mini.frame.size.height)]];
    miniBounds.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [self.mini addAnimation:miniBounds forKey:@"miniBounds"];
    

    //Alpha of the shadow
    
    CAKeyframeAnimation *shadow = [CAKeyframeAnimation animationWithKeyPath:@"shadowOpacity"];
    shadow.duration = 2.0;
    shadow.values = @[@(0.7), @(0.2), @(0.7), @(0.2), @(0.7)];
    shadow.delegate = self;
    shadow.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [shadow setValue:@"anim3" forKey:@"animation"];
    
    [self.shadow addAnimation:shadow forKey:@"shadow"];
    
    //MiniSquare
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self animateCube:self.cube andShadow:self.shadow];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.count < 2) {
        self.cube.position = CGPointMake(self.cube.position.x + 160, self.cube.position.y);
        [self animateCube:self.cube andShadow:self.shadow];
    }
    self.count ++;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
