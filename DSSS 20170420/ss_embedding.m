clc; clear all;

audio = audio_load();

file = 'text.txt';
fid  = fopen(file, 'r');
text = fread(fid,'*char')';
fclose(fid);

out = dsss_enc(audio.data, text);
audio_save(out, audio.name, audio.ext, audio.fs, audio.bitrate);
disp('Process completed!');