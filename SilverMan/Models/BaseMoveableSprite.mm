//
//  BaseMoveableSprite.cpp
//  SilverMan
//
//  Created by Willy on 30.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "BaseMoveableSprite.h"
#include "PCBoard.h"

using namespace std;
using namespace PacMan;

BaseMoveableSprite::BaseMoveableSprite(PCProgramWrapper * wrapper): BaseSprite(wrapper)
{
    rotationVector = {0,0,0};
    rotationDegree = 0;
    velocity = {0, 0};
    desirableDirection = PCDirectionNope;
};

void BaseMoveableSprite::setupDynamicVBOs() {
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, pair.vertices.size(), pair.vertices.array(), GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, pair.indexes.size(), pair.indexes.array(), GL_DYNAMIC_DRAW);
}

int BaseMoveableSprite::playerSpeed()
{
    return 2.0 * [UIScreen mainScreen].scale;
}

void BaseMoveableSprite::setModelViewMatrix(PCProgramWrapper *program)
{
    Matrix3D    rotationMatrix;
    Matrix3D    translationMatrix;
    Matrix3D    modelViewMatrix;
    
    Matrix3DSetIdentity(rotationMatrix);
    Matrix3DSetIdentity(translationMatrix);
    Matrix3DSetTranslation(translationMatrix, position.xDirection, position.yDirection, 0.f);
    Matrix3DSetRotationByDegrees(rotationMatrix, rotationDegree, rotationVector);
    
    Matrix3DMultiply(translationMatrix, rotationMatrix, modelViewMatrix);
    glUniformMatrix4fv(program->modelView(), 1, 0, modelViewMatrix);
}

#pragma mark Next Coordinate


PCLocation BaseMoveableSprite::nextCenterFaceCoodinate()
{
    PCLocation next = Vector2Sum(velocity, position);
    int size = PCBoard::pacmanSize()/2-4;
    PCLocation shift = Vector2Mul({size, size}, direction());

    return Vector2Sum(next, shift);
}
PCLocation* BaseMoveableSprite::nextCoordinate(PCLocation vector, PCLocation reverseVector, PCLocation velocityVector)
{
    
    PCLocation next = Vector2Sum(velocityVector, position);
    PCLocation downLock;
    PCLocation upLoc;
    int size = PCBoard::pacmanSize()/2-1;
    
    PCLocation shift = Vector2Mul({size, size}, vector);
    PCLocation reverseUp = Vector2Mul({size, size}, reverseVector);
    PCLocation reverseDown = Vector2Mul({size, size},Vector2MulScalar(reverseVector, -1) );
    
    downLock = Vector2Sum(next, shift);
    upLoc = Vector2Sum(next, shift);
    
    downLock = Vector2Sum(downLock, reverseDown);
    upLoc = Vector2Sum(upLoc, reverseUp);
    
    PCLocation list[] = {downLock, upLoc};
    return (PCLocation *)list;
}


PCLocation* BaseMoveableSprite::nextFaceCoordinate()
{
    return nextCoordinate(direction(), reverseDirection(), velocity);
}

PCLocation* BaseMoveableSprite::nextDesirableCoordinate()
{
    return nextCoordinate(desirableVector(), reverseDesirableVector(), desirableVelocityVector());
}

PCFRect BaseMoveableSprite::boundingBox()
{
    PCFRect rect;
    int size = PCBoard::pacmanSize();
    int shift = 4;
    rect.x = position.xDirection - size/2 + shift;
    rect.y = position.yDirection - size/2 + shift;
    rect.width = size - 2*shift;
    rect.height = size - 2*shift;
    
    return rect;
}

#pragma mark -
#pragma mark Vectors

PCLocation BaseMoveableSprite::desirableVelocityVector()
{
    PCLocation loc = desirableVector();
    return {loc.xDirection * playerSpeed(), loc.yDirection * playerSpeed() };
}

PCLocation BaseMoveableSprite::reverseDesirableVector()
{
    PCLocation loc = desirableVector();
    loc.xDirection = (loc.xDirection == 0 ? 1 : 0);
    loc.yDirection = (loc.yDirection == 0 ? 1 : 0);
    return loc;
}


PCLocation BaseMoveableSprite::desirableVector()
{
    PCLocation vel = {0,0};
    if (desirableDirection == PCDirectionRight) vel.xDirection = 1;
    if (desirableDirection == PCDirectionLeft) vel.xDirection = -1;
    if (desirableDirection == PCDirectionUp) vel.yDirection = 1;
    if (desirableDirection == PCDirectionDown) vel.yDirection = -1;
    return vel;
}

PCLocation BaseMoveableSprite::reverseDirection()
{
    return reverseDirection(direction());
}

PCLocation BaseMoveableSprite::reverseDirection(PCLocation loc)
{
    loc.xDirection = (loc.xDirection == 0 ? 1 : 0);
    loc.yDirection = (loc.yDirection == 0 ? 1 : 0);
    return loc;
}

PCLocation BaseMoveableSprite::direction()
{
    return {velocity.xDirection/playerSpeed(), velocity.yDirection/playerSpeed()};
}

PCLocation BaseMoveableSprite::location()
{
    return position;
}

#pragma mark -
#pragma mark Desirable Handlers

void BaseMoveableSprite::goDesirable()
{
    if (desirableDirection == PCDirectionRight) right();
    if (desirableDirection == PCDirectionLeft) left();
    if (desirableDirection == PCDirectionUp) up();
    if (desirableDirection == PCDirectionDown) down();
    
    desirableDirection = PCDirectionNope;
}

void BaseMoveableSprite::performDesirableAction(PCBoard *board)
{
    if (desirableDirection == PCDirectionNope) return;
    if (board->canMoveTo(nextDesirableCoordinate()) && desirableDirection != PCDirectionUp)
    {
        goDesirable();
    }
    
    if (board->canMoveTo(nextDesirableCoordinate()) && desirableDirection == PCDirectionUp)
    {
        goDesirable();
    }
}

#pragma mark -
#pragma mark Update Function


void BaseMoveableSprite::update(PCBoard *board)
{
    if (!board->canMoveTo(nextFaceCoordinate()))
    {
        stop();
    }
    
    performDesirableAction(board);
    position = Vector2Sum(position, velocity);
}

#pragma mark -
#pragma mark Controls

void BaseMoveableSprite::left()
{
    rotationVector = {0, 1, 0};
    rotationDegree = 180;
    velocity = {-1*playerSpeed(), 0};
}

void BaseMoveableSprite::right()
{
    rotationDegree = 0;
    rotationVector = {0, 1, 0};
    velocity = {playerSpeed(), 0};
}

void BaseMoveableSprite::down()
{
    rotationVector = {0, 0, 1};
    rotationDegree = -90;
    velocity = {0, -playerSpeed()};
}

void BaseMoveableSprite::up()
{
    rotationVector = {0, 0, 1};
    rotationDegree = 90;
    velocity = {0, playerSpeed()};
}

void BaseMoveableSprite::wantLeft()
{
    desirableDirection = PCDirectionLeft;
}

void BaseMoveableSprite::wantRight()
{
    desirableDirection = PCDirectionRight;
}

void BaseMoveableSprite::wantDown()
{
    desirableDirection = PCDirectionDown;
}

void BaseMoveableSprite::wantUp()
{
    desirableDirection = PCDirectionUp;
}
void BaseMoveableSprite::stop()
{
    velocity = {0, 0};
}

#pragma mark -
