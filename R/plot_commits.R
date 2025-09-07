#' Plot GitHub commits as clock or line chart
#'
#' @param df Data frame from get_commits(), must contain datetime column `date` or `dttm`
#' @param crit Character. Column name to group/colour by (default "author")
#' @param type Character. "clock" or "line" (default "clock")
#' @return ggplot object
#' @export
#' @examples
#' \dontrun{
#' library(getcommit)
#' library(clockplot)
#'
#' # Fetch the most recent 50 commits from tidyverse/dplyr
#' comm <- get_commits("tidyverse/dplyr", n = 50)
#'
#' # Plot as clockplot grouped by author
#' plot_commits(comm, crit = "author", type = "clock")
#'
#' # Plot as line chart grouped by author
#' plot_commits(comm, type = "line")
#' }
plot_commits <- function(df, crit = "author", type = "clock") {
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("dplyr required")
  if (!requireNamespace("hms", quietly = TRUE)) stop("hms required")
  if (!requireNamespace("clockplot", quietly = TRUE)) stop("clockplot required")

  df <- df %>%
    dplyr::mutate(hms = hms::as_hms(date))

  crit_sym <- rlang::ensym(crit)
  crit_title <- tools::toTitleCase(crit)  # convert to title case

  if (type == "clock") {
    clockplot::clock_chart_qlt(df, time = hms, crit = !!crit_sym) +
      ggplot2::labs(color = crit_title)  # set legend title
  } else if (type == "line") {
    df %>%
      dplyr::mutate(hour = as.numeric(format(date, "%H"))) %>%
      dplyr::count(!!crit_sym, hour) %>%
      ggplot2::ggplot(ggplot2::aes(x = hour, y = n, fill = !!crit_sym)) +
      ggplot2::geom_bar(stat = "identity") +
      ggplot2::labs(x = "Hour of day", y = "Number of commits", color = crit_title)
  } else {
    stop("Invalid type: must be 'clock' or 'line'")
  }
}
