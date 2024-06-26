% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SelectorSequential.R
\name{dict_selectors_sequential}
\alias{dict_selectors_sequential}
\alias{SelectorSequential}
\title{Run Multiple Selection Operations in Sequence}
\description{
\code{\link{Selector}} that wraps multiple other \code{\link{Selector}}s given during construction and uses them for selection in sequence.
This makes it possible for one \code{\link{Selector}} to discard a few individuals, followed by a second \code{\link{Selector}} to
discard more, etc., until \code{n_select} individuals are remaining.
}
\section{Algorithm}{

Given that there are \code{nrow(values)} input individuals in an operation, and \code{n_select} individuals requested to be selected,
the operation calls \code{selector_i} for \code{i} in 1 ... \code{length(selectors)} to reduce the number of individuals in this pipeline.
The relative quantity by which the number of individuals is reduced in each step is determined by the configuration parameters
\code{reduction_1}, \code{reduction_2}, etc., and also dependent on the sum of these values, in the following denoted, with a slight abuse of notation, by \verb{sum[reduction_#]}.

Let the number of individuals passed to step \code{i} be denoted by \code{n_values[i]}, and the number of individuals requested to be
selected by that step be denoted as \code{n_select_[i]}. In particular, \code{n_values[1] == nrow(values)}, and \code{n_select_[length(selectors)] == n_select}.

When \code{reduction_by_factor} is \code{TRUE}, then the reduction at step \code{i} is done by a factor, meaning that \code{n_values[i] / n_select_[i]} is set (up to rounding).
This factor is \verb{(nrow(values) / n_select) ^ (reduction_i / sum[reduction_#])}.

When \code{reduction_by_factor} is \code{FALSE}, then the reduction at step \code{i} is done by absolute differences, meaning that \code{n_values[i] - n_select_[i]} is set (up to rounding).
This difference is \verb{(nrow(values) - n_select) * (reduction_i / sum[reduction_#])}, with \verb{sum[reduction_#]} as above.

In particular, this means that when all \code{reduction_#} values are the same and \code{reduction_by_factor} is \code{TRUE}, then each operation reduces the number of
individuals in the pipeline by the same factor. When \code{reduction_by_factor} is \code{FALSE}, then each operation removes the same absolute number of individuals.

While the illustrations are done with the assumption that \code{nrow(values) >= n_select}, they hold equivalently with \code{nrow(values) < n_select}.

All except the last \code{\link{Selector}}s are called with \code{group_size} set to their \code{n_select} value; the last \code{\link{Selector}} is called with the \code{group_size} value
given as input.
}

\section{Configuration Parameters}{

This operator has the configuration parameters of the \code{\link{Selector}}s that it wraps: The configuration parameters of the operator given to the \code{selectors} construction
argument are prefixed with \code{"selector_1"}, \code{"selector_2"}, ... up to \code{"selector_#"}, where \verb{#} is \code{length(selectors)}.

Additional configuration parameters:
\itemize{
\item \code{reduction_1}, \code{reduction_2}, ... :: \code{numeric(1)}\cr
Relative reduction done by \code{selector_1}, \code{selector_2}, ..., as described in the section \strong{Algorithm}. The values are all initialized to 1, meaning
the same factor (when \code{reduction_by_factor} is \code{TRUE}) or absolute number (otherwise) of reduction by each operation.
\item \code{reduction_by_factor} :: \code{logical(1)}\cr
Whether to do reduction by factor (\code{TRUE}) or absolute number (\code{FALSE}), as described in \strong{Algorithm}. Initialized to \code{TRUE}.
}
}

\section{Supported Operand Types}{


Supported \code{\link[paradox:Domain]{Domain}} classes are the set intersection of supported classes of the \code{\link{Selector}}s given in \code{selectors}.
}

\section{Dictionary}{

This \code{\link{Selector}} can be created with the short access form \code{\link[=sel]{sel()}}
(\code{\link[=sels]{sels()}} to get a list), or through the the \link[mlr3misc:Dictionary]{dictionary}
\code{\link{dict_selectors}} in the following way:

\if{html}{\out{<div class="sourceCode">}}\preformatted{# preferred:
sel("sequential", <selectors>)
sels("sequential", <selectors>)  # takes vector IDs, returns list of Selectors

# long form:
dict_selectors$get("sequential", <selectors>)
}\if{html}{\out{</div>}}
}

\seealso{
Other selectors: 
\code{\link{Selector}},
\code{\link{SelectorScalar}},
\code{\link{dict_selectors_best}},
\code{\link{dict_selectors_maybe}},
\code{\link{dict_selectors_null}},
\code{\link{dict_selectors_proxy}},
\code{\link{dict_selectors_random}},
\code{\link{dict_selectors_tournament}}

Other selector wrappers: 
\code{\link{dict_selectors_maybe}},
\code{\link{dict_selectors_proxy}}
}
\concept{selector wrappers}
\concept{selectors}
\section{Super classes}{
\code{\link[miesmuschel:MiesOperator]{miesmuschel::MiesOperator}} -> \code{\link[miesmuschel:Selector]{miesmuschel::Selector}} -> \code{SelectorSequential}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{selectors}}{(\code{list} of \code{\link{Selector}})\cr
\code{\link{Selector}}s being wrapped. These operators get run sequentially in order.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-SelectorSequential-new}{\code{SelectorSequential$new()}}
\item \href{#method-SelectorSequential-prime}{\code{SelectorSequential$prime()}}
\item \href{#method-SelectorSequential-clone}{\code{SelectorSequential$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="help"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-help'><code>miesmuschel::MiesOperator$help()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="operate"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-operate'><code>miesmuschel::MiesOperator$operate()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="print"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-print'><code>miesmuschel::MiesOperator$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="repr"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-repr'><code>miesmuschel::MiesOperator$repr()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-SelectorSequential-new"></a>}}
\if{latex}{\out{\hypertarget{method-SelectorSequential-new}{}}}
\subsection{Method \code{new()}}{
Initialize the \code{SelectorSequential} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SelectorSequential$new(selectors)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{selectors}}{(\code{list} of \code{\link{Selector}})\cr
\code{\link{Selector}}s to wrap. The operations are run in order given to \code{selectors}.
The constructed object gets a \emph{clone} of this argument. The \verb{$selectors} field will reflect this value.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-SelectorSequential-prime"></a>}}
\if{latex}{\out{\hypertarget{method-SelectorSequential-prime}{}}}
\subsection{Method \code{prime()}}{
See \code{\link{MiesOperator}} method. Primes both this operator, as well as the wrapped operators
given to \code{selectors} during construction.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SelectorSequential$prime(param_set)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{param_set}}{(\code{\link[paradox:ParamSet]{ParamSet}})\cr
Passed to \code{\link{MiesOperator}}\verb{$prime()}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{invisible} \code{self}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-SelectorSequential-clone"></a>}}
\if{latex}{\out{\hypertarget{method-SelectorSequential-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SelectorSequential$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
