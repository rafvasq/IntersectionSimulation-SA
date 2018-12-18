function [F] = SimulateIntersection(x)

    veh = importdata('veh.mat'); % importing the matrix created by VehMatrixGenerator.m

    global T StopCriteria;  % defining global variables
    T=0;
    StopCriteria=0; 
    i = 0;      
    t1=x(1);    % east and west
    t2=x(2);    % north and south
    
    while StopCriteria == 0
        i = i + 1;
        if mod(i,2)==0 % even number of iteration
            T=T+t2;

            % taking care of all of the vehicles on unrelated links; if they
            % arrive (e.g. have state 0) within the current iteration
            for j=1:size(veh,1)
                if veh(j,3)<=T
                    if (veh(j,1)==1 || veh(j,1)==4) && veh(j,8)==0  % if vehicle is on link 1 or 4; AND vehicle has not arrived or departed
                        veh(j,8)=1;                                 % set that vehicle's state to 1 
                    end
                end
            end

            % loop through all of the vehicles on the relevant links we need to
            % deal with in the current iteration
            NS=find((veh(:,1)==2 | veh(:,1)==3) & (veh(:,8)==0 | veh(:,8)==1)); %& veh(:,3)<=T);
            for k=1:size(NS,1)

                if k==1                                                         % for the very first vehicle
                        if veh(NS(k,1),8) == 1                                  % if the vehicle was already waiting
                            if ((T-t2) + veh(NS(k,1),5)) <= T                       % if signal change + service time within this iteration
                                veh(NS(k,1),4)= T-t2;                                   % actual_arrival = T
                                veh(NS(k,1),8)=2;                                       % state is departed (2)
                                veh(NS(k,1),6)=veh(NS(k,1),4)+veh(NS(k,1),5);           % departure_time = actual_arrival + service_time
                                veh(NS(k,1),7)=veh(NS(k,1),4)-veh(NS(k,1),3);           % wait_time = actual_arrival - arrival
                            else                                                % else
                                veh(NS(k,1),8)=1;                                       % state is waiting
                            end
                        else                                                    % if vehicle was NOT already waiting
                            if (veh(NS(k,1),3) + veh(NS(k,1),5)) <= T               % if arrival + service time within this iteration
                                veh(NS(k,1),4)=veh(NS(k,1),3);                          % actual_arrival = arrival 
                                veh(NS(k,1),8)=2;                                       % state is departed (2)
                                veh(NS(k,1),6)=veh(NS(k,1),4)+veh(NS(k,1),5);           % departure_time = actual_arrival + service_time
                                veh(NS(k,1),7)=veh(NS(k,1),4)-veh(NS(k,1),3);           % wait_time = actual_arrival - arrival
                            else                                                % else
                                veh(NS(k,1),8)=1;                                   % state is waiting
                            end
                        end

                % for the rest of the vehicles    
                else  

                    % if this vehicle's arrival_time < the previous
                    % vehicle's departure_time (vehicle arrives
                    % before the previous vehicle departs)
                    if  veh(NS(k,1),3) < veh(NS(k-1,1),6)                             
                        veh(NS(k,1),8)=1;                                       % this vehicle arrives and waits (state is 1)
                        if  veh(NS(k-1,1),6)+veh(NS(k,1),5)<=T                  % if previous vehicle's departure_time + this vehicle's service < T
                            veh(NS(k,1),4)=veh(NS(k-1,1),6);                    % this vehicle's actual_arrival = previous vehicle's departure time
                            veh(NS(k,1),8)=2;                                   % state is departed (2)
                            veh(NS(k,1),6)=veh(NS(k,1),4)+veh(NS(k,1),5);       % departure_time = actual_arrival + service_time
                            veh(NS(k,1),7)=veh(NS(k,1),4)-veh(NS(k,1),3);       % wait_time = actual_arrival - arrival
                        end

                    else

                        % if the previous car never left
                        if veh(NS(k-1,1),6) == 0
                            veh(NS(k,1),8) = 1;                                   % state = 1 (waiting)

                        % if vehicle's arrival + service_time < T (if it will depart in this iteration)
                        elseif veh(NS(k,1),3)+veh(NS(k,1),5)<=T                          
                            veh(NS(k,1),4)=veh(NS(k,1),3);                      % actual_arrival = arrival
                            veh(NS(k,1),8)=2;                                   % state is departed (2)
                            veh(NS(k,1),6)=veh(NS(k,1),4)+veh(NS(k,1),5);       % departure_time = actual_arrival + service_time
                            veh(NS(k,1),7)= veh(NS(k,1),4) - veh(NS(k,1),3);    % wait_time = actual_arrival-arrival;

                        % vehicle won't be serviced in this iteration
                        else
                            veh(NS(k,1),8)=1;  % state is waiting (1)
                        end
                    end
                end
            end

        else % if odd number of iteration (links 1 and 4)
            T=T+t1;

            % taking care of all of the vehicles on unrelated links; if they
            % arrive (e.g. have state 0) within the current iteration
            for j=1:size(veh,1)
                if veh(j,3)<=T
                    if (veh(j,1)==2 || veh(j,1)==3) && veh(j,8)==0  % if vehicle is on link 1 or 4; AND vehicle has not arrived or departed
                        veh(j,8)=1;
                    end
                end
            end

            % loop through all of the vehicles on the relevant links we need to
            % deal with in the current iteration
            EW=find((veh(:,1)==1 | veh(:,1)==4) & (veh(:,8)==0 | veh(:,8)==1));% & veh(:,3)<=T);
            for k=1:size(EW,1)

                if k==1                                                         % for the very first vehicle
                        if veh(EW(k,1),8) == 1                                  % if the vehicle was already waiting
                            if ((T-t1) + veh(EW(k,1),5)) <= T                       % if signal change + service time within this iteration
                                veh(EW(k,1),4)= T-t1;                                   % actual_arrival = T
                                veh(EW(k,1),8)=2;                                       % state is departed (2)
                                veh(EW(k,1),6)=veh(EW(k,1),4)+veh(EW(k,1),5);           % departure_time = actual_arrival + service_time
                                veh(EW(k,1),7)=veh(EW(k,1),4)-veh(EW(k,1),3);           % wait_time = actual_arrival - arrival
                            else                                                % else
                                veh(EW(k,1),8)=1;                                       % state is waiting
                            end
                        else                                                    % if vehicle was NOT already waiting
                            if (veh(EW(k,1),3) + veh(EW(k,1),5)) <= T               % if arrival + service time within this iteration
                                veh(EW(k,1),4)=veh(EW(k,1),3);                          % actual_arrival = arrival 
                                veh(EW(k,1),8)=2;                                       % state is departed (2)
                                veh(EW(k,1),6)=veh(EW(k,1),4)+veh(EW(k,1),5);           % departure_time = actual_arrival + service_time
                                veh(EW(k,1),7)=veh(EW(k,1),4)-veh(EW(k,1),3);           % wait_time = actual_arrival - arrival
                            else                                                % else
                                veh(EW(k,1),8)=1;                                   % state is waiting
                            end
                        end

                % for the rest of the vehicles    
                else  

                    % if this vehicle's arrival_time < the previous vehicle's 
                    % departure_time (vehicle arrives before the previous 
                    % vehicle departs)
                    if  veh(EW(k,1),3) < veh(EW(k-1,1),6)                             
                        veh(EW(k,1),8)=1;                                       % this vehicle arrives and waits (state is 1)
                        if  veh(EW(k-1,1),6)+veh(EW(k,1),5)<=T                  % if previous vehicle's departure_time + this vehicle's service < T
                            veh(EW(k,1),4)=veh(EW(k-1,1),6);                    % this vehicle's actual_arrival = previous vehicle's departure time
                            veh(EW(k,1),8)=2;                                   % state is departed (2)
                            veh(EW(k,1),6)=veh(EW(k,1),4)+veh(EW(k,1),5);       % departure_time = actual_arrival + service_time
                            veh(EW(k,1),7)=veh(EW(k,1),4)-veh(EW(k,1),3);       % wait_time = actual_arrival - arrival
                        end

                    else

                        % if the car ahead never left
                        if veh(EW(k-1,1),6) == 0
                            veh(EW(k,1),8) = 1;                                   % state = 1 (waiting)

                        % if vehicle's arrival + service_time < T (if it will depart in this iteration)
                        elseif veh(EW(k,1),3) + veh(EW(k,1),5)<=T                          
                            veh(EW(k,1),4) = veh(EW(k,1),3);                    % actual_arrival = arrival
                            veh(EW(k,1),8) = 2;                                 % state is departed (2)
                            veh(EW(k,1),6) = veh(EW(k,1),4) + veh(EW(k,1),5);   % departure_time = actual_arrival + service_time
                            veh(EW(k,1),7) = veh(EW(k,1),4) - veh(EW(k,1),3);   % wait_time = actual_arrival-arrival;

                        % vehicle won't be serviced in this iteration
                        else
                            veh(EW(k,1),8) = 1;  % state is arrived/waiting (1)
                        end
                    end
                end
            end
        end
        
        % Checking to see if any vehicles have not been processed yet
        if ~ismember(0, veh(:,8)) && ~ismember(1, veh(:,8))
           StopCriteria = 1; 
        end

    end
    
    % output for each link individually
    index1 = find((veh(:,1) == 1));
    link1 = veh(index1, :); %#ok<*FNDSB>
    index2 = find((veh(:,1) == 2));
    link2 = veh(index2, :);
    index3 = find((veh(:,1) == 3));
    link3 = veh(index3, :);
    index4 = find((veh(:,1) == 4));
    link4 = veh(index4, :);

    % Event simulation based on the output of the intersection simulation
    Event1 = GetEvent(link1, T);
    Event2 = GetEvent(link2, T);
    Event3 = GetEvent(link3, T);
    Event4 = GetEvent(link4, T);
    allEvents = vertcat(Event1, Event2, Event3, Event4);
    queue_lengths = allEvents(:, 3);
    
    % The mean of the queues
    F = mean(queue_lengths);
end