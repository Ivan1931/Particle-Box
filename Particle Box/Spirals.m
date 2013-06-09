//
//  Spirals.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/02.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Spirals.h"


#define RINGS 100.f
#define PULLIN 2.f
#define COLOR_CHNG_FREQ 600

@implementation Spirals

-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims {
    self = [super initWithStrength:pstrength Suction:pstrength Position:xy dimesions:pdims];
    if (self) {
        colorChangeCount = 0;
        effectDistance = strength * 5.f;
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
    a.x = -sinf(d.x / distance);
    a.y = -sinf(d.y / distance);
    if (distance < effectDistance) {
        [particle addAcceleration:a];
    } else {
        [particle setVelocity:a];
    }
}

-(void) calculateEffectLocation {
    float totalx = 0.f;
    float totaly = 0.f;
    for (int i = 0; i < numNodes; i++) {
        totalx += nodes[i].position.x;
        totaly += nodes[i].position.y;
    }
    effectLocation = VEC2(totalx / numNodes, totaly / numNodes);
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
