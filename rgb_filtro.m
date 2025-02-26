% Carica l'immagine
name = 'Lena';
img = imread(['img_filtro\', name, '.jpeg']);
dim = 32;

% Riduci l'immagine ad una dimensione di 32x32 pixel
resized_image = imresize(img, [dim, dim]);

% Estrae i canali rosso, verde e blu
red = resized_image(:,:,1);
green = resized_image(:,:,2);
blue = resized_image(:,:,3);

%% 
% Carica l'immagine filtrata dal circuito
path_behav = 'project_pix\project_pix.sim\sim_1\behav\xsim\';
path_impl = 'project_pix\project_pix.sim\sim_1\impl\timing\xsim\';
Rout_result_behav = readmatrix([path_behav, 'Routput_results.txt']);
Gout_result_behav = readmatrix([path_behav, 'Goutput_results.txt']);
Bout_result_behav = readmatrix([path_behav, 'Boutput_results.txt']);
Rout_result_impl = readmatrix([path_impl, 'Routput_results.txt']);
Gout_result_impl = readmatrix([path_impl, 'Goutput_results.txt']);
Bout_result_impl = readmatrix([path_impl, 'Boutput_results.txt']);


% Reshape i dati in una matrice 32x32 
Rdata_behav = reshape(Rout_result_behav, [dim, dim]);
Gdata_behav = reshape(Gout_result_behav, [dim, dim]);
Bdata_behav = reshape(Bout_result_behav, [dim, dim]);
Rdata_impl = reshape(Rout_result_impl, [dim, dim]);
Gdata_impl = reshape(Gout_result_impl, [dim, dim]);
Bdata_impl = reshape(Bout_result_impl, [dim, dim]);


% Convert binary matrix to decimal matrix
Rmyfilt_image_behav = zeros(dim,dim);
Gmyfilt_image_behav = zeros(dim,dim);
Bmyfilt_image_behav = zeros(dim,dim);
Rmyfilt_image_impl = zeros(dim,dim);
Gmyfilt_image_impl = zeros(dim,dim);
Bmyfilt_image_impl = zeros(dim,dim);
for i = 1:dim
    for j = 1:dim 
    % Convert each row of binary numbers to decimal
    Rmyfilt_image_behav(i,j) = bin2dec(num2str(Rdata_behav(j,i)));
    Gmyfilt_image_behav(i,j) = bin2dec(num2str(Gdata_behav(j,i)));
    Bmyfilt_image_behav(i,j) = bin2dec(num2str(Bdata_behav(j,i)));
    Rmyfilt_image_impl(i,j) = bin2dec(num2str(Rdata_impl(j,i)));
    Gmyfilt_image_impl(i,j) = bin2dec(num2str(Gdata_impl(j,i)));
    Bmyfilt_image_impl(i,j) = bin2dec(num2str(Bdata_impl(j,i)));
    end
end

Rmyfilt_image_behav = uint8(Rmyfilt_image_behav);
Gmyfilt_image_behav = uint8(Gmyfilt_image_behav);
Bmyfilt_image_behav = uint8(Bmyfilt_image_behav);
Rmyfilt_image_impl = uint8(Rmyfilt_image_impl);
Gmyfilt_image_impl = uint8(Gmyfilt_image_impl);
Bmyfilt_image_impl = uint8(Bmyfilt_image_impl);

% Unisce i tre colori in un'unica immagine
myfilt_image_behav = cat(3, Rmyfilt_image_behav, Gmyfilt_image_behav, Bmyfilt_image_behav);
myfilt_image_impl = cat(3, Rmyfilt_image_impl, Gmyfilt_image_impl, Bmyfilt_image_impl);

%% Mirroring
% Definisco le immagini estese
red_ext = uint8(zeros(dim+2, dim+2));
green_ext = uint8(zeros(dim+2, dim+2));
blue_ext = uint8(zeros(dim+2, dim+2));

% Copio l'immagine
for i = 1:dim
    for j = 1:dim
        red_ext(i+1, j+1) = red(i, j);
        green_ext(i+1, j+1) = green(i, j);
        blue_ext(i+1, j+1) = blue(i, j);
    end
end

% Applico l'estensione
for i=1:dim+1
    red_ext(1, i) = red_ext(3, i);
    green_ext(1, i) = green_ext(3, i);
    blue_ext(1, i) = blue_ext(3, i);
end

for i=1:dim+1
    red_ext(i, dim+2) = red_ext(i, dim);
    green_ext(i, dim+2) = green_ext(i, dim);
    blue_ext(i, dim+2) = blue_ext(i, dim);
end

for i=1:dim+1
    red_ext(dim+2, dim+3-i) = red_ext(dim, dim+3-i);
    green_ext(dim+2, dim+3-i) = green_ext(dim, dim+3-i);
    blue_ext(dim+2, dim+3-i) = blue_ext(dim, dim+3-i);
end

for i=1:dim+1
    red_ext(dim+3-i, 1) = red_ext(dim+3-i, 3);
    green_ext(dim+3-i, 1) = green_ext(dim+3-i, 3);
    blue_ext(dim+3-i, 1) = blue_ext(dim+3-i, 3);
end

red_ext(1, 1) = red_ext(3, 3);
green_ext(1, 1) = green_ext(3, 3);
blue_ext(1, 1) = blue_ext(3, 3);


%% 
% Definisci il kernel personalizzato
w = 10;
wl = -1;
wc = -1;

w_r = w;
wl_r = wl;
wc_r = wc;

w_g = w;
wl_g = wl;
wc_g = wc;

w_b = w;
wl_b = wl;
wc_b = wc;

kernel_r = [wc_r, wl_r, wc_r;
            wl_r, w_r, wl_r;
            wc_r, wl_r, wc_r]; %kernel personalizzato

kernel_g = [wc_g, wl_g, wc_g;
            wl_g, w_g, wl_g;
            wc_g, wl_g, wc_g]; %kernel personalizzato

kernel_b = [wc_b, wl_b, wc_b;
            wl_b, w_b, wl_b;
            wc_b, wl_b, wc_b]; %kernel personalizzato


% % Applica il filtro
% borders = 'symmetric';
% r_image = imfilter(red, kernel_r, 0);
% g_image = imfilter(green, kernel_g, 0);
% b_image = imfilter(blue, kernel_b, 0);
% 
% % Unisce i colori
% filtered_image = cat(3, r_image, g_image, b_image);

% Applica il mirroring
r_image_ext = imfilter(red_ext, kernel_r);
g_image_ext = imfilter(green_ext, kernel_g);
b_image_ext = imfilter(blue_ext, kernel_b);
filtered_image_ext = cat(3, r_image_ext, g_image_ext, b_image_ext);

% Unisce i colori e ritaglia i bordi
filtered_image = filtered_image_ext(2:end-1, 2:end-1, :);


%% 
% PSNR
ref = reshape(double(filtered_image), 1, []);
I_behav = reshape(double(myfilt_image_behav), 1, []);
I_impl = reshape(double(myfilt_image_impl), 1, []);
mse_behav = norm((ref-I_behav))^2/(3*dim^2);
mse_impl = norm((ref-I_impl))^2/(3*dim^2);
mse = norm((I_behav-I_impl))^2/(3*dim^2);

%% 
% Visualizza l'immagine originale e l'immagine filtrata
caption_behav = sprintf('Filtro FPGA "behavioral"\nMSE = %d', mse_behav);
caption_impl = sprintf('Filtro FPGA "post timing implementation"\nMSE = %d', mse_impl);
subplot(2,2,1), imshow(resized_image), title(sprintf('Immagine %dx%d', dim, dim))
subplot(2,2,2), imshow(filtered_image), title('Filtro Matlab')
subplot(2,2,3), imshow(myfilt_image_behav), title(caption_behav)
subplot(2,2,4), imshow(myfilt_image_impl), title(caption_impl)

% %%
% % Mostra l'immagine originale e quella filtrata
% num_pixel_diversi=0;
% % subplot(1,3,1);
% % imshow(myfilt_image_impl);
% % title('Immagine filtrata con mirroring matlab');
% subplot(1,3,2)
% imshow(myfilt_image_impl);
% title('FPGA');
% for i = 1:32
%     for j = 1:32
%         for k= 1:3
%         if myfilt_image_impl(i,j,k) ~= filtered_image(i,j,k)
%             num_pixel_diversi = num_pixel_diversi + 1;
%             fprintf('Pos (%d, %d, %d)', i, j, k);
%         end
%         end
%     end
% end
% fprintf('Il numero di pixel diversi tra le due immagini è: %d\n', num_pixel_diversi);

