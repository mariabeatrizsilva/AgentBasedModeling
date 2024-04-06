% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.


numIndivs = 50;  % number of people
numTrials = 100; % number of steps they take
riskDist = 1;    % each indiv will infect people who are riskDist away from them

iPosX = [numIndivs];
iPosY = [numIndivs];
iGrp  = [numIndivs];

% Create figure for plotting
figure;
hold on;
axis square;
title('Individual Positions of Agents');
xlabel('x');
ylabel('y');
xbound = 10;
ybound = 10;
axis([0 xbound 0 ybound]);
% grid on;

%%Compute Initial Positions
for ind=1:numIndivs
    person = indiv; 
    person.pos = [10*rand(),10*rand];
    person.grp = 'S';
    iPosX(ind) = person.pos(1);
    iPosY(ind) = person.pos(2);
    iGrp(ind) = person.grp;
end 

%Move the individuals
stepsize = .2;
handle = plot(iPosX(ind),iPosY(ind), 'g.', 'MarkerSize', 25);
hold on;
for trials =1: numTrials
    for ind=1:numIndivs
        mark = 'green'; %defaults to green for susceptible
        if iGrp(ind) == 'I'
            mark = 'red';
        elseif iGrp(ind) == 'R'
            mark = 'blue';
        elseif iGrp(ind) == 'D'
            mark = 'black';
        end
        mvx = stepsize * (rand()-.5);
        mvy = stepsize * (rand()-.5);
        iPosX(ind) = iPosX(ind) + mvx;
        iPosY(ind) = iPosY(ind) + mvy;
        if iPosX(ind)>xbound
           disp("trial " + trials + " moved " + iPosX(ind) +  " to " + xbound)
           iPosX(ind) = xbound;
        end
        if iPosX(ind)<-xbound
           disp("trial " + trials + " moved " + iPosX(ind) +  " to " + -xbound)
           iPosX(ind) = -xbound;
        end
        if iPosY(ind)>ybound
           disp("trial " + trials + " moved " + iPosY(ind) +  " to " + ybound)
           iPosY(ind) = ybound;
        end
        if iPosY(ind)<-ybound
           disp("trial " + trials + " moved "+ iPosY(ind) +  " to " + ybound)
           iPosY(ind) = -ybound;
        end
        handle.XData = iPosX(1:numIndivs);
        handle.YData = iPosY(1:numIndivs);
        handle.Color = mark;
        drawnow;
    end 
end 
