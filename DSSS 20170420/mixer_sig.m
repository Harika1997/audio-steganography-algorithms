function [ w_sig, m_sig ] = mixer_sig( L, bits, lower, upper, K )
%MIXER_SIG is the function to create a mixer signal to spread data easier.
%   - It creates a data signal according to binary data of the message
%   to be embeded.
%   - Hanning window is used to smooth joints of mixer signal to solve
%   discontinuity problem between segments.
%   - Upper and lower bounds are added as variables to be able to use
%   same function for different algorithms. E.g. Bipolar bounds {-1,+1}
%   are used in spread spectrum based techniques, and {0,1} are used in
%   Echo Hiding based techniques.
%   - Same function to smooth data signal can be defined using Matlab's 
%   filter() function. I have chosen longer way in terms of translating
%   this function into other languages, since smoothing is very important
%   not to distort audio signal on joints of segments.
%
%   INPUTS VARIABLES
%       L     : Length of segment
%       bits  : Binary sequence (1xm char)
%       K     : Length to be smoothed
%       upper : Upper bound of mixer signal
%       lower : Lower bound of mixer signal
%
%   OUTPUTS VARIABLES
%       m_sig : Mixer signal to spread data
%       w_sig : Smoothed mixer signal
%
%   20170420 - Kadir Tekeli
%   For any questions: kadir_tekeli@hotmail.com

if (nargin < 4)
    lower = 0;
    upper = 1;
end

if (nargin < 5) || (2*K > L)
	K = floor(L/4) - mod(floor(L/4), 4);
else
    K = K - mod(K, 4);                         %Divisibility by 4
end

N = length(bits);                              %Length of data = number of segments
encbit = str2num(reshape(bits, N, 1))';        %char -> double
m_sig  = reshape(ones(L,1)*encbit, N*L, 1);    %Mixer signal
c      = conv(m_sig, hann(K));                 %Hanning windowing
wnorm  = c(K/2+1:end-K/2+1) / max(abs(c));     %Normalization
w_sig  = wnorm * (upper-lower)+lower;          %Adjusting bounds
m_sig  = m_sig*(upper-lower)+lower;            %Adjusting bounds

end