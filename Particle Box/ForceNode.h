//
//  Graviton.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Particle.h"
@interface ForceNode : NSObject
{
    @protected
    float strength;
    //float suctionp1;
    float suction;
    Vec2 position;
    Vec2 nothing;
    Color changeColor;

}
@property (nonatomic) Vec2 position;
@property (nonatomic) float strength;
@property (nonatomic) float suction;
-(id) initWithStrength:(float) pstrength andSuction:(float)psuction andPosition:(Vec2)xy;
-(void) influenceParticle:(Particle*)particle;
-(void) update;
+(float) Q_rsqrt:(float) number;
Vec2 computeXYDiff (Vec2 vec1, Vec2 vec2);
float computeDistance (Vec2 vec1, Vec2 vec2);
float computeGradient (Vec2 vecA, Vec2 vecB);
bool isEqualVectors (Vec2 vec1, Vec2 vec2);
@end
