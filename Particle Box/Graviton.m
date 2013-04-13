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
    
    float disx = position.x - particle.postion.x;
    float disy = position.y - particle.postion.y;
    float squ_d = powf(fabsf(disx) + fabsf(disy),2);
    Vec2 a = {0.f,0.f};
    if (squ_d >= strength + 1) {
        float puller = 1.f / squ_d * strength;
        a.x =   disx * puller;
        a.y =   disy * puller;
        if (a.y * particle.velocity.y <= 0)
        {
            a.y *= suction;
        }
        if (a.x * particle.velocity.x <= 0)
        {
            a.x *= suction;
        }
        a.x += powf(particle.velocity.x,2) / squ_d;
        a.y += powf(particle.velocity.y, 2) / squ_d;
    }
    //if (a.x / a.y > 3)
    //NSLog(@"dx: %f dx: %f\n y/x: %f",disx,disy, a.x / a.y);
    [particle addAcceleration:a];
}
@end
