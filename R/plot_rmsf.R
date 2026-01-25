#' Plot RMSF
#'
#' @param data Data frame with Residue and RMSF columns
#' @param color Line color (default: "red")
#' @param title Plot title (default: "RMSF Analysis")
#' @param show_stats Show statistics overlay (default: FALSE)
#' @param xlab X-axis label (default: "Residue Number")
#' @param ylab Y-axis label (default: "RMSF (nm)")
#' @return ggplot2 object
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text annotate
plot_rmsf <- function(data, color = "red", title = "RMSF Analysis", show_stats = FALSE, xlab = "Residue Number", ylab = "RMSF (nm)") {
  if (ncol(data) < 2) stop("Data must have at least 2 columns")
  colnames(data)[1:2] <- c("Residue", "RMSF")
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Residue, y = RMSF)) +
    ggplot2::geom_line(color = color, linewidth = 1) +
    ggplot2::labs(title = title, x = xlab, y = ylab) +
    ggplot2::theme_classic() +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 14, face = "bold"))
  if (show_stats) {
    stats_text <- sprintf("Mean: %.3f\nSD: %.3f", mean(data$RMSF, na.rm = TRUE), sd(data$RMSF, na.rm = TRUE))
    p <- p + ggplot2::annotate("text", x = max(data$Residue) * 0.75, y = max(data$RMSF) * 0.95, label = stats_text, hjust = 0, vjust = 1)
  }
  return(p)
}
