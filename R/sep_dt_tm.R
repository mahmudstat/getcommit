#' Separate datetime into date and time columns
#'
#' @param df A data frame containing a datetime column (POSIXct) named 'dttm'
#' @param datetime_col Name of the datetime column, default 'dttm'
#' @return Data frame with separate 'dt' (Date) and 'tm' (hms) columns
#' @examples
#' comm <- get_commits("tidyverse/dplyr", n = 10)
#' comm2 <- sep_dt_tm(comm)
#' @export
sep_dt_tm <- function(df, datetime_col = "date") {
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("dplyr is required")
  if (!requireNamespace("hms", quietly = TRUE)) stop("hms is required")

  datetime_col <- rlang::ensym(datetime_col)

  df %>%
    dplyr::mutate(
      dt = as.Date(!!datetime_col),
      tm = hms::as_hms(!!datetime_col)
    )
}
