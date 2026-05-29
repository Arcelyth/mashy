///| 4-Dimensional vector.
pub(all) struct Vec4 {
  raw : @ffi.Vec4Raw
}

///| Create a new 4D vector.
#inline
pub fn Vec4::new(x : Float, y : Float, z : Float, w : Float) -> Vec4 {
  { raw: @ffi.ext_vec4f_new(x, y, z, w) }
}

///| Add to another 4D vector then return a new 4D vector.
#inline
pub impl Add for Vec4 with add(self : Vec4, other : Vec4) -> Vec4 {
  { raw: @ffi.ext_vec4f_add(self.raw, other.raw) }
}

///|
#inline
pub impl Sub for Vec4 with sub(self : Vec4, other : Vec4) -> Vec4 {
  { raw: @ffi.ext_vec4f_sub(self.raw, other.raw) }
}

///|
#inline
pub impl Mul for Vec4 with mul(self : Vec4, other : Vec4) -> Vec4 {
  { raw: @ffi.ext_vec4f_mul(self.raw, other.raw) }
}

///|
#inline
pub impl Div for Vec4 with div(self : Vec4, other : Vec4) -> Vec4 {
  { raw: @ffi.ext_vec4f_div(self.raw, other.raw) }
}

///| 
#inline
pub impl Eq for Vec4 with equal(self: Vec4, other: Vec4) -> Bool {
  @ffi.ext_vec4f_get_x(self.raw) == @ffi.ext_vec4f_get_x(other.raw) &&
  @ffi.ext_vec4f_get_y(self.raw) == @ffi.ext_vec4f_get_y(other.raw) &&
  @ffi.ext_vec4f_get_z(self.raw) == @ffi.ext_vec4f_get_z(other.raw) &&
  @ffi.ext_vec4f_get_w(self.raw) == @ffi.ext_vec4f_get_w(other.raw)
}

///|
#inline
pub impl Show for Vec4 with output(self: Vec4, logger: &Logger) -> Unit {
  logger.write_string("Vec4((\{self.x()}), (\{self.y()}), (\{self.z()}), (\{self.w()}))")
}

///| Get the first element.
#inline 
pub fn Vec4::x(self : Vec4) -> Float { @ffi.ext_vec4f_get_x(self.raw) }

///| Get the second element.
#inline 
pub fn Vec4::y(self : Vec4) -> Float { @ffi.ext_vec4f_get_y(self.raw) }

///| Get the third element.
#inline 
pub fn Vec4::z(self : Vec4) -> Float { @ffi.ext_vec4f_get_z(self.raw) }

///| Get the forth element.
#inline 
pub fn Vec4::w(self : Vec4) -> Float { @ffi.ext_vec4f_get_w(self.raw) }

///| 
#inline 
pub fn Vec4::add_bulk(out_pool: Bytes, a_pool: Bytes, b_pool: Bytes, count: Int) -> Unit {
  @ffi.ext_vec4f_add_bulk(out_pool, a_pool, b_pool, count)
}

///| 
#inline 
pub fn Vec4::sub_bulk(out_pool: Bytes, a_pool: Bytes, b_pool: Bytes, count: Int) -> Unit {
  @ffi.ext_vec4f_sub_bulk(out_pool, a_pool, b_pool, count)
}

///| 
#inline 
pub fn Vec4::mul_bulk(out_pool: Bytes, a_pool: Bytes, b_pool: Bytes, count: Int) -> Unit {
  @ffi.ext_vec4f_mul_bulk(out_pool, a_pool, b_pool, count)
}

///| 
#inline 
pub fn Vec4::div_bulk(out_pool: Bytes, a_pool: Bytes, b_pool: Bytes, count: Int) -> Unit {
  @ffi.ext_vec4f_div_bulk(out_pool, a_pool, b_pool, count)
}

///| 
#inline 
pub fn Vec4::dot_bulk(out_pool: Bytes, a_pool: Bytes, b_pool: Bytes, count: Int) -> Unit {
  @ffi.ext_vec4f_dot_bulk(out_pool, a_pool, b_pool, count)
}

///|
/// Create a 4D vector with all elements are 'v'.
#inline 
pub fn Vec4::splat(v: Float) -> Vec4 {
  { raw: @ffi.ext_vec4f_new(v, v, v, v) }
}

///|
/// Create a 4D vector from an array.
#inline 
pub fn Vec4::from_array(arr: Array[Float]) -> Vec4 {
  { raw: @ffi.ext_vec4f_new(arr[0], arr[1], arr[2], arr[3]) }
}

///|
/// Create a 4D vector from an fixed array.
#inline 
pub fn Vec4::from_fixed_array(arr: FixedArray[Float]) -> Vec4 {
  { raw: @ffi.ext_vec4f_new(arr[0], arr[1], arr[2], arr[3]) }
}

///|
/// Return an array from a 4D vector.
#inline 
pub fn Vec4::to_array(self: Vec4) -> Array[Float] {
  [self.x(), self.y(), self.z(), self.w()]
}

///|
/// Return a fixed array from a 4D vector.
#inline 
pub fn Vec4::to_fixed_array(self: Vec4) -> FixedArray[Float] {
  [self.x(), self.y(), self.z(), self.w()]
}

///|
/// Write the elements of the 4D vector one by one starting from 'pos' index to the target array.
#inline 
pub fn Vec4::write_to_array(self: Vec4, arr: Array[Float], pos: Int) -> Unit? {
  guard pos >= 0 && pos + 3 < arr.length() else { None }  
  arr[pos] = self.x()
  arr[pos + 1] = self.y()
  arr[pos + 2] = self.z()
  arr[pos + 3] = self.w()
  Some(())
}

///|
#inline
pub fn Vec4::dot(self : Vec4, other : Vec4) -> Float {
  @ffi.ext_vec4f_dot(self.raw, other.raw)
}

test "Vec4_add" {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  let v2 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  let v3 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  assert_eq(v1 + v2 + v3, Vec4::new(3.0, 6.0, 9.0, 12.0))
}

test "Vec4_sub" {
  let v1 = Vec4::new(4.0, 5.0, 6.0, 7.0)  
  let v2 = Vec4::new(1.0, 1.0, 1.0, 1.0)  
  let v3 = Vec4::new(2.0, 2.0, 2.0, 2.0)  
  assert_eq(v1 - v2 - v3, Vec4::new(1.0, 2.0, 3.0, 4.0))
}

test "Vec4_mul" {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)
  let v2 = Vec4::new(2.0, 3.0, 4.0, 5.0)
  assert_eq(v1 * v2, Vec4::new(2.0, 6.0, 12.0, 20.0))
}

test "Vec4_div" {
  let v1 = Vec4::new(8.0, 18.0, 32.0, 50.0)
  let v2 = Vec4::new(2.0, 3.0, 4.0, 5.0)
  assert_eq(v1 / v2, Vec4::new(4.0, 6.0, 8.0, 10.0))
}

test "Vec4_dot" {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)
  let v2 = Vec4::new(5.0, 6.0, 7.0, 8.0)
  assert_eq(v1.dot(v2), 70.0)
}

test "Vec4_mixed_expr" {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)
  let v2 = Vec4::new(2.0, 3.0, 4.0, 5.0)
  let v3 = Vec4::new(10.0, 10.0, 10.0, 10.0)

  let r = (v1 + v2) * v3 - v1

  assert_eq(
    r,
    Vec4::new(
      (1.0 + 2.0) * 10.0 - 1.0,
      (2.0 + 3.0) * 10.0 - 2.0,
      (3.0 + 4.0) * 10.0 - 3.0,
      (4.0 + 5.0) * 10.0 - 4.0
    )
  )
}

test "Vec4_get_element" {
  let v = Vec4::new(1.1, 2.2, 3.3, 4.4)

  assert_eq(v.x(), 1.1)
  assert_eq(v.y(), 2.2)
  assert_eq(v.z(), 3.3)
  assert_eq(v.w(), 4.4)
}

test "Vec4_splat" {
  let v = Vec4::splat(3.0)
  assert_eq(v, Vec4::new(3.0, 3.0, 3.0, 3.0))
}

test "Vec4_write_to_array" {
  let v = Vec4::new(1.1, 2.2, 3.3, 4.4)
  let arr: Array[Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

  let result = v.write_to_array(arr, 1)
 
  assert_true(result != None) 

  assert_eq(arr[0], 0.0)
  assert_eq(arr[1], 1.1)
  assert_eq(arr[2], 2.2)
  assert_eq(arr[3], 3.3)
  assert_eq(arr[4], 4.4)
  assert_eq(arr[5], 0.0)
}

test "Vec4_add_bulk" {
  let n = 4
  let byte_len = n * 4

  let a = Bytes::from_array([
    0, 0, 128, 63,  // 1.0
    0, 0, 128, 63,
    0, 0, 128, 63,
    0, 0, 128, 63,
  ].map(fn(x) { x.to_byte() }))

  let b = Bytes::from_array([
    0, 0, 0, 64,    // 2.0
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
  ].map(fn(x) { x.to_byte() }))

  let out = Bytes::from_array(
    Array::make(byte_len, 0)
      .map(fn(x) { x.to_byte() })
  )

  Vec4::add_bulk(out, a, b, n)

  let expected = [
    0, 0, 64, 64,   // 3.0
    0, 0, 64, 64,
    0, 0, 64, 64,
    0, 0, 64, 64,
  ]

  for i in 0..<byte_len {
    assert_eq(
      out[i].to_int(),
      expected[i]
    )
  }
}

test "Vec4_sub_bulk" {
  let n = 4
  let byte_len = n * 4

  // a = [5.0, 5.0, 5.0, 5.0]
  let a = Bytes::from_array([
    0, 0, 160, 64,
    0, 0, 160, 64,
    0, 0, 160, 64,
    0, 0, 160, 64,
  ].map(fn(x) { x.to_byte() }))

  // b = [2.0, 2.0, 2.0, 2.0]
  let b = Bytes::from_array([
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
  ].map(fn(x) { x.to_byte() }))

  let out = Bytes::from_array(
    Array::make(byte_len, 0)
      .map(fn(x) { x.to_byte() })
  )

  Vec4::sub_bulk(out, a, b, n)

  // expected = [3.0, 3.0, 3.0, 3.0]
  let expected = [
    0, 0, 64, 64,
    0, 0, 64, 64,
    0, 0, 64, 64,
    0, 0, 64, 64,
  ]

  for i in 0..<byte_len {
    assert_eq(out[i].to_int(), expected[i])
  }
}

test "Vec4_mul_bulk" {
  let n = 4
  let byte_len = n * 4

  // a = [2.0, 2.0, 2.0, 2.0]
  let a = Bytes::from_array([
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
  ].map(fn(x) { x.to_byte() }))

  // b = [4.0, 4.0, 4.0, 4.0]
  let b = Bytes::from_array([
    0, 0, 128, 64,
    0, 0, 128, 64,
    0, 0, 128, 64,
    0, 0, 128, 64,
  ].map(fn(x) { x.to_byte() }))

  let out = Bytes::from_array(
    Array::make(byte_len, 0)
      .map(fn(x) { x.to_byte() })
  )

  Vec4::mul_bulk(out, a, b, n)

  // expected = [8.0, 8.0, 8.0, 8.0]
  // 8.0 -> 00 00 00 41
  let expected = [
    0, 0, 0, 65,
    0, 0, 0, 65,
    0, 0, 0, 65,
    0, 0, 0, 65,
  ]

  for i in 0..<byte_len {
    assert_eq(out[i].to_int(), expected[i])
  }
}

test "Vec4_div_bulk" {
  let n = 4
  let byte_len = n * 4

  // a = [8.0, 8.0, 8.0, 8.0]
  let a = Bytes::from_array([
    0, 0, 0, 65,
    0, 0, 0, 65,
    0, 0, 0, 65,
    0, 0, 0, 65,
  ].map(fn(x) { x.to_byte() }))

  // b = [2.0, 2.0, 2.0, 2.0]
  let b = Bytes::from_array([
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
    0, 0, 0, 64,
  ].map(fn(x) { x.to_byte() }))

  let out = Bytes::from_array(
    Array::make(byte_len, 0)
      .map(fn(x) { x.to_byte() })
  )

  Vec4::div_bulk(out, a, b, n)

  // expected = [4.0, 4.0, 4.0, 4.0]
  // 4.0 -> 00 00 80 40
  let expected = [
    0, 0, 128, 64,
    0, 0, 128, 64,
    0, 0, 128, 64,
    0, 0, 128, 64,
  ]

  for i in 0..<byte_len {
    assert_eq(out[i].to_int(), expected[i])
  }
}

test "Vec4_dot_bulk" {
  // A = [1.0, 2.0, 3.0, 4.0]
  let a = Bytes::from_array([
    0, 0, 128, 63, // 1.0
    0, 0, 0, 64,   // 2.0
    0, 0, 64, 64,  // 3.0
    0, 0, 128, 64, // 4.0
  ].map(fn(x) { x.to_byte() }))

  // B = [1.0, 1.0, 1.0, 1.0]
  let b = Bytes::from_array([
    0, 0, 128, 63, 
    0, 0, 128, 63, 
    0, 0, 128, 63, 
    0, 0, 128, 63,
  ].map(fn(x) { x.to_byte() }))

  let out = Bytes::from_array(Array::make(4, 0).map(fn(x) { x.to_byte() }))

  Vec4::dot_bulk(out, a, b, 4)

  // 1*1 + 2*1 + 3*1 + 4*1 = 10.0 [0, 0, 32, 65]
  if out[2] != (32 : Byte) || out[3] != (65 : Byte) {
    panic()
  }
}


