//
//  Whirl.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Whirl.h"

@implementation Whirl
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy {
    self = [super initWithStrength:pstrength andSuction:psuction andPosition:xy];
    if (self) {
        radius = pow (strength * 3,2);
        
    }
    return  self;
}
-(void) influenceParticle:(Particle *)particle {
    
    float disx = position.x - particle.postion.x;
    float disy = position.y - particle.postion.y;
    float squ_d = powf(fabsf(disx) + fabsf(disy),2);
    Vec2 a = {0.f,0.f};
    if (fabsf(disx) > (strength + 1) || fabsf(disy) > (strength + 1)) {
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
        
        if(disx > 0) {
            if (disy > 0)
            {
                if ((particle.velocity.y < 0) && (particle.velocity.x > 0)) a.x *= -1.f * suction;
            } else {
                if ((particle.velocity.x < 0) && (particle.velocity.y < 0)) a.y *= -1.f * suction;
            }
        } else {
            if (disy > 0) {
                if ((particle.velocity.y > 0) && (particle.velocity.x > 0)) a.y *= -1.f * suction;
            } else {
                if ((particle.velocity.x < 0) && (particle.velocity.y > 0)) a.x *= -1.f * suction;
            }
        }
        
        //Centrifugal force
        
        //a.x += powf(particle.velocity.x,2) / radius;
        //a.y += powf(particle.velocity.y, 2) / radius;
        
    }
    //if (a.x / a.y > 3)
    //NSLog(@"dx: %f dx: %f\n y/x: %f",disx,disy, a.x / a.y);
    [particle addAcceleration:a];
}

@end
