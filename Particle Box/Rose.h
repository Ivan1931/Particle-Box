//
//  Rose.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/04/19.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@interface Rose : ForceNode
{
    @private
    Vec2 firePosition;
    Vec2 dims;
}
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy andFirePosition:(Vec2) fp andDimensions:(Vec2) dims;
-(void) influenceParticle:(Particle *)particle;
@property (nonatomic) Vec2 firePosition;
@end
