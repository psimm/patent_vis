# Sidebar -----------------------------------------------------------------
sidebar <- dashboardSidebar(
  # CSS to set colors
  tags$head(
    tags$style(HTML("
                    .not-full .item {
                    background: #3C8DBC !important;
                    color: white !important;
                    }
                    .selectize-dropdown-content .active {
                    background: #3C8DBC !important;
                    color: white !important;
                    }
                    .dropdown-shinyWidgets {
                    background: #e5e5e5;
                    }
                    #apply {
                    background: #3C8DBC !important;
                    color: white !important;
                    }
                    "))
    ),
  # Package shinyjs is used for reset button, this fct needs to be called first
  useShinyjs(),
  div(
    id = "inputs",
    sliderInput(
      round = TRUE,
      step = 1,
      inputId = "year_range",
      label = "Year of issue",
      min = year_min,
      max = year_max,
      value = c(year_min, year_max),
      sep = ""
    ),
    radioButtons(
      inputId = "aggregate_by",
      label = "Level",
      choices = c("Country", "City"),
      selected = "Country",
      inline = TRUE
    ),
    conditionalPanel(
      condition = "input.aggregate_by == 'City'",
      selectInput(
        inputId = "selected_country",
        label = "Select country",
        choices = countries,
        selected = "Denmark",
        selectize = TRUE)
    ),
    br(),
    column(12, tags$b("IPC classes")),
    dropdownButton(
      circle = FALSE,
      label = "Select by class",
      icon = icon("cog", lib = "glyphicon"),
      status = "primary",
      width = 245,
      selectizeInput(
        inputId = "ipc1",
        label = "IPC 1 codes",
        choices = ipc1_choices,
        selected = ipc1_choices,
        multiple = TRUE,
        options = list(plugins = list("remove_button"))
      ),
      selectizeInput(
        inputId = "ipc2",
        label = "IPC 2 codes",
        choices = ipc2_choices,
        selected = ipc2_choices,
        multiple = TRUE,
        options = list(plugins = list("remove_button"))
      ),
      selectizeInput(
        inputId = "ipc3",
        label = "IPC 3 codes",
        choices = ipc3_choices,
        selected = ipc3_choices,
        multiple = TRUE,
        options = list(plugins = list("remove_button"))
      )
    ),
    sliderInput(
      inputId = "min_count",
      label = "Minimum patent count",
      min = 0,
      step = 10,
      round = 1,
      max = 5000,
      value = 10
    ),
    selectizeInput(
      inputId = "color_by",
      label = "Color by",
      choices = vars_show,
      selected = "Similarity future",
      multiple = FALSE
    ),
    plotOutput("legend_color", height = legend_height),
    selectizeInput(
      inputId = "size_by",
      label = "Size by",
      choices = vars_size,
      selected = "Count",
      multiple = FALSE
    ),
    plotOutput("legend_size", height = legend_height)
  ),
#  actionButton(
#    inputId = "apply",
#    label = "Apply settings",
#    icon = icon("refresh")
#  ),
  actionButton(
    inputId = "reset",
    label = "Reset settings",
    icon = icon("trash", lib = "glyphicon")
  )
)