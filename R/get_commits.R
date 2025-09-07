#' Get recent commits from a GitHub repository
#'
#' @param repo Character. Repository in "user/repo" format, e.g., "mahmudstat/clockplot".
#' @param n Integer. Maximum number of commits to fetch. Default 100.
#' @param branch Character. Branch name. Default "main".
#' @param from Character or Date. Optional start date (ISO 8601 or "YYYY-MM-DD").
#' @param to Character or Date. Optional end date (ISO 8601 or "YYYY-MM-DD").
#' @return A tibble with columns: sha, author, date-time (UTC), message
#' @export
#' @examples
#' get_commits("mahmudstat/clockplot", n = 20, from = "2025-07-01", to = "2025-09-02")
get_commits <- function(repo, n = 100, branch = "main", from = NULL, to = NULL) {
  if (!requireNamespace("gh", quietly = TRUE)) {
    stop("Package 'gh' is required. Please install it first.")
  }
  if (!requireNamespace("tibble", quietly = TRUE)) {
    stop("Package 'tibble' is required. Please install it first.")
  }

  # Split repo into owner and repo name
  repo_split <- strsplit(repo, "/")[[1]]
  if (length(repo_split) != 2) stop("Repo must be in 'owner/repo' format.")
  owner <- repo_split[1]
  repo_name <- repo_split[2]

  # Build query parameters
  params <- list(
    sha = branch,
    per_page = min(n, 100) # GitHub API limit
  )
  if (!is.null(from)) params$since <- as.character(from)
  if (!is.null(to)) params$until <- as.character(to)

  # Fetch commits
  commits <- gh::gh("/repos/{owner}/{repo}/commits",
                    owner = owner,
                    repo  = repo_name,
                    .params = params)

  # Limit to n most recent
  commits <- commits[1:min(length(commits), n)]

  # Extract relevant info
  tibble::tibble(
    author = vapply(commits, function(x) x$commit$author$name, character(1)),
    date = as.POSIXct(
      vapply(commits, function(x) x$commit$author$date, character(1)),
      format = "%Y-%m-%dT%H:%M:%SZ",
      tz = "UTC"
    ),
    message = vapply(commits, function(x) x$commit$message, character(1)),
    sha = vapply(commits, function(x) x$sha, character(1))
  )
}
