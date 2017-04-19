function audio_save(data,name,ext,fs,bitrate)

if ~exist('audio_out/')
    mkdir('audio_out');
end

saveName = ['audio_out/',name,'_stego',ext];
if ext == '.mp3'
    mp3write(data, fs, saveName, ['-b ' num2str(bitrate)]);
elseif ext == '.wav'
    audiowrite(saveName, data, fs);
end

end