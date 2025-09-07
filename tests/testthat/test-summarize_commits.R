# tests/testthat/test-summarize_commits.R

library(testthat)
library(getcommit)
library(dplyr)

test_that("summarize_commits aggregates correctly", {
  # Create a fake commits tibble
  comm <- tibble::tibble(
    sha = letters[1:6],
    author = c("Alice", "Bob", "Alice", "Bob", "Alice", "Charlie"),
    date = as.POSIXct(c(
      "2025-09-01 10:00", "2025-09-01 11:00", "2025-09-02 10:30",
      "2025-09-02 12:00", "2025-09-03 09:00", "2025-09-03 14:00"
    ), tz = "UTC")
  )

  # By author only
  res_author <- summarize_commits(comm, by = "author")
  expect_s3_class(res_author, "tbl_df")
  expect_equal(res_author$author, c("Alice", "Bob", "Charlie"))
  expect_equal(res_author$n, c(3, 2, 1))

  # By author and day
  res_author_day <- summarize_commits(comm, by = c("author", "day"))
  expect_s3_class(res_author_day, "tbl_df")
  expect_true(all(c("author", "day", "n") %in% colnames(res_author_day)))

  # By year and month
  res_ym <- summarize_commits(comm, by = c("year", "month"))
  expect_s3_class(res_ym, "tbl_df")
  expect_true(all(c("year", "month", "n") %in% colnames(res_ym)))

  # Invalid `by` should throw error
  expect_error(summarize_commits(comm, by = "invalid"))
})
