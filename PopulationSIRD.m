day = 60*60*24 % Day length (s).
tmax = day * 10 % Duration of the simulation (s).
clockmax = 50 % Number of time steps.
dt = tmax/clockmax % Calculates the duration of each time step.

a = 5/day
b = 0.5/day
c = 0.2/day

N = 500 % Total population

num_trials = 4 % How many time the model will run

t_save = zeros(1, clockmax+1);
S_average = zeros(1, clockmax+1);
I_average = zeros(1, clockmax+1);
R_average = zeros(1, clockmax+1);
D_average = zeros(1, clockmax+1);

figure;
hold on;

axis([0, tmax, 0, 1.05 * N])

for trial=1:num_trials
    I = 25     % Infected
    S = N - I   % Susceptible 
    R = 0       % Recovered
    D = 0       % Deceased

    S_average(1) = S;
    I_average(1) = I;
    R_average(1) = R;
    D_average(1) = D;

    for clock=1:clockmax
        t = clock*dt; % Updates current time
    
        ptrans = I/N;
    
        % Calculates new cases of I, R and D
        if S > 0
            newI = sum(rand(S,1) < dt*a*ptrans);
        else
            newI = 0;
        end
        if I > 0
            random = rand(I,1);
            newR = sum(random < dt*b);
            newD = sum(random > 1 - dt*c);
        else
            newR = 0;
            newD = 0;
        end
        
        % Calculate final values of variables
        S = S - newI;
        I = I + newI - newR - newD;
        R = R + newR;
        D = D + newD;
        
        % Update t_save, Ssave, Isave, Rsave, Dsave
        t_save(clock+1) = t; 
        S_average(clock+1) = (S_average(clock+1)*(trial-1) + S)/trial;
        I_average(clock+1) = (I_average(clock+1)*(trial-1) + I)/trial;
        R_average(clock+1) = (R_average(clock+1)*(trial-1) + R)/trial;
        D_average(clock+1) = (D_average(clock+1)*(trial-1) + D)/trial;

        % Adds new points
        scatter(t, S, 1, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'linewidth', 0.1);
        scatter(t, I, 1, 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'linewidth', 0.1);
        scatter(t, R, 1, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'linewidth', 0.1);
        scatter(t, D, 1, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k','linewidth', 0.1);
           
        drawnow expose; % Update the plot
    end
end

% Plots trendlines
hS = plot(t_save, S_average, 'r', 'linewidth', 1.5);
hI = plot(t_save, I_average, 'g', 'linewidth', 1.5);
hR = plot(t_save, R_average, 'b', 'linewidth', 1.5);
hD = plot(t_save, D_average, 'k', 'linewidth', 1.5);

legend({'S','I','R', 'D'},'Location','northeast')
