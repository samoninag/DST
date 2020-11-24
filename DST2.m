%% CREATED BY SAMONI NAG ON 10/22/2020

% daybag COLUMNS NEEDED:
    % UserId
    % SessionLocalTime
    % RankId
    % StatusId 
    % TotalStars 
    % TimeInScanner
    % Suspected 
    % IllegalItems   
    % Illegal1Marked
    % Illegal1MarkTime
    % Illegal2Marked
    % Illegal3Marked 
    % DayOfWeek 

% opts = detectImportOptions('DST_AUTUMN_2015_MOUNTAIN_PRE.csv');
% opts.SelectedVariableNames = {'UserId' 'IllegalItems' 'SessionLocalTime' 'RankId' 'DayOfWeek' 'Suspected' 'TimeInScanner' 'Illegal1Marked' 'Illegal1MarkTime' 'Illegal2Marked' 'Illegal3Marked' 'StatusId' 'TotalStars'}; 
% t = readtable('DST_AUTUMN_2015_MOUNTAIN_PRE.csv',opts);
% t.ExtraVar1 = []; t.ExtraVar2 = []; t.ExtraVar3 = []; 
% ttds = tabularTextDatastore(direc.data,'FileExtensions','.csv', 'OutputType', table);
    
%%

clc; clear; close all; 

%% DIRECTORIES

server = 0; % change to 1 if running on server thingy 

if server == 1
    % SERVER
    direc.home = '/bigraid/samoninag/DST';
    direc.data = '/bigraid/samoninag/DST/data';
    direc.results = '/bigraid/samoninag/DST/results';
else
    % LOCAL
    direc.home = '/Users/samoninag/Documents/Mitroff Lab/DST';
    direc.data = '/Users/samoninag/Documents/Mitroff Lab/DST/data';
    direc.results = '/Users/samoninag/Documents/Mitroff Lab/DST/results';
end
 
%% GATHER DATA

% columnNames = {'UserId','OriginalId','BagId','Date','SessionLength','SessionId','SessionLocalTime','TimeZone','RankId','StatusId','AirportId','Passengers','Aircrafts','Tier','Day','DayLength','isAssessment','AssessmentId','isChallenge','ChallengeId','Replay','ModeId','DayId','Score','Rating','TotalStars','LevelId','TypeId','SoundId','AirMarshal','TimeInScanner','ActiveUpgradesId','Suspected','UniqueTaps','FirstLegalTapTime','HighLightItemId','Bags1Illegal','Bags2Illegal','Bags3Illegal','FalseCalls','FalseMarks','SecurityBreaches','FlightCrew','FlightCrewDelayed','FirstClass','FirstClassDelayed','NextFlight','NextFlightNotHeld','AirMarshalls','AirMarshallsOk','AppVersion','DeviceName','SystemName','SystemVersion','LostDataSincePreviousSession','IllegalItemsAvailable','LegelItemsAvailable','IllegalItems','RareItems','LegalItems','IllegalItemsMarked','LegalItemsMarked','Illegal1Id','Illegal1Marked','Illegal1MarkTime','Illegal1X','Illegal1Y','Illegal1Z','Illegal1Rot','Illegal2Id','Illegal2Marked','Illegal2MarkTime','Illegal2X','Illegal2Y','Illegal2Z','Illegal2Rot','Illegal3Id','Illegal3Marked','Illegal3MarkTime','Illegal3X','Illegal3Y','Illegal3Z','Illegal3Rot','RareItemId','RareItemMarked','RareItemMarkTime','RareItemX','RareItemY','RareItemZ','RareItemRot','Legal1Id','Legal1Marked','Legal1X','Legal1Y','Legal1Z','Legal1Rot','Legal2Id','Legal2Marked','Legal2X','Legal2Y','Legal2Z','Legal2Rot','Legal3Id','Legal3Marked','Legal3X','Legal3Y','Legal3Z','Legal3Rot','Legal4Id','Legal4Marked','Legal4X','Legal4Y','Legal4Z','Legal4Rot','Legal5Id','Legal5Marked','Legal5X','Legal5Y','Legal5Z','Legal5Rot','Legal6Id','Legal6Marked','Legal6X','Legal6Y','Legal6Z','Legal6Rot','Legal7Id','Legal7Marked','Legal7X','Legal7Y','Legal7Z','Legal7Rot','Legal8Id','Legal8Marked','Legal8X','Legal8Y','Legal8Z','Legal8Rot','Legal9Id','Legal9Marked','Legal9X','Legal9Y','Legal9Z','Legal9Rot','Legal10Id','Legal10Marked','Legal10X','Legal10Y','Legal10Z','Legal10Rot','Legal11Id','Legal11Marked','Legal11X','Legal11Y','Legal11Z','Legal11Rot','Legal12Id','Legal12Marked','Legal12X','Legal12Y','Legal12Z','Legal12Rot','Legal13Id','Legal13Marked','Legal13X','Legal13Y','Legal13Z','Legal13Rot','Legal14Id','Legal14Marked','Legal14X','Legal14Y','Legal14Z','Legal14Rot','Legal15Id','Legal15Marked','Legal15X','Legal15Y','Legal15Z','Legal15Rot','Legal16Id','Legal16Marked','Legal16X','Legal16Y','Legal16Z','Legal16Rot','Legal17Id','Legal17Marked','Legal17X','Legal17Y','Legal17Z','Legal17Rot','Legal18Id','Legal18Marked','Legal18X','Legal18Y','Legal18Z','Legal18Rot','Legal19Id','Legal19Marked','Legal19X','Legal19Y','Legal19Z','Legal19Rot','Legal20Id','Legal20Marked','Legal20X','Legal20Y','Legal20Z','Legal20Rot','TotalItemCombination','DayOfWeek','Var213'}; 

% fields = {'pres','pres_rt','abs', 'dual', 'multi', 'tooEarly', 'toolate', 'tooFewTrials', 'tooManyTrials'};
% c = cell(length(fields),1);
% n = cell2struct(c,fields);
% 
% fields = {'id','rank','year', 'season', 'timeZone', 'position', 'day', 'hit', 'rt', 'miss', 'cr', 'tis', 'fa', 'dual', 'multi', 'completed', 'securityBreach', 'outOfTime', 'quit', 'totalStars', 'badges'};
% c = cell(length(fields),1);
% res = cell2struct(c,fields);

cd(direc.data); 

dataFiles = dir('*.csv');
numFiles = numel(dataFiles); 

tic
for i = 1:numFiles
    
    clear d opts
    
    fprintf('\n\n');
    fprintf('EXTRACTING DATA FROM FILE %d OUT OF %d!\n', i, numFiles);
    fprintf('\t FILE: %s\n', dataFiles(i).name);
     
    d = importfile_matlab(dataFiles(i).name);   
    
    % YEAR 
    if contains(dataFiles(i).name,'2013') 
        year = repmat(2013, [height(d),1]);
    elseif contains(dataFiles(i).name,'2014')
        year = repmat(2014, [height(d),1]);
    elseif contains(dataFiles(i).name,'2015')
        year = repmat(2015, [height(d),1]);
    elseif contains(dataFiles(i).name,'2016')
        year = repmat(2016, [height(d),1]);
    elseif contains(dataFiles(i).name,'2017')
        year = repmat(2017, [height(d),1]);
    elseif contains(dataFiles(i).name,'2018')
        year = repmat(2018, [height(d),1]);
    elseif contains(dataFiles(i).name,'2019') 
        year = repmat(2019, [height(d),1]);
    end
    d.year = year; 
    
    % SEASON 
    if contains(dataFiles(i).name,'SPRING')  
        season = repmat({'Spring'}, height(d), 1);
    elseif contains(dataFiles(i).name,'SUMMER')
        season = repmat({'Summer'}, height(d), 1);
    elseif contains(dataFiles(i).name,'AUTUMN') 
        season = repmat({'Autumn'}, height(d), 1);
    end
    d.season = season; 
      
    % TIME ZONE 
    if contains(dataFiles(i).name,'EASTERN') 
        tz = repmat({'Eastern'}, height(d), 1);
    elseif contains(dataFiles(i).name,'CENTRAL')
        tz = repmat({'Central'}, height(d), 1);
    elseif contains(dataFiles(i).name,'MOUNTAIN')
        tz = repmat({'Mountain'}, height(d), 1);
    elseif contains(dataFiles(i).name,'PACIFIC')
        tz = repmat({'Pacific'}, height(d), 1);
    elseif contains(dataFiles(i).name,'ALASKA') 
        tz = repmat({'Alaska'}, height(d), 1);
    end
    d.timezoneLabel = tz; 
    
    % POSITION
    if contains(dataFiles(i).name,'PRE') 
        pos = repmat({'Pre'}, height(d), 1);
    elseif contains(dataFiles(i).name,'POST') 
        pos = repmat({'Post'}, height(d), 1);
    end
    d.position = pos;
    
    ids = unique(d.UserId); 
    N = numel(ids); 
    
    n.pres = zeros(N,1); 
    n.pres_rt = zeros(N,1); 
    n.abs = zeros(N,1); 
    n.dual = zeros(N,1); 
    n.multi = zeros(N,1);  
    n.tooEarly = zeros(N,1);  
    n.tooLate = zeros(N,1);  
    n.tooFewTrials = zeros(N,1);  
    n.tooManyTrials = zeros(N,1);  

    res.id = NaN(N,1); 
    res.rank = cell(N,1); % RankId
    res.year = NaN(N,1); % 2013-2019
    res.season = cell(N,1); % spring, summer, autumn
    res.timeZone = cell(N,1); % eastern, central, mountain, pacific, alaska 
    res.position = cell(N,1); % before-change, after-change 
    res.day = cell(N,1); % DayOfWeek
    res.hit = zeros(N,1); % Illegal1Marked=1 on single-target present trials
    res.rt = zeros(N,1); % Illegal1MarkedTime on single-target present trials
    res.miss = zeros(N,1); % Suspected=0 and Illegal1Marked=0 on single-target present trials 
    res.cr = zeros(N,1); % Suspected=0 on target absent trials
    res.tis = zeros(N,1); % TimeInScanner on target absent trials
    res.fa = zeros(N,1); % Suspected=1 on target absent trials   
    res.dual = zeros(N,1); % Illegal2Marked when IllegalItems>1 & Illegal1Marked=1   
    res.multi = zeros(N,1); % Illegal3Marked when IllegalItems>2 & Illegal1Marked=1 & Illegal2Marked=1  
    res.completed = zeros(N,1); % % StatusId=1
    res.securityBreach = zeros(N,1); % % StatusId=2
    res.outOfTime = zeros(N,1); % StatusId=3  
    res.quit = zeros(N,1); % StatusId=4 
    res.totalStars = zeros(N,1); % 
    res.badges = NaN(N,1); % 
 
    for subj = 1:N
        
%         fprintf('\n'); 
        id = ids(subj);  
        subjData = d(d.UserId==id,:);  
        fprintf('File number: %d out of %d\n\t Subject %d out of %d (ID:%d)\n', i, numFiles, subj, N, id);

        % EXCLUSIONS 
        if height(subjData) > 24 % more than 24 trials/bags in HA day 1 (this shouldn't happen...)
            n.tooManyTrials(subj) = 1;  
            continue; % skip
        end 
        if sum(subjData.IllegalItems==1) < 5 % fewer than 5 target-present trials 
            n.tooFewTrials(subj) = 1; 
            continue; % skip 
        end 
        if subjData.SessionLocalTime(1) < (3600 * 6)  % game play between 12:00AM and 5:59AM
            n.tooEarly(subj) = 1; 
            continue; % skip 
        elseif subjData.SessionLocalTime(1) > (3600 * 24) % game play after 11:59PM
            n.tooLate(subj) = 1; 
            continue; % skip 
        end 

        % SUBJECT ID
        res.id(subj,1) = id; 

        % RANK 
        rank = subjData.RankId(1); 
        switch rank
            case 1 % trainee
                res.rank{subj,1} = 'Trainee'; 
            case 2 % operator
                res.rank{subj,1} = 'Operator'; 
            case 3 % pro
                res.rank{subj,1} = 'Pro'; 
            case 4 % expert
                res.rank{subj,1} = 'Expert'; 
            case 5 % elite 
                res.rank{subj,1} = 'Elite'; 
        end 

        % YEAR 
        res.year(subj,1) = subjData.year(1);

        % SEASON 
        res.season(subj,1) = subjData.season(1); 

        % TIME ZONE 
        res.timeZone(subj,1) = subjData.timezoneLabel(1); 

        % POSITION
        res.position(subj,1) = subjData.position(1);

        % DAY OF WEEK 
        switch subjData.DayOfWeek{1}
            case {'1'}
                res.day{subj,1} = 'Sunday'; 
            case {'2'}
                res.day{subj,1} = 'Monday'; 
            case {'3'}
                res.day{subj,1} = 'Tuesday'; 
            case {'4'}
                res.day{subj,1} = 'Wednesday'; 
            case {'5'}
                res.day{subj,1} = 'Thursday'; 
            case {'6'}
                res.day{subj,1} = 'Friday'; 
            case {'7'}
                res.day{subj,1} = 'Saturday'; 
        end 

        % HIT RATE, MISS RATE, FALSE ALARM RATE, CORRECT REJECTION RATE, RESPONSE TIME, TIME IN SCANNER, DUAL TARGET ACC, MULTI TARGET ACC   
        for trial = 1:height(subjData)

            switch subjData.IllegalItems(trial)
                case 0 % target-absent 
                    n.abs(subj,1) = n.abs(subj,1) + 1;  
                    if subjData.Suspected(trial) == 0 % correct rejection
                        res.cr(subj,1) = res.cr(subj,1) + 1; 
                        res.tis(subj,1) = res.tis(subj,1) + subjData.TimeInScanner(trial); 
                    elseif subjData.Suspected(trial) == 1 % false alarm
                        res.fa(subj,1) = res.fa(subj,1) + 1; 
                    end 
                case 1 % target-present 
                    n.pres(subj,1) = n.pres(subj,1) + 1;  
                    if subjData.Illegal1Marked(trial) == 1 % hit
                        res.hit(subj,1) = res.hit(subj,1) + 1;  
                        if subjData.Illegal1MarkTime(trial)>= 100
                            n.pres_rt(subj,1) = n.pres_rt(subj,1) + 1; 
                            res.rt(subj,1) = res.rt(subj,1) + subjData.Illegal1MarkTime(trial); 
                        end
                    elseif subjData.Illegal1Marked(trial) == 0 && subjData.Suspected(trial) == 0 % miss
                        res.miss(subj,1) = res.miss(subj,1) + 1; 
                    end 
                case 2 % dual-taget
                    n.dual(subj,1) = n.dual(subj,1) + 1; 
                    if subjData.Illegal1Marked(trial) == 1 && strcmp(subjData.Illegal2Marked(trial), '1') % found both targets
                        res.dual(subj,1) = res.dual(subj,1) + 1; 
                    elseif (subjData.Illegal1Marked(trial) == 1 && strcmp(subjData.Illegal2Marked(trial), '0')) || (subjData.Illegal1Marked(trial) == 0 && strcmp(subjData.Illegal2Marked(trial), '1')) % only found 1 target
                        res.dual(subj,1) = res.dual(subj,1) + 0;  
                    end
                case 3 % multi-target 
                    n.multi(subj,1) = n.multi(subj,1) + 1; 
                    if subjData.Illegal1Marked(trial) == 1 && strcmp(subjData.Illegal2Marked(trial), '1')  && strcmp(subjData.Illegal3Marked(trial), '1') % found all targets
                        res.multi(subj,1) = res.multi(subj,1) + 1; 
                    elseif ((subjData.Illegal1Marked(trial) == 1 && strcmp(subjData.Illegal2Marked(trial), '1') && strcmp(subjData.Illegal3Marked(trial), '0')) || (subjData.Illegal1Marked(trial) == 1 && strcmp(subjData.Illegal2Marked(trial), '0') && strcmp(subjData.Illegal3Marked(trial), '1')) || (subjData.Illegal1Marked(trial) == 0 && strcmp(subjData.Illegal2Marked(trial), '1') && strcmp(subjData.Illegal3Marked(trial), '1'))) % found 2 of 3 targets 
                        res.multi(subj,1) = res.multi(subj,1) + 0;  
                    end
            end  

        end % trial loop 

        % REPLACE ZEROS with NaNs
        if n.pres(subj) == 0 
            res.hit(subj) = NaN;
            res.rt(subj) = NaN;
            res.miss(subj) = NaN;
        end
        if n.abs(subj) == 0
            res.cr(subj) = NaN;
            res.tis(subj) = NaN;
            res.fa(subj) = NaN;
        end
        if n.dual(subj) == 0
            res.dual(subj) = NaN;
        end
        if n.multi(subj) == 0
            res.multi(subj) = NaN;
        end

        % STATUS (COMPLETED, SECURITY BREACH, OUT OF TIME, & SOMETHING-ELSE)
        switch subjData.StatusId(1) 
            case 1 % completed
                res.completed(subj,1) = 1; 
            case 2 % security breach
                res.securityBreach(subj,1) = 1;
            case 3 % out of time
                res.outOfTime(subj,1) = 1;
            case 4 % quit
                res.quit(subj,1) = 1;
        end

        % TOTAL STARS
        res.totalStars(subj,1) = subjData.TotalStars(end); 

        % BADGES 

    end % subject loop 
    
    temp1 = res; 
    res.hit = (res.hit ./ n.pres) * 100;
    res.miss = (res.miss ./ n.pres) * 100;
    res.rt = res.rt ./ n.pres_rt;
    res.cr = (res.cr ./ n.abs) * 100;
    res.fa = (res.fa ./ n.abs) * 100;
    res.tis = res.tis ./ n.abs;
    res.dual = res.dual ./ n.dual;
    res.multi = res.multi ./ n.multi;

    if i == 1
        results = struct2table(res); 
    else
        results = [results; struct2table(res)]; 
    end
    
    toc
    
end % data file loop

% remove rows where subjects were skipped (id should be NaN)
for j = 1:height(results)
    if isnan(results.id(j))
        idx(j,1) = 1; 
    else
        idx(j,1) = 0; 
    end 
end 
results.idx = idx; 
results(results.idx==1,:) = []; 
N = height(results);

fprintf('\n N = %d\n', N); 

%% PHASE ADVANCE (SPRING)

spring = results;
% idx = ~strcmp(results.season, 'Spring');
spring(~strcmp(results.season, 'Spring'),:) = [];  
    advance.avg.hit.pre = nanmean(spring.hit(strcmp(spring.position, 'Pre'))); 
    advance.avg.rt.pre = nanmean(spring.rt(strcmp(spring.position, 'Pre')));
    advance.avg.cr.pre = nanmean(spring.cr(strcmp(spring.position, 'Pre')));
    advance.avg.tis.pre = nanmean(spring.tis(strcmp(spring.position, 'Pre')));
    advance.avg.miss.pre = nanmean(spring.miss(strcmp(spring.position, 'Pre')));
    advance.avg.fa.pre = nanmean(spring.fa(strcmp(spring.position, 'Pre')));
    advance.avg.dual.pre = nanmean(spring.dual(strcmp(spring.position, 'Pre')));
    advance.avg.multi.pre = nanmean(spring.multi(strcmp(spring.position, 'Pre')));
    advance.avg.complete.pre = nanmean(spring.completed(strcmp(spring.position, 'Pre')));
    advance.avg.breach.pre = nanmean(spring.securityBreach(strcmp(spring.position, 'Pre')));
    advance.avg.timeout.pre = nanmean(spring.outOfTime(strcmp(spring.position, 'Pre')));
    advance.avg.quit.pre = nanmean(spring.quit(strcmp(spring.position, 'Pre')));
    advance.avg.hit.post = nanmean(spring.hit(strcmp(spring.position, 'Post'))); 
    advance.avg.rt.post = nanmean(spring.rt(strcmp(spring.position, 'Post')));
    advance.avg.cr.post = nanmean(spring.cr(strcmp(spring.position, 'Post')));
    advance.avg.tis.post = nanmean(spring.tis(strcmp(spring.position, 'Post')));
    advance.avg.miss.post = nanmean(spring.miss(strcmp(spring.position, 'Post')));
    advance.avg.fa.post = nanmean(spring.fa(strcmp(spring.position, 'Post')));
    advance.avg.dual.post = nanmean(spring.dual(strcmp(spring.position, 'Post')));
    advance.avg.multi.post = nanmean(spring.multi(strcmp(spring.position, 'Post')));
    advance.avg.complete.post = nanmean(spring.completed(strcmp(spring.position, 'Post')));
    advance.avg.breach.post = nanmean(spring.securityBreach(strcmp(spring.position, 'Post')));
    advance.avg.timeout.post = nanmean(spring.outOfTime(strcmp(spring.position, 'Post')));
    advance.avg.quit.post = nanmean(spring.quit(strcmp(spring.position, 'Post')));
        advance.stDev.hit.pre = nanstd(spring.hit(strcmp(spring.position, 'Pre'))); 
        advance.stDev.rt.pre = nanstd(spring.rt(strcmp(spring.position, 'Pre')));
        advance.stDev.cr.pre = nanstd(spring.cr(strcmp(spring.position, 'Pre')));
        advance.stDev.tis.pre = nanstd(spring.tis(strcmp(spring.position, 'Pre')));
        advance.stDev.miss.pre = nanstd(spring.miss(strcmp(spring.position, 'Pre')));
        advance.stDev.fa.pre = nanstd(spring.fa(strcmp(spring.position, 'Pre')));
        advance.stDev.dual.pre = nanstd(spring.dual(strcmp(spring.position, 'Pre')));
        advance.stDev.multi.pre = nanstd(spring.multi(strcmp(spring.position, 'Pre')));
        advance.stDev.complete.pre = nanstd(spring.completed(strcmp(spring.position, 'Pre')));
        advance.stDev.breach.pre = nanstd(spring.securityBreach(strcmp(spring.position, 'Pre')));
        advance.stDev.timeout.pre = nanstd(spring.outOfTime(strcmp(spring.position, 'Pre')));
        advance.stDev.quit.pre = nanstd(spring.quit(strcmp(spring.position, 'Pre')));
        advance.stDev.hit.post = nanstd(spring.hit(strcmp(spring.position, 'Post'))); 
        advance.stDev.rt.post = nanstd(spring.rt(strcmp(spring.position, 'Post')));
        advance.stDev.cr.post = nanstd(spring.cr(strcmp(spring.position, 'Post')));
        advance.stDev.tis.post = nanstd(spring.tis(strcmp(spring.position, 'Post')));
        advance.stDev.miss.post = nanstd(spring.miss(strcmp(spring.position, 'Post')));
        advance.stDev.fa.post = nanstd(spring.fa(strcmp(spring.position, 'Post')));
        advance.stDev.dual.post = nanstd(spring.dual(strcmp(spring.position, 'Post')));
        advance.stDev.multi.post = nanstd(spring.multi(strcmp(spring.position, 'Post')));
        advance.stDev.complete.post = nanstd(spring.completed(strcmp(spring.position, 'Post')));
        advance.stDev.breach.post = nanstd(spring.securityBreach(strcmp(spring.position, 'Post')));
        advance.stDev.timeout.post = nanstd(spring.outOfTime(strcmp(spring.position, 'Post')));
        advance.stDev.quit.post = nanstd(spring.quit(strcmp(spring.position, 'Post')));
            advance.counts.hit.pre = sum(~isnan(spring.hit(strcmp(spring.position, 'Pre'))));
            advance.counts.rt.pre = sum(~isnan(spring.rt(strcmp(spring.position, 'Pre'))));
            advance.counts.cr.pre = sum(~isnan(spring.cr(strcmp(spring.position, 'Pre'))));
            advance.counts.tis.pre = sum(~isnan(spring.tis(strcmp(spring.position, 'Pre'))));
            advance.counts.miss.pre = sum(~isnan(spring.miss(strcmp(spring.position, 'Pre'))));
            advance.counts.fa.pre = sum(~isnan(spring.fa(strcmp(spring.position, 'Pre'))));
            advance.counts.dual.pre = sum(~isnan(spring.dual(strcmp(spring.position, 'Pre'))));
            advance.counts.multi.pre = sum(~isnan(spring.multi(strcmp(spring.position, 'Pre'))));
            advance.counts.complete.pre = sum(~isnan(spring.completed(strcmp(spring.position, 'Pre'))));
            advance.counts.breach.pre = sum(~isnan(spring.securityBreach(strcmp(spring.position, 'Pre'))));
            advance.counts.timeout.pre = sum(~isnan(spring.outOfTime(strcmp(spring.position, 'Pre'))));
            advance.counts.quit.pre = sum(~isnan(spring.quit(strcmp(spring.position, 'Pre'))));
            advance.counts.hit.post = sum(~isnan(spring.hit(strcmp(spring.position, 'Post'))));
            advance.counts.rt.post = sum(~isnan(spring.rt(strcmp(spring.position, 'Post'))));
            advance.counts.cr.post = sum(~isnan(spring.cr(strcmp(spring.position, 'Post'))));
            advance.counts.tis.post = sum(~isnan(spring.tis(strcmp(spring.position, 'Post'))));
            advance.counts.miss.post = sum(~isnan(spring.miss(strcmp(spring.position, 'Post'))));
            advance.counts.fa.post = sum(~isnan(spring.fa(strcmp(spring.position, 'Post'))));
            advance.counts.dual.post = sum(~isnan(spring.dual(strcmp(spring.position, 'Post'))));
            advance.counts.multi.post = sum(~isnan(spring.multi(strcmp(spring.position, 'Post'))));
            advance.counts.complete.post = sum(~isnan(spring.completed(strcmp(spring.position, 'Post'))));
            advance.counts.breach.post = sum(~isnan(spring.securityBreach(strcmp(spring.position, 'Post'))));
            advance.counts.timeout.post = sum(~isnan(spring.outOfTime(strcmp(spring.position, 'Post'))));
            advance.counts.quit.post = sum(~isnan(spring.quit(strcmp(spring.position, 'Post'))));
                advance.sem.hit.pre = advance.stDev.hit.pre / sqrt(advance.counts.hit.pre);
                advance.sem.rt.pre = advance.stDev.rt.pre / sqrt(advance.counts.rt.pre);
                advance.sem.cr.pre = advance.stDev.cr.pre / sqrt(advance.counts.cr.pre);
                advance.sem.tis.pre = advance.stDev.tis.pre / sqrt(advance.counts.tis.pre);
                advance.sem.miss.pre = advance.stDev.miss.pre / sqrt(advance.counts.miss.pre);
                advance.sem.fa.pre = advance.stDev.fa.pre / sqrt(advance.counts.fa.pre);
                advance.sem.dual.pre = advance.stDev.dual.pre / sqrt(advance.counts.dual.pre);
                advance.sem.multi.pre = advance.stDev.multi.pre / sqrt(advance.counts.multi.pre);
                advance.sem.complete.pre = advance.stDev.complete.pre / sqrt(advance.counts.complete.pre);
                advance.sem.breach.pre = advance.stDev.breach.pre / sqrt(advance.counts.breach.pre);
                advance.sem.timeout.pre = advance.stDev.timeout.pre / sqrt(advance.counts.timeout.pre);
                advance.sem.quit.pre = advance.stDev.quit.pre / sqrt(advance.counts.quit.pre);
                advance.sem.hit.post = advance.stDev.hit.post / sqrt(advance.counts.hit.post);
                advance.sem.rt.post = advance.stDev.rt.post / sqrt(advance.counts.rt.post);
                advance.sem.cr.post = advance.stDev.cr.post / sqrt(advance.counts.cr.post);
                advance.sem.tis.post = advance.stDev.tis.post / sqrt(advance.counts.tis.post);
                advance.sem.miss.post = advance.stDev.miss.post / sqrt(advance.counts.miss.post);
                advance.sem.fa.post = advance.stDev.fa.post / sqrt(advance.counts.fa.post);
                advance.sem.dual.post = advance.stDev.dual.post / sqrt(advance.counts.dual.post);
                advance.sem.multi.post = advance.stDev.multi.post / sqrt(advance.counts.multi.post);
                advance.sem.complete.post = advance.stDev.complete.post / sqrt(advance.counts.complete.post);
                advance.sem.breach.post = advance.stDev.breach.post / sqrt(advance.counts.breach.post);
                advance.sem.timeout.post = advance.stDev.timeout.post / sqrt(advance.counts.timeout.post);
                advance.sem.quit.post = advance.stDev.quit.post / sqrt(advance.counts.quit.post);

%% PHASE DELAY (AUTUMN)

autumn = results;
autumn(~strcmp(results.season, 'Autumn'),:) = []; 
    delay.avg.hit.pre = nanmean(autumn.hit(strcmp(autumn.position, 'Pre'))); 
    delay.avg.rt.pre = nanmean(autumn.rt(strcmp(autumn.position, 'Pre')));
    delay.avg.cr.pre = nanmean(autumn.cr(strcmp(autumn.position, 'Pre')));
    delay.avg.tis.pre = nanmean(autumn.tis(strcmp(autumn.position, 'Pre')));
    delay.avg.miss.pre = nanmean(autumn.miss(strcmp(autumn.position, 'Pre')));
    delay.avg.fa.pre = nanmean(autumn.fa(strcmp(autumn.position, 'Pre')));
    delay.avg.dual.pre = nanmean(autumn.dual(strcmp(autumn.position, 'Pre')));
    delay.avg.multi.pre = nanmean(autumn.multi(strcmp(autumn.position, 'Pre')));
    delay.avg.complete.pre = nanmean(autumn.completed(strcmp(autumn.position, 'Pre')));
    delay.avg.breach.pre = nanmean(autumn.securityBreach(strcmp(autumn.position, 'Pre')));
    delay.avg.timeout.pre = nanmean(autumn.outOfTime(strcmp(autumn.position, 'Pre')));
    delay.avg.quit.pre = nanmean(autumn.quit(strcmp(autumn.position, 'Pre')));
    delay.avg.hit.post = nanmean(autumn.hit(strcmp(autumn.position, 'Post'))); 
    delay.avg.rt.post = nanmean(autumn.rt(strcmp(autumn.position, 'Post')));
    delay.avg.cr.post = nanmean(autumn.cr(strcmp(autumn.position, 'Post')));
    delay.avg.tis.post = nanmean(autumn.tis(strcmp(autumn.position, 'Post')));
    delay.avg.miss.post = nanmean(autumn.miss(strcmp(autumn.position, 'Post')));
    delay.avg.fa.post = nanmean(autumn.fa(strcmp(autumn.position, 'Post')));
    delay.avg.dual.post = nanmean(autumn.dual(strcmp(autumn.position, 'Post')));
    delay.avg.multi.post = nanmean(autumn.multi(strcmp(autumn.position, 'Post')));
    delay.avg.complete.post = nanmean(autumn.completed(strcmp(autumn.position, 'Post')));
    delay.avg.breach.post = nanmean(autumn.securityBreach(strcmp(autumn.position, 'Post')));
    delay.avg.timeout.post = nanmean(autumn.outOfTime(strcmp(autumn.position, 'Post')));
    delay.avg.quit.post = nanmean(autumn.quit(strcmp(autumn.position, 'Post')));
        delay.stDev.hit.pre = nanstd(autumn.hit(strcmp(autumn.position, 'Pre'))); 
        delay.stDev.rt.pre = nanstd(autumn.rt(strcmp(autumn.position, 'Pre')));
        delay.stDev.cr.pre = nanstd(autumn.cr(strcmp(autumn.position, 'Pre')));
        delay.stDev.tis.pre = nanstd(autumn.tis(strcmp(autumn.position, 'Pre')));
        delay.stDev.miss.pre = nanstd(autumn.miss(strcmp(autumn.position, 'Pre')));
        delay.stDev.fa.pre = nanstd(autumn.fa(strcmp(autumn.position, 'Pre')));
        delay.stDev.dual.pre = nanstd(autumn.dual(strcmp(autumn.position, 'Pre')));
        delay.stDev.multi.pre = nanstd(autumn.multi(strcmp(autumn.position, 'Pre')));
        delay.stDev.complete.pre = nanstd(autumn.completed(strcmp(autumn.position, 'Pre')));
        delay.stDev.breach.pre = nanstd(autumn.securityBreach(strcmp(autumn.position, 'Pre')));
        delay.stDev.timeout.pre = nanstd(autumn.outOfTime(strcmp(autumn.position, 'Pre')));
        delay.stDev.quit.pre = nanstd(autumn.quit(strcmp(autumn.position, 'Pre')));
        delay.stDev.hit.post = nanstd(autumn.hit(strcmp(autumn.position, 'Post'))); 
        delay.stDev.rt.post = nanstd(autumn.rt(strcmp(autumn.position, 'Post')));
        delay.stDev.cr.post = nanstd(autumn.cr(strcmp(autumn.position, 'Post')));
        delay.stDev.tis.post = nanstd(autumn.tis(strcmp(autumn.position, 'Post')));
        delay.stDev.miss.post = nanstd(autumn.miss(strcmp(autumn.position, 'Post')));
        delay.stDev.fa.post = nanstd(autumn.fa(strcmp(autumn.position, 'Post')));
        delay.stDev.dual.post = nanstd(autumn.dual(strcmp(autumn.position, 'Post')));
        delay.stDev.multi.post = nanstd(autumn.multi(strcmp(autumn.position, 'Post')));
        delay.stDev.complete.post = nanstd(autumn.completed(strcmp(autumn.position, 'Post')));
        delay.stDev.breach.post = nanstd(autumn.securityBreach(strcmp(autumn.position, 'Post')));
        delay.stDev.timeout.post = nanstd(autumn.outOfTime(strcmp(autumn.position, 'Post')));
        delay.stDev.quit.post = nanstd(autumn.quit(strcmp(autumn.position, 'Post')));
            delay.counts.hit.pre = sum(~isnan(autumn.hit(strcmp(autumn.position, 'Pre'))));
            delay.counts.rt.pre = sum(~isnan(autumn.rt(strcmp(autumn.position, 'Pre'))));
            delay.counts.cr.pre = sum(~isnan(autumn.cr(strcmp(autumn.position, 'Pre'))));
            delay.counts.tis.pre = sum(~isnan(autumn.tis(strcmp(autumn.position, 'Pre'))));
            delay.counts.miss.pre = sum(~isnan(autumn.miss(strcmp(autumn.position, 'Pre'))));
            delay.counts.fa.pre = sum(~isnan(autumn.fa(strcmp(autumn.position, 'Pre'))));
            delay.counts.dual.pre = sum(~isnan(autumn.dual(strcmp(autumn.position, 'Pre'))));
            delay.counts.multi.pre = sum(~isnan(autumn.multi(strcmp(autumn.position, 'Pre'))));
            delay.counts.complete.pre = sum(~isnan(autumn.completed(strcmp(autumn.position, 'Pre'))));
            delay.counts.breach.pre = sum(~isnan(autumn.securityBreach(strcmp(autumn.position, 'Pre'))));
            delay.counts.timeout.pre = sum(~isnan(autumn.outOfTime(strcmp(autumn.position, 'Pre'))));
            delay.counts.quit.pre = sum(~isnan(autumn.quit(strcmp(autumn.position, 'Pre'))));
            delay.counts.hit.post = sum(~isnan(autumn.hit(strcmp(autumn.position, 'Post'))));
            delay.counts.rt.post = sum(~isnan(autumn.rt(strcmp(autumn.position, 'Post'))));
            delay.counts.cr.post = sum(~isnan(autumn.cr(strcmp(autumn.position, 'Post'))));
            delay.counts.tis.post = sum(~isnan(autumn.tis(strcmp(autumn.position, 'Post'))));
            delay.counts.miss.post = sum(~isnan(autumn.miss(strcmp(autumn.position, 'Post'))));
            delay.counts.fa.post = sum(~isnan(autumn.fa(strcmp(autumn.position, 'Post'))));
            delay.counts.dual.post = sum(~isnan(autumn.dual(strcmp(autumn.position, 'Post'))));
            delay.counts.multi.post = sum(~isnan(autumn.multi(strcmp(autumn.position, 'Post'))));
            delay.counts.complete.post = sum(~isnan(autumn.completed(strcmp(autumn.position, 'Post'))));
            delay.counts.breach.post = sum(~isnan(autumn.securityBreach(strcmp(autumn.position, 'Post'))));
            delay.counts.timeout.post = sum(~isnan(autumn.outOfTime(strcmp(autumn.position, 'Post'))));
            delay.counts.quit.post = sum(~isnan(autumn.quit(strcmp(autumn.position, 'Post'))));
                delay.sem.hit.pre = delay.stDev.hit.pre / sqrt(delay.counts.hit.pre);
                delay.sem.rt.pre = delay.stDev.rt.pre / sqrt(delay.counts.rt.pre);
                delay.sem.cr.pre = delay.stDev.cr.pre / sqrt(delay.counts.cr.pre);
                delay.sem.tis.pre = delay.stDev.tis.pre / sqrt(delay.counts.tis.pre);
                delay.sem.miss.pre = delay.stDev.miss.pre / sqrt(delay.counts.miss.pre);
                delay.sem.fa.pre = delay.stDev.fa.pre / sqrt(delay.counts.fa.pre);
                delay.sem.dual.pre = delay.stDev.dual.pre / sqrt(delay.counts.dual.pre);
                delay.sem.multi.pre = delay.stDev.multi.pre / sqrt(delay.counts.multi.pre);
                delay.sem.complete.pre = delay.stDev.complete.pre / sqrt(delay.counts.complete.pre);
                delay.sem.breach.pre = delay.stDev.breach.pre / sqrt(delay.counts.breach.pre);
                delay.sem.timeout.pre = delay.stDev.timeout.pre / sqrt(delay.counts.timeout.pre);
                delay.sem.quit.pre = delay.stDev.quit.pre / sqrt(delay.counts.quit.pre);
                delay.sem.hit.post = delay.stDev.hit.post / sqrt(delay.counts.hit.post);
                delay.sem.rt.post = delay.stDev.rt.post / sqrt(delay.counts.rt.post);
                delay.sem.cr.post = delay.stDev.cr.post / sqrt(delay.counts.cr.post);
                delay.sem.tis.post = delay.stDev.tis.post / sqrt(delay.counts.tis.post);
                delay.sem.miss.post = delay.stDev.miss.post / sqrt(delay.counts.miss.post);
                delay.sem.fa.post = delay.stDev.fa.post / sqrt(delay.counts.fa.post);
                delay.sem.dual.post = delay.stDev.dual.post / sqrt(delay.counts.dual.post);
                delay.sem.multi.post = delay.stDev.multi.post / sqrt(delay.counts.multi.post);
                delay.sem.complete.post = delay.stDev.complete.post / sqrt(delay.counts.complete.post);
                delay.sem.breach.post = delay.stDev.breach.post / sqrt(delay.counts.breach.post);
                delay.sem.timeout.post = delay.stDev.timeout.post / sqrt(delay.counts.timeout.post);
                delay.sem.quit.post = delay.stDev.quit.post / sqrt(delay.counts.quit.post);

%% CONTROL (SUMMER)

summer = results;
summer(~strcmp(results.season, 'Summer'),:) = []; 
    control.avg.hit.pre = nanmean(summer.hit(strcmp(summer.position, 'Pre'))); 
    control.avg.rt.pre = nanmean(summer.rt(strcmp(summer.position, 'Pre')));
    control.avg.cr.pre = nanmean(summer.cr(strcmp(summer.position, 'Pre')));
    control.avg.tis.pre = nanmean(summer.tis(strcmp(summer.position, 'Pre')));
    control.avg.miss.pre = nanmean(summer.miss(strcmp(summer.position, 'Pre')));
    control.avg.fa.pre = nanmean(summer.fa(strcmp(summer.position, 'Pre')));
    control.avg.dual.pre = nanmean(summer.dual(strcmp(summer.position, 'Pre')));
    control.avg.multi.pre = nanmean(summer.multi(strcmp(summer.position, 'Pre')));
    control.avg.complete.pre = nanmean(summer.completed(strcmp(summer.position, 'Pre')));
    control.avg.breach.pre = nanmean(summer.securityBreach(strcmp(summer.position, 'Pre')));
    control.avg.timeout.pre = nanmean(summer.outOfTime(strcmp(summer.position, 'Pre')));
    control.avg.quit.pre = nanmean(summer.quit(strcmp(summer.position, 'Pre')));
    control.avg.hit.post = nanmean(summer.hit(strcmp(summer.position, 'Post'))); 
    control.avg.rt.post = nanmean(summer.rt(strcmp(summer.position, 'Post')));
    control.avg.cr.post = nanmean(summer.cr(strcmp(summer.position, 'Post')));
    control.avg.tis.post = nanmean(summer.tis(strcmp(summer.position, 'Post')));
    control.avg.miss.post = nanmean(summer.miss(strcmp(summer.position, 'Post')));
    control.avg.fa.post = nanmean(summer.fa(strcmp(summer.position, 'Post')));
    control.avg.dual.post = nanmean(summer.dual(strcmp(summer.position, 'Post')));
    control.avg.multi.post = nanmean(summer.multi(strcmp(summer.position, 'Post')));
    control.avg.complete.post = nanmean(summer.completed(strcmp(summer.position, 'Post')));
    control.avg.breach.post = nanmean(summer.securityBreach(strcmp(summer.position, 'Post')));
    control.avg.timeout.post = nanmean(summer.outOfTime(strcmp(summer.position, 'Post')));
    control.avg.quit.post = nanmean(summer.quit(strcmp(summer.position, 'Post')));
        control.stDev.hit.pre = nanstd(summer.hit(strcmp(summer.position, 'Pre'))); 
        control.stDev.rt.pre = nanstd(summer.rt(strcmp(summer.position, 'Pre')));
        control.stDev.cr.pre = nanstd(summer.cr(strcmp(summer.position, 'Pre')));
        control.stDev.tis.pre = nanstd(summer.tis(strcmp(summer.position, 'Pre')));
        control.stDev.miss.pre = nanstd(summer.miss(strcmp(summer.position, 'Pre')));
        control.stDev.fa.pre = nanstd(summer.fa(strcmp(summer.position, 'Pre')));
        control.stDev.dual.pre = nanstd(summer.dual(strcmp(summer.position, 'Pre')));
        control.stDev.multi.pre = nanstd(summer.multi(strcmp(summer.position, 'Pre')));
        control.stDev.complete.pre = nanstd(summer.completed(strcmp(summer.position, 'Pre')));
        control.stDev.breach.pre = nanstd(summer.securityBreach(strcmp(summer.position, 'Pre')));
        control.stDev.timeout.pre = nanstd(summer.outOfTime(strcmp(summer.position, 'Pre')));
        control.stDev.quit.pre = nanstd(summer.quit(strcmp(summer.position, 'Pre')));
        control.stDev.hit.post = nanstd(summer.hit(strcmp(summer.position, 'Post'))); 
        control.stDev.rt.post = nanstd(summer.rt(strcmp(summer.position, 'Post')));
        control.stDev.cr.post = nanstd(summer.cr(strcmp(summer.position, 'Post')));
        control.stDev.tis.post = nanstd(summer.tis(strcmp(summer.position, 'Post')));
        control.stDev.miss.post = nanstd(summer.miss(strcmp(summer.position, 'Post')));
        control.stDev.fa.post = nanstd(summer.fa(strcmp(summer.position, 'Post')));
        control.stDev.dual.post = nanstd(summer.dual(strcmp(summer.position, 'Post')));
        control.stDev.multi.post = nanstd(summer.multi(strcmp(summer.position, 'Post')));
        control.stDev.complete.post = nanstd(summer.completed(strcmp(summer.position, 'Post')));
        control.stDev.breach.post = nanstd(summer.securityBreach(strcmp(summer.position, 'Post')));
        control.stDev.timeout.post = nanstd(summer.outOfTime(strcmp(summer.position, 'Post')));
        control.stDev.quit.post = nanstd(summer.quit(strcmp(summer.position, 'Post')));
            control.counts.hit.pre = sum(~isnan(summer.hit(strcmp(summer.position, 'Pre'))));
            control.counts.rt.pre = sum(~isnan(summer.rt(strcmp(summer.position, 'Pre'))));
            control.counts.cr.pre = sum(~isnan(summer.cr(strcmp(summer.position, 'Pre'))));
            control.counts.tis.pre = sum(~isnan(summer.tis(strcmp(summer.position, 'Pre'))));
            control.counts.miss.pre = sum(~isnan(summer.miss(strcmp(summer.position, 'Pre'))));
            control.counts.fa.pre = sum(~isnan(summer.fa(strcmp(summer.position, 'Pre'))));
            control.counts.dual.pre = sum(~isnan(summer.dual(strcmp(summer.position, 'Pre'))));
            control.counts.multi.pre = sum(~isnan(summer.multi(strcmp(summer.position, 'Pre'))));
            control.counts.complete.pre = sum(~isnan(summer.completed(strcmp(summer.position, 'Pre'))));
            control.counts.breach.pre = sum(~isnan(summer.securityBreach(strcmp(summer.position, 'Pre'))));
            control.counts.timeout.pre = sum(~isnan(summer.outOfTime(strcmp(summer.position, 'Pre'))));
            control.counts.quit.pre = sum(~isnan(summer.quit(strcmp(summer.position, 'Pre'))));
            control.counts.hit.post = sum(~isnan(summer.hit(strcmp(summer.position, 'Post'))));
            control.counts.rt.post = sum(~isnan(summer.rt(strcmp(summer.position, 'Post'))));
            control.counts.cr.post = sum(~isnan(summer.cr(strcmp(summer.position, 'Post'))));
            control.counts.tis.post = sum(~isnan(summer.tis(strcmp(summer.position, 'Post'))));
            control.counts.miss.post = sum(~isnan(summer.miss(strcmp(summer.position, 'Post'))));
            control.counts.fa.post = sum(~isnan(summer.fa(strcmp(summer.position, 'Post'))));
            control.counts.dual.post = sum(~isnan(summer.dual(strcmp(summer.position, 'Post'))));
            control.counts.multi.post = sum(~isnan(summer.multi(strcmp(summer.position, 'Post'))));
            control.counts.complete.post = sum(~isnan(summer.completed(strcmp(summer.position, 'Post'))));
            control.counts.breach.post = sum(~isnan(summer.securityBreach(strcmp(summer.position, 'Post'))));
            control.counts.timeout.post = sum(~isnan(summer.outOfTime(strcmp(summer.position, 'Post'))));
            control.counts.quit.post = sum(~isnan(summer.quit(strcmp(summer.position, 'Post'))));
                control.sem.hit.pre = control.stDev.hit.pre / sqrt(control.counts.hit.pre);
                control.sem.rt.pre = control.stDev.rt.pre / sqrt(control.counts.rt.pre);
                control.sem.cr.pre = control.stDev.cr.pre / sqrt(control.counts.cr.pre);
                control.sem.tis.pre = control.stDev.tis.pre / sqrt(control.counts.tis.pre);
                control.sem.miss.pre = control.stDev.miss.pre / sqrt(control.counts.miss.pre);
                control.sem.fa.pre = control.stDev.fa.pre / sqrt(control.counts.fa.pre);
                control.sem.dual.pre = control.stDev.dual.pre / sqrt(control.counts.dual.pre);
                control.sem.multi.pre = control.stDev.multi.pre / sqrt(control.counts.multi.pre);
                control.sem.complete.pre = control.stDev.complete.pre / sqrt(control.counts.complete.pre);
                control.sem.breach.pre = control.stDev.breach.pre / sqrt(control.counts.breach.pre);
                control.sem.timeout.pre = control.stDev.timeout.pre / sqrt(control.counts.timeout.pre);
                control.sem.quit.pre = control.stDev.quit.pre / sqrt(control.counts.quit.pre);
                control.sem.hit.post = control.stDev.hit.post / sqrt(control.counts.hit.post);
                control.sem.rt.post = control.stDev.rt.post / sqrt(control.counts.rt.post);
                control.sem.cr.post = control.stDev.cr.post / sqrt(control.counts.cr.post);
                control.sem.tis.post = control.stDev.tis.post / sqrt(control.counts.tis.post);
                control.sem.miss.post = control.stDev.miss.post / sqrt(control.counts.miss.post);
                control.sem.fa.post = control.stDev.fa.post / sqrt(control.counts.fa.post);
                control.sem.dual.post = control.stDev.dual.post / sqrt(control.counts.dual.post);
                control.sem.multi.post = control.stDev.multi.post / sqrt(control.counts.multi.post);
                control.sem.complete.post = control.stDev.complete.post / sqrt(control.counts.complete.post);
                control.sem.breach.post = control.stDev.breach.post / sqrt(control.counts.breach.post);
                control.sem.timeout.post = control.stDev.timeout.post / sqrt(control.counts.timeout.post);
                control.sem.quit.post = control.stDev.quit.post / sqrt(control.counts.quit.post);

%% HISTOGRAMS 

fontSize = 15; 

% VISUAL SEARCH DATA
r = 2; 
c = 4; 

hist_data_visualsearch = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(r,c,1); 
    histogram(results.hit); 
    xlabel('Hit Rate (%)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.hit(~isnan(results.hit)));
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,5); 
    histogram(results.rt); 
    xlabel('Response Time (ms)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.rt(~isnan(results.rt)));
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,2); 
    histogram(results.cr);
    xlabel('Correct Rejection Rate (%)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.cr(~isnan(results.cr)));
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,6); 
    histogram(results.tis);
    xlabel('Time In Scanner (ms)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.tis(~isnan(results.tis))); 
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,3); 
    histogram(results.miss);
    xlabel('Miss rate (%)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.miss(~isnan(results.miss)));
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,7); 
    histogram(results.fa);
    xlabel('False alarm rate (%)');
    set(gca, 'FontSize', fontSize); 
    mu = mean(results.fa(~isnan(results.fa)));
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,4); 
    histogram(results.dual);
    xlabel('Dual target accuracy (%)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.dual(~isnan(results.dual))); 
    title(sprintf('mu = %.3f', mu)); 
subplot(r,c,8); 
    histogram(results.multi);
    xlabel('Multiple target accuracy (%)');
    set(gca, 'FontSize', fontSize);
    mu = mean(results.multi(~isnan(results.multi)));
    title(sprintf('mu = %.3f', mu)); 
    if server == 0  
        suptitle(sprintf('N = %d',N));  
    end

% PARADIGM SPECIFIC DATA
hist_data_paradigmspecific = figure('units','normalized','outerposition',[0 0 1 1]);  
    completed = nonzeros(results.completed);
    securityBreach = nonzeros(results.securityBreach) * 2;
    outOfTime = nonzeros(results.outOfTime) * 3;
    quit = nonzeros(results.quit) * 4;
    status = [completed; securityBreach; outOfTime; quit];
    histogram(status,4);
    xlabel('Status');
    xticks(1:4);
    xticklabels({'Completed' 'Security Breach' 'Out of Time' 'Quit'});
    set(gca, 'FontSize', fontSize);
    title(sprintf('N = %d', N))

% TIME VARIABLES
hist_timingvariables = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,3,1); 
    histogram(results.year); 
    xlabel('Year');
    set(gca, 'FontSize', fontSize);
subplot(2,3,2); 
    seasons = categorical(results.season);
    seasons = reordercats(seasons, {'Spring', 'Summer', 'Autumn'});
    histogram(seasons); 
    xlabel('Season');
    set(gca, 'FontSize', fontSize);
subplot(2,3,3); 
    timeZones = categorical(results.timeZone);
    timeZones = reordercats(timeZones, {'Alaska', 'Pacific', 'Mountain', 'Central', 'Eastern'});
    histogram(timeZones); 
    xlabel('Time Zone');
    set(gca, 'FontSize', fontSize);
subplot(2,3,4); 
    positions = categorical(results.position);
    positions = reordercats(positions, {'Pre', 'Post'});
    histogram(positions);   
    xlabel('Position relative to critical time change');
    set(gca, 'FontSize', fontSize); 
subplot(2,3,5); 
    days = categorical(results.day);
    days = reordercats(days, {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'});
    histogram(days);   
    xlabel('Day of week');
    set(gca, 'FontSize', fontSize); 
    if server == 0
        suptitle(sprintf('N = %d',N)); 
    end

%% VISUAL SEARCH (PRIMARY DVs) FIGURE

fig_data_visualsearch = figure('units','normalized','outerposition',[0 0 1 1]);
r = 3; % seasons
c = 6; % DVs
x = 1:2;
black = [0 0 0]; 
lineWidth = 2;
xlab = 'Position relative to time change'; 
xlabels = {'' ''};
counter = 1; 

subplot(r,c,counter); % SPRING HIT
    y = [advance.avg.hit.pre advance.avg.hit.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.hit.pre advance.sem.hit.post], [advance.sem.hit.pre advance.sem.hit.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    ylabel('Phase Advance (Spring)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Hit Rate (%%)'));
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING RT
    y = [advance.avg.rt.pre advance.avg.rt.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.rt.pre advance.sem.rt.post], [advance.sem.rt.pre advance.sem.rt.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Response Time (ms)'));  
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING CR
    y = [advance.avg.cr.pre advance.avg.cr.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.cr.pre advance.sem.cr.post], [advance.sem.cr.pre advance.sem.cr.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Correct Rejection Rate (%%)'));   
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING TIS
    y = [advance.avg.tis.pre advance.avg.tis.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.tis.pre advance.sem.tis.post], [advance.sem.tis.pre advance.sem.tis.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Time In Scanner (ms)'));   
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING MISS
    y = [advance.avg.miss.pre advance.avg.miss.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.miss.pre advance.sem.miss.post], [advance.sem.miss.pre advance.sem.miss.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Miss Rate (%%)'));   
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING FA
    y = [advance.avg.fa.pre advance.avg.fa.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.fa.pre advance.sem.fa.post], [advance.sem.fa.pre advance.sem.fa.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('False Alarm Rate (%%)'));   
   
counter = counter + 1;     
subplot(r,c,counter); % FALL HIT
    y = [delay.avg.hit.pre delay.avg.hit.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.hit.pre delay.sem.hit.post], [delay.sem.hit.pre delay.sem.hit.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels);  
    ylabel('Phase Delay (Autumn)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize); 
    
counter = counter + 1;     
subplot(r,c,counter); % FALL RT
    y = [delay.avg.rt.pre delay.avg.rt.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.rt.pre delay.sem.rt.post], [delay.sem.rt.pre delay.sem.rt.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);    
    
counter = counter + 1;     
subplot(r,c,counter); % FALL CR
    y = [delay.avg.cr.pre delay.avg.cr.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.cr.pre delay.sem.cr.post], [delay.sem.cr.pre delay.sem.cr.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);       
    
counter = counter + 1;     
subplot(r,c,counter); % FALL TIS
    y = [delay.avg.tis.pre delay.avg.tis.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.tis.pre delay.sem.tis.post], [delay.sem.tis.pre delay.sem.tis.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);      
    
counter = counter + 1;     
subplot(r,c,counter); % FALL MISS
    y = [delay.avg.miss.pre delay.avg.miss.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.miss.pre delay.sem.miss.post], [delay.sem.miss.pre delay.sem.miss.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);      
    
counter = counter + 1;     
subplot(r,c,counter); % FALL FA
    y = [delay.avg.fa.pre delay.avg.fa.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.fa.pre delay.sem.fa.post], [delay.sem.fa.pre delay.sem.fa.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  

xlabels = {'Pre' 'Post'};
counter = counter + 1;     
subplot(r,c,counter); % SUMMER HIT
    y = [control.avg.hit.pre control.avg.hit.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.hit.pre control.sem.hit.post], [control.sem.hit.pre control.sem.hit.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels);  
    ylabel('Control (Summer)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize); 
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER RT
    y = [control.avg.rt.pre control.avg.rt.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.rt.pre control.sem.rt.post], [control.sem.rt.pre control.sem.rt.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);    
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER CR
    y = [control.avg.cr.pre control.avg.cr.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.cr.pre control.sem.cr.post], [control.sem.cr.pre control.sem.cr.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);       
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER TIS
    y = [control.avg.tis.pre control.avg.tis.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.tis.pre control.sem.tis.post], [control.sem.tis.pre control.sem.tis.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);      
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER MISS
    y = [control.avg.miss.pre control.avg.miss.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.miss.pre control.sem.miss.post], [control.sem.miss.pre control.sem.miss.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);      
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER FA
    y = [control.avg.fa.pre control.avg.fa.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.fa.pre control.sem.fa.post], [control.sem.fa.pre control.sem.fa.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    
    if server == 0
        suptitle(sprintf('\nN = %d\n', N));
    end

%% VISUAL SEARCH (SECONDARY DVs) FIGURE

fig_data_visualsearch2 = figure('units','normalized','outerposition',[0 0 1 1]);
r = 3; % seasons
c = 2; % DVs
x = 1:2;
black = [0 0 0]; 
lineWidth = 2;
xlab = 'Position relative to time change'; 
xlabels = {'' ''};
counter = 1; 

subplot(r,c,counter); % SPRING dual
    y = [advance.avg.dual.pre advance.avg.dual.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.dual.pre advance.sem.dual.post], [advance.sem.dual.pre advance.sem.dual.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    ylabel('Phase Advance (Spring)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Dual Target Accuracy (%%)'));
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING multi
    y = [advance.avg.multi.pre advance.avg.multi.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.multi.pre advance.sem.multi.post], [advance.sem.multi.pre advance.sem.multi.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Multiple Target Accuracy (%%)'));  
    
counter = counter + 1;     
subplot(r,c,counter); % FALL DUAL
    y = [delay.avg.dual.pre delay.avg.dual.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.dual.pre delay.sem.dual.post], [delay.sem.dual.pre delay.sem.dual.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels);  
    ylabel('Phase Delay (Autumn)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize); 
    
counter = counter + 1;     
subplot(r,c,counter); % FALL multi
    y = [delay.avg.multi.pre delay.avg.multi.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.multi.pre delay.sem.multi.post], [delay.sem.multi.pre delay.sem.multi.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);    
    
xlabels = {'Pre' 'Post'};
counter = counter + 1;     
subplot(r,c,counter); % SUMMER dual
    y = [control.avg.dual.pre control.avg.dual.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.dual.pre control.sem.dual.post], [control.sem.dual.pre control.sem.dual.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels);  
    ylabel('Control (Summer)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize); 
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER multi
    y = [control.avg.multi.pre control.avg.multi.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.multi.pre control.sem.multi.post], [control.sem.multi.pre control.sem.multi.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);    

if server == 0     
    suptitle(sprintf('\nN = %d\n', N));
end
 
%% PARADIGM SPECIFIC FIGURE

fig_data_paradigmspecific = figure('units','normalized','outerposition',[0 0 1 1]);
r = 3; % seasons
c = 4; % DVs
x = 1:2;
black = [0 0 0]; 
lineWidth = 2;
xlab = 'Position relative to time change'; 
xlabels = {'' ''};
counter = 1; 

subplot(r,c,counter); % SPRING complted
    y = [advance.avg.complete.pre advance.avg.complete.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.complete.pre advance.sem.complete.post], [advance.sem.complete.pre advance.sem.complete.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    ylabel('Phase Advance (Spring)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Completed'));
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING breach
    y = [advance.avg.breach.pre advance.avg.breach.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.breach.pre advance.sem.breach.post], [advance.sem.breach.pre advance.sem.breach.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Security Breach'));  
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING timeout
    y = [advance.avg.timeout.pre advance.avg.timeout.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.timeout.pre advance.sem.timeout.post], [advance.sem.timeout.pre advance.sem.timeout.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Time Out'));   
    
counter = counter + 1;     
subplot(r,c,counter); % SPRING quit
    y = [advance.avg.quit.pre advance.avg.quit.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [advance.sem.quit.pre advance.sem.quit.post], [advance.sem.quit.pre advance.sem.quit.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);  
    title(sprintf('Quit'));   
    
counter = counter + 1;     
subplot(r,c,counter); % FALL complete
    y = [delay.avg.complete.pre delay.avg.complete.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.complete.pre delay.sem.complete.post], [delay.sem.complete.pre delay.sem.complete.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels);  
    ylabel('Phase Delay (Autumn)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize); 
    
counter = counter + 1;     
subplot(r,c,counter); % FALL breach
    y = [delay.avg.breach.pre delay.avg.breach.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.breach.pre delay.sem.breach.post], [delay.sem.breach.pre delay.sem.breach.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);    
    
counter = counter + 1;     
subplot(r,c,counter); % FALL timeout
    y = [delay.avg.timeout.pre delay.avg.timeout.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.timeout.pre delay.sem.timeout.post], [delay.sem.timeout.pre delay.sem.timeout.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);       
    
counter = counter + 1;     
subplot(r,c,counter); % FALL quit
    y = [delay.avg.quit.pre delay.avg.quit.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [delay.sem.quit.pre delay.sem.quit.post], [delay.sem.quit.pre delay.sem.quit.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);      
    
xlabels = {'Pre' 'Post'};
counter = counter + 1;     
subplot(r,c,counter); % SUMMER complete
    y = [control.avg.complete.pre control.avg.complete.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.complete.pre control.sem.complete.post], [control.sem.complete.pre control.sem.complete.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels);  
    ylabel('Control (Summer)', 'FontSize', fontSize); 
    set(gca, 'FontSize', fontSize); 
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER breach
    y = [control.avg.breach.pre control.avg.breach.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.breach.pre control.sem.breach.post], [control.sem.breach.pre control.sem.breach.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);    
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER timeout
    y = [control.avg.timeout.pre control.avg.timeout.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.timeout.pre control.sem.timeout.post], [control.sem.timeout.pre control.sem.timeout.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);       
    
counter = counter + 1;     
subplot(r,c,counter); % SUMMER quit
    y = [control.avg.quit.pre control.avg.quit.post];
    b = bar(x, y);
    hold on;
    err = errorbar(x, y, [control.sem.quit.pre control.sem.quit.post], [control.sem.quit.pre control.sem.quit.post]);
    err.Color = black;
    err.LineStyle = 'none';
    err.LineWidth = lineWidth; 
    xticklabels(xlabels); 
    set(gca, 'FontSize', fontSize);      
    
if sevrer == 0 
    suptitle(sprintf('\nN = %d\n', N)); 
end 

%% SAVE STUFF

cd(direc.results);

save('DST_results.mat', 'results', 'N', 'spring', 'summer', 'autumn', 'advance', 'delay', 'control');

writetable(results,'DST_results_all.csv');
writetable(autumn,'DST_results_autumn.csv');
writetable(spring,'DST_results_spring.csv');
writetable(summer,'DST_results_summer.csv');

saveas(hist_data_visualsearch, 'hist_data_visualsearch', 'png');
saveas(hist_data_paradigmspecific, 'hist_data_paradigmspecific', 'png');
saveas(hist_timingvariables, 'hist_timingvariables', 'png');
saveas(fig_data_visualsearch, 'results_visualsearch', 'png');
saveas(fig_data_visualsearch2, 'results_visualsearch2', 'png');
saveas(fig_data_paradigmspecific, 'results_paradigmspecific', 'png');

close all; 

