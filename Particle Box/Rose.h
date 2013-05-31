//
//  Rose.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/04/19.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"
#define RAND_TABLE_SIZE 255
#define PARTICLE_COLOR_TIME 200
#define COLOR_CHANGE_DISTANCE 5.f
@interface Rose : ForceNode
{
    @private
    int randomValue;
}

-(id) initWithStrength:(float) pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims;

-(void) influenceParticle:(Particle *)particle;

@property (nonatomic) Vec2 firePosition;


@end
