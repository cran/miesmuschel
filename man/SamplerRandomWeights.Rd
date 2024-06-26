% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ScalorFixedProjections.R
\name{SamplerRandomWeights}
\alias{SamplerRandomWeights}
\title{Sampler for Projection Weights}
\description{
Sampler for a single \code{\link[paradox:Domain]{p_uty}} that samples weight-matrices
as used by \code{\link{ScalorFixedProjection}}.
}
\examples{
set.seed(1)
}
\section{Super class}{
\code{\link[paradox:Sampler]{paradox::Sampler}} -> \code{SamplerRandomWeights}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{nobjectives}}{(\code{numeric(1)})\cr
Number of objectives for which weights are generated.}

\item{\code{nweights}}{(\code{numeric(1)})\cr
Number of weight vectors generated for each configuration.}

\item{\code{weights_component_id}}{(\code{numeric(1)})\cr
search space component identifying the weights by which to scalarize.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-SamplerRandomWeights-new}{\code{SamplerRandomWeights$new()}}
\item \href{#method-SamplerRandomWeights-clone}{\code{SamplerRandomWeights$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="paradox" data-topic="Sampler" data-id="format"><a href='../../paradox/html/Sampler.html#method-Sampler-format'><code>paradox::Sampler$format()</code></a></span></li>
<li><span class="pkg-link" data-pkg="paradox" data-topic="Sampler" data-id="print"><a href='../../paradox/html/Sampler.html#method-Sampler-print'><code>paradox::Sampler$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="paradox" data-topic="Sampler" data-id="sample"><a href='../../paradox/html/Sampler.html#method-Sampler-sample'><code>paradox::Sampler$sample()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-SamplerRandomWeights-new"></a>}}
\if{latex}{\out{\hypertarget{method-SamplerRandomWeights-new}{}}}
\subsection{Method \code{new()}}{
Initialize the \code{SamplerRandomWeights} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SamplerRandomWeights$new(
  nobjectives = 2,
  nweights = 1,
  weights_component_id = "scalarization_weights"
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{nobjectives}}{(\code{numeric(1)})\cr
Number of objectives for which weights are generated.}

\item{\code{nweights}}{(\code{numeric(1)})\cr
Number of weight vectors generated for each configuration.}

\item{\code{weights_component_id}}{(\code{character(1)})\cr
Id of the \code{\link[paradox:Domain]{p_uty}}. Default is \code{"scalarization_weights"}.
Can be changed arbitrarily but should match the \code{\link{ScalorFixedProjection}}'s \code{weights_component_id}.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-SamplerRandomWeights-clone"></a>}}
\if{latex}{\out{\hypertarget{method-SamplerRandomWeights-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SamplerRandomWeights$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
