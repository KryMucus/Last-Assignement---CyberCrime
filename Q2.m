% Load the image
image = imread("Q2.jpg");

% Rotate the image 45 degrees clockwise
rotated_image = imrotate(image, -45);

% Load Camera 1’s precomputed fingerprint
fingerprint_camera1 = readmatrix('Cameras\Camera1\Fingerprint.dat');

% Compute the PCE for Camera 1's fingerprint
Noisex = NoiseExtractFromImage(rotated_image, 2);
Noisex = WienerInDFT(Noisex, std2(Noisex));

% Convert the rotated image to grayscale and to double precision
Ix = double(rgb2gray(rotated_image));

%Cropping as a camera can take images of various resolutions 
Noisex = imcrop(Noisex, [1, 1, 1000, 1000]);
Ix = imcrop(Ix, [1, 1, 1000, 1000]);

fingerprint_camera1_cropped = imcrop(fingerprint_camera1, [1, 1, 1000, 1000]);

% Compute cross-correlation and PCE

[best_pos, best_pce] = NCC_blocks(Noisex, fingerprint_camera1_cropped);

if best_pce > 50
    % If PCE > 50, the image has been taken by Camera 1
    disp('The image has been taken by Camera 1');
else
    % Load Camera 6’s precomputed fingerprint
    fingerprint_camera6 = readmatrix('Cameras\Camera6\Fingerprint.dat');
    
    fingerprint_camera6_cropped = imcrop(fingerprint_camera6, [1, 1, 1000, 1000]);
   
    [best_pos, best_pce] = NCC_blocks(Noisex,fingerprint_camera6_cropped);

    if best_pce > 50
        % If PCE > 50, the image has been taken by Camera 6
        disp('The image has been taken by Camera 6');
    else
        % Conclude: The image hasn’t been taken by Camera 6 nor Camera 1
        disp('The image hasn’t been taken by Camera 6 nor Camera 1');
    end
end