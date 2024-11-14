clear
disp('Quiz 7A');


  %%Part A: Fingerprint generation

%% Video1 
 r_file_loc = ['Frames' '\*.jpg']; 

 D = dir (r_file_loc);

 for j = 1:length(D)
 Images(j).name = strcat(string(D(j).folder), '\', string(D(j).name)); % The file names
 end

 RP = getFingerprint(Images); % Fingerprint computation
 RP = rgb2gray1(RP);
    sigmaRP = std2(RP);
 Fingerprint = WienerInDFT(RP,sigmaRP); % The fingerprint

w_file_loc = ['Frames' '\Fingerprint.dat']; 
writematrix(Fingerprint,w_file_loc); % Writes the fingerprint



%%%Part B: Perform matching
%Read two fingerprints and store them in "Fingerprint1" and "Fingerprint2" variables
 r_file_loc = 'Frames\Fingerprint.dat'; % Fingerprint of Video1
 Fingerprint1 = readmatrix(r_file_loc);
 
 r_file_loc = 'Cameras\Camera3\Fingerprint.dat'; % Fingerprint of Video2
 Fingerprint2 = readmatrix(r_file_loc);

Fingerprint2 = imcrop(Fingerprint2, [50, 50, 980, 980]);

%Use NCC to match the fingerprint with the noise from the image
[best_pos, best_pce] = NCC_blocks(Fingerprint1, Fingerprint2)
if(best_pce >= 60)
  disp('The video and image were taken by the same camera as they matched')
end
%%% End of Quiz 6
