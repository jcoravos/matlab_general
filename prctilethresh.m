function[level] = prctilethresh(image,pthresh)
%% prctile thresh identifies the threshold level for image matrices based on a user-defined percentile.    
% example: [level] = prctilethresh(image,percentile)

    imvector = double(reshape(image,1,[])); %turns the 2-D image into a row vector
    level = prctile(imvector,pthresh);
end    
