function [xmlout]=xmlsave(filename,varargin)
%XMLSAVE saves variables to file in xml format.
% 
% Synopsis
%        XMLSAVE(FILENAME,VARIABLE1,VARIABLE2,VARIABLE3,...)
%        XMLSAVE('',VARIABLE1,VARIABLE2,VARIABLE3,...)
%  out = XMLSAVE('',VARIABLE1,VARIABLE2,VARIABLE3,...)
% 
% Description
%  XMLSAVE saves variables into XML file named 'FILENAME'. Temporary file
%  is created and immediately opened in editor if parameter FILENAME is
%  empty string. Alternatively xmlsave returns conntents of xml file in the
%  first output variable.                     
% 
% Example
%  >> t=task('t1',5,1,10);
%  >> txml=xmlsave('',t)
%  txml =
%  <?xml version="1.0" encoding="utf-8"?>
%  <matlabdata date="24-Sep-2007 08:45:33" proccessor="TORSCHE Scheduling Toolbox for Matlab" ver="0.2">
%     <task id="t"><!--Basic Params-->
%        <name>t1</name>
%        <proctime>5</proctime>
%        <releasetime>1</releasetime>
%        <deadline>10</deadline>
%        <duedate>Inf</duedate>
%        <weight>1</weight><!--Graphics parameters-->
%        <graphicparam>
%           <position>
%              <x>0</x>
%              <y>0</y>
%           </position>
%        </graphicparam>
%     </task>
%  </matlabdata>
%
% See also TASKSET/TASKSET, CSSIMOUT.

%   Author(s): M. Kutil
%   Copyright (c) 2005
%   $Revision: 1847 $  $Date: 2007-09-24 09:10:14 +0200 (po, 24 IX 2007) $

% This file is part of Scheduling Toolbox.
% 
% Scheduling Toolbox is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation; either version 2 of the
% License, or (at your option) any later version.
% 
% Scheduling Toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with Scheduling Toolbox; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
% USA

% realvariable creating
ni = nargin;
for i = 1:ni-1
    if ~isempty(inputname(i+1))
        eval([inputname(i+1) ' = varargin{i};']);
        varname = inputname(i+1);
    else
        varname = 'varargin{i}';
    end
    % variables calling names preparing
    if i == 1
        variables = varname ;
    else
        variables = [variables ', ' varname ];
    end
end

% path changing
path_save = pwd;
schroot = fileparts(mfilename('fullpath'));
matlabxmlpath = [schroot filesep 'contrib' filesep 'matlabxml'];
if ~exist(matlabxmlpath,'dir') 
    error('TORSCHE:MatlabXML:notinstalled','matlabXML toolbox isn''t properly instaled, see to documentation!');
end
eval(['cd ' '''' matlabxmlpath '''']);

try
    struct = eval(['vartostruct(' variables ')']);
    struct.attribut.proccessor = 'TORSCHE Scheduling Toolbox for Matlab';
    docNode = structtoxml(struct);
catch
    eval(['cd ' '''' path_save '''']);
    lerr=lasterror;
    disp(lerr.message);
    error('TORSCHE:MatlabXML:notinstalled','matlabXML toolbox isn''t properly instaled, see to documentation');
end
    
eval(['cd ' '''' path_save '''']);
% Save the XML document.
emptyfn = 0;
if (isempty(filename) && (nargout==0))
    emptyfn = 1;
    filename = [tempname,'.xml'];
end
if nargout == 1
    xmlout = xmlwrite(docNode);
else
    xmlwrite(filename,docNode);
end
if (emptyfn) 
    edit(filename);
end
