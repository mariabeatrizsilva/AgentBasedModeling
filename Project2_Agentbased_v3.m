
%% Setting random seed 
rng(1)

%% Calls to function 
% numIll + numMasked <= numIndivs
agentbased( .9, ...    % a
            0.05, ...   % b
            0.02,...    % c
            50,...     % numIndivs
            50, ...    % numTrials
            1, ...      % riskDist
            10, ...     % numIll
            0.2, ...    % D (m^2/s)
            30, ...     % numdays
            10, ...     % numMasked
            0.0, ...   % maskEffect
            'T');       % seeSociability


function agentbased(aIn,bIn,cIn, numIndivs, numTrials, riskDist, numIll, D, numdays, numMasked, maskEffect, seeSociability)
%% Constants
tmax          = numdays;          % Duration of the simulation (s).
dt            = tmax/numTrials;         % The duration of each time step.
a             = aIn;                % Transmission Rate (s).
b             = bIn;                % Recovery Rate     (s).
c             = cIn;                % Death Rate        (s).
stepSize      = sqrt(D*dt);

%% Create figure for plotting
figure;
x0=0;
y0=0;
width=600;
height=400;
set(gcf,'position',[x0 y0 2*width 2*height])
hold on;
axis square;
xlabel('x');
ylabel('y');
xbound = 10;
ybound = 10;
axis([-.5 xbound+2.25 -.25 ybound+1.75]);

%% Create array of individuals with initial positions and groups
numSpec = 0;
p1 = indiv; 
p1.pos = [10*rand(),10*rand];
indivs = createArray(1,numIndivs,FillValue=p1);     %% Make an array of people
for ind=1:numIndivs 
    person = indiv; 
    person.pos = [10*rand(),10*rand];
    if ind <= numIll                                %% Infect numIll of them 
        person.grp = 'I';
    end
    if person.grp ~= 'I' && numSpec < numMasked     %% Make some wear masks 
        person.maskWearer = 'Y';
        numSpec = numSpec + 1;
    end 
    if seeSociability == 'T'
        person.sociability = 0.9*(rand(1)^2) + 0.1; %% People are social in diff ways
    end
    indivs(ind) = person;
end 

%% Arrays to plot final SIRD graphs
t_save = zeros(1, numTrials+1);
S_save = zeros(1, numTrials+1);
I_save = zeros(1, numTrials+1);
R_save = zeros(1, numTrials+1);
D_save = zeros(1, numTrials+1);
MWS_save = zeros(1, numTrials+1);
MWI_save = zeros(1, numTrials+1);
MWR_save = zeros(1, numTrials+1);
MWD_save = zeros(1, numTrials+1);

S_save(1)   = numIndivs - numIll;
I_save(1)   = numIll;
MWS_save(1) = numMasked;
MWI_save(1) = 0;

hold on;

for trial=1: numTrials
    subplot(1,2,1);
    hold off
    subplot(1,2,2);
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
            mvx = agent.sociability *  stepSize * (sqrt(12) * rand()-(sqrt(12)/2));   % amount for x to move
            mvy = agent.sociability *  stepSize * (sqrt(12) * rand()-(sqrt(12)/2));   % amount for y to move
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
        subplot(1,2,2);
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
            for new_ind=1:numIndivs           % loop over all individuals
                new_person = indivs(new_ind);
                if indivs(new_ind).grp == 'I' % if someone is sick how far they are
                    distance = norm(new_person.pos - agent.pos);
                    if distance < riskDist    % if theyre close enough 
                        transmission = dt * a * (1 - distance/riskDist); % compute transmission chance
                        if (indivs(new_ind).maskWearer == 'Y')           % if they're wearing a mask --> transmission chance decreases 
                            transmission = (1-maskEffect) * transmission;
                        end
                        if (indivs(ind).maskWearer == 'Y')               % if we're wearing a mask --> transmission chance decreases 
                            transmission = (1-maskEffect) * transmission;
                        end
                        % Plot dot on interaction matrix
                        subplot(1,2,1);
                        scatter(ind,new_ind, 200*2*transmission, 'filled', 'MarkerFaceColor', [transmission 1-transmission 0]);
                        hold on
                        if transmission > rand(1)                        % make sick if bigger than a value
                            indivs(ind).grp = 'I';
                            break;
                        end
                    end
                end
            end
        end
    end
    subplot(1,2,2);
    Stxt = ['S: ' num2str(S)];
    Itxt = ['I: ' num2str(I)];
    Rtxt = ['R: ' num2str(R)];
    Dtxt = ['D: ' num2str(D)];
    MWstxt = ['S: ' num2str(MWs)];
    MWitxt = ['I: ' num2str(MWi)];
    MWrtxt = ['R: ' num2str(MWr)];
    MWdtxt = ['D: ' num2str(MWd)];
    shifty = .25;
    text(.1,10.75+shifty,'Everyone:','Color', 'k');
    text(.1,10.25+shifty,'Masked:','Color', 'k');
    text(2,10.75+shifty,Stxt,'Color', 'g');
    text(4,10.75+shifty,   Itxt,'Color', 'r');
    text(6,10.75+shifty,   Rtxt,'Color', 'b');
    text(8,10.75+shifty,   Dtxt,'Color', 'k');
    text(2,10.25+shifty,MWstxt,'Color', 'g');
    text(4,10.25+shifty,MWitxt,'Color', 'r');
    text(6,10.25+shifty,MWrtxt,'Color', 'b');
    text(8,10.25+shifty,MWdtxt,'Color', 'k');
    text(10.35,11.5,'% Infected','Color', 'k');
    text(11.,10.75+shifty,[num2str((I+R+D)/(S+I+R+D))],'Color', 'k');
    text(11.,10.25+shifty,[num2str((MWi+MWr+MWd)/(MWs+MWi+MWr+MWd))],'Color', 'k');

    % Update t_save, Ssave, Isave, Rsave, Dsave
    t_save(trial+1) = t; 
    S_save(trial+1) = S;
    I_save(trial+1) = I; 
    R_save(trial+1) = R; 
    D_save(trial+1) = D; 
    MWS_save(trial+1) = MWs;
    MWI_save(trial+1) = MWi; 
    MWR_save(trial+1) = MWr; 
    MWD_save(trial+1) = MWd; 

    axis equal;
    xlabel('x');
    ylabel('y');
    axis([-.25,xbound+2.25,-.25,ybound+1.25])
    xline(10.25);
    title(['Trial: ', num2str(trial), '  |  Day: ', num2str(t)]);
    subplot(1,2,1);
    axis equal;
    axis([0, numIndivs,0,numIndivs]);
    grid on;
    xlabel('Susceptible Individual');
    ylabel('Infected Individual');
    drawnow;
    %% Uncomment to save first and final frame 
     % if trial == 1 
     %     saveas(gcf, ['mn' num2str(numMasked) 'me' num2str(maskEffect) '-init.png']);
     % end
     % if trial == numTrials 
     %    saveas(gcf, ['mn' num2str(numMasked) 'me' num2str(maskEffect) '-final.png']);
     % end
end 

figure('Name', ['mn = ' num2str(numMasked) ' | me = ' num2str(maskEffect)])
x0=0;
y0=0;
width=500;
height=500;
set(gcf,'position',[x0 y0 2*width 2*height])
subplot(2,2,1);
hold on

% Plots total population graph
title('Total Population');
plot(t_save, S_save, 'g', 'linewidth', 1.5);
plot(t_save, I_save, 'r', 'linewidth', 1.5);
plot(t_save, R_save, 'b', 'linewidth', 1.5);
plot(t_save, D_save, 'k', 'linewidth', 1.5);

legend({'S','I','R', 'D'},'Location','northeast')

drawnow

subplot(2,2,2);
hold on
title('Masked vs Unmasked');
plot(t_save, MWS_save, 'Color', '#77AC30', 'linewidth', 1, 'LineStyle', '--');
plot(t_save, MWI_save, 'Color', '#A2142F', 'linewidth', 1, 'LineStyle', '--');
plot(t_save, MWR_save, 'Color', '#0072BD', 'linewidth', 1, 'LineStyle', '--');
plot(t_save, MWD_save, 'Color', '#7E2F8E', 'linewidth', 1, 'LineStyle', '--');
plot(t_save, S_save-MWS_save, 'g', 'linewidth', 1, 'LineStyle', '-');
plot(t_save, I_save-MWI_save, 'r', 'linewidth', 1, 'LineStyle', '-');
plot(t_save, R_save-MWR_save, 'b', 'linewidth', 1, 'LineStyle', '-');
plot(t_save, D_save-MWD_save, 'k', 'linewidth', 1, 'LineStyle', '-')

lgd = legend({'S','I','R','D', 'S','I','R','D'},'Location','northeast');
title(lgd,'Masked   Unmasked')
lgd.NumColumns = 2;
drawnow;

subplot(2,2,3);
hold on
title('Unmasked Population');
plot(t_save, S_save-MWS_save, 'g', 'linewidth', 1.5);
plot(t_save, I_save-MWI_save, 'r','linewidth', 1.5);
plot(t_save, R_save-MWR_save, 'b','linewidth', 1.5);
plot(t_save, D_save-MWD_save, 'k','linewidth', 1.5);

legend({'S','I','R', 'D'},'Location','northeast')

drawnow;

subplot(2,2,4);
hold on
title('Masked Population');
plot(t_save, MWS_save,'g', 'linewidth', 1.5);
plot(t_save, MWI_save, 'r','linewidth', 1.5);
plot(t_save, MWR_save,'b', 'linewidth', 1.5);
plot(t_save, MWD_save,'k', 'linewidth', 1.5);

legend({'S','I','R', 'D'},'Location','northeast');
%% Uncomment to save graph 
% saveas(gcf, ['mn' num2str(numMasked) 'me' num2str(maskEffect) '-SIRD.png']);
end % ends the function 