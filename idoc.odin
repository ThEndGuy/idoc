package idoc

import "core:fmt"
import "core:c"
import "core:os"
import "core:strings"

foreign import libc "system:c"
foreign libc {
    @(link_name="free")
    @(private)
    cfree :: proc(ptr: rawptr) ---
}

foreign import idoc_lib "libidoc.a"


Idoc :: struct {}
foreign idoc_lib {
    @(link_name="idoc_init")
    init :: proc (file_name: cstring) -> ^Idoc ---
    @(link_name="idoc_free")
    free :: proc (idoc: ^Idoc) ---

    @(private)
    idoc_get_bool_arr :: proc(idoc: ^Idoc, def_bool: c.bool, path: [^]cstring, path_size: c.size_t) -> c.bool --- 

    @(private)
    idoc_get_int_arr :: proc(idoc: ^Idoc, def_int: c.int, path: [^]cstring, path_size: c.size_t) -> c.int ---
    @(private)
    idoc_get_double_arr :: proc(idoc: ^Idoc, def_double: c.double, path: [^]cstring, path_size: c.size_t) ->c.double ---
    @(private)
    idoc_get_cstr_arr :: proc(idoc: ^Idoc, def_str: cstring, path: [^]cstring, path_size: c.size_t) -> cstring ---

    @(private)
    idoc_get_tuple_bool_arr     :: proc(idoc: ^Idoc, out: [^]c.bool, out_size: c.size_t,  path: [^]cstring, path_size: c.size_t ) -> c.bool ---

    @(private)
    idoc_get_tuple_int_arr     :: proc(idoc: ^Idoc, out: [^]c.int, out_size: c.size_t,  path: [^]cstring, path_size: c.size_t ) -> c.bool ---
    @(private)
    idoc_get_tuple_double_arr  :: proc(idoc: ^Idoc, out: [^]c.double, out_size: c.size_t ,  path: [^]cstring, path_size: c.size_t ) ->c.bool ---
    @(private)
    idoc_get_tuple_cstr_arr    :: proc(idoc: ^Idoc, out: [^]cstring, out_size: c.size_t ,  path: [^]cstring, path_size: c.size_t ) ->c.bool ---
}

get_bool :: proc(idoc: ^Idoc,  path: ..cstring, def_bool: bool = false) -> (result: bool) {
    return idoc_get_bool_arr(idoc, def_bool, &path[0], len(path))
}

get_i32 :: proc(idoc: ^Idoc,  path: ..cstring, def_i32: i32 = 0) -> (result: i32) {
    return idoc_get_int_arr(idoc, def_i32, &path[0], len(path))
}

get_f64 :: proc(idoc: ^Idoc, path: ..cstring, def_f64: f64 = 0.0) -> (result: f64) {
    return idoc_get_double_arr(idoc, def_f64, &path[0], len(path))
}

get_string :: proc(idoc: ^Idoc,  path: ..cstring, def_str: string = "") -> (result: string) {
    def_cstr := strings.clone_to_cstring(def_str)
    defer delete(def_cstr)
    cstr := idoc_get_cstr_arr(idoc, def_cstr, &path[0], len(path))
    defer cfree(rawptr(cstr))
    return strings.clone_from_cstring(cstr)
}

get_tuple_bool :: proc(idoc: ^Idoc, size: i32, path: ..cstring) -> (result: []bool, ok: bool) {
    tuple := make([]bool, size)
    ok = idoc_get_tuple_bool_arr(idoc, &tuple[0], uint(size), &path[0], len(path))
    if !ok {
        delete(tuple)
        return nil, false
    }
    return tuple, true
}

get_tuple_i32 :: proc(idoc: ^Idoc, size: i32, path: ..cstring) -> (result: []i32, ok: bool) {
    tuple := make([]i32, size)
    ok = idoc_get_tuple_int_arr(idoc, &tuple[0], uint(size), &path[0], len(path))
    if !ok {
        delete(tuple)
        return nil, false
    }
    return tuple, true
}

get_tuple_f64 :: proc(idoc: ^Idoc, size: i32, path: ..cstring) -> (result: []f64, ok: bool) {
    tuple := make([]f64, size)
    ok = idoc_get_tuple_double_arr(idoc, &tuple[0], uint(size), &path[0], len(path))
    if !ok {
        delete(tuple)
        return nil, false
    }
    return tuple, true
}

get_tuple_string :: proc(idoc: ^Idoc, size: i32, path: ..cstring) -> (result: []string, ok: bool) {
    src := make([]cstring, size)
    tuple := make([]string, size)
    ok = idoc_get_tuple_cstr_arr(idoc, &src[0], uint(size), &path[0], len(path))
    if !ok {
        delete(src)
        delete(tuple)
        return nil, false
    }
    for cstr, i in src {
        tuple[i] = strings.clone_from_cstring(cstr)
        cfree(rawptr(cstr))
    }
    delete(src)
    return tuple, true
}
