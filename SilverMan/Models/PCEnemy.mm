//
//  PCEnemy.cpp
//  SilverMan
//
//  Created by Willy on 02.04.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCEnemy.h"

using namespace std;
using namespace PacMan;


PCEnemy::PCEnemy(PCProgramWrapper *wrapper, PCLocation location) : BaseMoveableSprite(wrapper)
{
    position = {location.xDirection, location.yDirection};
    int size = PCBoard::pacmanSize()/2;
    pair.vertices.AddItem(-size, -size, 0, 1);
    pair.vertices.AddItem(size, -size, 1, 1);
    pair.vertices.AddItem(-size, size, 0, 0);
    pair.vertices.AddItem(size, size, 1, 0);
    
    pair.indexes.AddItems(0, 1, 2, 3);
    
    setupVBOs();
    texture = setupTexture("ghost");
}

void PCEnemy::draw()
{
    setModelViewMatrix(program);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(program->texture(), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program->position(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), 0);
    glVertexAttribPointer(program->textureCoorinates(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), (GLvoid*) (sizeof(float) * 2));
    
    glDrawElements(GL_TRIANGLE_STRIP, pair.indexes.count(), GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

bool PCEnemy::isPacmanFind(PCLocation targetLocation, PCLocation lt, PCLocation lb, PCLocation vector, int direction)
{
    int lookup_size = 3 * PCBoard::elementSize();
    PCLocation rt;
    PCLocation rb;

    rb.xDirection = lb.xDirection + vector.xDirection * lookup_size;
    rb.yDirection = lb.yDirection + vector.yDirection * lookup_size;
    
    rt.xDirection = lt.xDirection + vector.xDirection * lookup_size;
    rt.yDirection = lt.yDirection + vector.yDirection * lookup_size;
    if (direction == PCDirectionRight)
        return PCF4RectContainsPoint( lt, lb, rt, rb, targetLocation);
    else if (direction == PCDirectionLeft)
        return PCF4RectContainsPoint( rt, rb, lt, lb, targetLocation);
    else if (direction == PCDirectionUp)
        return PCF4RectContainsPoint( rb, lb, rt, lt, targetLocation);
    else
       return PCF4RectContainsPoint( lb, rb, lt, rt, targetLocation);
}

std::vector<int> PCEnemy::directions(PCBoard *board, PCPacMan *target)
{
    std::vector<int> moves;
    
    
    PCLocation items[4] = { {1,0}, {-1,0}, {0,1}, {0,-1} };
    int dirs[4] = {PCDirectionRight, PCDirectionLeft, PCDirectionUp, PCDirectionDown };
    PCLocation pdirection = direction();
    
    for (int i=0; i< 4; i++) {
        PCLocation vect = items[i];

        
        PCLocation *list = nextCoordinate(vect, reverseDirection(vect), Vector2MulScalar(vect, playerSpeed()));
        PCLocation lb = list[0];
        PCLocation lt = list[1];
        if (board->canMoveTo( list  ))
        {
          ;
            BOOL isPac = isPacmanFind(target->location(), lt, lb, vect, dirs[i]);
            if (isPac)
            {
                moves.clear();
                moves.push_back(dirs[i]);
                return moves;
            }
            if (!Vector2isEqual(vect,Vector2MulScalar(pdirection,-1) )) moves.push_back(dirs[i]);
        }
    }
    return moves;
}

void PCEnemy::update(PCBoard *board, PCPacMan *target)
{
    std::vector<int> moves = directions(board, target);

    if (moves.size() == 0) return;
    
    int index = arc4random() % moves.size();
    desirableDirection = moves.at(index);
    
    if (!board->canMoveTo(nextFaceCoordinate()))
    {
        stop();
    }
    
    performDesirableAction(board);
    
    position = Vector2Sum(position, velocity);
}


bool PCEnemy::executeEat(PCFRect pacmanRect)
{
    return PCFRectcontainsPoint(pacmanRect, nextCenterFaceCoodinate());
 
}
