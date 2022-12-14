#' @title Proxy-Scalor that Scales According to its Configuration parameter
#'
#' @include Scalor.R
#'
#' @name dict_scalors_proxy
#'
#' @description
#' [`Scalor`] that performs the operation in its `operation` configuration parameter. This is useful, e.g., to make
#' [`SelectorBest`]'s operation fully parametrizable.
#'
#' @section Configuration Parameters:
#' * `operation` :: [`Scalor`]\cr
#'   Operation to perform. Initialized to [`ScalorSingleObjective`].
#'   This is primed when `$prime()` of `ScalorProxy` is called, and also when `$operate()` is called, to make changing
#'   the operation as part of self-adaption possible. However, if the same operation gets used inside multiple `ScalorProxy`
#'   objects, then it is recommended to `$clone(deep = TRUE)` the object before assigning them to `operation` to avoid
#'   frequent re-priming.
#'
#' @templateVar id proxy
#' @template autoinfo_prepare_scl
#' @template autoinfo_operands
#' @template autoinfo_dict
#'
#' @family scalors
#' @family scalor wrappers
#' @examples
#' set.seed(1)
#' sp = scl("proxy")
#' p = ps(x = p_dbl(-5, 5))
#' # dummy data; note that ScalorOne does not depend on data content
#' data = data.frame(x = rep(0, 5))
#' fitnesses = c(1, 5, 2, 3, 0)
#'
#' sp$param_set$values$operation = scl("one")
#' sp$prime(p)
#' sp$operate(data, fitnesses)
#'
#' @export
ScalorProxy = R6Class("ScalorProxy",
  inherit = Scalor,
  public = list(
    #' @description
    #' Initialize the `ScalorProxy` object.
    initialize = function() {
      param_set = ps(operation = p_uty(custom_check = crate(function(x) check_r6(x, "Scalor"))))
      param_set$values = list(operation = ScalorSingleObjective$new())
      # call initialization with standard options: allow everything etc.
      super$initialize(param_set = param_set, dict_entry = "proxy")
    },
    #' @description
    #' See [`MiesOperator`] method. Primes both this operator, as well as the operator given to the `operation` configuration parameter.
    #'   Note that this modifies the `$param_set$values$operation` object.
    #' @param param_set ([`ParamSet`][paradox::ParamSet])\cr
    #'   Passed to [`MiesOperator`]`$prime()`.
    #' @return [invisible] `self`.
    prime = function(param_set) {
      operation = self$param_set$get_values()$operation
      operation$prime(param_set)
      super$prime(param_set)
      private$.primed_with = operation$primed_ps  # keep uncloned copy of configuration parameter value for check in `.select()`
      ######### the following may be necessary for context dependent params

      ## primed_with = self$param_set$values$operation
      ## super$prime(param_set)
      ## if (inherits(primed_with, "MiesOperator")) {
      ##   # if primed_with is context-dependent then we need to prime during operation.
      ##   operation = primed_with$clone(deep = TRUE)
      ##   operation$prime(param_set)
      ##   private$.primed_with = primed_with  # keep uncloned copy of configuration parameter value for check in `.select()`
      ## }
      invisible(self)
    }
  ),
  private = list(
    .scale = function(values, fitnesses) {
      operation = self$param_set$get_values()$operation
      if (is.null(private$.primed_with) || !identical(operation$primed_ps, private$.primed_with)) {
        # Unfortunately, when we clone, we can't keep track of self$param_set$values$operation.
        # In that case we try to stay safe by priming again.
        operation$prime(private$.primed_ps)
        private$.primed_with = operation$primed_ps
      }
      operation$operate(values, fitnesses)
    },
    .primed_with = NULL,
    deep_clone = function(name, value) {
      if (name == ".primed_with") return(NULL)  # don't even bother cloning this
      super$deep_clone(name, value)
    }
  )
)
dict_scalors$add("proxy", ScalorProxy)
