%% Function for loading in a three-chanel fixed image into three matrices.
%Input [source_file,filename]
%Outut [channel1_stack, channel2_stack,channel3_stack,zdepth]
%example: [actin,dia,sqh,zdepth] = loadfixedimage('/Users/jcoravos/Desktop/Image8_032315/','Image8_03231']
function [channel1_stack,channel2_stack,channel3_stack,zdepth] = loadfixedimage(source_folder,filename);

    %% find zdepth with some string parsing
    filenames = dir(source_folder); %make a structure with the filenames
    lastfile = length(filenames); %find the last file, which is also the deepest z
    deepz = filenames(lastfile).name; %extract the filename
    C = strsplit(deepz,{'_z','_c'}); %parse the string to find the z value
    zdepth = str2num(cell2mat(C(2)));
 
    %%find the dimensions for the images to allocate memory
    calibrator = imread(strcat(source_folder,filename,'_z001_c001.tif') );
    [rows,cols] = size(calibrator);
    diastack = zeros(rows,cols,zdepth);
    actinstack = zeros(rows,cols,zdepth);
    myosinstack = zeros(rows,cols,zdepth);
    
    for zslice = 1:zdepth
        filename_c1 = strcat(source_folder,filename,'_z',sprintf('%03d',[zslice]),'_c001.tif');
        filename_c2 = strcat(source_folder,filename,'_z',sprintf('%03d',[zslice]),'_c002.tif');
        filename_c3 = strcat(source_folder,filename,'_z',sprintf('%03d',[zslice]),'_c003.tif');

        channel1_stack(:,:,zslice) = imread(filename_c1);
        channel2_stack(:,:,zslice) = imread(filename_c2);
        channel3_stack(:,:,zslice) = imread(filename_c3);
    end
end