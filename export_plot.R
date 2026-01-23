#' Export Plot
#'
#' Save GROMICA plots to file in various formats with customizable resolution.
#'
#' @param plot A ggplot2 plot object.
#' @param filename Character. Output filename with extension (.png, .pdf, .svg).
#' @param width Numeric. Plot width in inches (default: 8).
#' @param height Numeric. Plot height in inches (default: 6).
#' @param dpi Numeric. Resolution in dots per inch (default: 300). Max: 1200.
#'
#' @return Invisibly returns the filename.
#'
#' @export
#' @importFrom ggplot2 ggsave
#'
#' @examples
#' \dontrun{
#' data <- read_xvg("md_rmsd.xvg")
#' p <- plot_rmsd(data)
#' 
#' # Export as high-resolution PNG
#' export_plot(p, "rmsd_plot.png", dpi = 600)
#' 
#' # Export as vector PDF
#' export_plot(p, "rmsd_plot.pdf", width = 10, height = 7)
#' }
#'
export_plot <- function(plot,
                       filename,
                       width = 8,
                       height = 6,
                       dpi = 300) {
  
  # Validate inputs
  if (!inherits(plot, "gg")) {
    stop("Input must be a ggplot2 object")
  }
  
  if (dpi > 1200) {
    warning("DPI > 1200 may result in very large files. Capping at 1200.")
    dpi <- 1200
  }
  
  if (dpi < 72) {
    warning("DPI < 72 may result in low quality. Setting to 72.")
    dpi <- 72
  }
  
  # Save plot
  ggplot2::ggsave(filename = filename,
                  plot = plot,
                  width = width,
                  height = height,
                  dpi = dpi)
  
  message(sprintf("Plot saved successfully: %s", filename))
  message(sprintf("Dimensions: %.1f x %.1f inches, %d DPI", width, height, dpi))
  
  invisible(filename)
}
