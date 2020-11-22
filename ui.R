library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidymodels)
library(dplyr)
library(plotly)
library(DT)

shinyUI(# Define page
    navbarPage("ESPN FF Analysis",
               # Player Analysis
        tabPanel("Player Search",
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
        ),
        # Position Analysis
        tabPanel("Position Analysis",
            fluidPage(
                
            )
        )
    )
)
