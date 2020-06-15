I = double(imread('satpic1.bmp'));
kernel = [1, 2, 1; 2, 4, 2; 1, 2, 1];
% without prefiltering
% YOUR CODE HERE

for i = 1:3
    I_post(:, :, i) = downsample(downsample(I(:, :, i), 2)', 2)';
end

for i = 1:3
    I_up(:, :, i) = upsample(upsample(I_post(:, :, i), 2)', 2)';
end

% I_post = I(1:2:end, 1:2:end, :);
% I_up = zeros(size(I));
% I_up(1:2:end, 1:2:end, :) = I_post;
I_up = prefilterlowpass2d(I_up, kernel);
I_rec_notpre = I_up*4;

% Evaluation without prefiltering
% I_rec_notpre is the reconstructed image WITHOUT prefiltering
PSNR_notpre = calcPSNR(I, I_rec_notpre);
fprintf('Reconstructed image, not prefiltered, PSNR = %.2f dB\n', PSNR_notpre)





% with prefiltering
% YOUR CODE HERE

I_pre = prefilterlowpass2d(I, kernel);
% I_pre = I_pre(1:2:end, 1:2:end, :);
% I_up_pre = zeros(size(I));
% I_up_pre(1:2:end, 1:2:end, :) = I_pre;
for i = 1:3
    I_post_pre(:, :, i) = downsample(downsample(I_pre(:, :, i), 2)', 2)';
end

for i = 1:3
    I_up_pre(:, :, i) = upsample(upsample(I_post_pre(:, :, i), 2)', 2)';
end

I_up_pre = prefilterlowpass2d(I_up_pre, kernel);
I_rec_pre = I_up_pre * 4;

% Evaluation with prefiltering
% I_rec_pre is the reconstructed image WITH prefiltering
PSNR_pre = calcPSNR(I, I_rec_pre);
fprintf('Reconstructed image, prefiltered, PSNR = %.2f dB\n', PSNR_pre)

bpp_stat = (numel(uint8(I_post)) * 8)/(size(I_rec_notpre, 1)*size(I_rec_notpre, 2));

plot(bpp_stat, PSNR_pre, 'x');
text(bpp_stat, PSNR_pre, '  satpic1 - E1-2 Pre')
hold on;
axis([0 24 10 50]);


% put all the sub-functions called in your script here
function pic_pre = prefilterlowpass2d(picture, kernel)
% YOUR CODE HERE
pic_pre = zeros(size(picture));
kernel = kernel/sum(kernel(:));
for i = 1:size(picture, 3)
    pic_pre(:, :, i) = conv2(picture(:, :, i), kernel, 'same');
end
end

function MSE = calcMSE(Image, recImage)
% YOUR CODE HERE
Image = double(Image);
recImage = double(recImage);
dif_image = (Image-recImage).^2;
MSE = mean(dif_image(:));
end

function PSNR = calcPSNR(Image, recImage)
% YOUR CODE HERE
MSE = calcMSE(Image, recImage);
PSNR = 10 * log10((2^8-1)^2/MSE);
end