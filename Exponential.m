
function rnd = Exponential(lambda)

% ============================================================================
% DESCRIPTION
%
% usage: rnd = Exponential(lambda)
%
% Generates an exponentially distributed random variable.
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% lambda    the inverse expectation of the distribution
%
% ---------------------------------------------------------------------------
% RETURN VALUES
%
% rnd       an exponentially distributed random variable
%
% ============================================================================

rnd = - log(rand())/lambda ;

end