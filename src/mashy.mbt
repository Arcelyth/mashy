#borrow(out, x, y, z, w)
extern "C" fn ext_new_vec4f32(out : Bytes, x : Float, y : Float, z : Float, w : Float) = "new_vec4f32"
#borrow(out, a, b)
extern "C" fn ext_vec4f_add(out : Bytes, a : Bytes, b : Bytes) = "vec4f_add"
#borrow(v)
extern "C" fn ext_vec4f_get_x(v : Bytes) -> Float = "vec4f_get_x"
#borrow(v)
extern "C" fn ext_vec4f_get_y(v : Bytes) -> Float = "vec4f_get_y"
#borrow(v)
extern "C" fn ext_vec4f_get_z(v : Bytes) -> Float = "vec4f_get_z"
#borrow(v)
extern "C" fn ext_vec4f_get_w(v : Bytes) -> Float = "vec4f_get_w"

pub(all) struct Vec4 {
  data : Bytes
} derive(Show)

pub fn Vec4::new(x : Float, y : Float, z : Float, w : Float) -> Vec4 {
  let memory = Bytes::make(16, 0)
  ext_new_vec4f32(memory, x, y, z, w)
  { data: memory }
}

pub impl Add for Vec4 with add(self: Vec4, other: Vec4) -> Vec4 {
  let result_memory = Bytes::make(16, 0)
  ext_vec4f_add(result_memory, self.data, other.data)
  { data: result_memory }
}

pub impl Eq for Vec4 with equal(self: Vec4, other: Vec4) -> Bool {
  ext_vec4f_get_x(self.data) == ext_vec4f_get_x(other.data) &&
  ext_vec4f_get_y(self.data) == ext_vec4f_get_y(other.data) &&
  ext_vec4f_get_z(self.data) == ext_vec4f_get_z(other.data) &&
  ext_vec4f_get_w(self.data) == ext_vec4f_get_w(other.data)
}


test (b : @bench.T) {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)
  let v2 = Vec4::new(5.0, 6.0, 7.0, 8.0)

  b.bench(name="vec4f32_add", fn() {
    b.keep(v1 + v2)
  })
}
