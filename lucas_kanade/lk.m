im1t = im2double(imread('frame13.png'));
im2t = im2double(imread('frame14.png'));
%so that motion is less than one pixel, so downsize to half
im1 = imresize(im1t, 0.5); 
im2 = imresize(im2t, 0.5); 
%calculate directional gradients
[Ix_m, Iy_m] = imgradientxy(im1);
It_m = conv2(im1, .5*ones(2), 'same') + conv2(im2, -.5*ones(2), 'same');
u = zeros(size(im1));
v = zeros(size(im2));

window_size = 30;
shift = 15;

for i = shift+1:size(im1,1)-shift
    for j = shift+1:size(im1,2)-shift
        Ix = Ix_m(i-shift:i+shift, j-shift:j+shift);
        Iy = Iy_m(i-shift:i+shift, j-shift:j+shift);
        It = It_m(i-shift:i+shift, j-shift:j+shift);
        
        %convert to column vectors
        Ix = Ix(:);
        Iy = Iy(:);
        b = -It(:); 

        A = [Ix Iy]; 
        vxy = pinv(A)*b; 

        u(i,j)=vxy(1);
        v(i,j)=vxy(2);
    end
end

% sampling at intervals of 5 for the resized image
u_sampled = u(1:10:end, 1:10:end);
v_sampled = v(1:10:end, 1:10:end);
% sampling has to be done at intervals of 10 for original image
[m, n] = size(im1t);
[X,Y] = meshgrid(1:n, 1:m);
X_p = X(1:20:end, 1:20:end);
Y_p = Y(1:20:end, 1:20:end);

figure();
imshow(im2t);
hold on;
% draw the velocity vectors
quiver(X_p, Y_p, u_sampled,v_sampled, 'r')