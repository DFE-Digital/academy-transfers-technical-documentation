workspace "Academy Transfers" "Workspace containing C4 diagrams for AT" {

    model {
        academy = person "Academy" "" "Academy"
        sourceTrust = person "Source Trust" "" "Trust" 
        targetTrust = person "Target Trust" "" "Trust"
        rsc = person "Regional Schools Commissioner" "" "RSC"
        projectLead = person "Project Lead"
        developer = person "Developer" "A developer for AT"
        localIde = softwareSystem "Local Development Environment" "Typically an IDE plus required runtimes"
        gitHub = softwareSystem "GitHub"

        enterprise "DfE" {
            academyTransfersSystem = softwaresystem "Academy Transfers System" "Allows users to progress an AT project via a web site" "Internet-facing Web Application" {
                webApplication = container "Web Application" "Allows users to progress an AT project via a web site" ".NET Core MVC 3.1 C# application" {
                    # TODO: list the components and interactions for real - dummy data here
                    gw = component "GatewayLayer"
                    xController = component "XxxController"
                    xController -> gw "Calls to get retrieve and parse from API over HTTPS"
                }
                redisCache = container "Redis" "Stores session data" "Key-value pair cache" "Cache" {
                    Tags "Database"
                }
            }
            
            academiesApiSystem = softwareSystem "Academies API" "Provides academies data for DfE" "API" {
                academiesApiApplication = container "Web Application" "Allows the web site to persist and read data relating to an AT project" ".NET Core MVC 3.1 C# application"
                msSqlDatabase = container "Azure SQL DB" "Stores Academies Data" "Relational DB schema" "Azure SQL DB"
            }
        }

        # relationships between people and software systems
        #  - dev, CI/CD
        developer -> localIde "Develops with code"
        localIde -> gitHub "Pushes code to"
        gitHub -> gitHub "Builds, tests and deploys changes"
        #  - between people
        targetTrust -> academy "Sponsors"
        academy -> sourceTrust "Moves from here"
        academy -> targetTrust "Moves to here"
        rsc -> projectLead "Initiates transfer"            
        #  - between systems
        gitHub -> academyTransfersSystem "Deploys software to"
        
        # relationships to/from containers
        projectLead -> webApplication "Utilizes digital service to progress the transfer"
        webApplication -> academiesApiSystem "Reads and writes to"
        webApplication -> redisCache "Reads from and writes to" "TCP"
        
        deploymentEnvironment "Live" {
            deploymentNode "GovPaaS" {
                deploymentNode "Amazon Web Services" "" "" "Amazon Web Services - Cloud" {
                    region = deploymentNode "EU-West-2" "" "" "Amazon Web Services - Region" {
                        route53 = infrastructureNode "Route 53" "" "" "Amazon Web Services - Route 53"
                        lb = infrastructureNode "Load Balancer" "" "" "Amazon Web Services - Elastic Load Balancing"
    
                        deploymentNode "Autoscaling group" "" "" "Amazon Web Services - Auto Scaling" {
                            deploymentNode "Amazon EC2" "" "" "Amazon Web Services - EC2" {
                                webApplicationInstance = containerInstance webApplication
                            }
                        }
    
                        deploymentNode "Amazon RDS" "" "" "Amazon Web Services - RDS" {
                            deploymentNode "Redis" "" "" "Amazon Web Services - RDS Redis ElastiCache instance" {
                                databaseInstance = containerInstance redisCache
                            }
                        }
    
                    }
                }
            }

            # infrastructure relationships
            route53 -> lb "Forwards requests to" "HTTPS"
            lb -> webApplicationInstance "Forwards requests to" "HTTPS"
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
        deployment "academyTransfersSystem" "Live" "AmazonWebServicesDeployment" {
            include *
            autolayout lr
        }

        theme default
        
        styles {
            element "Trust" {
                background #b5b482
            }
            element "Academy" {
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
