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
#define RAND_ZERO_ONE() (((float) arc4random () / (float)RAND_MAX) - 1.f)
#define RAND_BETWEEN(a,b)((a) + arc4random() % (((b) - (a)) + 1))
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

static const int NUM_FMODE_TYPES = 10;

static const int BACK_SHOT = 0;
static const int GRAVITON = 1;
static const int SUCTION = 2;
static const int REPULSION = 3;
static const int ROSE = 4;
static const int RIBBON = 5;
static const int SWIRL = 6;
static const int SPIRALS = 7;
static const int WHIRL = 8;
static const int CRAZY = 9;

static const int MODE_LIST[NUM_FMODE_TYPES] = {BACK_SHOT, GRAVITON, SUCTION, WHIRL, ROSE,
                                                RIBBON, SWIRL , SPIRALS, REPULSION, CRAZY};

static const uint MAX_PARTICLES = 2000;
static const uint MIN_PARTICLES = 200;
static const uint POINTS_PER_PARTICLE = 4;

static const GLfloat overLay[] = {
    1.0, 1.0,
    1.0, -1.0,
    -1.0, 1.0,
    
    1.0,-1.0,
    -1.0,1.0,
    -1.0,-1.0
};

static const float MAX_THICKNESS = 3.f;

static const float MAX_VELOCITY_MULTIPLYER = 3.f;
static const float MIN_VELOCITY_MULTIPLYER = 0.5f;

static const float DEFAULT_RED = 0.4f;
static const float DEFAULT_BLUE = 0.9f;
static const float DEFAULT_GREEN = 0.1f;
static const float DEFAULT_ALPHA = 1.f;
static const float DEFAULT_VEL_MULT = 1.f;
static const float DEFAULT_INITIAL_PARTICLES = 1500;
static const float DEFAULT_THICKNESS = 2.f;
#endif
