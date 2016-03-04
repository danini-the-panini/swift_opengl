//
//  Shader.swift
//  ios-opengl
//
//  Created by Daniel Smith on 2015/01/30.
//  Copyright (c) 2015 Daniel Smith. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class Shader {
    var handle: GLuint = 0
    
    init(vertexFileName : String, fragFileName : String) {
        let vertexShader = loadShader(GLenum(GL_VERTEX_SHADER), source: readFile(vertexFileName))
        let fragShader = loadShader(GLenum(GL_FRAGMENT_SHADER), source: readFile(vertexFileName))
        
        handle = glCreateProgram()
        glAttachShader(handle, vertexShader)
        glAttachShader(handle, fragShader)
        glLinkProgram(handle)
    }
    
    func readFile(fileName : String) -> String {
        var err : NSError?
        return try! String(contentsOfFile: NSBundle.mainBundle().pathForResource(fileName, ofType: "glsl")!, encoding: NSUTF8StringEncoding)
    }
    
    func loadShader(type : GLenum, source: String) -> GLuint {
        let shader = glCreateShader(type)
        
        var sourceCString = (source as NSString).UTF8String
        glShaderSource(shader, GLsizei(1), &sourceCString, nil)
        glCompileShader(shader)
        
        return shader
    }
    
    func use() {
        glUseProgram(handle)
    }
}