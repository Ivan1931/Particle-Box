//
//  Repulsion.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/02.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Repulsion.h"

const float RING_RADIUS = 40.f;
const int NODE_COL_CHANGE_FREQ = 1000000;


@implementation Repulsion

-(void) influenceParticle:(Particle *)particle {
     if (![super influenceParticle:particle]) return;    
    for (int i = 0 ; i < numNodes; i++) {
        [self iterateColorNodeChangeValue:&nodes[i] :NODE_COL_CHANGE_FREQ];
        [self repulsionEffect:nodes[i] :particle];
    }
}

-(void) validateParticle:(Particle *)particle {
    if ([particle outOfBounds:nothing :dimesions ]) {
        [particle setPosition:VEC2(RAND_BETWEEN(0, (int)dimesions.x), RAND_BETWEEN(0, (int)dimesions.y))];
        [particle bringToCurrent];
        [particle resetVelocity];
    }
}

-(void) repulsionEffect:(Node) node :(Particle *) particle {
    float distance = computeDistance(particle.position, node.position);
    if (distance != 0) {
        Vec2 d = computeXYDiff(particle.position, node.position);
        Vec2 a;
        if (distance < RING_RADIUS) {
            a = VEC2(-d.x / distance * suction, -d.y / distance * suction);
            [particle setColor:node.nodeColor];
            [particle setVelocity:a];
        } else {
            a = VEC2(d.x / distance * suction, d.y / distance * suction);
            [particle addAcceleration:a];
        }
        
    }
}

@end
