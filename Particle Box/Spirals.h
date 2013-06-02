//
//  Spirals.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/02.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@interface Spirals : ForceNode {
    @private
    float effectDistance;
    Vec2 effectLocation;
    Color col;
    int colorChangeCount;
}

-(id) initWithStrength:(float)pstrength Suction:(float)psuction Position:(Vec2)xy dimesions:(Vec2)pdims;

-(void) influenceParticle:(Particle *)particle;

-(void) addNode:(Vec2)position;
-(void) deleteNode:(Vec2)position;
-(void) moveNode:(Vec2)position;

@end
