@startuml
!define RECTANGLE_RECTANGLE
!include <C4/C4_Container.puml>

Person(user, "User")
Container_Boundary(api, "API") {
    Container(apiServer, "API Server", "FastAPI", "Handles API requests")
    Container(conferenceService, "Conference Service", "Python", "Manages conference data")
    ContainerDb(conferenceDb, "Conference Database", "PostgreSQL", "Stores conference information")
}

Rel(user, apiServer, "POST /conferences/{conference_id}/add_talk/{talk_id}")
Rel(apiServer, conferenceService, "add_talk_to_conference(conference_id, talk_id)")
Rel(conferenceService, conferenceDb, "Update conference with talk")
@enduml
