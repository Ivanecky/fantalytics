library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidymodels)
library(dplyr)
library(plotly)
library(DT)

shinyUI(# Define page
    fluidPage(
        
        # Title
        titlePanel(
            "Fantasy Football EDA"
        ),
        
        # Sidebar
        sidebarPanel(
            # Widgets for searching
            # Name
            textInput("player_name", h3("Player Name"), value = "Aaron Rodgers"),
            # Search button
            actionButton("player_search", label = "Search")
        ),
        
        # Main
        mainPanel(
            fluidRow(
                DT::dataTableOutput('player_performances'),
            ),
            fluidRow(
                plotlyOutput("player_perf_plot")
            ),
            fluidRow(
                plotlyOutput("player_weekly_plot")
            )
        )
        
    )
    # dashboardPage(
    #     # Define page header
    #     dashboardHeader(title = "ESPN FF"),
    #     # Define sidebar
    #     dashboardSidebar(
    #         # Sidebar Menu
    #         sidebarMenu(
    #             menuItem("Main", tabName = "main"),
    #             menuItem("+/- Performances", tabName = "pt_performances"),
    #             menuItem("About", tabName = "about")
    #         )
    #     ),
    #     # Define body
    #     dashboardBody(
    #         tabItems(
    #             tabItem(
    #                 "main",
    #                 # Top summary row
    #                 fluidRow(
    #                     DT::dataTableOutput("playerPerformances")
    #                 )
    #             ),
    #             tabItem(
    #                 "pt_performances",
    #                 fluidRow(
    #                     DT::dataTableOutput("overperformers")
    #                 ),
    #                 fluidRow(
    #                     DT::dataTableOutput("underperformers")
    #                 )
    #             )
    #         )
    #     )
    # )
)
