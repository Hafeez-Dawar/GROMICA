#' Export Plot
#'
#' @param plot ggplot2 object
#' @param filename Output filename
#' @param width Width in inches (default: 8)
#' @param height Height in inches (default: 6)
#' @param dpi Resolution (default: 300, max: 1200)
#' @return NULL
#' @export
#' @importFrom ggplot2 ggsave
export_plot <- function(plot, filename, width = 8, height = 6, dpi = 300) {
  if (dpi > 1200) {
    warning("DPI capped at 1200 to prevent huge file sizes")
    dpi <- 1200
  }
  ggplot2::ggsave(filename, plot, width = width, height = height, dpi = dpi)
  cat("Plot saved to:", filename, "\n")
}
