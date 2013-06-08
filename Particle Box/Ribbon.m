//
//  Ribbon.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/24.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Ribbon.h"

#define CATCH_DISTANCE 15.f
#define SPREAD_FACT 2.f
#define COLOR_DURATION 500000
@implementation Ribbon

int randomNumber;

-(void) influenceParticle:(Particle *)particle {
    randomNumber = arc4random();
    if (![super influenceParticle:particle]) return;
    [self ribbonEffect:particle withNode:nodes[particle.nodeID]];
}

-(void) validateParticle:(Particle *)particle {
    [super validateParticle:particle];
    if (randomNumber % ESCAPE_FREQUENCY == 0)
        [self teleport:particle to:nodes[randomNumber % numNodes]];
    if (randomNumber % COLOR_DURATION == 0)
        CHANGECOLOR(nodes[particle.nodeID].nodeColor, 50);
    if (![particle outOfBounds
          :VEC2(nodes[particle.nodeID].position.x - CATCH_DISTANCE, nodes[particle.nodeID].position.y - CATCH_DISTANCE)
          :VEC2(nodes[particle.nodeID].position.x + CATCH_DISTANCE, nodes[particle.nodeID].position.y + CATCH_DISTANCE)]) {
        [particle setNodeID:(particle.nodeID >= numNodes - 1) ? 0 : particle.nodeID + 1 ];
        [particle setColor:nodes[particle.nodeID].nodeColor];
    }
}

-(void) ribbonEffect:(Particle *)particle withNode:(Node) node {
    float distance = computeDistance(particle.position, node.position);
    Vec2 d = computeXYDiff(particle.position, node.position);
    
    Vec2 a = VEC2(strength * -sinf(d.x / distance * M_1_PI),
                strength * -sinf(d.y / distance * M_1_PI));
    a.x += SPREAD_FACT * (RANFLOAT - RANFLOAT);
    a.y += SPREAD_FACT * (RANFLOAT - RANFLOAT);
    [particle setVelocity:a];
}

-(void) teleport:(Particle *)particle to:(Node)node {
    [particle setPosition:VEC2(node.position.x + SPREAD_FACT * (RANFLOAT - RANFLOAT),
                              node.position.y + SPREAD_FACT * (RANFLOAT - RANFLOAT))];
    [particle bringToCurrent];
    [particle setNodeID:node.ID];
    [particle setColor:node.nodeColor];
}

@end
