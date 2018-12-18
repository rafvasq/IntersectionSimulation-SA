
function times = HomogeneousPoissonProcess(lambda, duration)

% ============================================================================
% DESCRIPTION
%
% usage: times = HomogeneousPoissonProcess(lambda, duration)
%
% Generates a row vector of event times for a homogenous Poisson process
% with rate lambda and given duration.
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% lambda    the rate of the Poisson process
% duration  the duration of the Poisson process 
%
% ---------------------------------------------------------------------------
% RETURN VALUES
%
% times     a row vector of event times
%
% ============================================================================

t=0;
k=0;
arrivals = [];
while ( duration > t)
    t = t + Exponential(lambda);
%    t = t - log(rand())/lambda
    if (duration > t)
        arrivals = [arrivals, t]
    end
end

times = arrivals;

end