//
//  Graviton.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@implementation ForceNode
#pragma mark - getters
@synthesize suction;
@synthesize position;
@synthesize strength;
#pragma mark - Default constructor
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy
{
    self = [super init];
    if (self) {
        strength = pstrength;
        suction = psuction;
        position = xy;
        NSLog(@"x: %f y: %f", xy.x,xy.y);
        nothing = (Vec2){0.f,0.f};

    }
    return self;
}
-(void) influenceParticle:(Particle *)particle {
    
}
-(void) update{
    
}
#pragma mark - Maths methods
+(float) Q_rsqrt:(float) number
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;
    
    x2 = number * 0.5F;
    y  = number;
    i  = * ( long * ) &y;                       // evil floating point bit level hacking
    i  = 0x5f3759df - ( i >> 1 );               // what the fuck?
    y  = * ( float * ) &i;
    y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
    //      y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed
    
    return y;
}
//Returns a two vector containing the x and y difference between two point
Vec2 computeXYDiff (Vec2 vec1, Vec2 vec2)
{
    return (Vec2){vec1.x - vec2.x, vec1.y - vec2.y};
}
//Evaluates to true with the following condition
//1. Both parameter vectors have equal values for x and y
bool isEqualVectors (Vec2 vec1, Vec2 vec2)
{
    return (vec1.x == vec2.x && vec1.y == vec2.y);
}
float computeDistance (Vec2 vec1, Vec2 vec2) {
    return sqrtf(powf(vec1.x - vec2.x,2.f) + powf(vec1.y - vec2.y, 2.f));
}
float computeGradient (Vec2 vecA, Vec2 vecB) {
    return (vecA.y - vecB.y)/(vecA.x - vecB.x);
}
@end
