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
@end
