function xxd(data,name,fid)
    % XXD provides an array data export interface to C/C++ by generating a
    %   complete static C/C++ array definition (similar to xxd -i on Unix).
    %
    %   If you want to implement the output for another datatype, then just
    %   add another case here. If you do something interesting, then please
    %   be reminded that you can push changes upstream, see 
    %   https://github.com/bschauerte/xxd.
    %
    % @author B. Schauerte
    % @date   2013
    % @web    http://schauerte.me/
    
    % Copyright 2011-2013 B. Schauerte. All rights reserved.
    % 
    % Redistribution and use in source and binary forms, with or without 
    % modification, are permitted provided that the following conditions
    % are met:
    % 
    %    1. Redistributions of source code must retain the above copyright 
    %       notice, this list of conditions and the following disclaimer.
    % 
    %    2. Redistributions in binary form must reproduce the above 
    %       copyright notice, this list of conditions and the following
    %       disclaimer in the documentation and/or other materials provided
    %       with the distribution.
    % 
    % THIS SOFTWARE IS PROVIDED BY B. SCHAUERTE ''AS IS'' AND ANY EXPRESS 
    % OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
    % WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    % ARE DISCLAIMED. IN NO EVENT SHALL B. SCHAUERTE OR CONTRIBUTORS BE 
    % LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
    % CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
    % SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
    % BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
    % WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
    % OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
    % EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    % 
    % The views and conclusions contained in the software and documentation
    % are those of the authors and should not be interpreted as 
    % representing official policies, either expressed or implied, of B. 
    % Schauerte.
    
    %% default variables
    if nargin < 2, name = 'xxd'; end
    if nargin < 3, fid = 1; end

    %% helper variables
    nd = numel(data); % number of array elements
    sz = size(data);  % dimensions of the array
    ll = 12;          % line length: number of array elements per line
    
    %% data type?
    switch (class(data))
        case 'uint8'
            c_type_str     = 'unsigned char';
            fprintf_format = '0x%02X';
            
        otherwise
            error('Unsupported data type');
    end
    
    %% pre-data
    fprintf(fid,'%s %s[] = {\n',c_type_str,name);

    %% dump the data
    nl = ceil(nd/ll); % number of lines needed
    
    ilef = [fprintf_format,', '];
    elef = [fprintf_format,',\n'];
    llef = [fprintf_format,'\n'];
    
    for y = 1:nl
        offset = (y - 1)*ll;
        if y == nl % last line?
            fprintf(fid,'  ');
            for i = (offset+1):(nd-1)
                fprintf(fid,ilef,data(i));
            end
            fprintf(fid,llef,data(nd));
        else
            fprintf(fid,'  ');
            for i = (offset+1):(offset+ll-1)
                fprintf(fid,ilef,data(i));
            end
            fprintf(fid,elef,data(offset+ll));
        end
    end
    
    %% post-data
    fprintf(fid,'};\n');
    fprintf(fid,'unsigned int %s_len    = %d;\n',name,nd);
    fprintf(fid,'unsigned int %s_ndims  = %d;\n',name,ndims(data));
    fprintf(fid,'unsigned int %s_size[] = {',name);
    for i = 1:(ndims(data)-1)
        fprintf(fid,'%d,',sz(i));
    end
    fprintf(fid,'%d};\n',sz(ndims(data)));