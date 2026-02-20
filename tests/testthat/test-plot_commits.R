library(testthat)
library(getcommit)
library(clockplot)
library(ggplot2)
library(dplyr)
library(hms)

test_that("plot_commits works for both clock and bar types", {
  comm <- tibble::tibble(
    date = as.POSIXct(c("2025-09-02 08:30:00", "2025-09-02 12:45:00"), tz = "UTC"),
    author = c("Alice", "Bob")
  )

  # Clock plot
  p_clock <- plot_commits(comm, type = "clock")
  expect_s3_class(p_clock, "ggplot")
  expect_true("colour" %in% names(p_clock$mapping) || "colour" %in% unlist(lapply(p_clock$layers, function(l) names(l$mapping))))
  expect_equal(p_clock$labels$color %||% p_clock$labels$colour, "Author")

  # Bar plot
  p_bar <- plot_commits(comm, type = "bar")
  expect_s3_class(p_bar, "ggplot")
  layer_types <- sapply(p_bar$layers, function(x) class(x$geom)[1])
  expect_true(any(layer_types == "GeomBar"))
  expect_equal(p_bar$labels$y, "Number of commits")
  expect_equal(p_bar$labels$fill, "Author")

  expect_error(plot_commits(comm, type = "invalid"), "Invalid type")
})
