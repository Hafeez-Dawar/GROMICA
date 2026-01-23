#' Plot Hydrogen Bonds
#'
#' Creates a publication-quality plot of hydrogen bond analysis from GROMACS simulations.
#'
#' @param data A data frame with at least two columns (Time and H-bond count)
#' @param color Line color (default: "darkblue")
#' @param title Plot title (default: "Hydrogen Bond Analysis")
#' @param show_stats Logical, whether to display statistics (mean, SD, min, max) on the plot (default: FALSE)
#' @param xlab X-axis label (default: "Time (ps)")
#' @param ylab Y-axis label (default: "Number of H-bonds")
#'
#' @return A ggplot2 object
#'
#' @examples
#' \dontrun{
#' hbond_data <- read_xvg("hbond.xvg")
#' plot_hbond(hbond_data, color = "darkblue", show_stats = TRUE)
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text annotate
plot_hbond <- function(data, 
                       color = "darkblue", 
                       title = "Hydrogen Bond Analysis",
                       show_stats = FALSE,
                       xlab = "Time (ps)",
                       ylab = "Number of H-bonds") {
  
  # Check if data has at least 2 columns
  if (ncol(data) < 2) {
    stop("Data must have at least 2 columns (Time and H-bonds)")
  }
  
  # Rename columns for consistency
  colnames(data)[1:2] <- c("Time", "Hbonds")
  
  # Create base plot
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Time, y = Hbonds)) +
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
    mean_hb <- mean(data$Hbonds, na.rm = TRUE)
    sd_hb <- sd(data$Hbonds, na.rm = TRUE)
    min_hb <- min(data$Hbonds, na.rm = TRUE)
    max_hb <- max(data$Hbonds, na.rm = TRUE)
    
    stats_text <- sprintf(
      "Mean: %.1f\nSD: %.1f\nMin: %.0f\nMax: %.0f",
      mean_hb, sd_hb, min_hb, max_hb
    )
    
    p <- p + ggplot2::annotate(
      "text",
      x = max(data$Time) * 0.75,
      y = max(data$Hbonds) * 0.95,
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
