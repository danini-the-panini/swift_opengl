//
//  GLView.swift
//  ios-opengl
//
//  Created by Daniel Smith on 2015/01/29.
//  Copyright (c) 2015 Daniel Smith. All rights reserved.
//

import Foundation
import UIKit

class GLView: UIView {
    
    var eaglLayer: CAEAGLLayer!
    var context: EAGLContext!
    var colorRenderBuffer: GLuint = GLuint()
    
    var mesh: WavefrontMesh!
    var shader: Shader!
    
    var worldHandle: GLint = 0
    var projHandle: GLint = 0
    var viewHandle: GLint = 0
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayer()
        setupContext()
        setupRenderBuffer()
        setupFrameBuffer()
        
        onSurfaceCreated()
        onSurfaceChanged(GLint(self.frame.size.width), h: GLint(self.frame.size.height))
        onDrawFrame()
    }
    
    func setupLayer() {
        self.eaglLayer	= self.layer as! CAEAGLLayer
        self.eaglLayer.opaque = true
    }
    
    func setupContext() {
        let api: EAGLRenderingAPI = EAGLRenderingAPI.OpenGLES2
        self.context = EAGLContext(API: api)
        
        if (self.context == nil) {
            print("Failed to initialize OpenGLES 2.0 context!")
            exit(1)
        }
        
        if (!EAGLContext.setCurrentContext(self.context)) {
            print("Failed to set current OpenGL context!")
            exit(1)
        }
    }
    
    func setupRenderBuffer() {
        glGenRenderbuffers(1, &self.colorRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), self.colorRenderBuffer)
        self.context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable:self.eaglLayer)
    }
    
    func setupFrameBuffer() {
        var frameBuffer: GLuint = GLuint()
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER),
            self.colorRenderBuffer)
    }
    
    func onSurfaceCreated() {
        glClearColor(0, 0, 0, 1)
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        
        mesh = WavefrontMesh(fileName: "monkey")
        shader = Shader(vertexFileName: "vertex", fragFileName: "fragment")
        shader.use()
        
        let colorHandle = glGetUniformLocation(shader.handle, "vColor")
        glUniform4fv(colorHandle, GLsizei(1), UnsafePointer<GLfloat>([1.0, 0.0, 1.0, 1.0]))
        
        worldHandle = glGetUniformLocation(shader.handle, "world")
        projHandle = glGetUniformLocation(shader.handle, "projection")
        viewHandle = glGetUniformLocation(shader.handle, "view")
    }
    
    func onSurfaceChanged(w: Int32, h: Int32) {
        glViewport(0, 0, w, h)
        
        let ratio = GLfloat(w) / GLfloat(h)
    }
    
    func onDrawFrame() {
        glClear(UInt32(GL_COLOR_BUFFER_BIT) | UInt32(GL_DEPTH_BUFFER_BIT))
        
        mesh.draw(shader)
        
        self.context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }

}
