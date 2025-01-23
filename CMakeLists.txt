cmake_minimum_required(VERSION 3.26)
project(Test)

set(CMAKE_CXX_STANDARD 17)

file(GLOB SOURCE_FILES  main.cpp shader.frag shader.vert)

add_executable(Test main.cpp
        Camera.cpp
        Camera.h)

find_package(glfw3 REQUIRED)
target_link_libraries(Test PRIVATE glfw)

find_package(GLEW REQUIRED)
target_link_libraries(Test PRIVATE GLEW::GLEW)

find_package(glm REQUIRED)
target_include_directories(Test PRIVATE ${GLM_INCLUDE_DIRS})

# Link OpenGL
target_link_libraries(Test PRIVATE ${OPENGL_gl_LIBRARY})

target_include_directories(Test PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_directories(Test PRIVATE ${CMAKE_SOURCE_DIR}/include)
