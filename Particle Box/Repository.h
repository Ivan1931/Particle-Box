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

typedef struct {
    int len;
    Vec2* vals;
}Vec2List;

typedef struct {
    Node* nodes;
    int len;
} NodeList;
#define RADIAN 0.01745329251
#define CHANGE_DURATION 200000
#define MAX_NODES 5
#define MIN_RGB_VAL 50

static const int NUM_FMODE_TYPES = 9;

static const int BACK_SHOT = 0;
static const int GRAVITON = 1;
static const int SUCTION = 2;
static const int WHIRL = 3;
static const int ROSE = 4;
static const int RIBBON = 5;
static const int SWIRL = 6;
static const int SPIRALS = 7;
static const int REPULSION = 8;

static const int MODE_LIST[NUM_FMODE_TYPES] = {BACK_SHOT, GRAVITON, SUCTION, WHIRL, ROSE,
                                                RIBBON, SWIRL , SPIRALS, REPULSION};

static const uint MAX_PARTICLES = 4000;
static const uint POINTS_PER_PARTICLE = 4;
#endif
