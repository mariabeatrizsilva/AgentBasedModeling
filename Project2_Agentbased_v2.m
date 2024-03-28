% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.

numIndivs = 100;       % number of people
numTrials =  25;     % number of steps they take
riskDist  =   1;       % Maximum distance to infect someone
numIll    =  20;       % number of sick people to introduce
stepsize  =   100;      % scales how much the individuals move per step
day  = 60*60*24;       % Day length (s).
tmax = day * 10;       % Duration of the simulation (s).
dt   = tmax/numTrials; % Calculates the duration of each time step.

a = 0.3/day;            % Transmission Rate
b = 0.2/day;            % Recovery Rate
c = 0.1/day;            % Death Rate

p1 = indiv; % one person
p1.pos = [10*rand(),10*rand];
indivs = createArray(1,numIndivs,FillValue=p1);
grps = createArray(1,numIndivs,FillValue='S');

% Create figure for plotting
figure;
hold on;
axis square;
xlabel('x');
ylabel('y');
xbound = 10;
ybound = 10;
axis([-.25 xbound+2.25 -.25 ybound+.25]);

% Compute Initial Positions
for ind=1:numIndivs
    person = indiv; 
    person.pos = [10*rand(),10*rand];
    if ind < numIll
        % person.grp = 'I';
        grps(ind) = 'I';
    end
    indivs(ind) = person;
end 

t_save = zeros(1, numTrials+1);
S_save = zeros(1, numTrials+1);
I_save = zeros(1, numTrials+1);
R_save = zeros(1, numTrials+1);
D_save = zeros(1, numTrials+1);

S_save(1) = numIndivs - numIll;
I_save(1) = numIll;

hold on;

for trial =1: numTrials
    hold off
    % pause(.1)

    t = trial*dt;

    I = 0;       % Infected
    S = 0;       % Susceptible 
    R = 0;       % Recovered
    D = 0;       % Deceased

    for ind=1:numIndivs % move people
        agent = indivs(ind);
        if grps(ind) == 'D'                    % dead people go to a separate section
            agent.pos(1) = 11.25;
        else 
            mvx = stepsize * (rand()-.5);      % amount for x to move
            mvy = stepsize * (rand()-.5);      % amount for y to move
            agent.pos(1) = agent.pos(1) + sqrt(dt)/day * mvx; % updating positions
            agent.pos(2) = agent.pos(2) + sqrt(dt)/day * mvy;
            if agent.pos(1)>xbound
               agent.pos(1) = xbound;
            end
            if agent.pos(1)<-xbound
               agent.pos(1) = -xbound;
            end
            if agent.pos(2)>ybound
               agent.pos(2) = ybound;
            end
            if agent.pos(2)<-ybound
               agent.pos(2) = -ybound;
            end
        end
        if grps(ind) == 'S'
            color = 'green';
        elseif grps(ind) == 'I'
            color = 'red';
        elseif grps(ind) == 'R'
            color = 'blue';
        elseif grps(ind) == 'D'
            color = 'black';
        end
        plot(agent.pos(1), agent.pos(2), '.', 'MarkerSize', 25, 'Color', color);
        hold on
        if grps(ind) == 'R'
            R = R + 1;
        elseif grps(ind) == 'D'
            D = D + 1;
        elseif grps(ind) == 'I'
            I = I + 1;
            if rand(1) < dt*b
                grps(ind) = 'R';
            elseif rand(1) > 1-dt*c
                grps(ind) = 'D';
            end
        elseif grps(ind) == 'S'
            S = S + 1;
            for new_ind=1:numIndivs
                new_person = indivs(new_ind);
                if grps(new_ind) == 'I'
                    distance = norm(new_person.pos - agent.pos);
                    if distance < riskDist
                        transmission = dt * a * (1 - distance/riskDist);
                        if transmission > rand(1)
                            % agent.grp = 'I';
                            grps(ind) = 'I';
                            break;
                        end
                    end
                end
            end
        end
    end    
    
    % Update t_save, Ssave, Isave, Rsave, Dsave
    t_save(trial+1) = t; 
    S_save(trial+1) = S;
    I_save(trial+1) = I; 
    R_save(trial+1) = R; 
    D_save(trial+1) = D; 

    axis equal;
    xlabel('x');
    ylabel('y');
    axis([-.25,xbound+2.25,-.25,ybound+.25])
    xline(10.25);
    title(['Trial: ', num2str(trial), '  |  Day: ', num2str(t/day)]);
    drawnow;
    
end 

figure

hold on

% Plots total population graph
hS = plot(t_save, S_save, 'g', 'linewidth', 1.5);
hI = plot(t_save, I_save, 'r', 'linewidth', 1.5);
hR = plot(t_save, R_save, 'b', 'linewidth', 1.5);
hD = plot(t_save, D_save, 'k', 'linewidth', 1.5);

legend({'S','I','R', 'D'},'Location','northeast')

drawnow