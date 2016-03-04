attribute vec3 vPosition;
attribute vec3 vNormal;

uniform mat4 view;
uniform mat4 projection;
uniform mat4 world;

varying vec3 fPosition;

void main() {
  fPosition = vPosition;
  gl_Position = projection * view * world * vec4(vPosition, 1);
}

