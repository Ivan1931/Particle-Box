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
        radius = pow (strength,2);
        len = 0;
        //currentCenter = 0;
        [self moveCenter:position];
    }
    return  self;
}
-(void) influenceParticle:(Particle *)particle {
    
    float disx = centers[currentCenter].x - particle.postion.x;
    float disy = centers[currentCenter].y - particle.postion.y;
    float squ_d = powf(fabsf(disx) + fabsf(disy),2);
    Vec2 a = {0.f,0.f};
    if (fabsf(disx) > (strength + 1) || fabsf(disy) > (strength + 1)) {
        float puller = 1.f / squ_d * strength;
        a.x =   disx * puller;
        a.y =   disy * puller;
        if (a.y * particle.velocity.y < 0)
        {
            a.y *= suction;
        }
        if (a.x * particle.velocity.x < 0)
        {
            a.x *= suction;
        }
        /*
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
        */
        
    }
    //if (a.x / a.y > 3)
    //NSLog(@"dx: %f dx: %f\n y/x: %f",disx,disy, a.x / a.y);
    [particle addAcceleration:a];
}
-(void) moveCenter:(Vec2)center {
    free (centers);
    currentCenter = 0;
    [self circle:(int)position.x withY:(int)position.y withRad:(int)radius];
    
}
-(void) moveAround {
    if (currentCenter > len)
        currentCenter = 0;
    else currentCenter++;
}
// 'cx' and 'cy' denote the offset of the circle center from the origin.
-(void) circle:(int) cx withY:(int)cy withRad:(int) rad
{
    int error = -rad;
    int x = rad;
    int y = 0;
    
    // The following while loop may be altered to 'while (x > y)' for a
    // performance benefit, as long as a call to 'plot4points' follows
    // the body of the loop. This allows for the elimination of the
    // '(x != y)' test in 'plot8points', providing a further benefit.
    //
    // For the sake of clarity, this is not shown here.
    while (x >= y)
    {
        [self plot8points:cx withCY:cy withX:x withY:y];
        
        error += y;
        ++y;
        error += y;
        
        // The following test may be implemented in assembly language in
        // most machines by testing the carry flag after adding 'y' to
        // the value of 'error' in the previous step, since 'error'
        // nominally has a negative value.
        if (error >= 0)
        {
            error -= x;
            --x;
            error -= x;
        }
    }
}

-(void) plot8points:(int) cx withCY:(int) cy withX:(int)x withY: (int) y
{
    //plot4points(cx, cy, x, y);
    //if (x != y) plot4points(cx, cy, y, x);
    [self plot4points:cx withCY:cy andX:x andY:y];
    if (x != y) [self plot4points:cx withCY:cy andX:y andY:x];
}

// The '(x != 0 && y != 0)' test in the last line of this function
// may be omitted for a performance benefit if the radius of the
// circle is known to be non-zero.
-(void) plot4points:(int) cx withCY:(int) cy andX:(int)x andY:(int)y
{
    len+=4;
    centers = realloc(centers, sizeof(Vec2) * len);
    //setPixel(cx + x, cy + y);

    centers[len - 4] = (Vec2){cx + x, cy + y};
    if (x != 0) centers[len - 3] = (Vec2) {cx - x, cy + y};
    if (y != 0) centers[len -2] = (Vec2) {cx + x, cy - y};
    if (x != 0 && y != 0) centers[len - 1] = (Vec2){cx - x, cy - y};
}

@end
