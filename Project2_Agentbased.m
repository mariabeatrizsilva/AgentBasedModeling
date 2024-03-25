% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.


numIndivs = 5;  % number of people
numTrials = 10; % number of steps they take
riskDist  = 1;    % each indiv will infect people who are riskDist away from them
startIllness = 1; %number of trial for when to introduce sick people
numIll = 1; %number of sick people to introduce

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
axis([0 xbound+1 0 ybound+1]);
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
hh = plot(iPosX(ind),iPosY(ind), '.', 'MarkerSize', 25, 'Color', 'g');
ih = plot(iPosX(ind),iPosY(ind), '.', 'MarkerSize', 25, 'Color', 'r');
hold on;
for trials =1: numTrials
    title(['Trial: ', num2str(trials)]);
    if trials == startIllness
        for n=1:numIll
            iGrp(ind) = 'I';
            disp("Made person ill");
        end
    end
    for ind=1:numIndivs
        if iGrp(ind) == 'I'
            ih.XData = iPosX(ind);
            ih.YData = iPosY(ind);
        % elseif iGrp(ind) == 'R' %recovered
        %     hh.Color = 'b';
        % elseif iGrp(ind) == 'D' %dead 
        %     hh.Color = 'k';
        else                    %still susceptible
            hh.XData = iPosX(ind);
            hh.YData = iPosY(ind);
        end
        mvx = stepsize * (rand()-.5);  %amount for x to move
        mvy = stepsize * (rand()-.5);  %amount for y to move
        iPosX(ind) = iPosX(ind) + mvx; %updating positions
        iPosY(ind) = iPosY(ind) + mvy;
        if iPosX(ind)>xbound
           % disp("trial " + trials + " moved " + iPosX(ind) +  " to " + xbound)
           iPosX(ind) = xbound;
        end
        if iPosX(ind)<-xbound
           % disp("trial " + trials + " moved " + iPosX(ind) +  " to " + -xbound)
           iPosX(ind) = -xbound;
        end
        if iPosY(ind)>ybound
           % disp("trial " + trials + " moved " + iPosY(ind) +  " to " + ybound)
           iPosY(ind) = ybound;
        end
        if iPosY(ind)<-ybound
           % disp("trial " + trials + " moved "+ iPosY(ind) +  " to " + ybound)
           iPosY(ind) = -ybound;
        end
        drawnow;
    end 
end 
