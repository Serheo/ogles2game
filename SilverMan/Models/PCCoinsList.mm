//
//  PCCoinsList.cpp
//  SilverMan
//
//  Created by Willy on 02.04.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCCoinsList.h"

using namespace std;
using namespace PacMan;

PCCoinsList::PCCoinsList(PCProgramWrapper *wrapper, PCBoard *board) : BaseMoveableSprite(wrapper)
{
    position = {80,80};
    vertsPosition = board->createCoins();
    int size = PCBoard::pacmanSize()/2;
    pair.vertices.AddItem(-size, -size, 0, 1);
    pair.vertices.AddItem(size, -size, 1, 1);
    pair.vertices.AddItem(-size, size, 0, 0);
    pair.vertices.AddItem(size, size, 1, 0);
    
    pair.indexes.AddItems(0, 1, 2, 3);
    
    setupVBOs();
    texture = setupTexture("coin");    
    rotationVector = {1, 1, 0};
    rotationDegree = 15;
}

void PCCoinsList::draw()
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(program->texture(), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program->position(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), 0);
    glVertexAttribPointer(program->textureCoorinates(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), (GLvoid*) (sizeof(float) * 2));
    
    
    for (int i=0; i< vertsPosition.vertices.count(); i++) {
        PCVertex vert = vertsPosition.vertices.GetItem(i);
        setModelViewMatrix(program, vert.Position[0], vert.Position[1]);
        glDrawElements(GL_TRIANGLE_STRIP, pair.indexes.count(), GL_UNSIGNED_SHORT, 0);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void PCCoinsList::update(PCBoard *board )
{
    rotationDegree += 1;
    if (rotationDegree > 360) rotationDegree = 0;
}

void PCCoinsList::setModelViewMatrix(PCProgramWrapper *program, float x, float y)
{
    
    Matrix3D    rotationMatrix;
    Matrix3D    translationMatrix;
    Matrix3D    modelViewMatrix;
    
    Matrix3DSetIdentity(rotationMatrix);
    Matrix3DSetIdentity(translationMatrix);
    Matrix3DSetTranslation(translationMatrix, x,y, 0.f);
    Matrix3DSetRotationByDegrees(rotationMatrix, rotationDegree, rotationVector);
    
    Matrix3DMultiply(translationMatrix, rotationMatrix, modelViewMatrix);
    glUniformMatrix4fv(program->modelView(), 1, 0, modelViewMatrix);
}


bool PCCoinsList::executeDinner(PCLocation player)
{
    float size = (float)PCBoard::pacmanSize();
    for (int i=0; i< vertsPosition.vertices.count(); i++) {
        PCVertex vert = vertsPosition.vertices.GetItem(i);
        PCFRect rect = {vert.Position[0]- size/2, vert.Position[1]-size/2, size, size};
        
        bool eaten = PCFRectcontainsPoint(rect, player);
        if (eaten)
        {
            vertsPosition.vertices.RemoveAt(i);
            return true;
        }
    }
    return false;
}

bool PCCoinsList::empty()
{
    return vertsPosition.vertices.count() == 0;
}
