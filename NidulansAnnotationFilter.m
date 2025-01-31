function NidulansAnnotationFilter()
%% Info About this File:
% Start: 10/4/2021
% Last Edit: 10/4/2021

% This file will act as a filter for the NidulansChromosomeSearch data.
% This file will check each window where a 3+ cluster of the brlA motif
% appears to see if it occurs within 1000 base pairs of the start codon of
% an ORF. Known brlA motifs have this property, so this will act as a good
% filter against random appearances of the motif.

% I am going to code this to operate one chromosome at a time because the
% sheets of the excel document are set up that way.

%% Excel Data Input

Chromosome = '8';

GeneInfo = readtable('ManualGeneAnnotation.xlsx','Sheet',['Chr' Chromosome]);
GeneMatrix = readmatrix('ManualGeneAnnotation.xlsx','Sheet',['Chr' Chromosome]);

WindowInfo = readtable('brlA-abaA Motif Search.xlsx','Sheet',['Chr' Chromosome],'Range','D:D');
WindowMatrix = readmatrix('brlA-abaA Motif Search.xlsx','Sheet',['Chr' Chromosome],'Range','D:D');

%% Initalize Values for Loops

StartCodonSpot = [];
Strand = [];

AccessionNumber = cellstr('AccessionNumber');
WindowStart = 0;

DataOut = table(AccessionNumber,WindowStart);
DataNum = 1;

%% For Loops to Check All Values

% Loop through the upstream regions of each gene. For each of the upstream
% regions, check through the entire list of available windows.

for UpstreamCheck = 1:length(GeneMatrix(:,1))
   
    if mod(UpstreamCheck,250) == 0
    
        format = 'Read through %d of %d available genes.\n';
        fprintf(format,UpstreamCheck,length(GeneMatrix(:,1)))
        
    end 
    
    % Determine if start codon is on reverse or forward strand. Grab
    % appropriate value.
    if char(GeneInfo{UpstreamCheck,4}) == '+'
        
        StartCodonSpot = GeneInfo{UpstreamCheck,2};
        Strand = '+';
        
    elseif char(GeneInfo{UpstreamCheck,4}) == '-'
        
        StartCodonSpot = GeneInfo{UpstreamCheck,3};
        Strand = '-';
        
    end
   
    % Check through every available window to see if it is within the range
    
    if Strand == '+'
         
        MotifCheckStart = StartCodonSpot - 1000;
        
        for Window = 1:length(WindowMatrix)
            
            CheckWindow = WindowInfo{Window,1};
            
            % This if means we have a filtered hit!
            if CheckWindow > MotifCheckStart && CheckWindow < StartCodonSpot
               
                % To avoid gaps, use a variable that increments every time
                % we add data to the output table.
                DataOut{DataNum,1} = GeneInfo{UpstreamCheck,1};
                DataOut{DataNum,2} = WindowInfo{Window,1};
                DataNum = DataNum + 1;
                
            end
            
        end
        
    elseif Strand == '-'
        
        % Window of 1000, but this time on the reverse strand, so the start
        % codon is on the 3' side of the gene.
        MotifCheckStart = StartCodonSpot + 1000;
        
        for Window = 1:length(WindowMatrix)
            
            CheckWindow = WindowInfo{Window,1};
            
            % This if means we have a filtered hit!
            if CheckWindow < MotifCheckStart && CheckWindow > StartCodonSpot
               
                % To avoid gaps, use a variable that increments every time
                % we add data to the output table.
                DataOut{DataNum,1} = GeneInfo{UpstreamCheck,1};
                DataOut{DataNum,2} = WindowInfo{Window,1};
                DataNum = DataNum + 1;
                
            end
            
        end 
        
    end  
    
end

%% Put the finished data back into the Excel File.

writetable(DataOut,'brlA-abaA Motif Search.xlsx','Sheet',['Chr' Chromosome],'Range','I:J');

end