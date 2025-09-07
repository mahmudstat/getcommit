#' Summarize commit activity
#'
#' Aggregates commit counts by one or more grouping variables.
#'
#' @param df A tibble returned by [get_commits()].
#' @param by A character vector specifying grouping variables.
#'   Choices are `"author"`, `"year"`, `"month"`, `"day"`, or `"hour"`.
#'
#' @return A tibble with counts per group.
#'
#' @examples
#' \dontrun{
#' comm <- get_commits("tidyverse/dplyr", n = 50)
#' summarize_commits(comm, by = "author")
#' summarize_commits(comm, by = c("author", "year"))
#' }
#'
#' @export
summarize_commits <- function(df, by = c("author", "year", "month", "day", "hour")) {
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("dplyr required")
  if (!requireNamespace("lubridate", quietly = TRUE)) stop("lubridate required")

  valid <- c("author", "year", "month", "day", "hour")
  by <- match.arg(by, choices = valid, several.ok = TRUE)

  df <- dplyr::as_tibble(df)

  # add date-based fields as needed
  if ("year" %in% by) {
    df <- dplyr::mutate(df, year = lubridate::year(date))
  }
  if ("month" %in% by) {
    df <- dplyr::mutate(df, month = lubridate::month(date, label = TRUE, abbr = TRUE))
  }
  if ("day" %in% by) {
    df <- dplyr::mutate(df, day = lubridate::day(date))
  }
  if ("hour" %in% by) {
    df <- dplyr::mutate(df, hour = lubridate::hour(date))
  }

  df %>%
    dplyr::group_by(dplyr::across(dplyr::all_of(by))) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    dplyr::arrange(dplyr::across(dplyr::all_of(by)))
}
