clear

imx = 'Q5.jpg',

%Compute noise
Noisex = NoiseExtractFromImage(imx,2);
Noisex = WienerInDFT(Noisex,std2(Noisex));

%Read the fingerprint and store it in "Fingerprint" variable
r_file_loc = 'Cameras\Camera5\Fingerprint.dat';
Fingerprint = readmatrix(r_file_loc);
% crop the noise
tempnoise = imcrop(Noisex, [900, 900, 1500, 1500]);
%Do matching using NCC
[best_pos, best_pce] = NCC_blocks(tempnoise, Fingerprint);


       
  %Otherwise check for matching 
   if(best_pce >= 60)
        output=strcat(' Camera 1 has taken the given image. PCE is: ', string(best_pce));
        disp(output); 
        output=strcat('Matching for scale factor: ', num2str(fac), ' and location: ', num2str (best_pos (1)), ', ', num2str (best_pos (2)));
        disp(output);
   end 
