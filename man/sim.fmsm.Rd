\name{sim.fmsm}
\alias{sim.fmsm}
\title{Simulate paths through a fully parametric semi-Markov multi-state model}
\description{
  Simulate changes of state and transition times from a semi-Markov
  multi-state model fitted using \code{\link{flexsurvreg}}.
}
\usage{
sim.fmsm(x, trans, t, newdata=NULL, start=1, M=10, tvar="trans",
         tcovs=NULL, debug=FALSE)
}
\arguments{
  \item{x}{A model fitted with \code{\link{flexsurvreg}}. See
\code{\link{msfit.flexsurvreg}} for the required form of the model and
the data.

Alternatively \code{x} can be a list of fitted \code{\link{flexsurvreg}}
model objects.  The \code{i}th element of this list is the model
corresponding to the \code{i}th transition in \code{trans}.  This is a
more efficient way to fit a multi-state model, but only valid if the
parameters are different between different transitions.
}
  \item{trans}{Matrix indicating allowed transitions.  See \code{\link{msfit.flexsurvreg}}.}
  \item{t}{Time, or vector of times for each of the \code{M} individuals, to simulate trajectories until.}
  \item{newdata}{A data frame specifying the values of covariates in the
    fitted model, other than the transition number.  See \code{\link{msfit.flexsurvreg}}.}
  \item{start}{Starting state, or vector of starting states for each of the \code{M} individuals.}
  \item{M}{Number of individual trajectories to simulate.}
  \item{tvar}{Variable in the data representing the transition type.}
  \item{tcovs}{Names of "predictable" time-dependent covariates in
    \code{newdata}, i.e. those whose values change at the
    same rate as time.  Age is a typical example.  During simulation, their
    values will be updated after each transition time, by adding the
    current time to the value supplied in \code{newdata}.  This assumes
    the covariate is measured in the same unit as time. \code{tcovs}
    is supplied as a character vector.}
  \item{debug}{Print intermediate outputs: for development use.}
}
\value{
A list of two matrices named \code{st} and \code{t}.  The rows of each
matrix represent simulated individuals.  The columns of \code{t} contain the
times when the individual changes state, to the corresponding states in
\code{st}.

The first columns will always contain the starting states and the
starting times. The last column of \code{t} represents either the
time when the individual moves to an absorbing state, or right-censoring
in a transient state at the time given in the \code{t} argument to \code{sim.fmsm}.
}
\details{
\code{sim.fmsm} relies on the presence of a function to sample random
numbers from the parametric survival distribution used in the fitted
model \code{x}, for example \code{\link{rweibull}} for Weibull models.
If \code{x} was fitted using a custom distribution,
called \code{dist} say, then there must be a function called (something like)
\code{rdist} either in the working environment, or supplied through the
\code{dfns} argument to \code{\link{flexsurvreg}}.  This must be in the same
format as standard R functions such as \code{\link{rweibull}}, with first argument
\code{n}, and remaining arguments giving the parameters of the
distribution.   It must be vectorised with respect to the parameter arguments.

This function is only valid for semi-Markov ("clock-reset") models,
though no warning or error is currently given if the model is not of
this type. An equivalent for time-inhomogeneous Markov ("clock-forward")
models has currently not been implemented.

Note the random sampling method for \code{flexsurvspline} models is
currently very inefficient, so that looping over the \code{M}
individuals will be very slow.
}
\seealso{
\code{\link{pmatrix.simfs}},\code{\link{totlos.simfs}}
}
\examples{
bexp <- flexsurvreg(Surv(years, status) ~ trans, data=bosms3, dist="exp")
tmat <- rbind(c(NA,1,2),c(NA,NA,3),c(NA,NA,NA))
sim.fmsm(bexp, M=10, t=5, trans=tmat)
}
\author{Christopher Jackson \email{chris.jackson@mrc-bsu.cam.ac.uk}.}
\keyword{models,survival}
