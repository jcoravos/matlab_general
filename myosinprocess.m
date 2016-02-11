%% Code to process Myosin images (i.e. subtract cytoplasmic background) and make projection

% ***Enter variables***
% Enter start (n1) and end (n2) time points
n1=1;  % starting image
n2=52;  % ending image
n=n2-n1+1; % # of frames

% Enter file name to read
file='Image4_100914_t';

% Enter directory to open (dir) and save (dir2)
dir = '/Volumes/CORAVOS/LSM Microscopy/H2O Injections/Sqh1_Sqh1;SqhAEGFP,GapCh_hsFLP/Image4_100914/';

dir2= '/Volumes/CORAVOS/LSM Microscopy/H2O Injections/Sqh1_Sqh1;SqhAEGFP,GapCh_hsFLP/Image4_100914/processed/';

source=[dir,file];
% source2=[dir2,file2];

% Enter image dimensions
xdim = 1020  ; % updated/flipped by Adam 9/21/11
ydim = 512  ; 

nz=7;


% Enter top left corner pixel (xy1) and box size (box) and z-slice (zbg) of an ROI from which you want to calculate mean and std of
% background myosin

xy1=[1,1]; %upper left corner
box=[10,10]; %box dimensions
xy2=xy1+box; %bottom right corner
zbg=7; %z slice of cytoplasm

% Enter threshold in standard deviations above mean cytoplasmic signal
thr = 0;

% ***Start code***
myosins = zeros(ydim,xdim,n);
for i=1:n   
    % read image
    rawmyo = zeros(ydim,xdim,nz);    
    ii = i+n1-1;
    istr = int2str(ii);
    if (ii < 10) 
       istr=strcat('0',istr); 
    end
    if (ii < 100) 
       istr=strcat('0',istr); 
    end
    for j=1:nz
        jstr = int2str(j);
        if (j < 10) 
            jstr=strcat('0',jstr); 
        end
        if (j < 100) 
            jstr=strcat('0',jstr); 
        end
        data=strcat(source,istr,'_z',jstr,'_c001.tif');

        rawmyo(:,:,j) = double(imread(data));
        F=fspecial('gaussian');
        rawmyo(:,:,j) = imfilter(rawmyo(:,:,j),F);
    end
    if (i==1)
       %cytoplasm=rawmyo(xy1(2):xy2(2),xy1(1):xy2(1),zbg);
       thmyo = 0 %mean(cytoplasm(:)) + thr*std(cytoplasm(:)); %3 std for myosin, 0 std for actin
%        thmyo=0; % for no thresholding
    end
    rawmyo(rawmyo<=thmyo)=0;
    rawmyo=sort(rawmyo,3,'descend');
%    q1=rawmyo(:,:,1);
%    q2=rawmyo(:,:,2);
%    q2(q2==0)=q1(q2==0);
%    q=(q1+q2)/2; 
    q=sum(rawmyo(:,:,1:2),3);
    q(q~=0)=q(q~=0)-thmyo;
    myosins(:,:,i)=q;
    myosins(:,:,i)=imfilter(myosins(:,:,i),F);
end

% imagesc(myosins);
% colorbar;
%%

cellmyomax=max(max(max((myosins(:)))));
% cellmyomax=255;

for t=n1:n2
    ii=t-n1+1;
    tstr = int2str(t);    
    if (t < 10) 
        tstr=strcat('0',tstr); 
    end
    if (t < 100) 
        tstr=strcat('0',tstr); 
    end
    
    cellmyo=myosins(:,:,ii);
    cellmyo=cellmyo/cellmyomax;
    imwrite(cellmyo,[dir2,'Image4_100914_t',tstr,'_z006','_c001.tif'],'tif','Compression','none');
end
   