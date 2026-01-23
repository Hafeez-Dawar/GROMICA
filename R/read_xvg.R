#' Read GROMACS XVG Files
#'
#' Imports XVG files from GROMACS molecular dynamics simulations.
#' Automatically handles comment lines (starting with # or @).
#'
#' @param file Path to the XVG file
#' @param skip Number of header lines to skip (default: 17, auto-detected if NULL)
#' @param col.names Column names (default: NULL, auto-generates "Time" and "Value")
#'
#' @return A data frame with time and value columns
#'
#' @examples
#' \dontrun{
#' data <- read_xvg("md_rmsd.xvg")
#' data <- read_xvg("rmsf.xvg", col.names = c("Residue", "RMSF"))
#' }
#'
#' @export
read_xvg <- function(file, skip = NULL, col.names = NULL) {
  
  # Check if file exists
  if (!file.exists(file)) {
    stop(paste("File not found:", file))
  }
  
  # Read all lines from file
  all_lines <- readLines(file, warn = FALSE)
  
  # Filter out comment lines (lines starting with # or @)
  data_lines <- all_lines[!grepl("^[@#]", all_lines)]
  
  # Remove empty lines
  data_lines <- data_lines[nzchar(trimws(data_lines))]
  
  if (length(data_lines) == 0) {
    stop("No data found in file (only comments)")
  }
  
  # Parse the first data line to detect number of columns
  first_line <- strsplit(trimws(data_lines[1]), "\\s+")[[1]]
  n_cols <- length(first_line)
  
  # Set column names
  if (is.null(col.names)) {
    if (n_cols == 2) {
      col.names <- c("Time", "Value")
    } else {
      col.names <- paste0("V", 1:n_cols)
    }
  } else if (length(col.names) != n_cols) {
    warning(paste("Number of column names (", length(col.names), 
                  ") doesn't match number of columns (", n_cols, 
                  "). Using default names."))
    col.names <- paste0("V", 1:n_cols)
  }
  
  # Write data lines to a temporary connection and read as table
  temp_conn <- textConnection(data_lines)
  data <- read.table(temp_conn, 
                     col.names = col.names,
                     colClasses = "numeric",
                     fill = TRUE)
  close(temp_conn)
  
  # Remove rows with all NA values
  data <- data[complete.cases(data), ]
  
  # Reset row names
  rownames(data) <- NULL
  
  return(data)
}
