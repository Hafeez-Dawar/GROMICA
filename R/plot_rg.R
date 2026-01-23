#' Plot Radius of Gyration
#'
#' Creates a publication-quality plot of radius of gyration data from GROMACS simulations.
#'
#' @param data A data frame with at least two columns (Time and Rg values)
#' @param color Line color (default: "green")
#' @param title Plot title (default: "Radius of Gyration Analysis")
#' @param show_stats Logical, whether to display statistics (mean, SD, min, max) on the plot (default: FALSE)
#' @param xlab X-axis label (default: "Time (ps)")
#' @param ylab Y-axis label (default: "Rg (nm)")
#'
#' @return A ggplot2 object
#'
#' @examples
#' \dontrun{
#' rg_data <- read_xvg("gyrate.xvg")
#' plot_rg(rg_data, color = "green", show_stats = TRUE)
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text annotate
plot_rg <- function(data, 
                    color = "green", 
                    title = "Radius of Gyration Analysis",
                    show_stats = FALSE,
                    xlab = "Time (ps)",
                    ylab = "Rg (nm)") {
  
  # Check if data has at least 2 columns
  if (ncol(data) < 2) {
    stop("Data must have at least 2 columns (Time and Rg)")
  }
  
  # Rename columns for consistency
  colnames(data)[1:2] <- c("Time", "Rg")
  
  # Create base plot
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Time, y = Rg)) +
    ggplot2::geom_line(color = color, linewidth = 1) +
    ggplot2::labs(
      title = title,
      x = xlab,
      y = ylab
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.title = ggplot2::element_text(size = 12),
      axis.text = ggplot2::element_text(size = 10)
    )
  
  # Add statistics if requested
  if (show_stats) {
    mean_rg <- mean(data$Rg, na.rm = TRUE)
    sd_rg <- sd(data$Rg, na.rm = TRUE)
    min_rg <- min(data$Rg, na.rm = TRUE)
    max_rg <- max(data$Rg, na.rm = TRUE)
    
    stats_text <- sprintf(
      "Mean: %.3f nm\nSD: %.3f nm\nMin: %.3f nm\nMax: %.3f nm",
      mean_rg, sd_rg, min_rg, max_rg
    )
    
    p <- p + ggplot2::annotate(
      "text",
      x = max(data$Time) * 0.75,
      y = max(data$Rg) * 0.95,
      label = stats_text,
      hjust = 0,
      vjust = 1,
      size = 3.5,
      color = "black",
      fontface = "italic"
    )
  }
  
  return(p)
}
