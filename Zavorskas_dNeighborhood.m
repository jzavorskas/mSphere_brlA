function d_NeighborsCell = Zavorskas_dNeighborhood(seq,MaxMismatch)
% Written by: Joe Zavorskas
% Start: 9/6/2021
% Last Edit: 9/7/2021

% This file will generate all possible DNA strings that can come from a
% given string, at or below a certain number of mutations. This can be
% solved in a few ways, but likely the simplest and easiest matlab
% implementation is a recursive function. This function will work from
% beginning to end of the DNA sequence, by changing the leading digit and
% its tail until running out of options and shortening the sequence by
% removing the leading value.

% My first try at this attempted the other direction (start from changing
% final value) and was unsuccesful.

%% Input Section

% Clear command window and declare necessary variables global so they do
% not need to be arguments.
clc
global bases

% Ask for user input. Collect DNA sequence and number of mismatches.
% % disp("Input Genome Sequence with single quotes (' ') around it")
% % seq = input('Here: ');
% % MaxMismatch = input('How many mismatches? Must be less than or equal to length of sequence. ');

% Initialize variables. All cells need to be initialized and fed into the
% program, otherwise "variable not found" errors occur.
bases = 'ACGT';
Neighborhood = {};
d_NeighborsCell = {};

% This section sews together information, since our recursive function
% solves for one d at a time. This needs to begin at zero so that the
% original sequence is included in the output as well.
for d = 0:MaxMismatch
    
    Neighborhood = MutateRecursive(seq,d,Neighborhood);
    d_NeighborsCell = [d_NeighborsCell; Neighborhood];
    
end

end

function NeighborHood = MutateRecursive(string,d,~)
global bases
% Throw a manual error if user ignores prompt to give less mutations than
% string length.
if d > length(string)
   
    disp('Choose "d" less than or equal to string length.')
    return
    
end

% Simple case. If no mutation, the string that is input will be the output.
if d == 0
    
    NeighborHood = cellstr(string);
    return
    
end

% Now we need two sections to avoid repeats. The first section will mutate
% all positions recursively by shrinking the string length and the number
% of mutations until reaching d = 0. This uses the first base in the current string 
% as an anchor point.

holdneighborhood = MutateRecursive(string(2:end),(d-1)); % shrink window by 1, mutations by 1.

%% Section 1: Mutate Beginning, Anchor End.

% This section assumes the mutation occurs in the first position. Since
% this is recursive, the first position will change with each pass, so this
% function will be used frequently.

for holdappend = 1:length(holdneighborhood) % this variable might contain multiple strings from previous iteration to loop through
    
    for base = bases % loop through all four bases.
        
        if base ~= string(1) % only changing the first available base, make sure it's not the same.
            
            % Attaching a new base to the saved ending.
            inputstring = cellstr([base char(holdneighborhood(holdappend))]);
            
            % Using try/catch to initialize the output variable, in case
            % this is the first pass through this recursion.
            try
                NeighborHood = [NeighborHood; cellstr(inputstring)];
            catch
                NeighborHood = {};
                NeighborHood = [NeighborHood; cellstr(inputstring)];
            end
            
        end
        
    end
 
end

%% Section 2: Anchor Beginning, Mutate End.

% This section cannot be performed if the # of mutations equals length.
% This section assumes the mutation is NOT in the first position, therefore
% the "d" value is not reduced. Since the first position is not mutated
% here, we will need to add it back into the string.

if d < length(string)
    
    holdneighborhood = MutateRecursive(string(2:end),d);
    
    for holdappend = 1:length(holdneighborhood)
        % This line attaches the leading base to the ending that has been
        % mutated. First character in the string is the anchor.
        inputstring = cellstr([string(1) char(holdneighborhood(holdappend))]);
        NeighborHood = [NeighborHood; inputstring];
      
    end
    
end

end