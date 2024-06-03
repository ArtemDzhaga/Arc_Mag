@startuml
!define RECTANGLE_RECTANGLE
!include <C4/C4_Container.puml>

Person(user, "User")
Container_Boundary(api, "API") {
    Container(apiServer, "API Server", "FastAPI", "Handles API requests")
    Container(talkService, "Talk Service", "Python", "Manages talk data")
    ContainerDb(talkDb, "Talk Database", "PostgreSQL", "Stores talk information")
}

Rel(user, apiServer, "GET /talks/")
Rel(apiServer, talkService, "get_all_talks()")
Rel(talkService, talkDb, "Retrieve all talks")
@enduml

