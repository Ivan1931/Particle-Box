//
//  Particle.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Particle.h"
#define VELOCITY_CAPX 10
#define VELOCITY_CAPY 20
#define VELOCITY_CAPXN -10
#define VELOCITY_CAPYN -20
@implementation Particle
@synthesize postion;
@synthesize color;
@synthesize velocity;
-(id) initWith:(Vec2)pposition andColor:(Color)pcolor {
    self = [super init];
    if(self){
        postion = pposition;
        previousPosition = pposition;
        color = pcolor;
        velocity.x = 0;
        velocity.x = 0;
    }
    return self;
}
-(void) addAcceleration:(Vec2)acceleration {
    if (velocity.x <= VELOCITY_CAPX){
        if (velocity.x >= VELOCITY_CAPXN)
            velocity.x += acceleration.x;
        else velocity.x = VELOCITY_CAPXN;
    }
    else velocity.x = VELOCITY_CAPX;
    if(velocity.y < VELOCITY_CAPY) {
        if (velocity.y > VELOCITY_CAPYN)
            velocity.y += acceleration.y;
        else velocity.y = VELOCITY_CAPYN;
    } else velocity.y = VELOCITY_CAPY;
    
}
-(void) resetVelocity {
    velocity.x = 0;
    velocity.y = 0;
}
-(void) move {
    previousPosition = postion;
    postion.x += velocity.x;
    postion.y += velocity.y;
}
-(Vec2) getPrevious {
    return previousPosition;
}
@end
