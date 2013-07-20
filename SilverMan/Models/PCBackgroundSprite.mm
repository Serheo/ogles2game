//
//  PCBackgroundSprite.cpp
//  SilverMan
//
//  Created by Willy on 24.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCBackgroundSprite.h"
#import <GLKit/GLKit.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#include <malloc/malloc.h>
#include <iostream>

using namespace std;
using namespace PacMan;

#define TEX_COORD_MAX 8

PCBackgroundSprite::PCBackgroundSprite(PCProgramWrapper *wrapper) : BaseSprite(wrapper)
{
    pair.vertices.AddItem(0, 0, 0, TEX_COORD_MAX);
    pair.vertices.AddItem(wrapper->size().width, 0, TEX_COORD_MAX, TEX_COORD_MAX);
    pair.vertices.AddItem(0, wrapper->size().height, 0, 0);
    pair.vertices.AddItem(wrapper->size().width, wrapper->size().height, TEX_COORD_MAX, 0);

    pair.indexes.AddItems(0, 1, 2, 3);
 
    setupVBOs();
    texture = setupTexture("woodBackground.jpg");
   
}

void PCBackgroundSprite::draw()
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

