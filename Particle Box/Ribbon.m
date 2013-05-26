//
//  Ribbon.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/24.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Ribbon.h"

#define CATCH_DISTANCE 5.f

@implementation Ribbon

-(void) influenceParticle:(Particle *)particle {
    if (numNodes > 1){
        int count = 0;
        int nextNode;
        while (count < numNodes) {
            nextNode = (count != numNodes - 1) ? count + 1 : 0;
            [self ribbonEffect:particle fromNode:nodes[count] toNode:nodes[nextNode]];
            count++;
        }
    }
}

-(void) ribbonEffect:(Particle *)particle fromNode:(Node)node toNode:(Node)node0 {
    int random = arc4random();
    /*if (random % REDEF_RAND_BOX_FREQ == 0) {
        setRespawnBox(&dimesions, &spawnBoxUp, &spawnBoxLow, RESPAWN_AREA_S);
    }
    if ([particle outOfBounds:nothing :dimesions]) {
        [self respawnParticleInRandomBox:particle];
        [particle setVelocity:nothing];
    } else {*/
        
        Vec2 d;
        
        if (fabsf(computeDistance(particle.position, node.position)) < CATCH_DISTANCE){
            d = computeXYDiff(node0.position, node.position);
            [particle setColor:node.nodeColor];
        } else if (fabsf(computeDistance(particle.position, node0.position)) < CATCH_DISTANCE) {
            d = computeXYDiff(node.position, node0.position);
            [particle setColor:node.nodeColor];
        } else if (isEqualVectors(particle.velocity, nothing)){
            d = computeXYDiff(nodes[random % numNodes].position, particle.position );
            [particle setNodeID:random % numNodes];
        } else return;
        
        [particle setVelocity:VEC2(1/strength * d.x, 1/strength * d.y)];
    //}
}

@end
