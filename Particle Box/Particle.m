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
@synthesize position;
@synthesize color;
@synthesize velocity;
@synthesize previousPosition;
-(id) initWith:(Vec2)pposition andColor:(Color)pcolor {
    self = [super init];
    if(self){
        position = pposition;
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
    previousPosition = position;
    position.x += velocity.x;
    position.y += velocity.y;
}
-(void) bringToCurrent {
    previousPosition = position;
}
-(BOOL) inRectBounds:(Vec2)topLeftCorner :(Vec2)bottomRightCorner {
    if (position.x >= topLeftCorner.x && position.x <= bottomRightCorner.x)
        if (position.y >= topLeftCorner.y && position.y <= bottomRightCorner.y)
            return true;
    return false;
}
@end
