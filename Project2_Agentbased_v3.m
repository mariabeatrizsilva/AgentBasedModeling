% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.

numIndivs = 100;       % number of people
numTrials = 25;       % number of steps they take
riskDist  =   1;       % Maximum distance to infect someone
numIll    =  20;       % number of sick people to introduce
stepsize  = 150;       % scales how much the individuals move per step
day  = 60*60*24;       % Day length (s).
tmax = day * 10;       % Duration of the simulation (s).
dt   = tmax/numTrials; % Calculates the duration of each time step.
autoImmune = 3;

a = 1.7/day ;           % Transmission Rate
b = 0.1/day;            % Recovery Rate
c = 0.1/day;            % Death Rate

p1 = indiv; % one person
p1.pos = [10*rand(),10*rand];
indivs = createArray(1,numIndivs,FillValue=p1);

% Create figure for plotting
figure;
hold on;
axis square;
xlabel('x');
ylabel('y');
xbound = 10;
ybound = 10;
axis([-.25 xbound+2.25 -.25 ybound+1.25]);

% Compute Initial Positions
numAuto = 0;
for ind=1:numIndivs
    person = indiv; 
    person.pos = [10*rand(),10*rand];
    if ind < numIll
        person.grp = 'I';
    end
    if person.grp ~= 'I' && numAuto < autoImmune
        person.isAutoimmune = 'Y';
        numAuto = numAuto + 1;
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
    t = trial*dt;

    I = 0;       % Infected
    S = 0;       % Susceptible 
    R = 0;       % Recovered
    D = 0;       % Deceased
    for ind=1:numIndivs % move people
        agent = indivs(ind);
        if indivs(ind).grp == 'D'                    % dead people go to a separate section
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
        if indivs(ind).grp == 'S'
            color = 'green';
        elseif indivs(ind).grp == 'I'
            color = 'red';
        elseif indivs(ind).grp == 'R'
            color = 'blue';
        elseif indivs(ind).grp == 'D'
            color = 'black';
        end
        if agent.isAutoimmune == 'Y'
            plot(agent.pos(1), agent.pos(2), '*', 'MarkerSize', 15, 'Color', color);
        else 
            plot(agent.pos(1), agent.pos(2), '.', 'MarkerSize', 25, 'Color', color);
        end 
        hold on
        if indivs(ind).grp == 'R'
            R = R + 1;
        elseif indivs(ind).grp == 'D'
            D = D + 1;
        elseif indivs(ind).grp == 'I'
            I = I + 1;
            if rand(1) < dt*b
                indivs(ind).grp = 'R';
            elseif rand(1) > 1-dt*c
                indivs(ind).grp = 'D';
            end
        elseif indivs(ind).grp == 'S'
            S = S + 1;
            for new_ind=1:numIndivs
                new_person = indivs(new_ind);
                if indivs(new_ind).grp == 'I'
                    distance = norm(new_person.pos - agent.pos);
                    if distance < riskDist
                        transmission = dt * a * (1 - distance/riskDist);
                        if transmission > rand(1)
                            indivs(ind).grp = 'I';
                            break;
                        end
                    end
                end
            end
        end
    end    

    Stxt = [' S: ' num2str(S)];
    Itxt = [' I: ' num2str(I)];
    Rtxt = [' R: ' num2str(R)];
    Dtxt = [' D: ' num2str(D)];

    text(4,10.75,Stxt,'Color', 'g');
    text(5 ,10.75,Itxt,'Color', 'r');
    text(6 ,10.75,Rtxt,'Color', 'b');
    text(7,10.75,Dtxt,'Color', 'k');

    % Update t_save, Ssave, Isave, Rsave, Dsave
    t_save(trial+1) = t; 
    S_save(trial+1) = S;
    I_save(trial+1) = I; 
    R_save(trial+1) = R; 
    D_save(trial+1) = D; 

    axis equal;
    xlabel('x');
    ylabel('y');
    axis([-.25,xbound+2.25,-.25,ybound+1.25])
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