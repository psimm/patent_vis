# Server ------------------------------------------------------------------
server <- function(input, output, session) {

  # Called nodes_prep because its not the final version
  # Needs to be combined with edges to set final ids
  nodes_prep <- reactive({
    validate(
      need(length(input$ipc1) > 0, error_ipc1),
      need(length(input$ipc2) > 0, error_ipc2),
      need(length(input$ipc3) > 0, error_ipc3)
    )

    # Choose df according to selected level of aggregation
    if (input$aggregate_by == "Country") {
      nodes <- nodes_country %>%
        group_by(Country)
    } else if (input$aggregate_by == "City") {
      nodes <- nodes_city %>%
        filter(Country == input$selected_country) %>%
        group_by(City)
    }

    # Apply the filter settings
    # Aggregate node statistics
    nodes %<>%
      filter(
        Year >= input$year_range[1],
        Year <= input$year_range[2],
        ipc1 %in% input$ipc1,
        ipc2 %in% input$ipc2,
        ipc3 %in% input$ipc3
      ) %>%
      summarise(
        sum_count = summarise_sum(Count),
        Radicalness = summarise_weighted_mean(Radicalness, Count),
        `Similarity all` = summarise_weighted_mean(`Similarity all`, Count),
        `Similarity past` = summarise_weighted_mean(`Similarity past`, Count),
        `Similarity present` = summarise_weighted_mean(`Similarity present`, Count),
        `Similarity future` = summarise_weighted_mean(`Similarity future`, Count),
        Originality = summarise_weighted_mean(Originality, Count),
        Generality = summarise_weighted_mean(Generality, Count),
        `Forward citations` = summarise_sum(`Forward citations`),
        `Breakthroughs` = summarise_sum(`Breakthroughs`),
        Monochrome = Monochrome[1],
        lon = lon[1],
        lat = lat[1],
        id = combine_ids(id) # Needed to select edges
      ) %>%
      rename(Count = sum_count) %>%
      ungroup() %>%
      filter(
        Count >= input$min_count # More intuitive for user than filter before aggregation
      )

    if (input$aggregate_by == "City") {
      nodes %<>% mutate(Country = input$selected_country) # This column gets lost in summarising
    }

    validate(
      need(nrow(nodes) > 0, error_no_data)
    )

    nodes
  })

  # Called edges because its not the final version
  # Needs to be combined with nodes to set final ids
  edges_prep <- reactive({
    if (input$aggregate_by == "Country") {
      edges_country
    } else if (input$aggregate_by == "City") {
      edges_city
    }
  })

  # Combines the nodes and edges
  # Filters down to relevant edges
  # Assigns new ids to nodes, because they were aggregated
  network <- reactive({
    aggregate_edges(nodes_prep(), edges_prep())
  })

  # Just a wrapper for convenience
  nodes <- reactive({
    network()$nodes
  })

  edges <- reactive({
    network()$edges
  })

  # Multiple graphics need to use the same colors
  # They are defined here and all graphics draw from the reactive value
  color <- reactive({
    validate(need(nrow(nodes() > 0), error_no_data))
    values <- nodes()[input$color_by] %>% pull()

    # Choose single color if all values are equal
    if (isTRUE(all.equal(max(values, na.rm = TRUE), min(values, na.rm = TRUE)))) {
      viridis(3)[2]
    } else {
      # Choose from viridis color scale
      colors <- viridis(length(unique(values)))
      # Assign color by rank order
      colors[values %>% factor() %>% as.numeric()]
    }
  })

  # See settings
  min_size <- reactive({
    ifelse(input$aggregate_by == "Country", node_size_min_country, node_size_min_city)
  })

  max_size <- reactive({
    ifelse(input$aggregate_by == "Country", node_size_max_country, node_size_max_city)
  })

  range <- reactive({
    max_size() - min_size()
  })

  # Same as color, multiple graphics use size
  # Defined here, reactive value is used by all graphics that need size
  size <- reactive({
    validate(need(nrow(nodes() > 0), error_no_data))
    values <- nodes()[input$size_by] %>% pull()
    # Normalize function is defined in functions.R
    values %>% normalize() * range() + min_size()
  })

  # Popups are used on the map
  popups <- reactive({
    validate(need(nrow(nodes() > 0), error_no_data))
    nodes <- nodes()
    nodes[vars_show] <- nodes[vars_show] %>% round(2)

    if (input$aggregate_by == "Country") {
      popups <- nodes$Country
    } else if (input$aggregate_by == "City") {
      popups <- nodes$City
    }

    popups %<>% paste0("<b>", ., "</b>")

    popups %<>% paste0(
      "<br>",
      "Number of patents: ",
      nodes$Count,
      "<br>",
      "Mean radicalness: ",
      nodes$Radicalness,
      "<br>",
      "Mean similarity all: ",
      nodes$`Similarity all`,
      "<br>",
      "Mean similarity past: ",
      nodes$`Similarity past`,
      "<br>",
      "Mean similarity present: ",
      nodes$`Similarity present`,
      "<br>",
      "Mean similarity future: ",
      nodes$`Similarity future`,
      "<br>",
      "Mean originality: ",
      nodes$Originality,
      "<br>",
      "Mean generality: ",
      nodes$Generality,
      "<br>",
      "Number of forward citations: ",
      nodes$`Forward citations`,
      "<br>",
      "Number of breakthroughs: ",
      nodes$`Breakthroughs`
    )

    paste0("<p>", popups, "</p>")
  })

  labels <- reactive({
    validate(need(nrow(nodes() > 0), error_no_data))
    if (input$aggregate_by == "Country") {
      nodes()$Country
    } else if (input$aggregate_by == "City") {
      nodes()$City
    }
  })

  # Create map
  # Not reactive, to avoid redrawing
  output$map <- renderLeaflet({
    leaflet(
      data = nodes_country,
      options = leafletOptions(worldCopyJump = TRUE)
    ) %>%
      setView(lng = mean_lon, lat = mean_lat, zoom = default_zoom_country) %>%
      # Provider Tiles can be changed easily
      # See http://leaflet-extras.github.io/leaflet-providers/preview/index.html
      addProviderTiles(
        providers$Stamen.TonerLite,
        options = providerTileOptions(
          noWrap = FALSE,
          maxZoom = max_zoom,
          minZoom = min_zoom
        )
      )
  })

  observe({
    validate(need(nrow(nodes() > 0), error_no_data))
    # Observe currently opened tab so markers are drawn
    # when map comes into focus
    input$tabs

    # By using a proxy, the map can be modified in place and isn't redrawn
    leafletProxy("map", data = nodes()) %>%
      clearMarkers() %>%
      addCircleMarkers(
        ~ lon,
        ~ lat,
        color = color(),
        fillColor = color(),
        radius = size(),
        popup = popups()
      )
  })

  # Delete all markers if no ipc codes are selected
  observe({
    if (is.null(input$ipc1) | is.null(input$ipc2) | is.null(input$ipc3)) {
      leafletProxy("map") %>% clearMarkers()
    }
  })

  # Fly to selected Country
  observe({
    if (input$aggregate_by == "City") {
      Country_geo <- nodes_country %>%
        filter(Country == input$selected_country)
      leafletProxy("map") %>%
        flyTo(lng = Country_geo$lon[1], lat = Country_geo$lat[1], zoom = default_zoom_city)
    }
  })

  # Fly to Country overview
  observe({
    if (input$aggregate_by == "Country") {
      leafletProxy("map") %>%
        flyTo(lng = mean_lon, lat = mean_lat, zoom = default_zoom_country)
    }
  })

# Network --------------------------------------------------------------

  # Set initial styling of the network
  network_styled <- reactive({
    g <- network()

    validate(
      need(!is.null(g$nodes), error_no_data),
      need(!is.null(g$edges), error_no_data)
    )

    # Need to isolate(), else map will still be redrawn on any settings change
    g$nodes %<>% mutate(
        label = isolate(labels()),
        color = isolate(color()),
        size = isolate(size())
      )

   g$edges %<>% mutate(
      width = isolate(edge_width())
   )
   g
  })

  output$network <- renderVisNetwork({
    g <- network_styled()
    visNetwork(g$nodes, g$edges) %>%
      visIgraphLayout(layout = "layout_in_circle") %>%
      visOptions(
        highlightNearest = list(enabled = TRUE, degree = 0),
        nodesIdSelection = list(
          enabled = TRUE,
          main = paste0("Select by ", input$aggregate_by)
          )
        ) %>%
      visNodes(font = "30px Arial")
  })

# Update nodes -----------------------------------------------------------
  observe({
    validate(need(nrow(nodes() > 0), error_no_data))
    nodes <- nodes() %>%
      mutate(
        size = size(),
        color = color()
      )
    visNetworkProxy("network") %>%
      visUpdateNodes(nodes)
  })

# Update edges ------------------------------------------------------------
  edge_width <- reactive({
    validate(need(!is.null(edges()), error_no_data))
    edges()[input$selected_edgeweight] %>%
      pull() %>%
      normalize() %>%
      multiply_by(edge_width_range) %>%
      add(edge_width_min)
  })

  edge_arrow <- reactive({
    ew <- input$selected_edgeweight
    ifelse(
      ew == "Similarity future" | ew == "Similarity past",
      "to",
      "none"
    )
  })

  observe({
    validate(need(!is.null(edges()), error_no_data))
    edges <- edges() %>% mutate(width = edge_width())

    visNetworkProxy("network") %>%
      visUpdateEdges(edges) %>%
      visEdges(arrows = edge_arrow())
  })


# Network selected box ----------------------------------------------------

  selected_node <- reactive({
    validate(need(nrow(nodes() > 0), error_no_data))
    i <- nodes()[which(nodes() %>% pull(id) == input$network_selected),]
    # This method of selection returns an empty df if no node is selected
    # It does not throw an error which filter() would.
    i[vars_show] <- round(i[vars_show], 2)
    i
  })

  output$selected_node_name <- renderText({
    if (input$aggregate_by == "Country") {
        selected_node()$Country
    } else if (input$aggregate_by == "City") {
        selected_node()$City
    }
  })

  output$selected_node_table <- renderTable({
      df <- selected_node() %>% select(-c(lat, lon, id, Country))
      # Somewhat awkward way of transmuting the df,
      # while turning colnames into column
      values <- df %>% as.matrix() %>% as.vector()
      if (length(values == ncol(df))) {
        tibble(
          Statistic = colnames(df),
          Value = values
        )
      }
  })

# Plots -------------------------------------------------------------------

  output$plot_bar <- renderPlot({
    validate(
      need(length(input$ipc1) > 0, error_ipc1),
      need(length(input$ipc2) > 0, error_ipc2),
      need(length(input$ipc3) > 0, error_ipc3),
      need(nrow(nodes() > 0), error_no_data)
    )

    # Colors need to be named after themselves for ggplot
    # Else ggplot would treat them as arbitrary strings
    color_manual <- color()
    names(color_manual) <- color_manual

    df <- tibble(
      xvar = nodes() %>% pull(input$aggregate_by),
      yvar = nodes() %>% pull(input$size_by),
      color = color()
    )

    if (input$bars_sort_by == "Value") {
      gg <- df %>% ggplot(aes(x = reorder(xvar, desc(yvar)), y = yvar, fill = color))
    } else {
      gg <- df %>% ggplot(aes(x = xvar, y = yvar, fill = color))
    }

    gg +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = color_manual) +
      theme(legend.position = "none") +
      xlab(input$aggregate_by) +
      ylab(input$size_by) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })

  output$plot_scatter <- renderPlot({
    validate(
      need(length(input$ipc1) > 0, error_ipc1),
      need(length(input$ipc2) > 0, error_ipc2),
      need(length(input$ipc3) > 0, error_ipc3)
    )

    df <- tibble(
      xvar = nodes() %>% pull(input$x_var),
      yvar = nodes() %>% pull(input$y_var),
      label = nodes() %>% pull(input$aggregate_by),
      size = size()
    )

    if (input$uniform_size) {
      point_size <- 1 # Arbitrary, just has to be same for all rows
      max_size <- node_size_uniform # Bc scale_size is used
      min_size <- node_size_uniform
    } else {
      point_size <- df$size
      max_size <- node_size_scatter_max
      min_size <- node_size_scatter_min
    }

    gg <- df %>%
      ggplot(aes(x = xvar, y = yvar, label = label, size = point_size)) +
      geom_point(color = color(), alpha = 0.8) +
      scale_size(range = c(min_size, max_size)) +
      theme(legend.position = "none") +
      xlab(input$x_var) +
      ylab(input$y_var)

    if (input$show_labels) {
      gg + geom_label_repel(size = 4)
    } else {
      gg
    }
  })

  output$nodes_df <- DT::renderDT({
    validate(need(nrow(nodes() > 0), error_no_data))
    output_df <- nodes() %>%
      select(-id, -lon, -lat, -Monochrome) %>%
      mutate_if(is.numeric, round, 2) %>%
      # Don't show country column if on city level
      when(
        input$aggregate_by == "City" ~ select(., -Country),
        ~ .
        )
    },
    selection = "none",
    rownames = FALSE,
    options = list(pageLength = 25)
  )

  # As the legends are shared across different graphics,
  # They have to be generated separately
  output$legend_color <- renderPlot({
    validate(need(nrow(nodes() > 0), error_no_data))
    nodes <- nodes()
    validate(
      need(nrow(nodes) >= 1, error_no_data)
    )

    df <- tibble(
      value = nodes[,input$color_by] %>% pull(),
      x = 1, # Arbitrary
      y = 1
    )

    gg <- df %>%
      ggplot(aes(x = x, y = y, col = value)) +
      geom_point() +
      scale_color_viridis(guide = guide_colorbar(
        direction = "horizontal",
        title = NULL,
        barwidth = unit(210, "points")
      )) +
      # Set background to sidebar color to let it blend in
      theme(legend.background = element_rect(fill = sidebar_color))

    # Only draw the legend
    legend <- cowplot::get_legend(gg)
    ggdraw(legend)
  }, bg = "transparent")

  # Same as color legend
  output$legend_size <- renderPlot({
    validate(need(nrow(nodes() > 0), error_no_data))
    nodes <- nodes()
    n_nodes <- nrow(nodes)

    validate(
      need(n_nodes > 0, error_no_data)
    )

    df <- tibble(
      value = nodes[,input$size_by] %>% pull(),
      x = 1:n_nodes,
      y = 1
    )

    gg <- df %>%
      ggplot(aes(x = x, y = y, size = value)) +
      geom_point(col = "gray40") +
      scale_size_continuous(
        guide = guide_legend(
          title = NULL,
          direction = "horizontal",
          label.position = "top",
          nrow = 1,
          keywidth = 2
        )
      ) +
      theme(
        legend.background = element_rect(fill = sidebar_color),
        legend.position = "top"
      )

    legend <- get_legend(gg)
    ggdraw(legend)
  }, bg = "transparent")

  # Headings for the legends
  output$size_by_selection <- renderText({
    input$size_by %>% toTitleCase()
  })

  output$color_by_selection <- renderText({
    input$color_by %>% toTitleCase()
  })

  output$selected_country <- renderText({
    paste0("Selected Country: ", input$selected_country)
  })

  observeEvent(input$reset, {
    shinyjs::reset("inputs")
  })
}