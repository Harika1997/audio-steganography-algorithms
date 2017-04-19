function [ file ] = audio_load()

message = 'Select audio file';
[FileName,PathName] = uigetfile({'*.mp3; *.wav'}, message);
[file.path,file.name,file.ext] = fileparts([PathName FileName]);

if file.ext == '.mp3'
    [file.data,file.fs,file.bitrate]=mp3read([PathName FileName]);
elseif file.ext == '.wav'
    [file.data,file.fs] = audioread([PathName FileName]);
    file.bitrate = 128;
else
    error('File format is not supported!');
end

end

