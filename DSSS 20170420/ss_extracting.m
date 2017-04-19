clc; clear all;

audio = audio_load();

%Reopen text file to obtain information about length
file = 'text.txt'; fid  = fopen(file, 'r');
text = fread(fid,'*char')'; fclose(fid);

msg  = dsss_dec(audio.data, 8*length(text));
err = BER(getBits(text),getBits(msg));

fprintf('Text: %s\n', msg);
fprintf('BER : %d errors in %d bytes \n', BER(text,msg), length(msg));
fprintf('BER : %d errors in %d bits \n', err, 8*length(msg));