#external
pub type Vec4Raw

pub extern "C" fn ext_vec4f_new(x : Float, y : Float, z : Float, w : Float) -> Vec4Raw = "vec4f_new"
pub extern "C" fn ext_vec4f_add(a : Vec4Raw, b : Vec4Raw) -> Vec4Raw = "vec4f_add"
pub extern "C" fn ext_vec4f_get_x(v : Vec4Raw) -> Float = "vec4f_get_x"
pub extern "C" fn ext_vec4f_get_y(v : Vec4Raw) -> Float = "vec4f_get_y"
pub extern "C" fn ext_vec4f_get_z(v : Vec4Raw) -> Float = "vec4f_get_z"
pub extern "C" fn ext_vec4f_get_w(v : Vec4Raw) -> Float = "vec4f_get_w"

#borrow(out, a, b)
pub extern "C" fn ext_vec4f_add_bulk(out : Bytes, a : Bytes, b : Bytes, count : Int) = "vec4f_add_bulk"

