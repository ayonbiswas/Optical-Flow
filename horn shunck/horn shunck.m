
im1=im2double(imread('frame13.png'));
im2=im2double(imread('frame14.png'));
%calculate directional gradients
[Ix, Iy] = imgradientxy(im1);
It = conv2(im1, 0.25*ones(2),'same') + conv2(im2, -0.25*ones(2),'same');

uInitial = zeros(size(im1));
vInitial = zeros(size(im2));

u = uInitial;
v = vInitial;
ite = 100;
%calculate average of the neighbouring pixels
kernel_1 = [0 , .25 , 0; .25 , 0 , .25 ; 0, .25 , 0];
alpha = 1;
for i=1:ite
    uAvg=conv2(u,kernel_1,'same');
    vAvg=conv2(v,kernel_1,'same');
    u= uAvg - ( Ix .* ( ( Ix .* uAvg ) + ( Iy .* vAvg ) + It ) ) ./ ( alpha^2 + Ix.^2 + Iy.^2); 
    v= vAvg - ( Iy .* ( ( Ix .* uAvg ) + ( Iy .* vAvg ) + It ) ) ./ ( alpha^2 + Ix.^2 + Iy.^2);
    
end
[m, n] = size(im1);
[X,Y] = meshgrid(1:n, 1:m);
%sampling points at intervals of 20 pixels
X_deci = X(1:20:end, 1:20:end);
Y_deci = Y(1:20:end, 1:20:end);
u_deci = u(1:20:end, 1:20:end);
v_deci = v(1:20:end, 1:20:end);
figure();
imshow(im2);
hold on;
% draw the velocity vectors
quiver(X_deci, Y_deci, u_deci,v_deci, 'y')