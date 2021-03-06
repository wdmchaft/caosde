timestep(1) = 0.0032;
timestep(2) = 0.0064;
timestep(3) = 0.0128;
timestep(4) = 0.0256;

eweaknorm = zeros(4,1);
mean = zeros(4,1);
meanew32000 = 0;

nsample = 10000;

S = zeros(32000,1);
sig = zeros(32000,1);
xi = zeros(32000,1);

for j = 1:nsample

    dtex = 0.0001;
    r = randn(32000,1);
    r1 = randn(32000,1);

    S(1) = 50.0;
    sig(1) = 0.2;
    xi(1) = 0.2;
    mu = 0.1; p = 1; alfa = 1;

    %the 'exact' solution. This is Milstein but with a very small timestep.
    for i = 2:32000
        deltaw = sqrt(dtex)*r(i);
        deltaw1 = sqrt(dtex)*r1(i);

        S(i) = S(i-1) + mu * S(i-1) * dtex + sig(i-1) * S(i-1) * deltaw...
            + 0.5*sig(i-1)*sig(i-1)*S(i-1)*(deltaw*deltaw-dtex);
        sig(i) = sig(i-1) - ( sig(i-1) - xi(i-1) ) * dtex + p * sig(i-1) * deltaw1...
            + 0.5*p*p*sig(i-1)*(deltaw1*deltaw1-dtex);
        xi(i) = xi(i-1) + (1.0/alfa) * ( sig(i-1) - xi(i-1) ) * dtex;

    end

    solution = S(32000);
    meanew32000 = meanew32000 + solution;

    %Numerical solution with Euler scheme
    dt = timestep(1);%this timestep is 32 times the timestep of the exact solution

    for i = 2:1000
        tmp = 0.0;
        tmp1 = 0.0;
        for z = 1:32
            tmp = tmp+r(32*i-(32-z));
            tmp1 = tmp1+r1(32*i -(32-z));
        end
        deltaw = sqrt(dtex)*tmp;
        deltaw1 = sqrt(dtex)*tmp1;
       
        S(i) = S(i-1) + mu * S(i-1) * dt + sig(i-1) * S(i-1) * deltaw;
        sig(i) = sig(i-1) - ( sig(i-1) - xi(i-1) ) * dt + p * sig(i-1) * deltaw1;
        xi(i) = xi(i-1) + (1.0/alfa) * ( sig(i-1) - xi(i-1) ) * dt;

    end
    mean(1) = mean(1)+S(1000); 
    
    dt = timestep(2);%this timestep is 64 times the timestep of the exact solution
    for i = 2:500
        tmp = 0.0;
        tmp1 = 0.0;
        for z = 1:64
            tmp = tmp+r(64*i-(64-z));
            tmp1 = tmp1+r1(64*i -(64-z));
        end
        deltaw = sqrt(dtex)*tmp;
        deltaw1 = sqrt(dtex)*tmp1;

      
        S(i) = S(i-1) + mu * S(i-1) * dt + sig(i-1) * S(i-1) * deltaw;
        sig(i) = sig(i-1) - ( sig(i-1) - xi(i-1) ) * dt + p * sig(i-1) * deltaw1;
        xi(i) = xi(i-1) + (1.0/alfa) * ( sig(i-1) - xi(i-1) ) * dt;

    end
    mean(2) = mean(2) + S(500);
   
    dt = timestep(3);%this timestep is 128 times the timestep of the exact solution
    for i = 2:250

        tmp = 0.0;
        tmp1 = 0.0;
        for z = 1:128
            tmp = tmp+r(128*i-(128-z));
            tmp1 = tmp1+r1(128*i -(128-z));
        end
        deltaw = sqrt(dtex)*tmp;
        deltaw1 = sqrt(dtex)*tmp1;

       
        S(i) = S(i-1) + mu * S(i-1) * dt + sig(i-1) * S(i-1) * deltaw;
        sig(i) = sig(i-1) - ( sig(i-1) - xi(i-1) ) * dt + p * sig(i-1) * deltaw1;
        xi(i) = xi(i-1) + (1.0/alfa) * ( sig(i-1) - xi(i-1) ) * dt;

    end
    mean(3) = mean(3)+S(250);
   
    dt = timestep(4);%this timestep is 256 times the timestep of the exact solution
    for i = 2:125

        tmp = 0.0;
        tmp1 = 0.0;
        for z = 1:256
            tmp = tmp+r(256*i-(256-z));
            tmp1 = tmp1+r1(256*i -(256-z));
        end
        deltaw = sqrt(dtex)*tmp;
        deltaw1 = sqrt(dtex)*tmp1;

        S(i) = S(i-1) + mu * S(i-1) * dt + sig(i-1) * S(i-1) * deltaw;
        sig(i) = sig(i-1) - ( sig(i-1) - xi(i-1) ) * dt + p * sig(i-1) * deltaw1;
        xi(i) = xi(i-1) + (1.0/alfa) * ( sig(i-1) - xi(i-1) ) * dt;

    end
    mean(4) = mean(4)+S(125);
    
end

eweaknorm = abs(mean/nsample - meanew32000/nsample);

plot((timestep),(eweaknorm),'-');
title('Error versus Timestep for Euler Scheme')
xlabel('Timestep')
ylabel('Absolute Error at T = 3.2')
