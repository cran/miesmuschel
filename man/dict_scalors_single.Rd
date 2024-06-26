% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ScalorSingleObjective.R
\name{dict_scalors_single}
\alias{dict_scalors_single}
\alias{ScalorSingleObjective}
\title{Single Objective Scalor}
\description{
\code{\link{Scalor}} that uses a single given objective, throwing an error in case it is used in a multi-objective problem.

In contrast to \code{\link{ScalorOne}}, this \code{\link{Scalor}} throws an error when more than one objective is present. When
this \code{\link{Scalor}} gets used as the default value, e.g. for a \code{\link{Selector}}, then it
forces the user to make an explicit decision about what \code{\link{Scalor}} to use in a multi-objective setting.
}
\section{Configuration Parameters}{

No configuration parameters.
}

\section{Supported Operand Types}{


Supported \code{\link[paradox:Domain]{Domain}} classes are: \code{\link[paradox:Domain]{p_lgl}} ('ParamLgl'), \code{\link[paradox:Domain]{p_int}} ('ParamInt'), \code{\link[paradox:Domain]{p_dbl}} ('ParamDbl'), \code{\link[paradox:Domain]{p_fct}} ('ParamFct')
}

\section{Dictionary}{

This \code{\link{Scalor}} can be created with the short access form \code{\link[=scl]{scl()}}
(\code{\link[=scls]{scls()}} to get a list), or through the the \link[mlr3misc:Dictionary]{dictionary}
\code{\link{dict_scalors}} in the following way:

\if{html}{\out{<div class="sourceCode">}}\preformatted{# preferred:
scl("single")
scls("single")  # takes vector IDs, returns list of Scalors

# long form:
dict_scalors$get("single")
}\if{html}{\out{</div>}}
}

\examples{
ss = scl("single")
p = ps(x = p_dbl(-5, 5))
# dummy data; note that ScalorOne does not depend on data content
data = data.frame(x = rep(0, 5))
fitnesses_so = c(1, 5, 2, 3, 0)
fitnesses_mo = matrix(c(1, 5, 2, 3, 0, 3, 1, 0, 10, 8), ncol = 2)

ss$prime(p)

ss$operate(data, fitnesses_so)

try(ss$operate(data, fitnesses_mo))

}
\seealso{
Other scalors: 
\code{\link{Scalor}},
\code{\link{dict_scalors_aggregate}},
\code{\link{dict_scalors_domcount}},
\code{\link{dict_scalors_fixedprojection}},
\code{\link{dict_scalors_hypervolume}},
\code{\link{dict_scalors_nondom}},
\code{\link{dict_scalors_one}},
\code{\link{dict_scalors_proxy}}
}
\concept{scalors}
\section{Super classes}{
\code{\link[miesmuschel:MiesOperator]{miesmuschel::MiesOperator}} -> \code{\link[miesmuschel:Scalor]{miesmuschel::Scalor}} -> \code{ScalorSingleObjective}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ScalorSingleObjective-new}{\code{ScalorSingleObjective$new()}}
\item \href{#method-ScalorSingleObjective-clone}{\code{ScalorSingleObjective$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="help"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-help'><code>miesmuschel::MiesOperator$help()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="operate"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-operate'><code>miesmuschel::MiesOperator$operate()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="prime"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-prime'><code>miesmuschel::MiesOperator$prime()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="print"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-print'><code>miesmuschel::MiesOperator$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="miesmuschel" data-topic="MiesOperator" data-id="repr"><a href='../../miesmuschel/html/MiesOperator.html#method-MiesOperator-repr'><code>miesmuschel::MiesOperator$repr()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ScalorSingleObjective-new"></a>}}
\if{latex}{\out{\hypertarget{method-ScalorSingleObjective-new}{}}}
\subsection{Method \code{new()}}{
Initialize the \code{ScalorSingleObjective} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ScalorSingleObjective$new()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ScalorSingleObjective-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ScalorSingleObjective-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ScalorSingleObjective$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
