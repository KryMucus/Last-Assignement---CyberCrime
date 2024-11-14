clear
disp('Genertaing fingerprint of cameras');

%%% Fingerprint Generation Code
directories_names_list = dir('Cameras\Camera*'); 
n = length(directories_names_list);
 for i=1:n
     dir_name = directories_names_list(i).name;
     dir_loc = ['Cameras' '\' dir_name]; 

     r_file_loc = [dir_loc '\*.jpg']; 
     D = dir (r_file_loc);

     for j = 1:length(D)
     Images(j).name = strcat(string(D(j).folder), '\', string(D(j).name)); % The file names
     end

     RP = getFingerprint(Images); % Fingerprint computation
     RP = rgb2gray1(RP);
        sigmaRP = std2(RP);
     Fingerprint = WienerInDFT(RP,sigmaRP); % The fingerprint

    % w_file_loc = [dir_loc '\Fingerprint.png']; % Location where the fingerprint to be written
     % We are writting the fingerprint to each camera location, Camera1 ...

    w_file_loc = [dir_loc '\Fingerprint.dat']; 
    writematrix(Fingerprint,w_file_loc); % Writes the fingerprint
 end
 %%% End of fingerprint generation code

% Determine which image come from Camera6 
Mixed = dir('Cameras\Mixed\*.jpg'); 
print_loc = 'Cameras\Camera1\Fingerprint.dat';
Fingerprint = readmatrix(print_loc);

for k = 1:length(Mixed)
    image = fullfile(Mixed(k).folder, Mixed(k).name);
    Noisex = NoiseExtractFromImage(image, 2);
    Noisex = WienerInDFT(Noisex, std2(Noisex));
    Ix = double(rgb2gray(imread(image)));
    C = crosscorr(Noisex, Ix .* Fingerprint);
    detection = PCE(C);
    
    if detection.PCE < 50
        display(['Camera6 has taken ' image]);
        %% I have manually created this Folder first
        %% This line adds the image to the Camera6 folder
         copyfile(image, 'Cameras\Camera6');
    end
end

% Compute Camera 6's Fingerprint
dir_loc = ['Cameras\Camera6']; 

r_file_loc = [dir_loc '\*.jpg']; 
D = dir (r_file_loc);

for j = 1:length(D)
Images(j).name = strcat(string(D(j).folder), '\', string(D(j).name)); % The file names
end

RP = getFingerprint(Images); % Fingerprint computation
RP = rgb2gray1(RP);
sigmaRP = std2(RP);
Fingerprint = WienerInDFT(RP,sigmaRP); % The fingerprint

w_file_loc = [dir_loc '\Fingerprint.dat']; 
writematrix(Fingerprint,w_file_loc); % Writes the fingerprint