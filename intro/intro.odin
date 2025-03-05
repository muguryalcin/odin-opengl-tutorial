package intro

import "core:fmt"
import gl "vendor:OpenGL"
import glfw "vendor:glfw"

framebuffer_size_callback :: proc "cdecl" (window: glfw.WindowHandle, width, height: i32){
    gl.Viewport(0, 0, width, height)
}
main :: proc() {
    glfw.Init()
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 4)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 4)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.TRUE)
    
    window := glfw.CreateWindow(800,600, "OpenGL Tutorial", nil, nil)
    if window == nil {
        fmt.printf("Failed to create GLFW window\n")
        glfw.Terminate()
        return
    }
    glfw.MakeContextCurrent(window)
    gl.load_up_to(4, 4, glfw.gl_set_proc_address)
    gl.Viewport(0, 0, 800, 600)
    glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)

    for !glfw.WindowShouldClose(window) {
        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }
    glfw.Terminate()
}