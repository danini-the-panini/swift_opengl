//
//  OpenGLHelper.m
//  ios-opengl
//
//  Created by Daniel Smith on 2015/02/02.
//  Copyright (c) 2015 Daniel Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "OpenGLHelper.h"

void glVertexAttribPointerHelper(GLuint index,
                                 GLint size,
                                 GLenum type,
                                 GLboolean normalized,
                                 GLsizei stride,
                                 GLint offset)
{
    glVertexAttribPointer(index, size, type, normalized, stride, (GLvoid*) offset);
}

void glDrawElementsHelper(GLenum mode,
                          GLsizei count,
                          GLenum type,
                          GLint offset)
{
    glDrawElements(mode, count, type, (GLvoid*) offset);
}
