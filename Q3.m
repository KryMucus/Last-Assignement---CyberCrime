clear
disp('Running Quiz 6C'); 

%%%Quiz 5C - 65326 (Scaling - Parameters not known)
%Read image
imx = 'Q3.jpg',

%Compute noise
Noisex = NoiseExtractFromImage(imx,2);
Noisex = WienerInDFT(Noisex,std2(Noisex));

%Read the fingerprint and store it in "Fingerprint" variable
r_file_loc = 'Cameras\Camera5\Fingerprint.dat';
Fingerprint = readmatrix(r_file_loc);

n = 5/0.1; % wanted to go from 0.1 till 5
for i=1:n
    
    %Try with a new scaling factor
    fac = 0.1*i;
    %resize the fingerprint 
    tempFp = imresize(Fingerprint, fac, 'bilinear');
       
    %Do matching using NCC
    [best_pos, best_pce] = NCC_blocks(tempFp, Noisex);
    
    %If one of the resolutions of noise is larger than the fngerprint,
    %there is no chance that the noise is cropped version of the
    %fingerprint. In that case, try with the next factor (i.e., continue)
     if( best_pos == -2)
        continue;
     end
       
  %Otherwise check for matching 
   if(best_pce >= 60)
        output=strcat(' Camera 1 has taken the given image. PCE is: ', string(best_pce));
        disp(output); 
        output=strcat('Matching for scale factor: ', num2str(fac), ' and location: ', num2str (best_pos (1)), ', ', num2str (best_pos (2)));
        disp(output);
        break; %One matching found means answer found. terminate
   end 
 end 
  %%% End of Quiz 5C

