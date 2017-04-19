function str = dsss_dec(signal, L_msg, L_min)
%DSSS_DEC is the function to retrieve hidden text message back.
%
%   INPUTS VARIABLES
%       signal : Stego audio signal
%       L_msg  : Length of message
%       L_min  : Minimum value for segment length
%
%   OUTPUTS VARIABLES
%       str    : Retrieved text message
%
%   20170420 - Kadir Tekeli
%   For any questions: kadir_tekeli@hotmail.com
%

if nargin < 3
    L_min = 4096;
end

s.data = signal(:,1);          %First channel of stego audio file
s.len  = length(s.data);
L2 = floor(s.len/L_msg);
L  = max(L_min, L2);
nframe = floor(s.len/L);
N = nframe - mod(nframe, 8);

xsig = reshape(s.data(1:N*L,1), L, N);  %Divide audio signal into segments

%Note: Choose r = prng('password', L) to use a pseudo random sequence
r = ones(L,1);
%r = prng('password', L);       %Generating same pseudo random sequence

data = num2str(zeros(N,1))';
for k=1:N  
    c(k)=sum(xsig(:,k).*r)/L;   %Linear correlation
    if c(k)<0
        data(k) = '0';
    else
        data(k) = '1';
    end      
end

bin = reshape(data(1:N), 8, N/8)';
str = char(bin2dec(bin))';
end

function [ pnseq ] = prng( key,L )

rand('seed', sum(double(key)));  %Setting seed of pseudo random sequence
a = rand(L, 1);
pnseq = (a > 0.5)*2-1;           %Convert into bipolar {-1,+1}
end
