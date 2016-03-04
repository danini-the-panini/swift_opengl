//
//  OpenGLHelper.h
//  ios-opengl
//
//  Created by Daniel Smith on 2015/02/02.
//  Copyright (c) 2015 Daniel Smith. All rights reserved.
//

#ifndef ios_opengl_OpenGLHelper_h
#define ios_opengl_OpenGLHelper_h

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

void glVertexAttribPointerHelper(GLuint index,
                                 GLint size,
                                 GLenum type,
                                 GLboolean normalized,
                                 GLsizei stride,
                                 GLint offset);

void glDrawElementsHelper(GLenum mode,
                    GLsizei count,
                    GLenum type,
                    GLint offset);

#endif
