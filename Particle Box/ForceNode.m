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
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy
{
    self = [super init];
    if (self) {
        strength = pstrength;
        suction = psuction;
        position = xy;
        NSLog(@"x: %f y: %f", xy.x,xy.y);

    }
    return self;
}
-(void) influenceParticle:(Particle *)particle {
    
}
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
@end
