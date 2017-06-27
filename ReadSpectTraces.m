function [file_header, headers, data] = ReadSpectTraces(filename,tracerange)
%% Reads a .spect file and returns the indexed traces and metadata 
% 
% Use: [fileheader, headers, data] = ReadSpectTraces(filename,tracerange);
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

% Pull out metadata that will be used to read
ns = file_header(3);
ntraces = file_header(4);

% Calc byte to skip
bytespersample = 8;
toskip = ns*2*bytespersample;

% Get traces to read
starttrace = tracerange(1);
endtrace = tracerange(2);
ntraces = endtrace - starttrace + 1;

% Now read all of the headers
headers = fread(fid, [4,ntraces],'4*double=>double',toskip);

% Return to starttrace's first real sample
fseek(fid, 32+32+(32+bytespersample*2*ns)*(starttrace-1), 'bof');

% Skip the imag part and next trace header
toskip = ns*bytespersample + 32;

% Read out all the real parts
realpart = fread(fid,[ns,ntraces],'1*double=>double',toskip);

% Return to first index's first imag sample
% FileHeader + TraceHeader + RealPart + (TraceHeader+Trace)*(PreviousTraces)
fseek(fid, 32+32+ns*bytespersample+(32+bytespersample*2*ns)*(starttrace-1), 'bof');

% Read all the imag parts 
imagpart = fread(fid,[ns,ntraces],'1*double=>double',toskip);

% Reconstruct complex data
data = complex(realpart, imagpart);

fclose(fid);
