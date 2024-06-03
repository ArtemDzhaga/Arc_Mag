@startuml
!define RECTANGLE_RECTANGLE
!include <C4/C4_Container.puml>

Person(user, "User")
Container_Boundary(api, "API") {
    Container(apiServer, "API Server", "FastAPI", "Handles API requests")
    Container(conferenceService, "Conference Service", "Python", "Manages conference data")
    ContainerDb(conferenceDb, "Conference Database", "PostgreSQL", "Stores conference information")
    ContainerDb(talkDb, "Talk Database", "PostgreSQL", "Stores talk information")
}

Rel(user, apiServer, "GET /conferences/{conference_id}/talks/")
Rel(apiServer, conferenceService, "get_conference_talks(conference_id)")
Rel(conferenceService, conferenceDb, "Retrieve talks from conference")
Rel(conferenceService, talkDb, "Retrieve talk details")
@enduml
