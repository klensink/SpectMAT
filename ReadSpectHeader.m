function [file_header] = ReadSpectHeader(filename);
%% Reads a .spect file and returns just the file header
% 
% Use: [fileheader] = ReadSpectHeader(filename);
% -----------------------------------------------------------------------------
%   Author: 
%       Keegan Lensink
%       Seismic Laboratory for Imaging and Modeling
%       Department of Earth, Ocean, and Atmospheric Sciences
%       The University of British Columbia
%         
%   Date: March, 2017
% -----------------------------------------------------------------------------

% Open the file for reading
fid = fopen(filename,'r');

% Read the file header
file_header = fread(fid,[4,1],'double');

fclose(fid);
