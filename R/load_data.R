# Preparing data ----------------------------------------------------------
nodes_city <- readRDS("data/nodes_city.RDS")
nodes_country <- readRDS("data/nodes_country.RDS")
edges_city <- readRDS("data/edges_city.RDS")
edges_country <- readRDS("data/edges_country.RDS")

# Define constants -------------------------------------------------
year_min <- nodes_country$Year %>% min()
year_max <- nodes_country$Year %>% max()
countries <- nodes_country$Country %>% unique() %>% sort()
ipc1_choices <- nodes_city$ipc1 %>% unique() %>% sort()
ipc2_choices <- nodes_city$ipc2 %>% unique() %>% sort()
ipc3_choices <- nodes_city$ipc3 %>% unique() %>% sort()
mean_lon <- nodes_country$lon %>% mean(na.rm = TRUE)
mean_lat <- nodes_country$lat %>% mean(na.rm = TRUE)
edge_weight_vars <- colnames(edges_country)[str_detect(colnames(edges_country), "Similarity")]
max_patent_count <- max(nodes_country$Count)
