//
//  PCProgramWrapper.cpp
//  SilverMan
//
//  Created by Willy on 17.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#include "PCProgramWrapper.h"

using namespace std;
using namespace PacMan;

#pragma mark Shaders

// outsource it
const char* PCProgramWrapper::loadShaderSource(const char* file, const char *ext)
{
    NSString *fileExt = [NSString stringWithUTF8String:ext];
    NSString *fileName = [NSString stringWithUTF8String:file];
    
    NSString *shaderPathname = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
    return [[NSString stringWithContentsOfFile:shaderPathname encoding:NSUTF8StringEncoding error:nil] UTF8String];
}

bool PCProgramWrapper::compileShader(GLuint *shader, GLenum type, const char* file)
{
    GLint status;
    const GLchar *source;
    
    source = file;
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return false;
    }
    
    return true;
}
GLuint PCProgramWrapper::createVertexShader()
{
    GLuint vertShader;
    const char *vshader = loadShaderSource([@"Shader" UTF8String], [@"vsh" UTF8String]);
    if (!compileShader(&vertShader, GL_VERTEX_SHADER, vshader)) {
        return -1;
    }
    return vertShader;
}

GLuint PCProgramWrapper::createFragmentShader()
{
    GLuint fragShader;
    const char *fshader = loadShaderSource([@"Shader" UTF8String], [@"fsh" UTF8String]);
    if (!compileShader(&fragShader, GL_FRAGMENT_SHADER, fshader)) {
        return -1;
    }
    return fragShader;
}

#pragma mark -
#pragma mark Compile And Link

bool PCProgramWrapper::compileAndLink()
{
    _program = glCreateProgram();
    glAttachShader(_program, createVertexShader());
    glAttachShader(_program, createFragmentShader());
    glLinkProgram(_program);
    
    GLint linkSuccess;
    glGetProgramiv(_program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    
    glUseProgram(_program);
    glEnableVertexAttribArray(position());
    glEnableVertexAttribArray(textureCoorinates());
    
   
  
    return true;
}

#pragma mark -
#pragma mark Public Methods



GLuint PCProgramWrapper::modelView()
{
    return glGetUniformLocation(_program, "Modelview");
}

GLuint PCProgramWrapper::projection()
{
    return glGetUniformLocation(_program, "Projection");
}

GLuint PCProgramWrapper::program()
{
    return _program;
}

GLuint PCProgramWrapper::matrix()
{
    return glGetUniformLocation(_program, "Matrix");
}

GLuint PCProgramWrapper::position()
{
    return glGetAttribLocation(_program, "Position");
}

GLuint PCProgramWrapper::texture()
{
    return glGetUniformLocation(_program, "Texture");
}

GLuint PCProgramWrapper::textureCoorinates()
{
    return glGetAttribLocation(_program, "TexCoordIn");
}

PCFSize PCProgramWrapper::size()
{
    return _size;
}

#pragma mark -

