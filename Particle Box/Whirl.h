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
    Vec2 *centers;
    int currentCenter;
    int len;
}
-(id) initWithStrength:(float)pstrength andSuction:(float)psuction andPosition:(Vec2)xy;
-(void) moveCenter:(Vec2)center;
-(void) moveAround;
@end
