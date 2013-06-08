//
//  BackShot.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "BackShot.h"

const float DISTANCE_INCREASE = 0.5f;
const float RANDOM_GRAD_INC = M_PI_4;
const int HALF_MAX_RAND = RAND_MAX / 2;
const int NODE_COLOR_CHANGE_FREQ = 500;

@implementation BackShot

-(void) influenceParticle:(Particle *)particle {
    if (![super influenceParticle:particle]) return;
    for (int i = 0 ; i < numNodes; i++) {
        if (!isEqualVectors(nodes[i].position,nodes[i].prevPos)) {
            [self fireToLast:particle :nodes[i]];
            [self iterateColorNodeChangeValue:&nodes[i] :NODE_COLOR_CHANGE_FREQ];
        }
    }
    
}

-(void) fireToLast:(Particle *)particle :(Node)node {
    int random = arc4random();
    int random0 = arc4random();
    if (([particle outOfBounds:nothing :dimesions ] || random % 100 == 0 || firedParticles < 1000)) {
        [particle setPosition:node.position];
        [particle resetVelocity];
        [particle bringToCurrent];
        [particle setColor:node.nodeColor];
        firedParticles++;
    }
    if (isEqualVectors(particle.position, node.position) || isEqualVectors(particle.position, nothing)) {
        Vec2 a;
        Vec2 d = computeXYDiff(node.position, node.prevPos);
        float distance = computeDistance(node.position, node.prevPos);
        if (distance > 0) {
            //firedParticles++;
            float ranX = (float) random / (float)RAND_MAX * ((random < HALF_MAX_RAND) ? 1.f : -1.f);
            float ranY = (float) random0 / (float)RAND_MAX * ((random0 < HALF_MAX_RAND) ? 1.f : -1.f);
            a.x = strength * -sinf(d.x / distance * M_1_PI) + ranX;
            a.y = strength * -sinf(d.y / distance * M_1_PI) + ranY;
            [particle setVelocity:a];
        }
    }
}

-(void) moveNode:(Vec2)pposition {
    [super moveNode:pposition];
    firedParticles = 0;

}
@end
