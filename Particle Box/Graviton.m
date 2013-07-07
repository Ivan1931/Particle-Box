//
//  Graviton.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Graviton.h"

@implementation Graviton
-(BOOL) influenceParticle:(Particle *)particle {
    if (![super influenceParticle:particle]) return NO;
    int random = arc4random();
    for (int i = 0; i < numNodes; i++) {
        [self applyGravity:particle withNode:nodes[i]];
        if (random % CHANGE_DURATION == 0)
            CHANGECOLOR(nodes[i].nodeColor, 50);
    }
    if (random % NODE_CHANGE_TIME)
        [self changeParticleNode:particle];
    return YES;
    
}
-(void) applyGravity:(Particle*)particle withNode:(Node)node {
    float disx = node.position.x - particle.position.x;
    float disy = node.position.y - particle.position.y;
    float squ_d = powf(fabsf(disx) + fabsf(disy),2);
    Vec2 a = {0.f,0.f};
    if (squ_d >= strength + 1) {
        float puller = (1.f / squ_d) * strength;
        a.x =   disx * puller;
        a.y =   disy * puller;
        if (a.y * particle.velocity.y <= 0){
            a.y *= suction;
        }
        if (a.x * particle.velocity.x <= 0){
            a.x *= suction;
        }
    } else if (particle.nodeID == node.ID) {
        
        [particle setColor:node.nodeColor];
    }
    [particle addAcceleration:a];
}

-(BOOL) requiresFadeEffect {
    return YES;
}
@end
