//
//  Particle.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "Particle.h"

@implementation Particle
@synthesize postion;
@synthesize color;
@synthesize velocity;
-(id) initWith:(Vec2)pposition andColor:(Color)pcolor {
    self = [super init];
    if(self){
        postion = pposition;
        color = pcolor;
        velocity.x = 0;
        velocity.x = 0;
    }
    return self;
}
-(void) addAcceleration:(Vec2)acceleration {
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    postion.x += velocity.x;
    postion.y += velocity.y;
}
@end
