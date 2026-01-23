#' Plot Solvent Accessible Surface Area (SASA)
#'
#' Creates a publication-quality plot of SASA data from GROMACS simulations.
#'
#' @param data A data frame with at least two columns (Time and SASA values)
#' @param color Line color (default: "purple")
#' @param title Plot title (default: "SASA Analysis")
#' @param show_stats Logical, whether to display statistics (mean, SD, min, max) on the plot (default: FALSE)
#' @param xlab X-axis label (default: "Time (ps)")
#' @param ylab Y-axis label (default: "SASA (nm²)")
#'
#' @return A ggplot2 object
#'
#' @examples
#' \dontrun{
#' sasa_data <- read_xvg("sasa.xvg")
#' plot_sasa(sasa_data, color = "purple", show_stats = TRUE)
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text annotate
plot_sasa <- function(data, 
                      color = "purple", 
                      title = "SASA Analysis",
                      show_stats = FALSE,
                      xlab = "Time (ps)",
                      ylab = "SASA (nm²)") {
  
  # Check if data has at least 2 columns
  if (ncol(data) < 2) {
    stop("Data must have at least 2 columns (Time and SASA)")
  }
  
  # Rename columns for consistency
  colnames(data)[1:2] <- c("Time", "SASA")
  
  # Create base plot
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Time, y = SASA)) +
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
    mean_sasa <- mean(data$SASA, na.rm = TRUE)
    sd_sasa <- sd(data$SASA, na.rm = TRUE)
    min_sasa <- min(data$SASA, na.rm = TRUE)
    max_sasa <- max(data$SASA, na.rm = TRUE)
    
    stats_text <- sprintf(
      "Mean: %.2f nm²\nSD: %.2f nm²\nMin: %.2f nm²\nMax: %.2f nm²",
      mean_sasa, sd_sasa, min_sasa, max_sasa
    )
    
    p <- p + ggplot2::annotate(
      "text",
      x = max(data$Time) * 0.75,
      y = max(data$SASA) * 0.95,
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
