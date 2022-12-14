% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/repr.R
\name{repr}
\alias{repr}
\title{Create a 'call' Object Representation}
\usage{
repr(obj, ...)
}
\arguments{
\item{obj}{(any)\cr
Object to create a representation of.}

\item{...}{(any)\cr
Further arguments to be passed to class methods. Currently in use are:
\itemize{
\item \code{skip_defaults} (\code{logical(1)}) whether to skip construction arguments that have their default value. Default \code{TRUE}.
\item \code{show_params} (\code{logical(1)}) whether to show \code{\link[paradox:ParamSet]{ParamSet}} values. Default \code{TRUE}.
\item \code{show_constructor_args} (\code{logical(1)}) whether to show construction args that are not \code{\link[paradox:ParamSet]{ParamSet}} values. Default \code{TRUE}.
}}
}
\value{
\code{\link[base:call]{call}}: A call that, when evaluated, tries to re-create the object.
}
\description{
\code{repr()} creates a \code{\link[base:call]{call}} object representing \code{obj}, if possible.
Evaluating the call should come close to recreating the original object.

In the most trivial cases, it should be possible to recreate objects from their
representation by evaluating them using \code{\link[base:eval]{eval()}}. Important exceptions
are:
\itemize{
\item Functions are represented by their source code, if available, and by their AST if not.
This drops the context from their environments and recreated objects will not work
if they contain functions that depend on specific environments
\item \code{\link[base:environment]{environment}}s are not represented.
\item \code{\link[R6:R6Class]{R6}} objects are only represented if they have a \verb{$repr()} function.
This function may have arbitrary arguments, and should have a \code{...} argument to
capture ignored arguments.
}

Objects that can not be represented are currently mapped to the call \code{stop("<###>")}, where
\verb{###} is a short description of the non-representable object.
}
