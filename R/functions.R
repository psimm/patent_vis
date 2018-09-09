# Helper functions --------------------------------------------------------

# Used when nodes are aggregated
combine_ids <- function(id) {
  paste(id, collapse = "-")
}

# Used when edges are aggregated according to aggregated nodes
split_ids <- function(id) {
  id %>%
    str_split(pattern = "-") %>%
    unlist() %>%
    as.numeric()
}

# Test data for aggregate_edges function
#nodes <- tibble(
#  id = c("1-2-3-4", "5-6-7", "8-9")
#)

#edges <- tibble(
#  to = 1:9,
#  from = 9:1
#)

aggregate_edges <- function(nodes, edges) {

  ids_used <- nodes$id %>% split_ids() %>% unique()

  # Choose only the edges with connections to nodes that are selected
  edges %<>% filter(
    to %in% ids_used,
    from %in% ids_used
  )

  if (nrow(edges) > 0) {

    # New ids for nodes, combining multiple old ids
    nodes %<>% ungroup() %>% mutate(id_aggr = 1:nrow(nodes))

    edges$new_to <- 0
    edges$new_from <- 0

    # Assign new ids to edges depending on old id group in new ids
    for (i in nodes$id_aggr) {
      ids_original <- nodes$id[i] %>% split_ids
      new_to_idx <- which(edges$to %in% ids_original)
      new_from_idx <- which(edges$from %in% ids_original)
      edges[new_to_idx,"new_to"] <- i
      edges[new_from_idx,"new_from"] <- i
    }

    # Summarise the edge attributes
    edges %<>%
      group_by(new_from, new_to) %>%
      summarise(
        `Similarity future` = summarise_weighted_mean(`Similarity future`, n),
        `Similarity past` = summarise_weighted_mean(`Similarity past`, n),
        `Similarity present` = summarise_weighted_mean(`Similarity present`, n),
        `Similarity all` = summarise_weighted_mean(`Similarity all`, n),
        sum_n = summarise_sum(n)
      ) %>%
      rename(
        n = sum_n,
        from = new_from,
        to = new_to
      ) %>%
      ungroup() %>%
      filter(to != from)

    nodes %<>% mutate(
      id = id_aggr
    ) %>% select(-id_aggr)

    list(nodes = nodes, edges = edges)

  } else {
    list(nodes = nodes, edges = NULL)
  }
}

# Robust normalization function which always returns numeric values
# Normalizes to [0, 1], all NAs and NaNs are assigned 0
normalize <- function(values) {
  if (all(is.na(values))) return(rep(0, length(values)))
  values_notna_idx <- which(!(is.na(values) | is.nan(values)))
  values_notna <- values[values_notna_idx]
  if (length(values_notna) > 1) { #Prevent division by zero
    norm_values <- (values_notna - min(values_notna)) / (max(values_notna) - min(values_notna))
  } else {
    norm_values <- 1
  }
  values_normalized <- rep(0, length(values))
  values_normalized[values_notna_idx] <- norm_values
  values_normalized
}

# Robust mean and sum functions to use for node aggregation
# Means that even if all values are NA, 0 is returned
summarise_weighted_mean <- function(values, weights = NULL) {
  if (all(is.na(values))) return(c(0))
  if (is.null(weights)) weights <- rep(1, length(values))
  values_notna_idx <- which(!(is.na(values) | is.nan(values | is.na(weights) | is.nan(weights))))
  values_notna <- values[values_notna_idx]
  weights_notna <- weights[values_notna_idx]
  weighted.mean(values_notna, weights_notna)
}

summarise_sum <- function(values) {
  if (all(is.na(values))) return(c(0))
  values_notna_idx <- which(!(is.na(values) | is.nan(values)))
  values_notna <- values[values_notna_idx]
  sum(values_notna)
}
