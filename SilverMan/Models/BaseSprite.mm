//
//  BaseSprite.cpp
//  SilverMan
//
//  Created by Willy on 24.03.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "BaseSprite.h"
#import <malloc/malloc.h>


using namespace std;
using namespace PacMan;

BaseSprite::BaseSprite(PCProgramWrapper * wrapper): program(wrapper)
{
    
};

GLuint BaseSprite::setupTexture(const char *fileName) {
    NSString *fileString = [NSString stringWithUTF8String:fileName];
    CGImageRef spriteImage = [UIImage imageNamed:fileString].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileString);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

void BaseSprite::setupVBOs() {
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, pair.vertices.size(), pair.vertices.array(), GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, pair.indexes.size(), pair.indexes.array(), GL_STATIC_DRAW);
}

#pragma mark Matrix Functions

void BaseSprite::setProjectionMatrix(PCProgramWrapper *program)
{
    Matrix3D    projectionMatrix;
    Matrix3DSetOrtho2DProjection(projectionMatrix, 0.0f,  program->size().width, 0.f, program->size().height);
    glUniformMatrix4fv(program->projection(), 1, 0, projectionMatrix);
}

void BaseSprite::setModelViewMatrix(PCProgramWrapper *program)
{
    Matrix3D    identity;
    Matrix3DSetIdentity(identity);
    glUniformMatrix4fv(program->modelView(), 1, 0, identity);
}

#pragma mark -


