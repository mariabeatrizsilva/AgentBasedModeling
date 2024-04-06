
rounds = [25, 50, 100, 200, 400];
for round=1:length(rounds)
    subplot(2, 3, round)
    %% Calls to function 
    agentbased( .75, ...               % a
                0.05, ...              % b
                0.02,...               % c
                50,...                 % numIndivs
                rounds(round), ...     % numTrials
                1, ...                 % riskDist
                15, ...                % numIll
                0.2, ...               % D (m^2/s)
                30, ...                % numdays
                10, ...                % numMasked
                0.5, ...               % maskEffect
                'T', ...               % seeSociability
                10);                   % numRuns       
end

function agentbased(aIn,bIn,cIn, numIndivs, numTrials, riskDist, numIll, D, numdays, numMasked, maskEffect, seeSociability, numRuns)
    %% Constants
    tmax          = numdays;          % Duration of the simulation (s).
    dt            = tmax/numTrials;         % The duration of each time step.
    a             = aIn;                % Transmission Rate (s).
    b             = bIn;                % Recovery Rate     (s).
    c             = cIn;                % Death Rate        (s).
    stepSize = sqrt(D*dt);
    
    %% Create figure for plotting
    hold on;
    axis square;
    xlabel('x');
    ylabel('y');
    xbound = 10;
    ybound = 10;
    axis([-.5 xbound+2.25 -.25 ybound+1.75]);
    
    t_save = zeros(1, numTrials+1);
    S_average = zeros(1, numTrials+1);
    I_average = zeros(1, numTrials+1);
    R_average = zeros(1, numTrials+1);
    D_average = zeros(1, numTrials+1);
        
    %% Create array of individuals with initial positions and groups
    numSpec = 0;
    p1 = indiv; 
    p1.pos = [10*rand(),10*rand];
    indivs = createArray(1,numIndivs,FillValue=p1);     %% Make an array of people
    for run=1:numRuns
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
        
        hold on;
        
        for trial=1: numTrials
            hold off

            t   = trial*dt;
            I  = 0;       % Infected
            S  = 0;       % Susceptible 
            R  = 0;       % Recovered
            D  = 0;       % Deceased
            
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
                    S= S+ 1;
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
                                if transmission > rand(1)                        % make sick if bigger than a value
                                    indivs(ind).grp = 'I';
                                    break;
                                end
                            end
                        end
                    end
                end
            end

            t_save(trial+1) = t; 
            S_average(trial+1) = (S_average(trial+1)*(run-1) +S)/run;
            I_average(trial+1) = (I_average(trial+1)*(run-1) + I)/run;
            R_average(trial+1) = (R_average(trial+1)*(run-1) + R)/run;
            D_average(trial+1) = (D_average(trial+1)*(run-1) + D)/run;
        
            axis equal;
            xlabel('x');
            ylabel('y');
            axis([-.25,xbound+2.25,-.25,ybound+1.25])
            xline(10.25);
            title(['Trial: ', num2str(trial), '  |  Day: ', num2str(t)]);

            drawnow update;
        end 
    end
    
    hold off;

    S_average(1) = numIndivs - numIll;
    I_average(1) = numIll;
        
    % Plots trendlines
    plot(t_save, S_average, 'green', 'linewidth', 1.5);

    hold on;

    plot(t_save, I_average, 'red', 'linewidth', 1.5);
    plot(t_save, R_average, 'blue', 'linewidth', 1.5);
    plot(t_save, D_average, 'black', 'linewidth', 1.5);

    legend({'S','I','R', 'D'},'Location','northeast');

    title(['Averages | Trials: ', num2str(numTrials) ' | Runs: ', num2str(numRuns)]);

    drawnow;

end %ends the function 