pub(all) struct Vec4 {
  raw : @ffi.Vec4Raw
}

#inline
pub fn Vec4::new(x : Float, y : Float, z : Float, w : Float) -> Vec4 {
  { raw: @ffi.ext_vec4f_new(x, y, z, w) }
}

#inline
pub impl Add for Vec4 with add(self : Vec4, other : Vec4) -> Vec4 {
  { raw: @ffi.ext_vec4f_add(self.raw, other.raw) }
}

#inline
pub impl Eq for Vec4 with equal(self: Vec4, other: Vec4) -> Bool {
  @ffi.ext_vec4f_get_x(self.raw) == @ffi.ext_vec4f_get_x(other.raw) &&
  @ffi.ext_vec4f_get_y(self.raw) == @ffi.ext_vec4f_get_y(other.raw) &&
  @ffi.ext_vec4f_get_z(self.raw) == @ffi.ext_vec4f_get_z(other.raw) &&
  @ffi.ext_vec4f_get_w(self.raw) == @ffi.ext_vec4f_get_w(other.raw)
}

#inline 
pub fn x(self : Vec4) -> Float { @ffi.ext_vec4f_get_x(self.raw) }
#inline 
pub fn y(self : Vec4) -> Float { @ffi.ext_vec4f_get_y(self.raw) }
#inline 
pub fn z(self : Vec4) -> Float { @ffi.ext_vec4f_get_z(self.raw) }
#inline 
pub fn w(self : Vec4) -> Float { @ffi.ext_vec4f_get_w(self.raw) }

#inline
pub impl Show for Vec4 with output(_self: Vec4, logger: &Logger) -> Unit {
  logger.write_string("Vec4((self.x()), (self.y()), (self.z()), (self.w()))")
}

test "vec4f_add_logic" {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  let v2 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  assert_eq(v1 + v2, Vec4::new(2.0, 4.0, 6.0, 8.0))
}

