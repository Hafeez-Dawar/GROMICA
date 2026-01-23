#' Plot RMSD Analysis
#'
#' Create publication-quality Root Mean Square Deviation (RMSD) plots
#' from GROMACS trajectory analysis.
#'
#' @param data Data frame from read_xvg() containing time and RMSD values.
#' @param color Character. Line color (default: "blue").
#' @param title Character. Plot title (default: "RMSD Analysis").
#' @param show_stats Logical. Show statistics on plot (default: FALSE).
#'
#' @return A ggplot2 object.
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text annotate
#'
#' @examples
#' \dontrun{
#' # Basic RMSD plot
#' data <- read_xvg("md_rmsd.xvg")
#' p <- plot_rmsd(data)
#' print(p)
#'
#' # With statistics
#' p <- plot_rmsd(data, show_stats = TRUE)
#' print(p)
#' }
#'
plot_rmsd <- function(data, 
                      color = "blue",
                      title = "RMSD Analysis",
                      show_stats = FALSE) {
  
  # Validate input
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }
  
  if (ncol(data) < 2) {
    stop("Data must have at least 2 columns (Time and Value)")
  }
  
  # Rename columns for consistency
  colnames(data)[1:2] <- c("Time", "Value")
  
  # Create base plot
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Time, y = Value)) +
    ggplot2::geom_line(color = color, linewidth = 1) +
    ggplot2::labs(title = title,
                  x = "Time (ps)",
                  y = "RMSD (nm)") +
    ggplot2::theme_classic(base_size = 14) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", size = 16),
      axis.title = ggplot2::element_text(face = "bold"),
      axis.text = ggplot2::element_text(color = "black")
    )
  
  # Add statistics if requested
  if (show_stats) {
    stats_text <- sprintf(
      "Mean: %.3f nm\nSD: %.3f nm\nMin: %.3f nm\nMax: %.3f nm",
      mean(data$Value), sd(data$Value), 
      min(data$Value), max(data$Value)
    )
    
    p <- p + ggplot2::annotate("text", 
                               x = max(data$Time) * 0.7,
                               y = max(data$Value) * 0.9,
                               label = stats_text,
                               hjust = 0,
                               size = 3.5,
                               fontface = "italic")
  }
  
  return(p)
}
