function demo()
%This function shows the superpixels in both random colors and overlayed on
%top of the original image. Label image shape should be(Y,X,V,U) 
%where X,Y are the image dimensions and U,V the horizontal and vertical number of views


%change folder to the path of superpixels and light field images in your device
pathToDownloadedLabelImage = ".\papillon20.mat"; %label image of ALFO
pathToHCIImage = "F:\HCIfolder\papillon\lf.h5"; %original HCI image

L = load(pathToDownloadedLabelImage).L;
%% Max number of labels, to generate a random coloring for superpixels
colors = rand( max(max(max(max(L)))), 3);  

%% To show label image in random colors
idxv =  repelem(1:size(L,3), 1, size(L,3));
idxu = repmat([1:size(L,4) size(L,4):-1:1], 1, round(size(L,4)/2.0));
for i = 1: size(idxv,2)
    imshow(label2rgb( L(:, :, idxv(i),idxu(i)), colors));
    %pause(0.1)
end

%% To show the superpixels overlayed on top of the original 4D light field image


LF = h5read(pathToHCIImage,'/LF' ); % change folder to the path of LF image in your device
LF = permute(LF, [3 2 1 5 4]);
D = uint16(zeros(size(L,1),size(L,2),size(L,3)*size(L,4)));
I = uint8(zeros(size(L,1),size(L,2),3,size(L,3)*size(L,4)));

for i = 1: size(idxv,2)
    microlensImg(:,:,:) = LF(:,:,:,idxv(i),idxu(i)); 
    D(:,:,i) = L(:, :, idxv(i),idxu(i));
    I(:,:,:,i) = microlensImg;
end

imSize = size(D);
imPlusBoundaries = zeros(imSize(1),imSize(2),3,imSize(3),'uint8');%uint8 the max value of pixels 255
for plane = 1:imSize(3)
    BW = boundarymask(D(:, :, plane));
    imPlusBoundaries(:, :, :, plane) = imoverlay(I(:, :,:,plane), BW, 'red');
end

implay(imPlusBoundaries,5)
end

