source("setup.R", local = TRUE)

library("mlr3misc")

baseclasses = c("Recombinator", "Mutator", "Selector", "Filtor", "Scalor")
dictionaries = list(Mutator = dict_mutators, Recombinator = dict_recombinators, Selector = dict_selectors, Filtor = dict_filtors, Scalor = dict_scalors)
shortformnames = list(Mutator = "mut", Recombinator = "rec", Selector = "sel", Filtor = "ftr", Scalor = "scl")

abstracts = c(baseclasses, "MutatorNumeric", "MutatorDiscrete", "FiltorSurrogate", "RecombinatorPair", "SelectorScalar")
non_op_entries = "xounif"  # entries in dictionaries that are r6-operators
# the constructors of the following don't know about their inheritance
exceptions = c("MutatorCombination", "RecombinatorCombination")

initargs = list(
  MutatorMaybe = list(mutator = mut("gauss")),
  MutatorSequential = list(mutators = muts("gauss")),
  MutatorCmpMaybe = list(mutator = mut("gauss")),
  MutatorCombination = list(operators = list(ParamAny = mut("gauss"))),
  MutatorSequential = list(mutators = list(mut("null"))),
  RecombinatorMaybe = list(recombinator = rec("swap")),
  RecombinatorCmpMaybe = list(recombinator = rec("swap")),
  RecombinatorSequential = list(recombinators = recs(c("swap", "null"))),
  RecombinatorCombination = list(operators = list(ParamAny = rec("xounif"))),
  RecombinatorSequential = list(recombinators = list(rec("null"))),
  FiltorMaybe = list(filtor = ftr("null")),
  FiltorSurrogateProgressive = list(surrogate_learner = mlr3::lrn("regr.featureless")),
  FiltorSurrogateTournament = list(surrogate_learner = mlr3::lrn("regr.featureless")),
  SelectorSequential = list(selectors = list(sel("random"))),
  SelectorMaybe = list(selector = sel("random")),
  ScalorAggregate = list(scalors = list(scl("one")))
)

# for repr-checks: these need to be looked up because the objects are not representable.
special_objects = list(`<LearnerRegrFeatureless>` = mlr3::lrn("regr.featureless"))

# check if something inherits from any <baseclasses> without constructing it
inherits_from_base = function(r6cg) {
  if (r6cg$classname %in% baseclasses) return(TRUE)
  upper = r6cg$get_inherit()
  if (is.null(upper)) return(FALSE)
  inherits_from_base(upper)
}

# get a list of exported objects
nspath = dirname(system.file("NAMESPACE", package = "miesmuschel"))
exports = parseNamespaceFile(basename(nspath), dirname(nspath))$exports

pkgenv = asNamespace("miesmuschel")

# check that `.dict_name` is correct
for (d in dictionaries) {
  expect_identical(get(d$.__enclos_env__$private$.dict_name, pkgenv), d)
}

operators = Filter(function(x) {
  objgen = get(x, pkgenv)
  "R6ClassGenerator" %in% class(objgen) && inherits_from_base(objgen)
}, ls(pkgenv, all.names = TRUE))

shortforms = lapply(shortformnames, get, pkgenv)
operators = setdiff(intersect(operators, exports), abstracts)


operators = c(operators, exceptions)

# for each operator that should be in one of the dictionaries, get the corresponding dict and key

dicts = sapply(operators, function(op) {
  for (type in names(dictionaries)) {
    dictobj = dictionaries[[type]]
    matches = keep(names(dictobj$items), function(n) {
      identical(dictobj$items[[n]]$value, get(op, pkgenv))
    })
    expect_character(matches, max.len = 1)
    if (length(matches)) {
      return(list(operator = op, base = type, name = matches))
    }
  }
  return(list(operator = op, base = NULL, name = "__NOT_FOUND__"))
}, simplify = FALSE)


# check that all exported R6 classes that inherit from <baseclasses> and are not <abstracts> have a dictionary
expect_true("__NOT_FOUND__" %nin% map_chr(dicts, "name"))

for (type in names(dictionaries)) {
  unexported = setdiff(dictionaries[[type]]$keys(), c(map(keep(dicts, function(x) identical(x$base, type)), "name"), non_op_entries))
  expect_true(length(unexported) == 0, info = sprintf("%s in dictionary that is not exported: %s", type, str_collapse(unexported)))
}

for (nonop in non_op_entries) {
  for (type in names(dictionaries)) {
    if (nonop %in% dictionaries[[type]]$keys()) {
      expect_class(dictionaries[[type]]$get(nonop), type)

      helpentry = help(paste0(dictionaries[[type]]$.__enclos_env__$private$.dict_name, "_", nonop), package = "miesmuschel")
      if (identical(help, utils::help)) {  # different behaviour if pkgload / devtools are doing help vs. vanilla R help()
        expect_equal(c(helpentry), c(dictionaries[[type]]$help(nonop)), info = paste("help for", nonop))
      } else {
        expect_equal(helpentry, dictionaries[[type]]$help(nonop), info = paste("help for", nonop))
      }
    }
  }
}

# make sure all active bindings are executed, normalise pre / post cloning state
expand = function(obj) {
  if (!(is.list(obj) || is.environment(obj)) || is.null(names(obj)) || anyDuplicated(names(obj))) return(obj)
  for (n in names(obj)[!grepl("^\\.", names(obj))]) {
    if (is.list(obj[[n]])) {
      tryCatch({
        obj[[n]] = expand(obj[[n]])
      }, error = function(e) NULL)
    } else {
      expand(obj[[n]])
    }
  }
  # handle special case: '.own_defaults' content is not touched sometimes
  if (!is.null(obj$.__enclos_env__$private$.own_defaults)) {
    obj$.__enclos_env__$private$.own_defaults = expand(obj$.__enclos_env__$private$.own_defaults)
  }
  # handle special case: .param_set_id is constructed as NULL and only becomes "" after clone if not changed.
  if (".param_set_id" %in% names(obj$.__enclos_env__$private) && is.null(obj$.__enclos_env__$private$.param_set_id)) {
    obj$.__enclos_env__$private$.param_set_id = ""
  }
  obj
}

construct_from_repr = function(rep) {
  constructed = eval(rep, envir = list(stop = function(x) {
    if (x %in% names(special_objects)) special_objects[[x]] else stop(sprintf("Non-representable object: %s", x))
  }), enclos = .GlobalEnv)
  expand(constructed)
  constructed
}

# check whether we can construct each operator from dictionary and from itself, and get the same result.
for (opinfo in dicts) {
  constructor = get(opinfo$operator, pkgenv)  # constructor as found in pkg namespace
  dictname = opinfo$name  # key in dictionary
  constargs = initargs[[opinfo$operator]] %??% list() # required construction args
  dict = dictionaries[[opinfo$base]]

  test_obj = do.call(constructor$new, constargs)
  expand(test_obj)

  expect_equal(test_obj$dict_shortaccess, shortformnames[[opinfo$base]], info = opinfo$operator)
  expect_equal(test_obj$dict_entry, dictname, info = opinfo$operator)

  expect_inherits(test_obj, opinfo$base, info = opinfo$operator)  # inherits from the correct base class
  if (opinfo$operator %in% exceptions) {
    # some operators do weird things with class
    expect_inherits(test_obj, opinfo$operator)  # name of constructor and some part of class match (for exceptions)
  } else {
    expect_equal(class(test_obj)[[1]], opinfo$operator)  # name of constructor and (topmost) class match
  }

  # check that dict_***$get()  gives the same object as **$new() does
  fromdict = do.call(dict$get, c(list(dictname), constargs))
  expand(fromdict)
  expect_equal(fromdict, test_obj, info = dictname)

  expect_equal(construct_from_repr(repr(test_obj)), test_obj, info = opinfo$operator)
  expect_equal(construct_from_repr(repr(test_obj, skip_defaults = FALSE)), test_obj, info = opinfo$operator)

  tops = test_obj$param_set
  # check that hyperparameters can be changed on construction
  # We do this by automatically generating a hyperparameter value that deviates from the automatically constructed one
  # We only skip this if there are no non-ParamUty parameters.
  eligible_params = which(
    tops$class != "ParamUty" &
    # filter out discrete params with only one level, or numeric params with $lower == $upper
    # (Note numeric parameters have 0 levels, discrete parameters have lower == upper == NA)
    (
      (!is.na(tops$lower) & tops$lower != tops$upper) |
      (is.finite(tops$nlevels) & tops$nlevels > 1)
    )
  )
  if (length(eligible_params)) {
    testingparam = tops$ids()[[eligible_params[[1]]]]
    origval = test_obj$param_set$values[[testingparam]]
    if (tops$is_number[[testingparam]]) {
      # we want to construct an object where the parameter value is different from the construction value
      # For this we take a few candidate values and filter for feasibility and inequality with original value
      candidates = c(as.list(tops$levels[[testingparam]]), list(tops$lower[[testingparam]], tops$upper[[testingparam]],
        tops$lower[[testingparam]] + 1, 0, tops$upper[[testingparam]] - 1, if (is.atomic(origval) && !is.null(origval)) origval + 1))
      val = Filter(function(x) !is.na(x) && is.finite(x) && (!is.atomic(origval) || is.null(origval) || origval != x), candidates)[[1]]
    } else {
      val = setdiff(tops$levels[[testingparam]], origval)[[1]]
    }


    constargs[[testingparam]] = val

    pv_obj = do.call(shortforms[[opinfo$base]], c(list(dictname), constargs))
    expand(pv_obj)
    expect_false(isTRUE(all.equal(test_obj, pv_obj)), info = opinfo$operator)
    test_obj$param_set$values[[testingparam]] = val
    expect_true(isTRUE(all.equal(test_obj, pv_obj)))

    expect_equal(construct_from_repr(repr(test_obj)), pv_obj, info = opinfo$operator)
    expect_equal(construct_from_repr(repr(test_obj, skip_defaults = FALSE)), pv_obj, info = opinfo$operator)

  }

  # class name

  expect_equal(opinfo$base, substr(class(test_obj)[[1]], 1, nchar(opinfo$base)))

  # $help() etc

  expect_equal(test_obj$man, paste0("miesmuschel::", opinfo$operator))



  entryname = paste0(dict$.__enclos_env__$private$.dict_name, "_", dictname)

  helpobj = help(opinfo$operator, package = "miesmuschel")
  helpobj_2 = help((entryname), package = "miesmuschel")


  if (identical(help, utils::help)) {  # different behaviour if pkgload / devtools are doing help vs. vanilla R help()
        # use c() to strip all attributes; they indicate the actual help()-call which is obviously different here.
    expect_equal(c(helpobj), c(test_obj$help()), info = paste("help for", opinfo$operator))
    expect_equal(c(helpobj_2), c(dict$help(dictname)), info = paste("help for", opinfo$operator, "II"))
    expect_equal(c(helpobj), c(helpobj_2), info = paste("help for", opinfo$operator, "III"))
  } else {
    expect_equal(helpobj, test_obj$help(), info = paste("help for", opinfo$operator))
    expect_equal(helpobj_2, dict$help(dictname), info = paste("help for", opinfo$operator, "II"))
    helpobj$topic <- helpobj_2$topic
    expect_equal(helpobj, helpobj_2, info = paste("help for", opinfo$operator, "III"))
  }
}

