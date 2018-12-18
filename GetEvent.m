function Event = GetEvent(link, T)

    % Variable set up
    totalArrivals = size(link, 1);
    totalDepartures = size(link, 1);
    totalEvents = totalArrivals + totalDepartures;
    
    departures = link(:,6);
    
    [minArr, minArrInd] = min(link(:,3));
    
    % Initialization
    time = 0;                   % Time Variable -- t
    n = 0;                      % System State Variable -- queue size
    tA = minArr; tD = Inf;      % Events list
    Event = [];                 % Output 
    
    while totalEvents > 0
        
        % Case 1
        if tA <= tD && tA <= T
            time = tA;                          % Move along to time tA
            n = n+1;                            % Add to the queue
            if(minArrInd + 1 < size(link,1))
                tA = link(minArrInd + 1, 3);    % Get the time of next arrival
            else
                tA = Inf;
            end
            if(n == 1)
                tD = departures(1,:);           % Get the time of departure
                departures = departures(2:end, :);
            end
            NewEvent = [1, time, n, tA, tD];
            Event = [Event; NewEvent];
            link = link(minArrInd + 1:end, :);
            
        % Case 2
        elseif tD < tA && tD <= T
            time = tD;
            n = max(n-1, 0);                    % remove from queue or 0
            if(n == 0) 
                tD = Inf;
            else
                tD = departures(1,:); 
                departures = departures(2:end, :);
            end
            NewEvent = [2, time, n, tA, tD];
            Event = [Event; NewEvent];
        
        elseif min(tA, tD) > T && n > 0
            time = tD;
            n = max(n-1, 0);                    % remove from queue or 0
            if(n > 0) 
                tD = departures(1,:); 
                departures = departures(2:end, :);
            end
            NewEvent = [2, time, n, tA, tD];
            Event = [Event; NewEvent];
        end
        
        totalEvents = totalEvents - 1;
    end
end