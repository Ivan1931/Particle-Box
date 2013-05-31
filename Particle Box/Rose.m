//
//  Rose.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/04/19.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Rose.h"

#define MAX_INTERACTION 3
#define LOWEST_VELOCITY 0.2f


@implementation Rose
@synthesize firePosition;

-(id) initWithStrength:(float) pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims {
    self = [super initWithStrength:pstrength Suction:psuction Position:xy dimesions:pdims];
    if (self) {
        randomValue = arc4random();
    }
    return self;
}

-(void) influenceParticle:(Particle *)particle {
    randomValue = arc4random();
    int count = 0;
    int nodeIndex = particle.nodeID;
    while (count < MAX_INTERACTION) {
        nodeIndex = (particle.nodeID + count >= numNodes) ? -1 + count : particle.nodeID + count;
        [self shootBetweenNodes:particle node:nodes[nodeIndex] gradient:0.f];
        if (randomValue % CHANGE_DURATION == 0) {
                CHANGECOLOR(nodes[nodeIndex].nodeColor, 50);
        }
        count++;
    }
    if (randomValue % NODE_CHANGE_TIME == 0) {
        [self changeParticleNode:particle];
        setRespawnBox(&dimesions, &spawnBoxUp, &spawnBoxLow, RESPAWN_AREA_S, 500);
    }
}

-(void) shootBetweenNodes:(Particle*) particle node:(Node)pnode gradient:(float)grad {
    //r = (cos(x + a))^2
    if( ![particle outOfBounds:nothing :dimesions]  && randomValue % ESCAPE_FREQUENCY != 0 ) {
        
        Vec2 dxy = computeXYDiff(particle.position, pnode.position);
        
        float theta = atan2f(dxy.y, dxy.x);
        float r = -powf(cosf(theta),2.f);
        float x = strength * r * cos(theta);
        float y = strength * r * sinf(theta);
        
        if (y * particle.velocity.y <= 0.f)
            y *= suction;
    
        if (x * particle.velocity.x <= 0.f)
            x *= suction;
        
        if (abs(dxy.x) < COLOR_CHANGE_DISTANCE &&
            abs(dxy.y) < COLOR_CHANGE_DISTANCE && particle.nodeID == pnode.ID)
            [self particleColorToNode:particle];
        [particle addAcceleration:(Vec2){x,y}];
        
    } else {
        [self respawnParticleInRandomBox:particle];
        [particle bringToCurrent];
        [particle resetVelocity];
    }
    
    
}

@end
