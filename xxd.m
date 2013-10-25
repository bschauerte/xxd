function xxd(data,name,fid)
    % XXD provides an array data export interface to C/C++ by generating a
    %   complete static C/C++ array definition (similar to xxd -i on Unix).
    %
    % @author B. Schauerte
    % @date   2013
    % @web    http://schauerte.me/
    
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