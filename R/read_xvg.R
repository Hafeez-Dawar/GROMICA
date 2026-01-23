#' Read GROMACS XVG File
#'
#' Import data from GROMACS XVG output files into a data frame.
#' Automatically handles comments and metadata lines.
#'
#' @param file Character. Path to the XVG file.
#' @param skip Integer. Number of header lines to skip (default: 17).
#' @param col.names Character vector. Column names for the data (default: c("Time", "Value")).
#'
#' @return A data frame with columns for time and value(s).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Read RMSD data
#' rmsd_data <- read_xvg("md_rmsd.xvg")
#' head(rmsd_data)
#' }
#'
read_xvg <- function(file, skip = 17, col.names = NULL) {
  
  # Check if file exists
  if (!file.exists(file)) {
    stop("File not found: ", file)
  }
  
  # Read all lines to count columns
  lines <- readLines(file, warn = FALSE)
  data_lines <- lines[!grepl("^[@#]", lines)]
  
  if (length(data_lines) == 0) {
    stop("No data found in file")
  }
  
  # Count columns from first data line
  n_cols <- length(strsplit(data_lines[1], "\\s+")[[1]])
  
  # Set default column names if not provided
  if (is.null(col.names)) {
    if (n_cols == 2) {
      col.names <- c("Time", "Value")
    } else {
      col.names <- c("Time", paste0("V", 1:(n_cols-1)))
    }
  }
  
  # Read data
  data <- read.table(file, 
                     comment.char = c("#", "@"),
                     col.names = col.names,
                     fill = TRUE)
  
  # Remove any NA rows
  data <- data[complete.cases(data), ]
  
  return(data)
}
