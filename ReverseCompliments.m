function ReverseComps = ReverseCompliments(ForwardCell)
%% Info about this File:
% Written by: Joe Zavorskas
% Start: 9/9/2021
% Last Edit: 9/9/2021

% This file will generate the reverse compliments of all strings that were
% input to the function. This will be a relatively simple function, done in
% two steps. First, the input will be reversed, then all "A-T" and "G-C" 
% pairs will be flipped.

%% Create two cells to hold the reversed strings and reverse compliments.

ReverseCell = cell(length(ForwardCell),1);
ReverseComps = cell(length(ForwardCell),1);

%% Flip all inputs and put into ReverseCell

for Seq = 1:length(ForwardCell)
    
    holdchar = '';
    Current = char(ForwardCell(Seq));
    
    for Position = 1:length(Current)
       % This will result in a first value length(Seq) and final value 1.  
       holdchar(Position) = Current(length(Current)+1-Position);
        
    end

    ReverseCell(Seq) = cellstr(holdchar);
    
end

%% Now, scan through all in ReverseCell and flip to complimentary base.

for NewSeq = 1:length(ReverseCell)
    
    holdchar = '';
    Current = char(ReverseCell(NewSeq));
    
    for Position = 1:length(Current)

       % Large if/else lattice to switch any base to its compliment.
       if Current(Position) == 'A'
           
           holdchar(Position) = 'T';
       
       elseif Current(Position) == 'T'
           
           holdchar(Position) = 'A';
           
       elseif Current(Position) == 'C'
           
           holdchar(Position) = 'G';
           
       elseif Current(Position) == 'G'
           
           holdchar(Position) = 'C';
           
       end  
    
    end
       
    ReverseComps(NewSeq) = cellstr(holdchar);
    
end