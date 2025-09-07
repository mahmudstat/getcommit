#' Get recent commits from a GitHub repository
#'
#' @param repo Character. Repository in "user/repo" format, e.g., "mahmudstat/clockplot".
#' @param n Integer. Maximum number of commits to fetch. Default 100.
#' @param branch Character. Branch name. Default "main".
#' @param from Character or Date. Optional start date (ISO 8601 or "YYYY-MM-DD").
#' @param to Character or Date. Optional end date (ISO 8601 or "YYYY-MM-DD").
#' @return A tibble with columns: sha, author, date, message
#' @export
get_commits <- function(repo, n = 100, branch = "main", from = NULL, to = NULL) {
  if (!requireNamespace("gh", quietly = TRUE)) {
    stop("Package 'gh' is required. Please install it first.")
  }
  if (!requireNamespace("tibble", quietly = TRUE)) {
    stop("Package 'tibble' is required. Please install it first.")
  }

  # Build query parameters
  params <- list(
    sha = branch,
    per_page = min(n, 100) # GitHub API limits per page to 100
  )

  if (!is.null(from)) params$since <- as.character(from)
  if (!is.null(to)) params$until <- as.character(to)

  # Fetch commits
  commits <- gh::gh("/repos/{owner}/{repo}/commits",
                    owner = strsplit(repo, "/")[[1]][1],
                    repo  = strsplit(repo, "/")[[1]][2],
                    .params = params)

  # Limit to `n` most recent
  commits <- commits[1:min(length(commits), n)]

  # Extract relevant info
  tibble::tibble(
    sha = vapply(commits, function(x) x$sha, character(1)),
    author = vapply(commits, function(x) x$commit$author$name, character(1)),
    date = as.POSIXct(vapply(commits, function(x) x$commit$author$date, character(1)), tz = "UTC"),
    message = vapply(commits, function(x) x$commit$message, character(1))
  )
}
