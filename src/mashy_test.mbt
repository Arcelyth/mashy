test "vec4f_add" {
  let v1 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  let v2 = Vec4::new(1.0, 2.0, 3.0, 4.0)  
  assert_eq(v1 + v2, Vec4::new(2.0, 4.0, 6.0, 8.0))
}
