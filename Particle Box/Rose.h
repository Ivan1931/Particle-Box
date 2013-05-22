//
//  Rose.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/04/19.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"
#import "Calculator.h"
#define RAND_TABLE_SIZE 255
@interface Rose : ForceNode
{
    @private
    Vec2 firePosition;
    Vec2 dims;
    float* randomValueTable;
}
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy andFirePosition:(Vec2) fp andDimensions:(Vec2) pdims;
-(void) influenceParticle:(Particle *)particle;
@property (nonatomic) Vec2 firePosition;
@end
