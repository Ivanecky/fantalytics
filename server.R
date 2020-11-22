library(shiny)
library(tidymodels)
library(dplyr)
library(httr)
library(reticulate)
library(plotly)
library(RPostgres)
library(DBI)
library(yaml)

# Read in GCP connection info
gcp_info <- as.data.frame(read_yaml("gcp_info.yml"))
gcp_info <- gcp_info %>%
    mutate(
        dbname = as.character(dbname),
        host = as.character(host),
        port = as.character(port),
        user = as.character(user),
        password = as.character(password)
    )

# Connect to GCP
con <- dbConnect(
    RPostgres::Postgres(),
    dbname=gcp_info$dbname,
    host=gcp_info$host,
    port=gcp_info$port,
    user=gcp_info$user,
    password=gcp_info$password
)

# COLLECT DATA
# Query GCP DB for data tables containing fantasy football data to be used in this application
# Get main players tables
full_players <- dbGetQuery(con, 
                           "SELECT
                            name,
                            week,
                            points,
                            team,
                            position
                           FROM full_players 
                           WHERE load_d = (SELECT MAX(load_d) FROM full_players)")
# Get performances
performances <- dbGetQuery(con, 
                           "SELECT
                            player,
                            projected,
                            points,
                            pts_diff,
                            perf_cat,
                            position,
                            week,
                            team
                           FROM performances 
                           WHERE load_d = (SELECT MAX(load_d) FROM performances)")
# Grouped performances
grp_perf <- dbGetQuery(con, "SELECT * FROM grouped_performances")
# Position performances
pos_perf <- dbGetQuery(con, "SELECT * FROM position_performances")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    # REACTIVE FXNS
    getPlayerPerfData <- eventReactive(input$player_search, {
        # Filter data for player name
        if(is.na(input$player_name)) { return(performances) }
        else {
            temp <- performances %>%
                filter(tolower(player) == tolower(input$player_name))

            return(temp)
        }
    })
    
    getPlayerWeeklyData <- eventReactive(input$player_search, {
        # Filter data for player name
        if(is.na(input$player_name)) { return(full_players) }
        else {
            temp <- full_players %>%
                filter(tolower(name) == tolower(input$player_name))
            
            return(temp)
        }
    })
    
    getPlayerName <- eventReactive(input$player_search, {
        return(input$player_name)
    })
    
    # VISUAL OUTPUTS
    output$player_performances <- renderDataTable({
        # Get data
        df <- getPlayerPerfData()
        # Rename columns
        names(df) <- c("Player", "Projected", "Points", "Differential", "Performance Category", "Position", "Week", "Team")
        # Return data
        return(df)
    })
    
    output$player_perf_plot <- renderPlotly({
        # Filter data
        tmp_perf <- getPlayerPerfData()
        # Create plot
        ggplot(tmp_perf, aes(as.numeric(week), pts_diff)) +
            geom_line(color = "blue") +
            geom_point(color = "blue", size = 2) +
            ggtitle(paste0("Weekly Performances for ", getPlayerName()),
                    subtitle = "Differential between projected points and points scored by week.") +
            labs(x = "Week", y = "Point Differential") +
            geom_hline(yintercept= 0, linetype="dashed", color = "red", size=0.5) -> p
        # Render plotly
        ggplotly(p)
    })
    
    output$player_weekly_plot <- renderPlotly({
        # Filter data
        tmp_perf <- getPlayerWeeklyData()
        # Create plot
        ggplot(tmp_perf, aes(as.numeric(week), points)) +
            geom_line(color = "blue") +
            geom_point(color = "blue", size = 2) +
            ggtitle(paste0("Weekly Points Scored for ", getPlayerName()),
                    subtitle = "") +
            labs(x = "Week", y = "Points Scored") -> p
        # Render plotly
        ggplotly(p)
    })
    

})
