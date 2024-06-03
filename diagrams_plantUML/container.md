@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Container.puml

Person(admin, "Администратор")
Person(moderator, "Модератор")
Person(user, "Участник")

System_Boundary(services_site, "Сайт организации конференций") {
  Container(web_app, "Веб-приложение", "Java, Spring MVC", "Предоставляет пользовательский интерфейс для взаимодействия с сервисами")
  Container(user_service, "Сервис пользователей", "Java, Spring Boot", "Управляет информацией о пользователях")
  Container(conference_service, "Сервис конференций", "Java, Spring Boot", "Управляет информацией о конференциях")
  Container(registration_service, "Сервис регистрации", "Java, Spring Boot", "Управляет информацией о регистрациях на конференции")
  Container(db, "База данных", "PostgreSQL", "Хранение данных о пользователях, конференциях и регистрациях")
}

Rel(admin, web_app, "Использует")
Rel(moderator, web_app, "Использует")
Rel(user, web_app, "Использует")

Rel(web_app, user_service, "Использует API")
Rel(web_app, conference_service, "Использует API")
Rel(web_app, registration_service, "Использует API")

Rel(user_service, db, "Использует")
Rel(conference_service, db, "Использует")
Rel(registration_service, db, "Использует")

@enduml
