function [output_data, bestVal, finalSol] = SimulatedAnnealingCustom(f, x0, maxIter, C)

    clf

    f0 = feval(f, x0); % first f value
    fx = f0;
    x = x0;
    bestVal = fx;
    
    output_data = zeros(maxIter, 5);
    output_data(1 , 1) = x(1);  % t1
    output_data(1 , 2) = x(2);  % t2
    output_data(1 , 3) = fx;    % feval
    output_data(1 , 4) = 1;     % acceptance
    output_data(1 , 5) = fx;    % best value
    
    for i=2:maxIter
        
        disp(i); % debug output
        
        x1 = GenerateSolution(x);       % generate neighbour solution
        fx1 = feval(f, x1);             % feval neighbour solution
        output_data(i , 1) = x1(1);     % save t1
        output_data(i , 2) = x1(2);     % save t2
        output_data(i , 3) = fx1;       % save f
        
        if(fx1 < fx)
            x = x1;
            fx = fx1;
            output_data(i , 4) = 1;    % acceptance
        else
            lambda = C * log(1 + i);
            temperature = exp(-lambda*fx1) / exp(-lambda*fx);
            alpha = min(temperature, 1);
            r = rand();
            if (r >= alpha)
                x = x1;    
                fx = fx1;
                output_data(i , 4) = 2;         % acceptance via probability
            else
                output_data(i , 4) = 0;         % not accepted
            end
        end
        output_data(i, 5) = fx;
        if(fx < bestVal)
            bestVal = fx;
            output_data(i, 6) = fx;
            finalSol = x;
        end
    end
    
    figure(1)
    plot (output_data(:, 3));
    hold on
    plot (output_data(:, 5), ':','LineWidth',2);
    for i=1:size(output_data)
        if(output_data(i, 4) == 2)
            plot(i, output_data(i, 5), 'O');
        end
    end
    xlabel('Iteration');
    ylabel('Queue Length');
    
end