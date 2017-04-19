function out = dsss_enc(signal, text, L_min, graf)
%DSSS_ENC is the function to hide data in audio using "conventional" Direct
%   Sequence Spread Spectrum technique. It is based on several papers [1]
%   and this version is not modified so much to keep it as "conventional".
%   - Transtions between adjacent segments were causing a hearable nosie,
%   so Hanning Window is applied in mixer_sig.m function and original mixer
%   signal is preserved as well in a variable called "datasig".
%   - Embedding strength "alpha" is chosen as a fixed value in this
%   version, but it gives better results when it is chosen according to
%   power spectrum of each segments.
%   - Preprocessing of cover signal helps with robustness, but they are not
%   included in this conventional approach. They will be added as evolution
%   from basic to more complicated.
%   - This version is to embed data in time domain. Transformation domains
%   such as DWT and DCT were also studied and implented in matlab in other
%   versions.
%
%   [1] Audio Watermarking Techniques, Hyoung Joong Kim
%
%   INPUTS VARIABLES
%       signal : Cover audio signal
%       text   : String to be embeded
%       L_min  : Minimum value for segment length
%       graf   : Plots after processing (graf=0 not to plot)
%
%   OUTPUTS VARIABLES
%       out    : Stego audio signal
%
%   20170420 - Kadir Tekeli
%   For any questions: kadir_tekeli@hotmail.com
%

if nargin < 3
    L_min = 4096;  % Setting a minimum value for segment length
end

if nargin < 4
    graf = 1;
end

s.data = signal;
[s.len, s.ch] = size(s.data);

bit = getBits(text);             %char -> binary sequence
L2  = floor(s.len/length(bit));  %Length of segments
L   = max(L_min, L2);            %Keeping length of segments big enough
nframe = floor(s.len/L);
N = nframe - mod(nframe, 8);     %Number of segments (Divisiblity, for 8bits)

if (length(bit) > N)
    warning('Message is too long, is being cropped...');
    bits = bit(1:N);
else
    bits = [bit, num2str(zeros(N-length(bit), 1))'];
end

%Note: Choose r = prng('password', L) to use a pseudo random sequence
r = ones(L,1);
%r = prng('password', L);                %Generating pseudo random sequence
rseq = reshape(r * ones(1,N), N*L, 1);  %Extending size of r up to N*L
alpha = 0.005;                          %Embedding strength

%%%%%%%%%%%%%%%%%%%%%%%%% EMBEDDING MESSAGE... %%%%%%%%%%%%%%%%%%%%%%%%%%
[windowed, datasig] = mixer_sig(L, bits, -1, 1, 256);
out = s.data;
stego = s.data(1:N*L,1) + alpha * windowed.*rseq;  %Using first channel
out(:,1) = [stego; s.data(N*L+1:s.len,1)];         %Adding rest of signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if graf ~= 0
    graph(s.data(:,1), out(:,1), bits, datasig, windowed, N, L);
end

end

function [ pnseq ] = prng( key,L )

rand('seed', sum(double(key)));  %Setting seed of pseudo random sequence
a = rand(L, 1);
pnseq = (a > 0.5)*2-1;           %Convert into bipolar {-1,+1}
end