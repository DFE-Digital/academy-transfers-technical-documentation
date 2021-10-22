workspace "Academy Transfers" "Workspace containing C4 diagrams for AT" {

    model {
        academy = person "Academy/ies" "" "Academy/ies"
        sourceTrust = person "Outgoing Trust" "" "Trust" 
        targetTrust = person "Incoming Trust / Sponsor" "" "Trust"
        rsc = person "Regional Schools Commissioner" "" "RSC"
        projectLead = person "Delivery Officer"
        developer = person "Developer" "A developer for AT"
        localIde = softwareSystem "Local Development Environment" "Typically an IDE plus required runtimes"
        gitHub = softwareSystem "GitHub"

        enterprise "DfE" {
            academyTransfersSystem = softwaresystem "Academy Transfers System" "GOV.UK PaaS: Allows users to progress an AT project via a web site" "Internet-facing Web Application" {
                webApplication = container "Web Application" "Allows users to progress an AT project via a web site" "GovPaaS: .NET Core MVC 3.1 C# application" {
                    controller = component "Controllers"
                    razorView = component "Razor Views"
                    razorPage = component "Razor Pages"
                    useCase = component "Use Cases"
                    gw = component "TRAMS Repositories"
                    httpClient = component "HTTP Client"
                    razorView -> controller "GET / POST"
                    controller -> useCase "Delegates to"
                    razorPage -> useCase "Delegates to"
                    useCase -> gw "Get and retrieve data"
                    gw -> httpClient "Calls to the correct API endpoints, parses repsonses, over HTTPS"
                    xDocGen = component "Document Generation Library"
                    useCase -> xDocGen "Creates Word document (HTB)"
                }
                redisCache = container "Redis" "Stores session data and data protection keys for usage across instances" "GOV.UK PaaS: Key-value pair cache" "Cache" {
                    Tags "Database"
                }
            }
            
            academiesApiSystem = softwareSystem "Academies API" "Azure: Provides academies data for DfE" "API" {
                academiesApiApplication = container "Azure App Service" "Allows the web site to persist and read data relating to an AT project" "Azure App Service: .NET Core MVC 3.1 C# application"
                msSqlDatabase = container "Azure SQL DB" "Stores Academies Data" "Relational DB schema" "Azure SQL DB"
            }
        }

        # relationships between people and software systems
        #  - dev, CI/CD
        developer -> localIde "Develops with code"
        localIde -> gitHub "Pushes code to"
        gitHub -> gitHub "Builds, tests and deploys changes"
        #  - between people
        academy -> sourceTrust "Moves from here"
        academy -> targetTrust "Moves to here"
        rsc -> projectLead "Initiates transfer"            
        #  - between systems
        gitHub -> academyTransfersSystem "Deploys software to"
        
        # relationships to/from containers
        projectLead -> webApplication "Utilizes digital service to progress the transfer" "Web Browser"
        webApplication -> academiesApiSystem "Reads and writes to" "HTTP"
        webApplication -> redisCache "Reads from and writes to" "TCP"
        
        deploymentEnvironment "Live" {
            deploymentNode "Amazon Web Services (EU-West-2)" "" "" "Amazon Web Services - Cloud" {
                deploymentNode "GOV.UK PaaS (Cloud Formation)" {
                    lb = infrastructureNode "Load Balancer" "" "" ""

                    wa = deploymentNode "Autoscaling Cloud Formation Instances" "" "" "" {
                        webApplicationInstance = containerInstance webApplication
                    }

                    deploymentNode "Redis" "" "" "Amazon Web Services - RDS Redis ElastiCache instance" {
                        databaseInstance = containerInstance redisCache
                    }
                }
            }
            
            az = deploymentNode "Azure DFE T1 Production subscription" {
                academiesApiInstance = containerInstance academiesApiApplication
            }

            # infrastructure relationships
            lb -> webApplicationInstance "Forwards requests to" "HTTPS"
            wa -> az "Reads and writes data" "HTTPS"
        }
    }

    views {
        # 'Level 0' - System Landscape
        # Not really a level in itself. Shows context and all personas/roles.
        systemlandscape "SystemLandscape" {
            title "System Landscape for Academy Transfers service"
            include *
            autoLayout tb
        }

        # Level 1 - Context
        # This is the most zoomed-out view showing a big picture of the system landscape. 
        # The focus should be on people (actors, roles, personas, etc) and software systems
        # rather than technologies, protocols and other low-level details. It's the sort of 
        # diagram that you could show to non-technical people.
        systemContext "academyTransfersSystem" {
            include *
            autoLayout lr
        }

        # Level 2 - Container
        # The Container diagram shows the high-level shape of the software architecture and 
        # how responsibilities are distributed across it. It also shows the major technology 
        # choices and how the containers communicate with one another. It's a simple, high-level
        # technology focussed diagram that is useful for software developers and support/operations staff alike.
        container academyTransfersSystem {
            include *
            autolayout
        }
        
        # Level 3 - Component
        component webApplication {
            include *
            autolayout lr
        }

        # Misc - deployment
        deployment "*" "Live" "AmazonWebServicesDeployment" {
            include *
            autolayout lr
        }

        theme default
        
        styles {
            element "Trust" {
                background #b5b482
            }
            element "Academy/ies" {
                background #b5b482
            }
            element "RSC" {
                background #b5b482
            }
            element "Database" {
                shape Cylinder
            }
        }
    }


}
