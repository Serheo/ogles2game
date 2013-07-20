//
//  PCPacMan.cpp
//  SilverMan
//
//  Created by Willy on 30.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCPacMan.h"
#import <GLKit/GLKit.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#include <malloc/malloc.h>
#include <iostream>

using namespace std;
using namespace PacMan;


PCPacMan::PCPacMan(PCProgramWrapper *wrapper, PCBoard *board) : BaseMoveableSprite(wrapper)
{
    position = board->createHero();
    int size = PCBoard::pacmanSize()/2;

    pair.vertices.AddItem(-size, -size, 0, 1);
    pair.vertices.AddItem(size, -size, 1, 1);
    pair.vertices.AddItem(-size, size, 0, 0);
    pair.vertices.AddItem(size, size, 1, 0);
    
    pair.indexes.AddItems(0, 1, 2, 3);
    
    setupVBOs();
    texture = setupTexture("pac_man1");
    nextTexure = setupTexture("pac_man2");
    currentTexture = texture;
}

void PCPacMan::update(PCBoard *board)
{
    BaseMoveableSprite::update(board);
 
    slideSwitch++;
    if (slideSwitch > 15)
    {
        slideSwitch = 0;
        currentTexture = (currentTexture == texture ? nextTexure : texture);
    }
}

void PCPacMan::draw()
{
    setModelViewMatrix(program);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, currentTexture);
    glUniform1i(program->texture(), 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program->position(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), 0);
    glVertexAttribPointer(program->textureCoorinates(), 2, GL_FLOAT, GL_FALSE, sizeof(PCVertex), (GLvoid*) (sizeof(float) * 2));
    
    glDrawElements(GL_TRIANGLE_STRIP, pair.indexes.count(), GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}


