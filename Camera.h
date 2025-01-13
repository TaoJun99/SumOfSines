#ifndef TEST_CAMERA_H
#define TEST_CAMERA_H

#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/gtx/rotate_vector.hpp>
#include <glm/gtx/vector_angle.hpp>


class Camera {
    public:
        glm::vec3 Position;
        glm::vec3 Orientation = glm::vec3(0.0f, 0.0f, -5.0f);
        glm:: vec3 Up = glm::vec3(0.0, 1.0, 0.0f);

        bool firstClick = true;
        float width;
        float height;

        float speed = 0.0001f;
        float sensitivity = 50.0f;

        Camera(float width, float height, glm::vec3 position);

        glm::mat4 getViewMatrix();
        glm::mat4 getProjMatrix(float FOVdeg, float nearPlane, float farPlane);
        void Inputs(GLFWwindow* window);
};


#endif //TEST_CAMERA_H
