function [x] = GenerateSolution(current_solution)

    stop=0;  
    while stop==0
        t1 = current_solution(1);
        t2 = current_solution(2);

        bb=rand();
        if bb<0.5
            a=-1;
            b=1;
            r=(b-a)*rand()+a;
            t1=t1+r;
        else
            a=-1;
            b=1;
            r=(b-a)*rand()+a;
            t2=t2+r;
        end

        % check if t1 and t2 are within the constraints ; if not we try again
        if (t1>=3 && t2>=3 && t1+t2<=60)
            stop = 1;
        end
    end
    x = [t1 t2];
end