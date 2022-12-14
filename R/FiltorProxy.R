#' @title Proxy-Filtor that Filters According to its Configuration Parameter
#'
#' @include Filtor.R
#'
#' @name dict_filtors_proxy
#'
#' @description
#' Filtor that performs the operation in its `operation` configuration parameter. This can be used to make filtor operations fully parametrizable.
#'
#' @section Configuration Parameters:
#' * `operation` :: [`Filtor`]\cr
#'   Operation to perform. Must be set by the user.
#'   This is primed when `$prime()` of `SelectorProxy` is called, and also when `$operate()` is called, to make changing
#'   the operation as part of self-adaption possible. However, if the same operation gets used inside multiple `SelectorProxy`
#'   objects, then it is recommended to `$clone(deep = TRUE)` the object before assigning them to `operation` to avoid
#'   frequent re-priming.
#'
#' @templateVar id proxy
#' @template autoinfo_prepare_sel
#' @template autoinfo_operands
#' @template autoinfo_dict
#'
#' @family filtors
#' @family filtor wrappers
#' @examples
#' library("mlr3")
#' library("mlr3learners")
#' fp = ftr("proxy")
#' p = ps(x = p_dbl(-5, 5))
#' known_data = data.frame(x = 1:5)
#' fitnesses = 1:5
#' new_data = data.frame(x = c(2.5, 4.5))
#'
#' fp$param_set$values$operation = ftr("null")
#' fp$prime(p)
#' fp$operate(new_data, known_data, fitnesses, 1)
#'
#' fp$param_set$values$operation = ftr("surprog", lrn("regr.lm"), filter.pool_factor = 2)
#' fp$operate(new_data, known_data, fitnesses, 1)
#' @export
FiltorProxy = R6Class("FiltorProxy",
  inherit = Filtor,
  public = list(
    #' @description
    #' Initialize the `FiltorProxy` object.
    initialize = function() {
      param_set = ps(operation = p_uty(custom_check = crate(function(x) check_r6(x, "Filtor")), tags = "required"))
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
    .filter = function(values, known_values, fitnesses, n_filter) {
      operation = self$param_set$get_values()$operation
      if (is.null(private$.primed_with) || !identical(operation$primed_ps, private$.primed_with)) {
        # Unfortunately, when we clone, we can't keep track of self$param_set$values$operation.
        # In that case we try to stay safe by priming again.
        # Note: this is never actually executed in the current setup, because .needed_input runs first.
        operation$prime(private$.primed_ps)  # nocov
        private$.primed_with = operation$primed_ps  # nocov
      }
      operation$operate(values, known_values, fitnesses, n_filter)
    },
    .needed_input = function(output_size) {
      operation = self$param_set$get_values()$operation
      if (is.null(private$.primed_with) || !identical(operation$primed_ps, private$.primed_with)) {
        # Unfortunately, when we clone, we can't keep track of self$param_set$values$operation.
        # In that case we try to stay safe by priming again.
        operation$prime(private$.primed_ps)
        private$.primed_with = operation$primed_ps
      }
      operation$needed_input(output_size)
    },
    .primed_with = NULL,
    deep_clone = function(name, value) {
      if (name == ".primed_with") return(NULL)  # don't even bother cloning this
      super$deep_clone(name, value)
    }
  )
)
dict_filtors$add("proxy", FiltorProxy)
