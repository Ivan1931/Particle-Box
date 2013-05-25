//
//  Graviton.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Graviton.h"

@implementation Graviton
-(void) influenceParticle:(Particle *)particle {
    if (rand() % CHANGE_DURATION == 0)
        CHANGECOLOR(changeColor, 50);
    for (int i = 0; i < numNodes; i++)
        [self applyGravity:particle withNode:nodes[i]];
    
}
-(void) applyGravity:(Particle*)particle withNode:(Node)node {
    float disx = node.position.x - particle.position.x;
    float disy = node.position.y - particle.position.y;
    float squ_d = powf(fabsf(disx) + fabsf(disy),2);
    Vec2 a = {0.f,0.f};
    if (squ_d >= strength + 1) {
        float puller = 1.f / squ_d * strength;
        a.x =   disx * puller;
        a.y =   disy * puller;
        if (a.y * particle.velocity.y <= 0){
            a.y *= suction;
        }
        if (a.x * particle.velocity.x <= 0){
            a.x *= suction;
        }
    } else {
        
        [particle setColor:changeColor];
    }
    [particle addAcceleration:a];
}
@end
