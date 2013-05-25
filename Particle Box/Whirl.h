//
//  Whirl.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"
#define MAGIC_RATIO 2
#define MAGIC_PUSH 500
#define RETURN_FREQUENCY 10
#define NEGATIVE_MAGIC_PUSH -500
#define MAGIC_INCREMENTOR 1.00001
#define ESCAPE_FREQUENCY 300
@interface Whirl : ForceNode
{
    @private
    float radius;
    float omega;
    float radius_s;
    float currentSuction; //Define the current suction. Value changes over time
    BOOL clockwise; //True if clockwise, false if anti-clockwise
    
}
-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy Clockwise:(BOOL) isClockwise screenDimesions:(Vec2)pdims;
@property (nonatomic) BOOL clockwise;
@end
