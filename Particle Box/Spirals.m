//
//  Spirals.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/02.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Spirals.h"

#define EFFECT_DISTANCE 50.f

@implementation Spirals

-(void) influenceParticle:(Particle *)particle {
    [self spirallingEffect:particle :nodes[0].position];
}

-(void) spirallingEffect:(Particle *) particle :(Vec2)centralPoint {
    Vec2 d = computeXYDiff(particle.position, centralPoint);
    float distance = computeDistance(particle.position, centralPoint);
    if ( ![ particle outOfBounds:nothing :dimesions ]) {
        Vec2 a;
        if (fabsf (distance) > strength) {
            if (distance > EFFECT_DISTANCE || (d.x * particle.velocity.x <= 0 && d.y * particle.velocity.y <= 0)) {
                //Apply suction
                a.x = -d.x / distance + 0.2f;
                a.y = -d.y / distance + 0.2f;
            } else {
                //Apply acceleration
                a.x = d.x / distance;
                a.y = d.y / distance;
            }
            
            [particle addAcceleration:a];
        }
    } else {
        [particle setPosition:centralPoint];
        [particle bringToCurrent];
    }
}

@end
