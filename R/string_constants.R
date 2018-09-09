# String constants
vars_show <- c(
  "Count",
  "Radicalness",
  "Generality",
  "Originality",
  "Breakthroughs",
  "Similarity all",
  "Similarity past",
  "Similarity present",
  "Similarity future",
  "Forward citations",
  "Monochrome"
)

# Don't show the Monochrome column as an option for size by
vars_size <- vars_show[1:(length(vars_show) - 1)]

# Error messages ----------------------------------------------------------
error_ipc1 <- "Please select an IPC 1 code"
error_ipc2 <- "Please select an IPC 2 code"
error_ipc3 <- "Please select an IPC 3 code"
error_no_data <- "No data selected"
error_not_enough_data_for_graph <- "Not enough data selected to make a graph"
