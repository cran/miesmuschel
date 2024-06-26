% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mies_methods.R
\name{mies_get_fitnesses}
\alias{mies_get_fitnesses}
\title{Get Fitness Values from OptimInstance}
\usage{
mies_get_fitnesses(inst, rows)
}
\arguments{
\item{inst}{(\code{OptimInstance})\cr
Optimization instance to evaluate.}

\item{rows}{optional (\code{integer})\cr
Indices of rows within \code{inst} to consider. If this is not given, then the entire archive is used.}
}
\value{
\code{numeric} \code{matrix} with \code{length(rows)} (if \code{rows} is given, otherwise \code{nrow(inst$archive$data)}) rows
and one column for each objective: fitnesses to be maximized.
}
\description{
Get fitness values in the correct form as used by \code{\link{Selector}} operators from an
\code{OptimInstance}.
This works for both single-criterion and multi-criterion optimization, and entails multiplying
objectives with -1 if they are being minimized, since \code{\link{Selector}} tries to maximize fitness.
}
\examples{
set.seed(1)
library("bbotk")
lgr::threshold("warn")

# Define the objective to optimize
objective <- ObjectiveRFun$new(
  fun = function(xs) {
    z <- exp(-xs$x^2 - xs$y^2) + 2 * exp(-(2 - xs$x)^2 - (2 - xs$y)^2)
    list(Obj = z)
  },
  domain = ps(x = p_dbl(-2, 4), y = p_dbl(-2, 4)),
  codomain = ps(Obj = p_dbl(tags = "maximize"))
)

# Get a new OptimInstance
oi <- OptimInstanceSingleCrit$new(objective,
  terminator = trm("evals", n_evals = 100)
)

mies_init_population(inst = oi, mu = 3)

oi$archive

mies_get_fitnesses(oi, c(2, 3))

###
# Multi-objective, and automatic maximization:
objective2 <- ObjectiveRFun$new(
  fun = function(xs) list(Obj1 = xs$x^2, Obj2 = -xs$y^2),
  domain = ps(x = p_dbl(-2, 4), y = p_dbl(-2, 4)),
  codomain = ps(
    Obj1 = p_dbl(tags = "minimize"),
    Obj2 = p_dbl(tags = "maximize")
  )
)
# Using MultiCrit!
oi <- OptimInstanceMultiCrit$new(objective2,
  terminator = trm("evals", n_evals = 100)
)

mies_init_population(inst = oi, mu = 3)

oi$archive

# Note Obj1 has a different sign than in the archive.
mies_get_fitnesses(oi, c(2, 3))

}
\seealso{
Other mies building blocks: 
\code{\link{mies_evaluate_offspring}()},
\code{\link{mies_generate_offspring}()},
\code{\link{mies_init_population}()},
\code{\link{mies_select_from_archive}()},
\code{\link{mies_step_fidelity}()},
\code{\link{mies_survival_comma}()},
\code{\link{mies_survival_plus}()}
}
\concept{mies building blocks}
