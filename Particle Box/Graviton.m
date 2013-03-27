//
//  Graviton.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Graviton.h"

@implementation Graviton
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
    }
    return self;
}

-(void) influenceParticle:(Particle *)particle {
    float disx = position.x - particle.postion.x;
    float disy = position.y - particle.postion.y;
    Vec2 a;
    if (fabsf(disx) > strength + 1 || fabsf(disy) > strength + 1) {
        float puller = 1.0f / (powf(fabsf(disx) + fabsf(disy), 2)) * strength;
        a.x = disx * puller;
        a.y = disy * puller;
    }
    [particle addAcceleration:a];
}
@end
