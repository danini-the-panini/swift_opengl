//
//  WavefrontMesh.swift
//  ios-opengl
//
//  Created by Daniel Smith on 2015/01/30.
//  Copyright (c) 2015 Daniel Smith. All rights reserved.
//

import Foundation
import OpenGLES

class WavefrontMesh {
    struct C {
        static let BYTES_PER_FLOAT = sizeof(GLfloat)
        static let BYTES_PER_INT = sizeof(GLint)
        static let FLOATS_PER_VECTOR = 3
        static let VECTORS_PER_ELEMENT = 2
        static let FLOATS_PER_ELEMENT = FLOATS_PER_VECTOR * VECTORS_PER_ELEMENT
        static let BYTES_PER_VECTOR = BYTES_PER_FLOAT * FLOATS_PER_VECTOR
        static let BYTES_PER_ELEMENT = BYTES_PER_FLOAT * FLOATS_PER_ELEMENT
    }

    var vertices: [GLfloat] = []
    var indices: [GLint] = []
    var vertexHandle: GLuint = 0
    var indexHandle: GLuint = 0
    
    var points: [GLfloat] = []
    var norms: [GLfloat] = []
    var ninds: [Int32] = []
    var inds: [Int32] = []
    
    init(fileName : NSString) {
        load(fileName)
        loadData()
        loadOpenGL()
    }
    
    func load(fileName : NSString) {
        if let reader = StreamReader(path: NSBundle.mainBundle().pathForResource(fileName as String, ofType:"obj")!) {
            for line in reader {
                let comps = line.componentsSeparatedByString(" ")
                switch (comps[0]) {
                case "v":
                    for i in 1...3 {
                        points.append((comps[i] as NSString).floatValue)
                    }
                    break
                case "vn":
                    for i in 1...3 {
                        norms.append((comps[i] as NSString).floatValue)
                    }

                    break
                case "f":
                    for i in 1...3 {
                        let ncomps = comps[i].componentsSeparatedByString("/")
                        inds.append((ncomps[0] as NSString).intValue - 1)
                        ninds.append((ncomps[ncomps.count-1] as NSString).intValue - 1)
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    func loadData() {
        var normalArray = [CFloat](count: points.count, repeatedValue: 0.0)
        var visited = [Bool](count: points.count, repeatedValue: false)
        
        for i in 0..<inds.count {
            let vi = Int(inds[i])
            if (!visited[vi]) {
                visited[vi] = true
                let ni = Int(ninds[i])
                
                for j in 0...2 {
                    normalArray[vi * 3 + j] = norms[ni * 3 + j]
                }
            }
        }
        
        vertices = []
        for var i = 0; i < points.count; i += 3 {
            for j in 0..<3 {
                vertices.append(points[i + j])
            }
            for j in 0..<3 {
                vertices.append(normalArray[i + j])
            }
        }
        
        indices = []
        for i in inds {
            indices.append(i)
        }
    }
    
    func loadOpenGL() {
        glGenBuffers(1, &vertexHandle)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexHandle)
        
        let unsafeVertices = UnsafePointer<Void>(vertices)
        glBufferData(GLenum(GL_ARRAY_BUFFER), C.BYTES_PER_FLOAT * vertices.count, unsafeVertices, GLenum(GL_STATIC_DRAW))
        
        glGenBuffers(1, &indexHandle)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexHandle)
        
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), C.BYTES_PER_INT * indices.count, indices, GLenum(GL_STATIC_DRAW))
    }
    
    func draw(shader: Shader) {
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexHandle)
        
        let vPosition = ("vPosition" as NSString).UTF8String
        let positionAttribute : GLuint = GLuint(glGetAttribLocation(shader.handle, vPosition))
        glVertexAttribPointerHelper(positionAttribute, GLint(C.FLOATS_PER_VECTOR), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(C.BYTES_PER_ELEMENT), 0)
        glEnableVertexAttribArray(positionAttribute)
        
        let vNormal = ("vNormal" as NSString).UTF8String
        let normalAttribute = GLuint(glGetAttribLocation(shader.handle, vNormal))
        glVertexAttribPointerHelper(normalAttribute, GLint(C.FLOATS_PER_VECTOR), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(C.BYTES_PER_ELEMENT), GLint(C.BYTES_PER_VECTOR))
        glEnableVertexAttribArray(normalAttribute)
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexHandle)
        glDrawElementsHelper(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), 0)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
}