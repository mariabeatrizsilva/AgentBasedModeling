% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.


numIndivs = 10; 
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
    hp = plot(person.pos(1), person.pos(2), 'g.', 'MarkerSize', 25);
    hold on;
end 

%Move the individuals
stepsize = .1;
numTrials = 100;
for trials =1: numTrials
    disp("move value = " + mv);
    for ind=1:numIndivs
        mark = 'g.'; %defaults to green for susceptible
        if iGrp(ind) == 'I'
            mark = 'r.';
        elseif iGrp(ind) == 'R'
            mark = 'b.';
        elseif iGrp(ind) == 'D'
            mark = 'k.';
        end
        mv1 = stepsize * (rand()-.5);
        mv2 = stepsize * (rand()-.5);
        iPosX(ind) = iPosX(ind) + mv1;
        iPosY(ind) = iPosY(ind) + mv2;
        while iPosX(ind)>xbound
           redo = rand()-.5;
           disp("moved " + iPosX(ind) +  " to " + (iPosX(ind) + rand()-.5))
           iPosX(ind) = iPosX(ind) + rand()-.5;
        end
        while iPosX(ind)<-10
           disp("moved " + iPosX(ind) +  " to " + (iPosX(ind) + rand()-.5))
           iPosX(ind) = iPosX(ind) + rand()-.5;
        end
        while iPosY(ind)>ybound
           disp("moved " + iPosY(ind) +  " to " + (iPosY(ind) + rand()-.5))
           iPosY(ind) = iPosY(ind) + rand()-.5;
        end
        while iPosY(ind)<-ybound
           disp("moved " + iPosY(ind) +  " to " + (iPosY(ind) + rand()-.5))
           iPosY(ind) = iPosY(ind) - rand()-.5;
        end
        if trials ~= numTrials
            plot(iPosX(ind), iPosY(ind), mark, 'MarkerSize', 25);
        else
            plot(iPosX(ind), iPosY(ind), 'm.', 'MarkerSize', 25);
        end 
        drawnow update;
    end 
end 
