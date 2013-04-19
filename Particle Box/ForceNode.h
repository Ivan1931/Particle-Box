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
}
@property (nonatomic) Vec2 position;
@property (nonatomic) float strength;
@property (nonatomic) float suction;
-(id) initWithStrength:(float) pstrength andSuction:(float)psuction andPosition:(Vec2)xy;
-(void) influenceParticle:(Particle*)particle;
-(void) update;
+(float) Q_rsqrt:(float) number ;
@end
