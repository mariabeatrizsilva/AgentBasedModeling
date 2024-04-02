
%% Calls to function 
agentbased( 1.00, ...   % a
            0.05, ...   % b
            0.02,...    % c
            100,...     % numIndivs
            30, ...     % numTrials
            1, ...      % riskDist
            20, ...     % numIll
            1, ...      % stepSize
            10, ...     % numdays
            20, ...     % spec
            0.5, ...    % maskEffect
            'T');       % seeSociability

function agentbased(aIn,bIn,cIn, numIndivs, numTrials, riskDist, numIll, stepSizeIn, numdays, numMasked, maskEffect, seeSociability)
%% Constants
day           = 60*60*24;               % Day length (s).
tmax          = day * numdays;          % Duration of the simulation (s).
dt            = tmax/numTrials;         % The duration of each time step.
a             = aIn/day;                % Transmission Rate (s).
b             = bIn/day;                % Recovery Rate     (s).
c             = cIn/day;                % Death Rate        (s).
stepSize      = stepSizeIn/day;   % Maximum daily step length (m/sqrt(s)).

%% Create figure for plotting
figure;
hold on;
axis square;
xlabel('x');
ylabel('y');
xbound = 10;
ybound = 10;
axis([-.25 xbound+2.25 -.25 ybound+1.25]);

%% Create array of individuals with initial positions and groups
numSpec = 0;
p1 = indiv; 
p1.pos = [10*rand(),10*rand];
indivs = createArray(1,numIndivs,FillValue=p1); % Array of people
for ind=1:numIndivs 
    person = indiv; 
    person.pos = [10*rand(),10*rand];
    if ind <= numIll %% Infect numIll of them 
        person.grp = 'I';
    end
    if person.grp ~= 'I' && numSpec < numMasked %% Make some wear masks 
        person.maskWearer = 'Y';
        numSpec = numSpec + 1;
    end 
    if seeSociability == 'T'
        person.sociability = 0.9*(rand(1)^2) + 0.1; %% People are social in diff ways
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

for trial=1: numTrials
    hold off
    t   = trial*dt;
    I   = 0;       % Infected
    S   = 0;       % Susceptible 
    R   = 0;       % Recovered
    D   = 0;       % Deceased
    MWs = 0;       
    MWi = 0;
    MWr = 0;
    MWd = 0;
    for ind=1:numIndivs % move people
        agent = indivs(ind);
        if indivs(ind).grp == 'D'              % Dead people go to a separate section
            indivs(ind).pos(1) = 11.25;
        else 
            mvx = agent.sociability *  sqrt(dt* stepSize)* (sqrt(12)*rand()-(sqrt(12)/2)) + 0.5 * agent.inertia(1);   % amount for x to move
            mvy = agent.sociability *  sqrt(dt* stepSize)* (sqrt(12)*rand()-(sqrt(12)/2)) + 0.5 * agent.inertia(2);   % amount for y to move
            agent.inertia(1) = mvx;
            agent.inertia(2) = mvy;
            agent.pos(1) = agent.pos(1) + mvx;  % updating positions
            agent.pos(2) = agent.pos(2) + mvy;
            if agent.pos(1)>xbound
               agent.pos(1) = xbound;
            end
            if agent.pos(1) <-xbound
               agent.pos(1) = -xbound;
            end
            if agent.pos(2) > ybound
               agent.pos(2) = ybound;
            end
            if agent.pos(2) < -ybound
               agent.pos(2) = -ybound;
            end
        end
        if indivs(ind).grp     == 'S'
            color = 'green';
        elseif indivs(ind).grp == 'I'
            color = 'red';
        elseif indivs(ind).grp == 'R'
            color = 'blue';
        elseif indivs(ind).grp == 'D'
            color = 'black';
        end
        scalesociability = 1;
        if seeSociability == 'T'
            scalesociability = 3 * agent.sociability;
        end
        if agent.maskWearer == 'Y'
            plot(agent.pos(1), agent.pos(2), 'o', 'MarkerSize', 7  * scalesociability , 'Color', color);
        else 
            plot(agent.pos(1), agent.pos(2), '.', 'MarkerSize', 25 * scalesociability, 'Color', color);
        end 
        hold on
        if indivs(ind).grp == 'R'
            R = R + 1;
            if indivs(ind).maskWearer == 'Y'
                MWr = MWr+1;
            end 
        elseif indivs(ind).grp == 'D'
            D = D + 1;
            if indivs(ind).maskWearer == 'Y'
                MWd = MWd+1;
            end 
        elseif indivs(ind).grp == 'I'
            I = I + 1;
            if indivs(ind).maskWearer == 'Y'
                MWi = MWi+1;
            end 
            if rand(1) < dt*b
                indivs(ind).grp = 'R';
            elseif rand(1) > 1-dt*c
                indivs(ind).grp = 'D';
            end
        elseif indivs(ind).grp == 'S'
            S = S + 1;
            if indivs(ind).maskWearer == 'Y'
                MWs = MWs+1;
            end 
            for new_ind=1:numIndivs
                new_person = indivs(new_ind);
                if indivs(new_ind).grp == 'I'
                    distance = norm(new_person.pos - agent.pos);
                    if distance < riskDist
                        transmission = maskEffect * dt * a * (1 - distance/riskDist);
                        if transmission > rand(1)
                            indivs(ind).grp = 'I';
                            break;
                        end
                    end
                end
            end
        end
    end
    Stxt = ['S: ' num2str(S)];
    Itxt = ['I: ' num2str(I)];
    Rtxt = ['R: ' num2str(R)];
    Dtxt = ['D: ' num2str(D)];
    MWstxt = ['S: ' num2str(MWs)];
    MWitxt = ['I: ' num2str(MWi)];
    MWrtxt = ['R: ' num2str(MWr)];
    MWdtxt = ['D: ' num2str(MWd)];
    Ttxt   = ['Total: ' num2str(S+I+R+D)];
    MWTtxt = ['Total: ' num2str(MWs+MWi+MWr+MWd)];
    text(.1,10.75,'No mask:','Color', 'k');
    text(.1,10.25,'Mask:','Color', 'k');
    text(2,10.75,Stxt,'Color', 'g');
    text(4,10.75,Itxt,'Color', 'r');
    text(6,10.75,Rtxt,'Color', 'b');
    text(8,10.75,Dtxt,'Color', 'k');
    text(2,10.25,MWstxt,'Color', 'g');
    text(4,10.25,MWitxt,'Color', 'r');
    text(6,10.25,MWrtxt,'Color', 'b');
    text(8,10.25,MWdtxt,'Color', 'k');
    text(10.5,10.75,Ttxt,'Color', 'k');
    text(10.5,10.25,MWTtxt,'Color', 'k');

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
plot(t_save, S_save, 'g', 'linewidth', 1.5);
plot(t_save, I_save, 'r', 'linewidth', 1.5);
plot(t_save, R_save, 'b', 'linewidth', 1.5);
plot(t_save, D_save, 'k', 'linewidth', 1.5);

legend({'S','I','R', 'D'},'Location','northeast')

drawnow
end %ends the function 