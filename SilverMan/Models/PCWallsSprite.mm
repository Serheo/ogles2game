//
//  PCWallsSprite.cpp
//  SilverMan
//
//  Created by Willy on 25.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCWallsSprite.h"

using namespace std;
using namespace PacMan;

PCWallsSprite::PCWallsSprite(PCProgramWrapper *wrapper, PCBoard *board) : BaseSprite(wrapper)
{
    pair = board->createBlocks();
    texture = setupTexture("block.jpg");
    setupVBOs();
}

void PCWallsSprite::draw()
{
    setModelViewMatrix(program);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(program->texture(), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program->position(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), 0);
    glVertexAttribPointer(program->textureCoorinates(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), (GLvoid*) (sizeof(float) * 2));
    
    glDrawElements(GL_TRIANGLES, pair.indexes.count(), GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
}

