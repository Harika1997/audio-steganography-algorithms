function [ber] = BER(x,y)
%BER calculation of Bit Error Rate

len = min(length(x),length(y));    
ber = 0;
for i=1:len
    err = (x(i)~= y(i));
    ber = ber + err;
end

end