precision mediump float;

uniform vec4 vColor;

varying vec3 fPosition;

void main() {
  gl_FragColor = vec4(vColor.xyz * length(fPosition), 1);
}
