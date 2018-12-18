% ============================================================================
% DESCRIPTION
%
% usage: [output_data, bestVal, finalSol] = SimulatedAnnealingCustom('SimulateIntersection', x0, maxIter, C);
%
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% x0        starting point
% maxIter   # of iterations
% C         constant
% ---------------------------------------------------------------------------
% RETURN VALUES
%
% rnd       an exponentially distributed random variable
%
% ============================================================================

objfunc = 'SimulateIntersection';
x0 = [5, 8]; 
maxIter = 1000;
C = 0.001 ;
[output_data, bestVal, finalSol] = SimulatedAnnealingCustom('SimulateIntersection', x0, maxIter, C);