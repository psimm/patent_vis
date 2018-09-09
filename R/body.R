# Body --------------------------------------------------------------------
body <- dashboardBody(
  # CSS to set colors and spacing
  tags$head(tags$style(
    HTML(
      '
      .sidebar {
      color: #000000;
      }
      .skin-blue .main-sidebar {
      background-color: #F2F2F2
      }
      .skin-blue .content {
      background-color: #F2F2F2
      }
      .skin-blue .content-wrapper {
      background-color: #F2F2F2
      }
      .sidebar .shiny-input-container {
      margin-bottom: 5px;
      }
      .wrapper {
      background-color: #F2F2F2
      }
      '
    )
    )),
  fluidRow(
    tabBox(
      id = "tabs",
      width = 12,
      tabPanel("Introduction",
               value = "introduction",
               div(
                 h1("Global Patent Explorer (Beta Version V2.4)"),
                 p("Welcome to the AAU global patent explorer. This tool lets you map and visualize inventive and innovative activity around the globe. The explorer relies on a series of novel indicators that combine insights from large-scale natural language processing and established patent analysis techniques and provide insights about dimensions such as", tags$i("technological originality"), "or", tags$i("future orientation."), "You can explore the dataset on country or city level, select time-ranges and technologies. The app features rich visualizations including a world map, network plots that show relations between countries and cities, and customizable statistical plots."),
                 h2("Visualizations"),
                 p(tags$b("Map:"), "The map-view provides a geographical overview on inventive and innovative activity around the globe. It enables to visually compare patent activity either on global level across countries or within a country across cities."),
                 p(tags$b("Network:"), "Uses the measures of technological distance based semantic similarity as constructed by Hain et al. (2018) (see below for further information) to explore similarities in patenting activity across countries and cities. In detail, it visualizes the overall technological similarity between countries or cities I and j, the similarity to past (similarity patents of i to previous patents of j), present (similarity patents of i to current patents of j), and future (similarity patents of i to later patents of j)."),
                 p(tags$b("Plots:"), "Provides informative figures on selected indicators, again across countries, or cities within countries. The first plot provides a bar chart of the selected indicators, while the second provides an interactive scatterplot, where the measures on the x- and y-axis can be individually chosen."),
                 p(tags$b("Data:"), "Provides the selected data used to construct the visualizations. Since the patent explorer is still in beta version, the data is not available for download yet. However, you might for now request it at", a(href = "mailto:dsh@business.aau.dk", "dsh@business.aau.dk"), "."),
                 h2("Indicators"),
                 p("The global patent explorers provides the possibility to analyze patents for selected countries, cities, and IPC (up to 3rd digit) classes. It currently visualizes the following indicators of technological novelty and potential impact and economic value. It draws from ex-ante (available in real time) as well as ex-post (available with delay after patent publication) indicators. Note that ex-post indicators are only available 5 years after patent publication, therefore stop at 2010. However, we currently work on providing predicted values for ex-post indicators in real time according to the methodology of Hain and Jurowetzki (2018) (see below for further information)."),
                 tags$ul(
                   tags$li(tags$b("Number of Patents:"), "The number of patents granted within the selection (time, geography, IPC class), derived from the PATSTAT data. Ex-ante indicator."),
                   tags$li(tags$b("Radicalness index:"), "Indicator aiming at measuring the technological radicalness of inventions. Operationalized as a time-invariant count of the number of IPC technology classes in which the patents cited by the given patent are, but in which the patent itself is not classified. For details, consider Squicciarini et al. (2013). Ex-ante indicator."),
                   tags$li(tags$b("Originality index:"), "The breadth of the technology fields on which a patent relies. For details, consider Squicciarini et al. (2013). Ex-ante indicator."),
                   tags$li(tags$b("Forward citations:"), "The number of citations a patent receives from later patents if often used as a measure of technological significance and impact. We here use the number of citations a patent receives in the 5 years following its publication. Ex-post indicator."),
                   tags$li(tags$b("Generality index:"), "Assess the range of later generations of inventions that have benefitted from a patent. Operationalized as the range of technology fields and consequently industries - that cite the patent. For details, consider Squicciarini et al. (2013). Ex-post indicator."),
                   tags$li(tags$b("(Semantic) Technological similarity:"), "Utilizes techniques from natural language processing (NLP) to construct measures of technological distance between patents based on the semantic similarity of the description of a patent's technological features in its abstract. Technological distance is also used to create patent-level measures of novelty (how similar is this patent to others published before), timeliness (how similar is the patent to others published around the same time) and impact (how similar is this patent to others published afterwards). For details consider Hain et al. (2018). Ex-ante (similarity to past, present) and ex-post (similarity to future) indicator. "),
                   tags$li(tags$b("Breakthroughs:"), "The number of patents that are in the top 1% of received forward citations (5 years) within the corresponding category. For details, consider Squicciarini et al. (2013). Ex-post indicator.")
                 ),
                 h2("Data Sources"),
                 p("The global patent explorer aims at providing a comprehensive overview on patenting activity around the globe, in terms of patent quantity as well as quality. Therefore, it draws from the following sources:"),
                 h4("PATSTAT, Autumn 2017 version:"),
                 p("Provides basic information on patents granted by the EPO and USTPO, their inventors, and corresponding addresses which are used to determine their geographical location."),
                 h4("OECD Patent Quality Indicators database, March 2018:"),
                 p("This database provides a number of indicators that are aimed at capturing the quality of patents, intended as the technological and economic value of patented inventions, and the possible impact that these might have on subsequent technological developments. It is available at:", a(href = "ftp://prese:Patents@ftp.oecd.org/Indicators_201803/", "ftp://prese:Patents@ftp.oecd.org/Indicators_201803/")),
                 p("For further details consider: Squicciarini, M., H. Dernis and C. Criscuolo (2013), Measuring Patent Quality: Indicators of Technological and Economic Value, OECD Science, Technology and Industry Working Papers, No. 2013/03, available at:", a(href = "http://dx.doi.org/10.1787/5k4522wkw1r8-en", "http://dx.doi.org/10.1787/5k4522wkw1r8-en")),
                 h4("AAU patent quality:"),
                 p("The AAU data on patent novelty and impact, based on semantic similarity. This data uses techniques from natural language processing (NLP) to construct measures of technological distance between patents based on the semantic similarity of the description of a patent's technological features in its abstract. Technological distance is also used to create patent-level measures of novelty (how similar is this patent to others published before) and impact (how similar is this patent to others published afterwards). For further details, consider:"),
                 p("D.S. Hain, R. Jurowetzki, T. Buchmann, P. Wolf (2018), A Vector Worth a Thousand Counts: A Temporal Semantic Similarity Approach to Patent Impact Prediction, available at:", a(href = "http://vbn.aau.dk/en/publications/a-vector-worth-a-thousand-counts(855d9758-d017-4b4a-baf5-8b7e72a1c223).html", "http://vbn.aau.dk/en/publications/a-vector-worth-a-thousand-counts(855d9758-d017-4b4a-baf5-8b7e72a1c223).html")),
                 h2("Future development:"),
                 p("The Global Patent Explorers is currently still under development, so undergoes constant improvements in terms of data quality and coverage, but also functionality and usability (requests welcome)."),
                 p("Up to now, it provides the possibility for near real-time nowcasting and placecasting of patenting activity. However, this can up to now only be done for ex-ante measure of patent quality and novelty, while ex-post measures of patent impact are only available until 2010. However, the main effort is currently channeled towards the creation and validation of predictive measures of patent impact, which can be provided in real time. This features will (hopefully) be made available soon. For first details regarding the methodology consider:"),
                 p("Hain, D. and R. Jurowetzki (2018), Introduction to Predictive Modeling in Entrepreneurship and Innovation Studies - A Hands-On Application in the Prediction of Breakthrough Patents, available at:", a(href =  "http://vbn.aau.dk/en/publications/introduction-to-predictive-modeling-in-entrepreneurship-and-innovation-studies(64154609-b45c-45dc-82c4-b148f1c5bb7f).html", "http://vbn.aau.dk/en/publications/introduction-to-predictive-modeling-in-entrepreneurship-and-innovation-studies(64154609-b45c-45dc-82c4-b148f1c5bb7f).html")),
                 p("Also, further features to explore the semantic structure and topic within patent texts are planned."),
                 h2("Feedback & Contact"),
                 p("Again, the current version is a beta and under constant development, therefore all kind of comments are highly appreciated to improve the quality of the global patent explorer. For feedback, requests, suggestions, bug- and error-reports (and everything else) contact"),
                 p("Daniel Hain,", a(href = "mailto:dsh@business.aau.dk", "dsh@business.aau.dk"),
                   p("Further contributors to the project are:"),
                   p("Roman Jurowetzki,", a(href = "mailto:roman@business.aau.dk", "roman@business.aau.dk")),
                   p("Tobias Buchmann,", a(href = "mailto:tobias.buchmann@zsw-bw.de", "tobias.buchmann@zsw-bw.de")),
                   p("Patrick Wolf,", a(href = "mailto:patrick.wolf@zsw-bw.de", "patrick.wolf@zsw-bw.de")),
                   br(),
                   p("R Shiny app developed by"),
                   p("Paul Simmering,", a(href = "mailto:paul.simmering@gmail.com", "paul.simmering@gmail.com"))
                 ))
      ),
      tabPanel(
        "Map",
        value = "map",
        tags$style(type = "text/css", "#map {height: calc(100vh - 130px) !important;}"),
        leafletOutput("map")
      ),

      tabPanel("Network graph",
               value = "network",
               fluidRow(
                 column(12, p("Plots can be downloaded as PNG images by using right click and save as."))
               ),
               fluidRow(
                 column(2,
                        radioButtons(
                          inputId = "selected_edgeweight",
                          label = "Edges by",
                          choiceNames = edge_weight_vars,
                          choiceValues = edge_weight_vars,
                          selected = "Similarity all"
                        ),
                        # If a node is selected, show its name. Condition argument in JavaScript.
                        conditionalPanel(
                          condition = "input.network_selected != \"\"",
                          tags$b(textOutput("selected_node_name"))
                        ),
                        tableOutput("selected_node_table")
                 ),
                 column(10, visNetworkOutput("network", height = 700))
               )
      ),
      tabPanel("Plots",
               value = "plot",
               fluidRow(
                 column(11, p("Plots can be downloaded as PNG images by using right click and save as.")),
                 column(11, plotOutput("plot_bar")),
                 column(
                   1,
                   radioButtons(
                     inputId = "bars_sort_by",
                     label = "Sort bars by",
                     choices = c("A-Z", "Value"),
                     selected = "A-Z"
                   )
                 ),
                 column(
                   6,
                   plotOutput("plot_scatter", height = 420)
                 ),
                 column(
                   6,
                   br(), # I'm sure there's a more elegant way
                   br(),
                   br(),
                   br(),
                   br(),
                   p("Please select x and y variables for the scatterplot on the left."),
                   selectInput(
                     inputId = "x_var",
                     label = "X-axis variable",
                     choices = vars_show,
                     selected = "Similarity future",
                     selectize = TRUE
                   ),
                   selectInput(
                     inputId = "y_var",
                     label = "Y-axis variable",
                     choices = vars_show,
                     selected = "Count",
                     selectize = TRUE
                   ),
                   checkboxInput(
                     inputId = "show_labels",
                     label = "Show labels",
                     value = FALSE
                   ),
                   checkboxInput(
                     inputId = "uniform_size",
                     label = "Uniform size",
                     value = FALSE
                   )
                 )
               )
      ),
      tabPanel("Data",
               value = "data",
               DT::DTOutput("nodes_df")
      )
    )
  )
)