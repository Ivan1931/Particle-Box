//
//  Repository.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#ifndef Particle_Box_Repository_h
#define Particle_Box_Repository_h
#define BYTESPERPIXEL 4
#define BITSPERCOMPONENT 8
#define VEC2(x,y)((Vec2){(x),(y)})
#define RANFLOAT ((float)arc4random() / (float)RAND_MAX)
typedef struct {
    Byte r;
    Byte g;
    Byte b;
}Color;
typedef struct {
    float x;
    float y;
}Vec2;
typedef struct{
    Vec2 position;
    Vec2 prevPos;
    Color nodeColor;
    int ID;
}Node;
#define RADIAN 0.01745329251
#define CHANGE_DURATION 200000
#define MAX_NODES 5
#endif
