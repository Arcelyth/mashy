#external
pub type Vec4Raw

#borrow(x, y, z, w)
pub extern "C" fn ext_vec4f_new(x : Float, y : Float, z : Float, w : Float) -> Vec4Raw = "vec4f_new"
#borrow(v)
pub extern "C" fn ext_vec4f_get_x(v : Vec4Raw) -> Float = "vec4f_get_x"
#borrow(v)
pub extern "C" fn ext_vec4f_get_y(v : Vec4Raw) -> Float = "vec4f_get_y"
#borrow(v)
pub extern "C" fn ext_vec4f_get_z(v : Vec4Raw) -> Float = "vec4f_get_z"
#borrow(v)
pub extern "C" fn ext_vec4f_get_w(v : Vec4Raw) -> Float = "vec4f_get_w"
#borrow(a, b)
pub extern "C" fn ext_vec4f_add(a : Vec4Raw, b : Vec4Raw) -> Vec4Raw = "vec4f_add"
#borrow(a, b)
pub extern "C" fn ext_vec4f_sub(a : Vec4Raw, b : Vec4Raw) -> Vec4Raw = "vec4f_sub"
#borrow(a, b)
pub extern "C" fn ext_vec4f_mul(a : Vec4Raw, b : Vec4Raw) -> Vec4Raw = "vec4f_mul"
#borrow(a, b)
pub extern "C" fn ext_vec4f_div(a : Vec4Raw, b : Vec4Raw) -> Vec4Raw = "vec4f_div"
#borrow(a, b)
pub extern "C" fn ext_vec4f_dot(a : Vec4Raw, b : Vec4Raw) -> Float = "vec4f_dot"

#borrow(out, a, b)
pub extern "C" fn ext_vec4f_add_bulk(out : Bytes, a : Bytes, b : Bytes, count : Int) = "vec4f_add_bulk"
#borrow(out, a, b)
pub extern "C" fn ext_vec4f_sub_bulk(out : Bytes, a : Bytes, b : Bytes, count : Int) = "vec4f_sub_bulk"
#borrow(out, a, b)
pub extern "C" fn ext_vec4f_mul_bulk(out : Bytes, a : Bytes, b : Bytes, count : Int) = "vec4f_mul_bulk"
#borrow(out, a, b)
pub extern "C" fn ext_vec4f_div_bulk(out : Bytes, a : Bytes, b : Bytes, count : Int) = "vec4f_div_bulk"
#borrow(out, a, b)
pub extern "C" fn ext_vec4f_dot_bulk(out : Bytes, a : Bytes, b : Bytes, count : Int) = "vec4f_dot_bulk"

