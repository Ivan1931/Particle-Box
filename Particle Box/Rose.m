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
const int NUM_ITERATIONS_COLOR = 600;
const int NUM_ITERATIONS_RESPBOX = 5;

@implementation Rose

-(id) initWithStrength:(float) pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims {
    self = [super initWithStrength:pstrength Suction:psuction Position:xy dimesions:pdims];
    if (self) {
        particleEscapeCount = 0;
        randomBoxChangeTime = 0;
    }
    return self;
}

-(BOOL) influenceParticle:(Particle *)particle {
    if (![super influenceParticle:particle]) return NO;
    int count = 0;
    int nodeIndex = particle.nodeID;
    while (count < MAX_INTERACTION) {
        nodeIndex = (particle.nodeID + count >= numNodes) ? -1 + count : particle.nodeID + count;
        [self roseAffectWithNode:particle node:nodes[nodeIndex] gradient:0.f];
        count++;
    }
    return YES;
    
}

-(void) update {
    
    if (randomBoxChangeTime >= NUM_ITERATIONS_RESPBOX) {
        setRespawnBox(&dimesions, &spawnBoxUp, &spawnBoxLow, RESPAWN_AREA_S, 500);
        randomBoxChangeTime = 0;
    } else {
        randomBoxChangeTime++;
    }
    if (colorChngGap < NUM_ITERATIONS_COLOR) {
        CHANGECOLOR(nodes[arc4random() % numNodes].nodeColor, MIN_RGB_VAL);
        colorChngGap = 0;
    } else {
        colorChngGap++;
    }
}
-(void) roseAffectWithNode:(Particle*) particle node:(Node)pnode gradient:(float)grad {
    //r = (cos(x + a))^2
    if( ![particle outOfBounds:nothing :dimesions]  && particleEscapeCount < ESCAPE_FREQUENCY ) {
        
        particleEscapeCount++;
        
        Vec2 dxy = computeXYDiff(particle.position, pnode.position);
        if (dxy.x != 0 && dxy.y != 0) {
            float theta = (numNodes == 1) ? 2.f * atan2f(dxy.y, dxy.x) : atan2(dxy.y, dxy.x);
            float r = -powf(cosf(theta),2.f);
            //float r = -sinf(theta);
            float x = strength * r * cos(theta);
            float y = strength * r * sinf(theta);
            
            if (y * particle.velocity.y <= 0.f)
                y *= suction;
    
            if (x * particle.velocity.x <= 0.f)
                x *= suction;
        
            if (abs(dxy.x) < COLOR_CHANGE_DISTANCE &&
                abs(dxy.y) < COLOR_CHANGE_DISTANCE && particle.nodeID == pnode.ID)
            [self particleColorToNode:particle];
            [particle addAcceleration:(Vec2){x, y}];
        }
        
    } else {
        //if (particleEscapeCount < ESCAPE_FREQUENCY)
        particleEscapeCount = 0;
        if ((randomBoxChangeTime & 0) == 0)
            [self respawnParticleInRandomBox:particle];
        else
            [particle respawnInBounds:nothing :dimesions ];
        [particle bringToCurrent];
        [particle resetVelocity];
    }
    
    
}

@end
