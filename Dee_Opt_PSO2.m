% Define the details of the table design problem
nVar = 2;
ub = [0.015, 0.001];
lb = [0.001, 0.0001];
fobj = @Dee_Opt_ExpectationMeasure1;

% Define the PSO's parameters
noP = 35;
maxIter = 200;
wMax = 0.9;
wMin = 0.1;
c1 = 2;
c2 = 2;
vMax = (ub - lb) .* 0.2;
vMin = -vMax;

% Initialize the particles
for k = 1 : noP
    Swarm.Particles(k).X = (ub - lb) .* rand(1, nVar) + lb;
    Swarm.Particles(k).V = zeros(1, nVar);
    Swarm.Particles(k).PBEST.X = zeros(1, nVar);
    Swarm.Particles(k).PBEST.O = inf;

    Swarm.GBEST.X = zeros(1, nVar);
    Swarm.GBEST.O = inf;
end

% Initialize the convergence curve
cgCurve = zeros(1, maxIter);

% Main loop
for t = 1 : maxIter
    % Calculate the objective value
    for k = 1 : noP
        currentX = Swarm.Particles(k).X;
        Swarm.Particles(k).O = fobj(currentX);

        % Update the PBEST
        if Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O
            Swarm.Particles(k).PBEST.X = currentX;
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
        end

        % Update the GBEST
        if Swarm.Particles(k).O < Swarm.GBEST.O
            Swarm.GBEST.X = currentX;
            Swarm.GBEST.O = Swarm.Particles(k).O;
        end
    end

    % Update the X and V vectors
    w = wMax - t .* ((wMax - wMin) / maxIter);

    for k = 1 : noP
        Swarm.Particles(k).V = w .* Swarm.Particles(k).V + c1 .* rand(1, nVar) .* (Swarm.Particles(k).PBEST.X - Swarm.Particles(k).X) ...
            + c2 .* rand(1, nVar) .* (Swarm.GBEST.X - Swarm.Particles(k).X);

        % Check velocities
        index1 = find(Swarm.Particles(k).V > vMax);
        index2 = find(Swarm.Particles(k).V < vMin);

        Swarm.Particles(k).V(index1) = vMax(index1);
        Swarm.Particles(k).V(index2) = vMin(index2);

        Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;

        % Check positions
        index1 = find(Swarm.Particles(k).X > ub);
        index2 = find(Swarm.Particles(k).X < lb);

        Swarm.Particles(k).X(index1) = ub(index1);
        Swarm.Particles(k).X(index2) = lb(index2);
    end

%     outmsg = ['Iteration# ', num2str(t), ' Swarm.GBEST.O = ', num2str(Swarm.GBEST.O)];
% %    
    outmsg = strcat('Iteration# ', num2str(t), ' Swarm.GBEST.O = ', num2str(Swarm.GBEST.O));


    disp(outmsg);

    % Update the convergence curve
    cgCurve(t) = Swarm.GBEST.O;
end

semilogy(cgCurve);
disp(Swarm.GBEST.X);



% Extract the optimized length and diameter
optimalLength = Swarm.GBEST.X(1);
optimalDiameter = Swarm.GBEST.X(2);


% Calculate the fitness using the linear model
x = optimalLength;
y = optimalDiameter;

% 
% Linear model Poly24:
%      f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + p21*x^2*y +
%                      p12*x*y^2 + p03*y^3 + p22*x^2*y^2 + p13*x*y^3 + p04*y^4
% Coefficients (with 95% confidence bounds):
%        p00 =       776.8  (634.6, 918.9)
%        p10 =   1.344e+05  (1.067e+05, 1.621e+05)
%        p01 =  -6.339e+06  (-7.417e+06, -5.262e+06)
%        p20 =  -2.174e+06  (-3.759e+06, -5.894e+05)
%        p11 =  -5.617e+08  (-6.9e+08, -4.335e+08)
%        p02 =   2.017e+10  (1.716e+10, 2.319e+10)
%        p21 =     7.4e+09  (9.089e+08, 1.389e+10)
%        p12 =   7.477e+11  (5.706e+11, 9.249e+11)
%        p03 =   -2.52e+13  (-2.887e+13, -2.153e+13)
%        p22 =   -5.63e+12  (-1.14e+13, 1.439e+11)
%        p13 =  -3.169e+14  (-4.092e+14, -2.246e+14)
%        p04 =    1.08e+16  (9.163e+15, 1.243e+16)
% 
% Goodness of fit:
%   SSE: 2.429e+08
%   R-square: 0.4314
%   Adjusted R-square: 0.4304
%   RMSE: 201.4




S_T = 776.8 + (1.344e+05)*x + (-6.339e+06)*y + (-2.174e+06)*x^2 + (-5.617e+08)*x*y + (2.017e+10)*y^2 + (7.4e+09)*x^2*y + (7.477e+11)*x*y^2 + (-2.52e+13)*y^3 + (-5.63e+12)*x^2*y^2 + (-3.169e+14)*x*y^3 + (1.08e+16)*y^4;


% Display the results
disp(['Optimized Length: ' num2str(optimalLength)]);
disp(['Optimized Diameter: ' num2str(optimalDiameter)]);
disp(['(Steady State): ' num2str(S_T)]);
