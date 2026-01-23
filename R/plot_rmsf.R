#' Plot RMSF Analysis
#'
#' Create publication-quality Root Mean Square Fluctuation (RMSF) plots
#' from GROMACS trajectory analysis.
#'
#' @param data Data frame from read_xvg() containing residue and RMSF values.
#' @param color Character. Line color (default: "red").
#' @param title Character. Plot title (default: "RMSF Analysis").
#' @param highlight_residues Numeric vector. Residues to highlight (default: NULL).
#'
#' @return A ggplot2 object.
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text
#'
#' @examples
#' \dontrun{
#' # Basic RMSF plot
#' data <- read_xvg("md_rmsf.xvg", col.names = c("Residue", "RMSF"))
#' p <- plot_rmsf(data)
#' print(p)
#' }
#'
plot_rmsf <- function(data,
                      color = "red",
                      title = "RMSF Analysis",
                      highlight_residues = NULL) {
  
  # Validate input
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }
  
  if (ncol(data) < 2) {
    stop("Data must have at least 2 columns (Residue and RMSF)")
  }
  
  # Rename columns
  colnames(data)[1:2] <- c("Residue", "Value")
  
  # Create base plot
  p <- ggplot2::ggplot(data, ggplot2::aes(x = Residue, y = Value)) +
    ggplot2::geom_line(color = color, linewidth = 1) +
    ggplot2::labs(title = title,
                  x = "Residue Number",
                  y = "RMSF (nm)") +
    ggplot2::theme_classic(base_size = 14) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, face = "bold", size = 16),
      axis.title = ggplot2::element_text(face = "bold"),
      axis.text = ggplot2::element_text(color = "black")
    )
  
  return(p)
}
