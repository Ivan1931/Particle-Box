//
//  Crazy.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/12.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Crazy.h"

#define ITERATIONS_BTW_BOXES 7

@implementation Crazy

-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims {
    self = [super initWithStrength:pstrength Suction:psuction Position:xy dimesions:pdims];
    if (self) {
        sinceLastBoxChange = 0;
        setRespawnBox(&(dimesions), &(spawnBoxUp), &(spawnBoxLow), RESPAWN_AREA_S, 200);
    }
    return self;
}

-(BOOL) influenceParticle:(Particle *)particle {
    if (![super influenceParticle:particle]) return NO;
    for (int i = 0; i < numNodes; i++) {
        [self crazyEffectWithNode:nodes[i] onParticle:particle];
    }
    return YES;
}

-(void) validateParticle:(Particle *)particle {
    [super validateParticle:particle];
    [particle resetVelocity];
    if ([particle outOfBounds:nothing :dimesions ]) {
        if ((sinceLastBoxChange & 0) > 0)
            [self respawnParticleInRandomBox:particle];
        else
            [particle respawnInBounds:nothing :dimesions];
    }
}

-(void) crazyEffectWithNode:(Node)node onParticle:(Particle *) particle {
    Vec2 d = computeXYDiff(node.position, particle.position);
    float theta = atan2f(d.y, d.x) - RADIAN;
    float r = theta + 3.f * sinf(4.f * theta) - 5.f * cosf(4.f * theta);
    [particle addAcceleration:VEC2(-r * cosf(theta) , -r * sinf(theta))];
}


-(void) update {
    if (sinceLastBoxChange < ITERATIONS_BTW_BOXES) {
        sinceLastBoxChange++;
    } else {
        sinceLastBoxChange = 0;
        setRespawnBox(&(dimesions), &(spawnBoxUp), &(spawnBoxLow), RESPAWN_AREA_S, 200);

    }
}
@end
