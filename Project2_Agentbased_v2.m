% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.

numIndivs = 100;  % number of people
numTrials = 100;  % number of steps they take
riskDist  = 1;    % each indiv will infect people who are riskDist away from them
numIll    = 10;    % number of sick people to introduce
stepsize  = .1;   % how much the individuals move
transmissionlimit = .8; %individuals will transmit infection if under this limit

day  = 60*60*24;       % Day length (s).
tmax = day * 10;       % Duration of the simulation (s).
dt   = tmax/numTrials; % Calculates the duration of each time step.

a = 5/day;
b = 0.1/day;
c = 0.2/day;

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
% grid on;

%%Compute Initial Positions
for ind=1:numIndivs
    person = indiv; 
    person.pos = [10*rand(),10*rand];
    if ind < numIll
        % person.grp = 'I';
        grps(ind) = 'I';
    end
    indivs(ind) = person;
end 

hold on;
%separate people into healthy and unhealthy
for trials =1: numTrials
    hold off
    title(['Trial: ', num2str(trials)]);
    pause(.1)
    t = trials*dt;
    for ind=1:numIndivs % move people
        agent = indivs(ind);
        if grps(ind) == 'D'                    % dead people go to a separate section
            agent.pos(1) = 11;
        else 
            mvx = stepsize * (rand()-.5);      % amount for x to move
            mvy = stepsize * (rand()-.5);      % amount for y to move
            agent.pos(1) = agent.pos(1) + mvx; % updating positions
            agent.pos(2) = agent.pos(2) + mvy;
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
        if grps(ind) == 'I'
            if rand(1) < dt*b
                grps(ind) = 'R';
            elseif rand(1) > 1-dt*c
                grps(ind) = 'D';
            end
        elseif grps(ind) == 'S'
            for new_ind=1:numIndivs
                new_person = indivs(new_ind);
                if grps(new_ind) == 'I'
                    distance = norm(new_person.pos - agent.pos);
                    transmission = dt * a * (1/distance);
                    if transmission > transmissionlimit
                        % agent.grp = 'I';
                        grps(ind) = 'I';
                        break;
                    end
                end
            end
        end
    end    
    axis square;
    xlabel('x');
    ylabel('y');
    axis([-.25,xbound+2.25,-.25,ybound+.25])
    drawnow;
    % check distances and infect people ..?
end 