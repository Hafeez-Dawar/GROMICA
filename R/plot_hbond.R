#' Plot Hydrogen Bonds
#'
#' @param data Data frame with Time and Hbond columns
#' @param color Line color (default: "darkblue")
#' @param title Plot title (default: "Hydrogen Bond Analysis")
#' @param show_stats Show statistics overlay (default: FALSE)
#' @param xlab X-axis label (default: "Time (ns)")
#' @param ylab Y-axis label (default: "Number of H-bonds")
#' @return ggplot2 object
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text annotate
plot_hbond <- function(data, color = "darkblue", title = "Hydrogen Bond Analysis", show_stats = FALSE, xlab = "Time (ns)", ylab = "Number of H-bonds") {
  if (ncol(data) < 2) stop("Data must have at least 2 columns")
  colnames(data)[1:2] <- c("Time", "Hbonds")
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Time, y = Hbonds)) +
    ggplot2::geom_line(color = color, linewidth = 1) +
    ggplot2::labs(title = title, x = xlab, y = ylab) +
    ggplot2::theme_classic() +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 14, face = "bold"))
  if (show_stats) {
    stats_text <- sprintf("Mean: %.1f\nSD: %.1f", mean(data$Hbonds, na.rm = TRUE), sd(data$Hbonds, na.rm = TRUE))
    p <- p + ggplot2::annotate("text", x = max(data$Time) * 0.75, y = max(data$Hbonds) * 0.95, label = stats_text, hjust = 0, vjust = 1)
  }
  return(p)
}
