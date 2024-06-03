@startuml
!define RECTANGLE_RECTANGLE
!include <C4/C4_Container.puml>

Person(user, "User")
Container_Boundary(api, "API") {
    Container(apiServer, "API Server", "FastAPI", "Handles API requests")
    Container(userService, "User Service", "Python", "Manages user data")
    ContainerDb(userDb, "User Database", "PostgreSQL", "Stores user information")
}

Rel(user, apiServer, "GET /users/{username}")
Rel(apiServer, userService, "get_user_by_username(username)")
Rel(userService, userDb, "Query user by username")
@enduml
