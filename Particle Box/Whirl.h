//
//  Whirl.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@interface Whirl : ForceNode
{
    @private
    float radius;
    float omega;
    float radius_s;
}
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy;
@end
