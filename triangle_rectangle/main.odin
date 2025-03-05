package triangle_rectangle

import "core:fmt"
import gl "vendor:OpenGL"
import "vendor:glfw"



framebuffer_size_callback :: proc "cdecl" (window: glfw.WindowHandle, width, height: i32){
    gl.Viewport(0, 0, width, height)
}

process_input :: proc (window: glfw.WindowHandle){
    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
        glfw.SetWindowShouldClose(window, true)
    }
}

draw_triangle :: proc (vertices: ^[9]f32){
    using gl
    VAO:u32
    GenVertexArrays(1, &VAO)
    BindVertexArray(VAO)

    VBO:u32
    GenBuffers(1, &VBO)
    BindBuffer(ARRAY_BUFFER, VBO)
    BufferData(ARRAY_BUFFER, size_of([9]f32), vertices, STATIC_DRAW)
    VertexAttribPointer(0,3,FLOAT,FALSE,3*size_of(f32),uintptr(0))
    EnableVertexAttribArray(0)

    vertex_shader_source := cstring(raw_data(#load("shader.vert")))
    vertex_shader := CreateShader(VERTEX_SHADER)
    ShaderSource(vertex_shader, 1, &vertex_shader_source, nil)
    CompileShader(vertex_shader)

    fragment_shader_source := cstring(raw_data(#load("frag.frag")))
    fragment_shader := CreateShader(FRAGMENT_SHADER)
    ShaderSource(fragment_shader, 1, &fragment_shader_source, nil)
    CompileShader(fragment_shader)

    shader_program := CreateProgram()
    AttachShader(shader_program, vertex_shader)
    AttachShader(shader_program, fragment_shader)
    LinkProgram(shader_program)

    DeleteShader(vertex_shader)
    DeleteShader(fragment_shader)

    UseProgram(shader_program)
    DrawArrays(TRIANGLES, 0, 3)
    
}

draw_rectangle :: proc(vertices: ^[12]f32, indices: ^[6]i32){
    using gl
    VAO:u32
    GenVertexArrays(1, &VAO)
    BindVertexArray(VAO)

    VBO:u32
    GenBuffers(1, &VBO)
    BindBuffer(ARRAY_BUFFER, VBO)
    BufferData(ARRAY_BUFFER, size_of([12]f32), vertices, STATIC_DRAW)

    EBO:u32
    GenBuffers(1, &EBO)
    BindBuffer(ELEMENT_ARRAY_BUFFER, EBO)
    BufferData(ELEMENT_ARRAY_BUFFER, size_of([6]i32), indices, STATIC_DRAW)
    VertexAttribPointer(0,3,FLOAT,FALSE,3*size_of(f32),uintptr(0))
    EnableVertexAttribArray(0)

    vertex_shader_source := cstring(raw_data(#load("shader.vert")))
    vertex_shader := CreateShader(VERTEX_SHADER)
    ShaderSource(vertex_shader, 1, &vertex_shader_source, nil)
    CompileShader(vertex_shader)

    fragment_shader_source := cstring(raw_data(#load("frag.frag")))
    fragment_shader := CreateShader(FRAGMENT_SHADER)
    ShaderSource(fragment_shader, 1, &fragment_shader_source, nil)
    CompileShader(fragment_shader)

    shader_program := CreateProgram()
    AttachShader(shader_program, vertex_shader)
    AttachShader(shader_program, fragment_shader)
    LinkProgram(shader_program)

    DeleteShader(vertex_shader)
    DeleteShader(fragment_shader)

    UseProgram(shader_program)
    DrawElements(TRIANGLES, 6, UNSIGNED_INT, nil)
    
}

main :: proc() {
    using gl
    // initialize and configure
    glfw.Init()
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 4)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 4)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
    
    // create window
    window := glfw.CreateWindow(800,600, "OpenGL Tutorial", nil, nil)
    if window == nil {
        fmt.printf("Failed to create GLFW window\n")
        glfw.Terminate()
        return
    }
    // make context current
    glfw.MakeContextCurrent(window)
    // load opengl functions
    load_up_to(4, 4, glfw.gl_set_proc_address)
    // set viewport
    Viewport(0, 0, 800, 600)
    // set framebuffer size callback
    glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)

    rectangle_vertices := [12]f32{
        -0.8, -0.8, 0.0,
        -0.2, -0.8, 0.0,
        -0.2, -0.2, 0.0,
        -0.8, -0.2, 0.0,
    }

    rectangle_indices := [6]i32{
        0, 1, 2,
        2, 3, 0,
    }

    triangle_vertices := [9]f32{
        0.2, 0.2, 0.0,
        0.8, 0.2, 0.0,
        0.5, 0.8, 0.0,
    }
    for !glfw.WindowShouldClose(window) {
        // processing input
        process_input(window)
        // rendering commands
        ClearColor(0.2, 0.3, 0.3, 1.0)
        Clear(COLOR_BUFFER_BIT)

        draw_rectangle(&rectangle_vertices, &rectangle_indices)
        draw_triangle(&triangle_vertices)
        // check and call events and swap buffers
        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }
    glfw.Terminate()
    return
}