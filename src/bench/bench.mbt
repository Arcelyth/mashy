///|
struct VecS4 {
  x :Float 
  y :Float 
  z :Float 
  w :Float
} derive(Eq, Debug)

///|
fn VecS4::VecS4(x : Float, y : Float, z : Float, w :Float) -> VecS4 {
  { x, y, z, w}
}

///|
impl Add for VecS4 with add(self, other) {
  VecS4::VecS4(self.x + other.x, self.y + other.y, self.z + other.z, self.w + other.w)
}

test (b : @bench.T) {
  let v1 = @f32.Vec4::new(1.0, 2.0, 3.0, 4.0)
  let v2 = @f32.Vec4::new(5.0, 6.0, 7.0, 8.0)

  b.bench(name="vec4f32_add", fn() {
    b.keep(v1 + v2)
  })

  let f1 : FixedArray[Float] = [1.0, 2.0, 3.0, 4.0]
  let f2 : FixedArray[Float] = [5.0, 6.0, 7.0, 8.0]
  b.bench(name="vec4_pure_fixed_array_inplace", fn() {
    f1[0] = f1[0] + f2[0]
    f1[1] = f1[1] + f2[1]
    f1[2] = f1[2] + f2[2]
    f1[3] = f1[3] + f2[3]
    b.keep(f1)
  })

  let vs1 = VecS4::VecS4(1.0, 2.0, 3.0, 4.0)
  let vs2 = VecS4::VecS4(5.0, 6.0, 7.0, 8.0)
  b.bench(name="vec4_struct", fn() {
    b.keep(vs1 + vs2)
  })
}

test "multi_scene_bench" (b : @bench.T) {
  let count = 1000

  let bulk_bytes_size = count * 16 
  let out_pool = Bytes::make(bulk_bytes_size, 0)
  let a_pool = Bytes::make(bulk_bytes_size, 0)
  let b_pool = Bytes::make(bulk_bytes_size, 0)
  
  b.bench(name="bulk_scene1_c_simd", fn() {
    @ffi.ext_vec4f_add_bulk(out_pool, a_pool, b_pool, count)
    b.keep(out_pool)
  })

  let total_elements = count * 4
  let f_out = FixedArray::make(total_elements, 0.0)
  let f_a = FixedArray::make(total_elements, 0.0)
  let f_b = FixedArray::make(total_elements, 0.0)

  b.bench(name="bulk_scene2_pure_fixed_array_loop", fn() {
    let mut i = 0
    while i < total_elements {
      f_out[i] = f_a[i] + f_b[i]
      f_out[i + 1] = f_a[i + 1] + f_b[i + 1]
      f_out[i + 2] = f_a[i + 2] + f_b[i + 2]
      f_out[i + 3] = f_a[i + 3] + f_b[i + 3]
      i = i + 4
    }
    b.keep(f_out)
  })

  let s_out = Array::make(count, VecS4::VecS4(0.0, 0.0, 0.0, 0.0))
  let s_a = Array::make(count, VecS4::VecS4(1.0, 2.0, 3.0, 4.0))
  let s_b = Array::make(count, VecS4::VecS4(5.0, 6.0, 7.0, 8.0))

  b.bench(name="bulk_scene3_struct_array_loop", fn() {
    let mut i = 0
    while i < count {
      s_out[i] = s_a[i] + s_b[i]
      i = i + 1
    }
    b.keep(s_out)
  })
}

