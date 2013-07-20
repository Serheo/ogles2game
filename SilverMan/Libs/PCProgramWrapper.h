//
//  PCProgramWrapper.h
//  SilverMan
//
//  Created by Willy on 17.02.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#ifndef __SilverMan__PCProgramWrapper__
#define __SilverMan__PCProgramWrapper__

#include <iostream>

namespace PacMan
{
    class PCProgramWrapper
    {
        GLuint _program;
        PCFSize _size;
        
    public:
        GLuint program();
        
        // Attributes
        GLuint matrix();
        GLuint modelView();
        GLuint projection();
        GLuint position();
        GLuint texture();
        GLuint textureCoorinates();
        PCFSize size();
        
        // Constructors
        PCProgramWrapper(): _size({260.0, 480.0}) { compileAndLink(); }
        PCProgramWrapper(PCFSize size): _size(size) { compileAndLink(); }
    private:
        const char* loadShaderSource(const char* file, const char *ext);
        bool compileShader(GLuint *shader, GLenum type, const char* file);
        bool compileAndLink();
        
        GLuint createVertexShader();
        GLuint createFragmentShader();
    };
}

#endif /* defined(__SilverMan__PCProgramWrapper__) */
