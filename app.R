# Patent explorer
# R Shiny app

library(shiny) # Essential
library(shinyWidgets) # For dropdownButton()
library(shinydashboard) # For layout
library(shinyjs) # For reset()
library(leaflet) # Draw a map
library(viridis) # Color scale
library(cowplot) # To plot legends by themselves with get_legend()
library(ggrepel) # Avoid overlapping labels in scatterplot
library(visNetwork) # Draw network
library(igraph) # Only for network layout
library(tidyverse) # Utility
library(magrittr) # for %<>% function
library(tools) # For tolower() and toTitleCase()
library(DT) # Customizable table outputs

# Load order matters
source("R/settings.R")
source("R/string_constants.R")
source("R/load_data.R")
source("R/functions.R")
source("R/sidebar.R")
source("R/body.R")
source("R/ui.R")
source("R/server.R")

shinyApp(ui, server)
