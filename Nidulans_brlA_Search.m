function StartPOI = Nidulans_brlA_Search()
%% Info about this File:
% Written by: Joe Zavorskas
% Start: 9/9/2021 (Birthday Coding!)
% Last Edit: 10/4/2021

% This file will contain a workflow to search for clumps of brlA's
% experimentally proven binding motif (Chang; Timberlake, 1992) in the rest
% of the nidulans genome. This algorithm is an easy version of the motif
% finding problem. I will code the algorithm to generate all sequences and
% reverse compliments with up to "d" mutations of "CAAGGG" (given motif).
% I'll do this brute force for now, since I'm not sure if there is a more
% efficient method yet.

%% Input and manipulation of chromosome being searched.
% Goal is to get from many rows of character strings to a single char.
%%% I will add in functionality here to select 1 of the 8 chromosomes as
%%% well.
temp = regexp(fileread("Nidulans Chromo1.txt"), '\r?\n', 'split');
seq = vertcat(temp{1:end-1});
str = string(seq); singlestring = strjoin(str,"");
fullseq = char(singlestring);


%% Define target and generate the mutation neighborhood/reverse compliments.
% target(1) = {'CAAGGGG'};
% target(2) = {'AAAGGGG'};
% target(3) = {'CGAGGGG'};
% target(4) = {'AGAGGGG'};
% target(5) = {'CAAGGGA'};
% target(6) = {'AAAGGGA'};
% target(7) = {'CGAGGGA'};
% target(8) = {'AGAGGGA'};
target(1) = {'CAAGGG'};
target(2) = {'AAAGGG'};
target(3) = {'CGAGGG'};
target(4) = {'AGAGGG'};

% target(1) = {'CAAGGG'};
% target(2) = {'AAAGGGG'};
% target(3) = {'CGAGGGG'};
% target(4) = {'AGAGGGG'};
% target(5) = {'AAAGGGA'};
% target(6) = {'CGAGGGA'};
% target(7) = {'AGAGGGA'};



% d_NeighborsCell = Zavorskas_dNeighborhood(target,1);
ReverseComps = ReverseCompliments(target);

MatchCell = vertcat(target',ReverseComps);

%% Define window size and sampling rate for DNA sequences.

Window = 150;
% How far do we move the window before taking another sample?
SampleShift = 125;

% This hash table will store the start point of each window as its key. The
% value will be the number of times the target within one mutation or the
% reverse compliments appear in that window.
Counter = containers.Map('KeyType','double','ValueType','any');

%% For loop searching section

for WindowIter = 1:ceil(length(fullseq)/SampleShift)
    
    % Progress Updates
    
    if mod(WindowIter,10000) == 0
    
        Progress = WindowIter*SampleShift;
        format = 'Reached Position %d in the DNA.\n';
        fprintf(format,Progress)
        
    end 
    
    TargetCount = 0;
    FirstValue = ((WindowIter-1)*SampleShift)+1;
    % Catch if statement to make sure the program doesn't run off the end
    % of the DNA strand with the given offset.
    try
        CheckSeq = fullseq(FirstValue:FirstValue+(Window-1));
    catch
        break
    end
        
    for Target = 1:length(MatchCell)
            
        WordCount(Target) = seqwordcount(CheckSeq,char(MatchCell(Target)));
        
    end   
    
    TargetCount = sum(WordCount);
    
    % Map Update
    Counter(FirstValue) = TargetCount;
    
end

%% Analysis Section

StartPositions = keys(Counter);
Appearances = values(Counter);

StartPosMat = cell2mat(StartPositions)';
AppearMat = cell2mat(Appearances)';

MaxAppear = max(AppearMat)

OutputContainer = containers.Map('KeyType','double','ValueType','any');

for NumAppear = MaxAppear:-1:3
   
    idx = find(AppearMat == NumAppear);
    StartPOI = zeros(length(idx),1);
    
    for ID = 1:length(idx)
       
        StartPOI(ID) = StartPosMat(idx(ID));
        
    end
    
    OutputContainer(NumAppear) = StartPOI;
    
end


end