% Creates a matrix of vehicles with arrival times and services times to be
% used in SimulateIntersection.m


    DEMAND_DURATION = 100;
    LAMBDA = [1.0 1.0 1.0 1.0];
    MU     = [3.0 3.0 3.0 3.0];

    for i = 1:4

        arrivals = HomogeneousPoissonProcess(LAMBDA(i),DEMAND_DURATION);
        size_arr = size(arrivals,2);
        veh = zeros(size_arr,7);

        for j=1:size_arr
            veh(j,1)=i;                                 % link
            veh(j,2)=j;                                 % id
            veh(j,3)=arrivals(1,j);                     % arrival time (entry time)
            veh(j,4)=0;                                 % "actual arrival" (process start time)
            veh(j,5)=Exponential(MU(1,i));              % service time (time it takes to process)
            veh(j,6)=0;                                 % departure time
            veh(j,7)=0;                                 % wait time (actual arrival - arrival time)
            veh(j,8)=0;                                 % state
        end

        if i==1
            veh_1=veh;
        elseif i==2
            veh_2=veh;
        elseif i==3
            veh_3=veh;
        else
            veh_4=veh;
        end

    end

    veh=vertcat(veh_1,veh_2,veh_3,veh_4);
    veh=sortrows(veh,3); % sorting all vehicles by arrival