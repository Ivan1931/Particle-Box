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

@implementation BackShot

-(void) influenceParticle:(Particle *)particle {
    for (int i = 0 ; i < numNodes; i++) {
        if (!isEqualVectors(nodes[i].position, prevNodePos[i])) {
            [self fireToLast:particle :nodes[i]];
        }
    }
    
}

-(void) fireToLast:(Particle *)particle :(Node)node {
    int random = arc4random();
    int random0 = arc4random();
    if (random % 5 == 0){
    if (isEqualVectors(particle.position, node.position) && ![particle outOfBounds:nothing :dimesions]) {
        Vec2 a;
        Vec2 d = computeXYDiff(node.position, prevNodePos[node.ID]);
        if (d.x != 0 && d.y != 0) {
            float distance = computeDistance(node.position, prevNodePos[node.ID]);
            float ranX = (float) random / (float)RAND_MAX * ((random < HALF_MAX_RAND) ? 1.f : -1.f);
            float ranY = (float) random0 / (float)RAND_MAX * ((random0 < HALF_MAX_RAND) ? 1.f : -1.f);
            a.x = strength * -sinf(d.x / distance * M_1_PI) + ranX;
            a.y = strength * -sinf(d.y / distance * M_1_PI) + ranY;
            [particle setVelocity:a];
        }
    }
    }  else {
        if (arc4random() % 30 == 0) {
            [particle setPosition:node.position];
            [particle resetVelocity];
            [particle bringToCurrent];
        } 
    }
}

@end
