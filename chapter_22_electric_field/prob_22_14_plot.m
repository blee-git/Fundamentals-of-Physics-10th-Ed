% cemVE04.m
% 8 april 2016
% Ian Cooper
% School of Physics, University of Sydney
% https://d-arora.github.io/Doing-Physics-With-Matlab/

% Potential and Electric Field in [2D] region
% 2 charges placesd along X axis
% Dipole / charges of the same charge / charges of different magnitudes
% For different charge distributions you need to modify the code for
     % figure 6 - need to adjust the starting postions of the streamlines
     % need more streamlines for the higer charge --> 
     % density of electric lines proportion to strength of electric field


clear all
close all
clc
tic

% INPUTS  ================================================================

% Number of grid point    [N = 10001]
   N = 1001;
   
% Charge  Q = [10, 0, 0, 0, 0] 
   Q = [-5, 2, 0, 0, 0] .* 1e-6;
   
% Radius of circular charged conductor;   
   a = 0.01;
   
% X & Y components of position of charges  [0, 0, 0, 0, 0]
   xC = [ 0,    1,  0.5, -0.5, 0];
   yC = [ 0,    0,    0,    0,   0];

% 5 random charges   uncomment to run the program for 5 random charges
%   Q = (1 + 9 .* rand(5,1)) .* 1e-6;
%   xC = -2 + 4 .* rand(5,1); 
%   yC = -2 + 4 .* rand(5,1); 

% constants
   eps0 = 8.854e-12;
   kC = 1/(4*pi*eps0);
   
% Dimensions of region / saturation levels
%   [dimensions of region -2 to 2 / minR = 1e-6 / Esat = 1e6 / Vsat = 1e6]
   minX = -2;  
   maxX =  3;
   minY = -2;
   maxY =  2;
   minR = 1e-6;
   minRx = 1e-6;
   minRy = 1e-6;
   Vsat = kC * max(abs(Q)) / a;
   Esat = kC * max(abs(Q)) / a^2;
   
% SETUP  =================================================================
   
  % fields
    V = zeros(N,N);
    Ex = zeros(N,N); Ey = zeros(N,N);
  % [2D] region
    x  = linspace(minX,maxX,N);
    y = linspace(minY, maxY,N);
    
  % color of charged object  +  red   /   - black
    col1 = [1 0 0];
    col2 = [0 0 0];
    %if Q(1) < 0; col1 = [0 0 0]; end;
        
  % grid positions
    [xG, yG] = meshgrid(x,y);


% CALCULATION: POTENTIAL & ELECTRIC FIELD ================================

for n = 1 : 2
   Rx = xG - xC(n);
   Ry = yG - yC(n);
   
   index = find(abs(Rx)+ abs(Ry) == 0); 
   Rx(index) = minRx;  Ry(index) = minRy;
   
   R = sqrt(Rx.^2 + Ry.^2);
   R(R==0) = minR;
   V = V + kC .* Q(n) ./ (R);
   
   R3 = R.^3;
   Ex = Ex + kC .* Q(n) .* Rx ./ R3;
   Ey = Ey + kC .* Q(n) .* Ry ./ R3;
end

   if max(max(V)) >=  Vsat; V(V > Vsat)  = Vsat; end;
   if min(min(V)) <= -Vsat; V(V < -Vsat) = -Vsat; end;

   E = sqrt(Ex.^2 + Ey.^2);
   if max(max(E)) >=  Esat; E(E >  Esat)  =  Esat; end;
   if min(min(E)) <= -Esat; E(E < -Esat)  = -Esat; end;
   
   if max(max(Ex)) >=  Esat; Ex(Ex >  Esat)  =  Esat; end;
   if min(min(Ex)) <= -Esat; Ex(Ex < -Esat)  = -Esat; end;
   
   if max(max(Ey)) >=  Esat; Ey(Ey >  Esat)  =  Esat; end;
   if min(min(Ey)) <= -Esat; Ey(Ey < -Esat)  = -Esat; end;
   

% GRAPHICS ===============================================================

%figure(1)
     set(gcf,'units','normalized','position',[0.73 0.1 0.23 0.32]); 
     hold on
     index1 = 51 : 50 : 951;
     index1 = [index1 500 502];
     index2 = index1;
          
     p1 = xG(index1, index2); p2 = yG(index1, index2);
     
     % scaling of electric field lines: unit length
        p3 = Ex(index1, index2)./(E(index1,index2));
        p4 = Ey(index1, index2)./(E(index1,index2));
     % no scaling of electric field lines
     %  p3 = Ex(index1, index2); p4 = Ey(index1, index2); 
     
     h = quiver(p1,p2,p3,p4,'autoscalefactor',0.8);
     set(h,'color',[0 0 1],'linewidth',1.2)
     
      hold on
      
      % charged conductors
      col = col1;
      if Q(1) < 0; col = col2; end;
      pos1 = [-a+xC(1), -a, 2*a, 2*a];
      h = rectangle('Position',pos1,'Curvature',[1,1]);
      set(h,'FaceColor',col,'EdgeColor',col);
      
      col = col1;
      if Q(2) < 0; col = col2; end;
      pos2 = [-a-xC(1), -a, 2*a, 2*a];
      h = rectangle('Position',pos2,'Curvature',[1,1]);
      set(h,'FaceColor',col,'EdgeColor',col);
     
     xlabel('x  [m]'); ylabel('y  [m]');
     title('direction of scaled E at grid points','fontweight','normal');
     
     set(gca,'xLim',[-2,2]); set(gca,'yLim', [-2, 2]);
     axis([-2 2 -2 2]);
     axis equal
     box on
 
     toc