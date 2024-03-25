% With our agents, we need to define their interactions and how those 
% interactions change their properties. We need to check the distance 
% between our agents and if they are close to an infected agent. 
% If an uninfected agent is close to an infected one we will 
% let the disease transfer and change the uninfected agents status to infected.
% We iterate this process as our agents move around --> simulation.


numIndivs = 5;  % number of people
numTrials = 100; % number of steps they take
riskDist  = 1;    % each indiv will infect people who are riskDist away from them
numIll    = 2; % number of sick people to introduce

p1 = indiv; % one person
p1.pos = [10*rand(),10*rand];
person.grp = 'S';
indivs = createArray(1,numIndivs,FillValue=p1);

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
    indivs(ind) = person;
end 
    ih = plot(person.pos(1), person.pos(2), '.', 'MarkerSize', 25, 'Color', 'r');
    sh = plot(person.pos(1), person.pos(2), '.', 'MarkerSize', 25, 'Color', 'g');
%Move the individuals
stepsize = .1; 
hold on;
    
%make an array of infected people and susceptible
susceptible = createArray(1,numIndivs,FillValue=p1);
infected = createArray(1,numIndivs,FillValue=p1); 
sind = 1;
iind = 1;
%array for positions of each group people (max size is num ppl)
sXpos = zeros(numIndivs);
sYpos = zeros(numIndivs);
iXpos = zeros(numIndivs);
iYpos = zeros(numIndivs);
for i=1:numIndivs
    sXpos(i) = -1;
    sYpos(i) = -1;
    iXpos(i) = -1;
    iYpos(i) = -1;
end
%separate people into healthy and unhealthy
    for i = 1: numIndivs
        if numIll ~= 0          %make numIll number of people sick 
            indivs(i).grp = 'I'; 
            infected(iind) = indivs(i);
            iXpos(iind) = indivs(i).pos(1);
            iYpos(iind) = indivs(i).pos(2);
            iind = iind+1;
            numIll = numIll-1;
        end
        if indivs(i).grp == 'S'
            susceptible(sind) = indivs(i);
            sXpos(sind) = indivs(i).pos(1);
            sYpos(sind) = indivs(i).pos(2);
            sind = sind+1;
        end
    end

for trials =1: numTrials
    title(['Trial: ', num2str(trials)]);
    pause(.1)
    for ind=1:sind-1 %move susceptible people
        agent = susceptible(ind);
        mvx = stepsize * (rand()-.5);  %amount for x to move
        mvy = stepsize * (rand()-.5);  %amount for y to move
        agent.pos(1) = agent.pos(1) + mvx; %updating positions
        agent.pos(2) = agent.pos(2) + mvy;
        if agent.pos(1)>xbound
           % disp("trial " + trials + " moved " + iPosX(ind) +  " to " + xbound)
           agent.pos(1) = xbound;
        end
        if agent.pos(1)<-xbound
           % disp("trial " + trials + " moved " + iPosX(ind) +  " to " + -xbound)
           agent.pos(1) = -xbound;
        end
        if agent.pos(2)>ybound
           % disp("trial " + trials + " moved " + iPosY(ind) +  " to " + ybound)
           agent.pos(2) = ybound;
        end
        if agent.pos(2)<-ybound
           % disp("trial " + trials + " moved "+ iPosY(ind) +  " to " + ybound)
           agent.pos(2) = -ybound;
        end
        sXpos(ind) = agent.pos(1);
        sYpos(ind) = agent.pos(2);
        % plot(agent.pos(1), agent.pos(2), 'g.');
        sh.XData = sXpos(1:sind);
        sh.YData = sYpos(1:sind);
    end
    for ind=1:iind-1 %move infected people
        agent = infected(ind);
        mvx = stepsize * (rand()-.5);  %amount for x to move
        mvy = stepsize * (rand()-.5);  %amount for y to move
        agent.pos(1) = agent.pos(1) + mvx; %updating positions
        agent.pos(2) = agent.pos(2) + mvy;
        if agent.pos(1)>xbound
           % disp("trial " + trials + " moved " + iPosX(ind) +  " to " + xbound)
           agent.pos(1) = xbound;
        end
        if agent.pos(1)<-xbound
           % disp("trial " + trials + " moved " + iPosX(ind) +  " to " + -xbound)
           agent.pos(1) = -xbound;
        end
        if agent.pos(2)>ybound
           % disp("trial " + trials + " moved " + iPosY(ind) +  " to " + ybound)
           agent.pos(2) = ybound;
        end
        if agent.pos(2)<-ybound
           % disp("trial " + trials + " moved "+ iPosY(ind) +  " to " + ybound)
           agent.pos(2) = -ybound;
        end
        iXpos(ind) = agent.pos(1);
        iYpos(ind) = agent.pos(2);
        % plot(agent.pos(1), agent.pos(2), 'g.');
        ih.XData = iXpos(1:iind);
        ih.YData = iYpos(1:iind);
    end
    drawnow;
end 
