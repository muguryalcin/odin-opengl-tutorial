package hello_triangle

import "core:fmt"
import gl "vendor:OpenGL"
import "vendor:glfw"



framebuffer_size_callback :: proc "cdecl" (window: glfw.WindowHandle, width, height: i32){
    gl.Viewport(0, 0, width, height)
}

process_input :: proc "c" (window: glfw.WindowHandle){
    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
        glfw.SetWindowShouldClose(window, true)
    }
}

draw_triangle :: proc "c" (){
    using gl
    vertices := [9]f32{
        -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0,
        0.0, 0.5, 0.0,
    }
    VBO: u32
    GenBuffers(1, &VBO)
    BindBuffer(ARRAY_BUFFER, VBO)
    BufferData(ARRAY_BUFFER, len(vertices) * size_of(f32), &vertices, STATIC_DRAW)
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

    for !glfw.WindowShouldClose(window) {
        // processing input
        process_input(window)
        // rendering commands
        ClearColor(0.2, 0.3, 0.3, 1.0)
        Clear(COLOR_BUFFER_BIT)
        // check and call events and swap buffers
        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }
    glfw.Terminate()
    return
}