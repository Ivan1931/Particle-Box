//
//  Swirl.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/02.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Swirl.h"

@implementation Swirl

#define RING_RADIUS 50.f

-(void) influenceParticle:(Particle *)particle {
    [self iterateNodeChange:particle :NODE_CHANGE_TIME];
    if ([particle outOfBounds:nothing :dimesions ]) {
        [particle setPosition:VEC2(RAND_BETWEEN(0, (int)dimesions.x), RAND_BETWEEN(0, (int)dimesions.y))];
        [particle bringToCurrent];
        [particle resetVelocity];
    }
    for (int i = 0; i < numNodes; i++) {
        [self swirlEffect:particle :nodes[i]];
    }
    
}

-(void) swirlEffect:(Particle *)paricle :(Node) node {
        float distance = computeDistance(paricle.position, node.position);
        if (distance != 0) {
            Vec2 d = computeXYDiff(paricle.position, node.position);
            Vec2 a = distance < RING_RADIUS ? VEC2(d.x / distance * 3.f, d.y / distance * 3.f) : VEC2(-d.x / distance, -d.y / distance);
            [paricle addAcceleration:a];
        }
}

@end

