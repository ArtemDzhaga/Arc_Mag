workspace {
    name "Сайт конференции"
    description "Приложение для управления конференциями, докладами и пользователями"

    # включаем режим с иерархической системой идентификаторов
    !identifiers hierarchical

    # Модель архитектуры
    model {

        # Настраиваем возможность создания вложенных групп
        properties { 
            structurizr.groupSeparator "/"
        }

        # Описание компонент модели
        user = person "Пользователь"
        conference_site = softwareSystem "Сайт конференции" {
            description "Сервер управления конференциями"

            user_service = container "User Service" {
                description "Сервис управления пользователями"
            }

            report_service = container "Report Service" {
                description "Сервис управления докладами"
            }

            conference_service = container "Conference Service" {
                description "Сервис управления конференциями"
            }

            group "Слой данных" {
                user_database = container "User Database" {
                    description "База данных пользователей"
                    technology "PostgreSQL 15"
                    tags "database"
                }

                report_database = container "Report Database" {
                    description "База данных докладов"
                    technology "PostgreSQL 15"
                    tags "database"
                }

                conference_database = container "Conference Database" {
                    description "База данных конференций"
                    technology "PostgreSQL 15"
                    tags "database"
                }
            }

            user_service -> user_database "Получение/обновление данных о пользователях" 
            report_service -> report_database "Получение/обновление данных о докладах" 
            conference_service -> conference_database "Получение/обновление данных о конференциях" 
            conference_service -> report_service "Получение данных о докладах"

            user -> user_service "Создание нового пользователя"
            user -> user_service "Поиск пользователя"
            user -> report_service "Создание доклада"
            user -> report_service "Получение списка всех докладов"
            user -> conference_service "Добавление доклада в конференцию"
            user -> conference_service "Получение списка докладов в конференции"
        }

        user -> conference_site "Взаимодействие с сайтом конференции"

        deploymentEnvironment "Production" {
            deploymentNode "User Server" {
                containerInstance conference_site.user_service
            }

            deploymentNode "Report Server" {
                containerInstance conference_site.report_service
                properties {
                    "cpu" "4"
                    "ram" "256Gb"
                    "hdd" "4Tb"
                }
            }

            deploymentNode "Conference Server" {
                containerInstance conference_site.conference_service
                properties {
                    "cpu" "4"
                    "ram" "256Gb"
                    "hdd" "4Tb"
                }
            }

            deploymentNode "databases" {
                deploymentNode "Database Server 1" {
                    containerInstance conference_site.user_database
                }

                deploymentNode "Database Server 2" {
                    containerInstance conference_site.report_database
                }

                deploymentNode "Database Server 3" {
                    containerInstance conference_site.conference_database
                    instances 3
                }
            }
        }
    }

    views {
        themes default

        properties { 
            structurizr.tooltips true
        }

        !script groovy {
            workspace.views.createDefaultViews()
            workspace.views.views.findAll { it instanceof com.structurizr.view.ModelView }.each { it.enableAutomaticLayout() }
        }

        dynamic conference_site "UC01" "Создание нового пользователя" {
            autoLayout
            user -> conference_site.user_service "Создать нового пользователя (POST /user)"
            conference_site.user_service -> conference_site.user_database "Сохранить данные о пользователе" 
        }

        dynamic conference_site "UC02" "Поиск пользователя по логину" {
            autoLayout
            user -> conference_site.user_service "Поиск пользователя по логину (GET /user/{login})"
            conference_site.user_service -> conference_site.user_database "Получить данные о пользователе" 
        }

        dynamic conference_site "UC03" "Поиск пользователя по маске имя и фамилии" {
            autoLayout
            user -> conference_site.user_service "Поиск пользователя по имени и фамилии (GET /user?firstName&lastName)"
            conference_site.user_service -> conference_site.user_database "Получить данные о пользователе" 
        }

        dynamic conference_site "UC04" "Создание доклада" {
            autoLayout
            user -> conference_site.report_service "Создать новый доклад (POST /report)"
            conference_site.report_service -> conference_site.report_database "Сохранить данные о докладе" 
        }

        dynamic conference_site "UC05" "Получение списка всех докладов" {
            autoLayout
            user -> conference_site.report_service "Получить список всех докладов (GET /reports)"
            conference_site.report_service -> conference_site.report_database "Получить данные о всех докладах" 
        }

        dynamic conference_site "UC06" "Добавление доклада в конференцию" {
            autoLayout
            user -> conference_site.conference_service "Добавить доклад в конференцию (POST /conference/{conferenceId}/report)"
            conference_site.conference_service -> conference_site.conference_database "Сохранить данные о докладе в конференции" 
            conference_site.conference_service -> conference_site.report_service "Получить данные о докладе"
        }

        dynamic conference_site "UC07" "Получение списка докладов в конференции" {
            autoLayout
            user -> conference_site.conference_service "Получить список докладов в конференции (GET /conference/{conferenceId}/reports)"
            conference_site.conference_service -> conference_site.conference_database "Получить данные о докладах в конференции" 
        }

        styles {
            element "database" {
                shape cylinder
            }
        }
    }
}