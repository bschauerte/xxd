% generate array data
data = uint8(rand(4,5,6)*255);
% write dump
xxd(data,'foo');