//
//  Particle.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Repository.h"
@interface Particle : NSObject {
    @private
    Vec2 position;
    Vec2 previousPosition;
    Vec2 velocity;
    Color color;
    
    Vec2 bresherLinePoints;
}
@property (nonatomic) Vec2 postion;
@property (nonatomic) Vec2 velocity;
@property (nonatomic) Color color;
-(id) initWith:(Vec2)pposition andColor:(Color)pcolor;
-(void) addAcceleration:(Vec2) acceleration;
-(void) move;
-(Vec2) getPrevious;
@end
