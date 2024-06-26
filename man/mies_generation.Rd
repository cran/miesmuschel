% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mies_methods.R
\name{mies_generation}
\alias{mies_generation}
\title{Get the Last Generation that was Evaluated}
\usage{
mies_generation(inst)
}
\arguments{
\item{inst}{(\code{OptimInstance})\cr
Optimization instance to evaluate.}
}
\value{
a scalar integer value indicating the last generation that was evaluated in \code{inst}. It is 0 when \code{inst} is empty, and also typically 0 if all evaluations
in \code{inst} so far were performed outside of \code{miesmuschel}. Every call of \code{\link{mies_init_population}} that actually performs evaluations, as well as each call to
\code{\link{mies_evaluate_offspring}} with non-empty \code{offspring}, increases the generation by 1.
}
\description{
Gets the last generation that was evaluated as counted by the \code{"dob"} column in the \code{OptimInstance}'s \code{\link[bbotk:Archive]{Archive}}.

This accepts \code{OptimInstance}s that were not evaluated with \code{miesmuschel} and are therefore missing the \code{"dob"} column, returning
a value of 0. However, if the \code{"dob"} column is invalid (the inferred generation is not integer numeric or not non-negative), an error is thrown.
}
\examples{
library("bbotk")
lgr::threshold("warn")

# Define the objective to optimize
objective <- ObjectiveRFun$new(
  fun = function(xs) {
    z <- 10 - exp(-xs$x^2 - xs$y^2) + 2 * exp(-(2 - xs$x)^2 - (2 - xs$y)^2)
    list(Obj = z)
  },
  domain = ps(x = p_dbl(-2, 4), y = p_dbl(-2, 4)),
  codomain = ps(Obj = p_dbl(tags = "minimize"))
)

oi <- OptimInstanceSingleCrit$new(objective,
  terminator = trm("evals", n_evals = 6)
)

op <- opt("mies",
  lambda = 2, mu = 2,
  mutator = mut("gauss", sdev = 0.1),
  recombinator = rec("xounif"),
  parent_selector = sel("best")
)
set.seed(1)

mies_generation(oi)

op$optimize(oi)
mies_generation(oi)

oi$terminator = trm("evals", n_evals = 10)

op$optimize(oi)
mies_generation(oi)
}
