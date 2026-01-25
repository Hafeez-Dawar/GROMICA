#' Read GROMACS XVG Files
#'
#' @param file Path to XVG file
#' @param skip Number of header lines to skip (default: NULL for auto-detect)
#' @param col.names Column names (default: NULL for auto-generate)
#' @return Data frame with time and value columns
#' @export
read_xvg <- function(file, skip = NULL, col.names = NULL) {
  if (!file.exists(file)) {
    stop(paste("File not found:", file))
  }
  all_lines <- readLines(file, warn = FALSE)
  data_lines <- all_lines[!grepl("^[@#]", all_lines)]
  data_lines <- data_lines[nzchar(trimws(data_lines))]
  if (length(data_lines) == 0) {
    stop("No data found in file")
  }
  first_line <- strsplit(trimws(data_lines[1]), "\\s+")[[1]]
  n_cols <- length(first_line)
  if (is.null(col.names)) {
    col.names <- if (n_cols == 2) c("Time", "Value") else paste0("V", 1:n_cols)
  }
  temp_conn <- textConnection(data_lines)
  data <- read.table(temp_conn, col.names = col.names, colClasses = "numeric", fill = TRUE)
  close(temp_conn)
  data <- data[complete.cases(data), ]
  rownames(data) <- NULL
  return(data)
}
