test_that("get_commits returns a tibble with expected columns", {
  skip_if_offline()
  skip_on_cran()

  commits <- get_commits("mahmudstat/clockplot", n = 5)

  # basic structure
  expect_s3_class(commits, "tbl_df")
  expect_true(all(c("sha", "author", "date", "message") %in% names(commits)))

  # row count within expected range
  expect_true(nrow(commits) <= 5)
})

test_that("get_commits respects from/to filters", {
  skip_if_offline()
  skip_on_cran()

  commits <- get_commits(
    "mahmudstat/clockplot",
    from = "2025-07-01",
    to   = "2025-09-02"
  )

  # date range check
  expect_true(all(as.Date(commits$date) >= as.Date("2025-07-01")))
  expect_true(all(as.Date(commits$date) <= as.Date("2025-09-02")))
})
