//
//  Particle.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Particle : NSObject {
    @private
    Vec2 position;
    Vec2 previousPosition;
    Vec2 velocity;
    Color color;
    int nodeID;
    int dataIndex;
}
@property (nonatomic) Vec2 position;
@property (nonatomic) Vec2 velocity;
@property (nonatomic) Color color;
@property (nonatomic) Vec2 previousPosition;
@property (nonatomic) int nodeID;
@property (nonatomic) int dataIndex;
-(id) initWith:(Vec2)pposition Color:(Color)pcolor atDataIndex:(int)index;
-(void) addAcceleration:(Vec2) acceleration;  //Adds acceletation values to the velocity
-(void) moveWithVelocityMultiplyer:(float) velMult; //Adds current velocity values to position
-(void) resetVelocity;//Sets velocity to zero
-(void) bringToCurrent; //Sets the previous position to the current position
-(BOOL) outOfBounds:(Vec2)topLeftCorner :(Vec2)bottomRightCorner;
-(int) getDataIndex;
-(void) respawnInBounds:(Vec2)start :(Vec2) end;
@end
