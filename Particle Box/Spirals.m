//
//  Spirals.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/02.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Spirals.h"


#define RINGS 60.f
#define PULLIN 2.f
#define COLOR_CHNG_FREQ 600

@implementation Spirals

-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims {
    self = [super initWithStrength:pstrength Suction:pstrength Position:xy dimesions:pdims];
    if (self) {
        colorChangeCount = 0;
        [self calculateEffectLocation];
        CHANGECOLOR(col, MIN_RGB_VAL);
    }
    return self;
}

-(BOOL) influenceParticle:(Particle *)particle {
    if (![super influenceParticle:particle]) return NO;
    [self spirallingEffect:particle :effectLocation];
    return YES;
}

-(void) validateParticle:(Particle *)particle {
    [super validateParticle:particle];
    [particle setColor:col];
}

-(void) update {
    if (colorChangeCount< COLOR_CHNG_FREQ) {
        colorChangeCount ++;
    } else {
        CHANGECOLOR(col, MIN_RGB_VAL);
        colorChangeCount = 0;
    }
}
-(void) spirallingEffect:(Particle *) particle :(Vec2)centralPoint {
    Vec2 d = computeXYDiff(particle.position, centralPoint);
    float distance = computeDistance(particle.position, centralPoint);
    Vec2 a;
    a.x = -sinf(d.x / distance) * numNodes;
    a.y = -sinf(d.y / distance) * numNodes;
    if (distance < effectDistance) {
        [particle addAcceleration:a];
    } else {
        [particle setVelocity:a];
    }
    if (particle.velocity.x == 0) {
        [particle addAcceleration:VEC2(RAND_ZERO_ONE(), 0.f)];
    } else if (particle.velocity.y == 0) {
        [particle addAcceleration:VEC2(0.f, RAND_ZERO_ONE())];
    } else if (particle.velocity.y / particle.velocity.x == 1.f || particle.velocity.y / particle.velocity.x == -1.f) {
        [particle addAcceleration:VEC2(RAND_ZERO_ONE(), RAND_ZERO_ONE())];
    }
}

-(void) calculateEffectLocation {
    if (numNodes > 0) {
        float totalx = 0.f;
        float totaly = 0.f;
        for (int i = 0; i < numNodes; i++) {
            totalx += nodes[i].position.x;
            totaly += nodes[i].position.y;
        }
        effectLocation = VEC2(totalx / numNodes, totaly / numNodes);
        if (numNodes == 1)
            effectDistance = RINGS;
        else {
            effectDistance = 0;
            for (int i = 0 ; i < numNodes; i++) {
                effectDistance += computeDistance(nodes[i].position, effectLocation);
            }
            effectDistance /= numNodes;
        }
    }
}

-(void) addNodeList:(NodeList)list {
    [super addNodeList:list];
    [self calculateEffectLocation];
}
-(void) addNode:(Vec2)position {
    [super addNode:position];
    [self calculateEffectLocation];
}

-(void) deleteNode:(Vec2)position {
    [super deleteNode:position];
    [self calculateEffectLocation];
}

-(void) moveNode:(Vec2)position {
    [super moveNode:position];
    [self calculateEffectLocation];
}

@end
