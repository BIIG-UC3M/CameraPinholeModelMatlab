%% Ejemplo de modelo de proyecci�n 

close all
clear all
clc

% En coordenadas homog�neas
% El centro de proyecci�n est� en [0,0,0,1]
% El plano de la retina o proyecci�n en Z = 1 [0 0 -1 1]

C = [0,0,0,1];
C1 = [0,0,1,1];
R = [0,0,-1,1];

% En este caso, x = X/Z, y = Y/Z
% Para un punto p = [X,Y,Z] su proyecci�n en el plano estar� en:
% (x,y)

% p = [x,y,1]'
% T = [1 0 0 0;0 1 0 0;0 0 1 0] 
% P = [X,Y,Z,1];

% Ejemplo 1:
% Supongamos una figura
Z_image = 3;
N = 100;
t = linspace(5,25,N);
X = 10*cos(t)./(2*t);
Y = 10*sin(t)./(2*t);
Z = Z_image*ones(size(X));
espiral = [X;Y;Z;ones(size(X))];
plot3(espiral(1,:),espiral(2,:),espiral(3,:),'LineWidth',2);
grid on


% Dibujemos el plano de proyecci�n y el punto C centro de proyecci�n
hold on
plot3([C(1) C1(1)],[C(2) C1(2)],[C(3) C1(3)]);
scatter3(C(1),C(2),C(3),'rx','LineWidth',4);

% Plano
% Lo definiremos con 4 puntos 
[PX,PY] = meshgrid(linspace(-1,1,50),linspace(-1,1,50));
Plano = ones(size(PX)); 
surf(PX,PY,Plano,0.5*ones(size(Plano)),'EdgeAlpha',0.02,'FaceAlpha',0.5);


% Y ahora traslademos las coordenadas del espacio X Y Z de la figura a las
% del propio plano de proyecci�n Z

fx = 1;
fy = 1;
Skew = 0;

T = [fx Skew C(1) 0;0 fy C(2) 0; 0 0 1 0];

espiralProyeccion = T*espiral;
plot3(espiralProyeccion(1,:),espiralProyeccion(2,:),ones(size(espiralProyeccion)),'r','LineWidth',2);

%%
%
% Supongamos ahora que la c�mara se mueve
% El movimiento de la c�mara puede determinarse mediante una traslaci�n y
% una rotaci�n

rots = [0 0 0]';
t = [0 -2 1.5]';

Rt = [cos(rots(3)) sin(rots(3)) 0 0; -sin(rots(3)) cos(rots(3)) 0 0; 0 0 1 0; 0 0 0 1] * ...
             [cos(rots(2)) 0 sin(rots(2)) 0;0 1 0 0; -sin(rots(2)) 0 cos(rots(2)) 0; 0 0 0 1] * ...
             [1 0 0 0; 0 cos(rots(1)) sin(rots(1)) 0; 0 -sin(rots(1)) cos(rots(1)) 0; 0 0 0 1];
Tt = [eye(3,3) t;0 0 0 1];

% Teniendo el movimiento de la c�mara, ahora hay que movel en sentido inverso la escena
% para trasladar ese movimiento a los datos y no a la c�mara
             
K = T(1:3,1:3);

Mt_cam = Rt*Tt;
Mt = inv(Mt_cam);
P = K*[1 0 0 0;0 1 0 0;0 0 1 0]*Mt; % Matriz de transformaci�n a coordenadas de la imagen

% Movimiento de la c�mara
C_movido = (Mt_cam)*C';
C1_movido = (Mt_cam)*C1';
plot3([C_movido(1) C1_movido(1)],[C_movido(2) C1_movido(2)],[C_movido(3) C1_movido(3)]);
scatter3(C_movido(1),C_movido(2),C_movido(3),'bx','LineWidth',4);

Plano_mov = Mt_cam'*[0 0 -1 1]';
PZ_movido = -(Plano_mov(1)*PX + Plano_mov(2)*PY + Plano_mov(4))/Plano_mov(3);
surf(PX,PY,PZ_movido,0.5*ones(size(PZ_movido)),'EdgeAlpha',0.02,'FaceAlpha',0.5);


%%
%
% Movimiento del plano de proyecci�n
% El plano se mueve de acuerdo a Mt_cam

Plano_mov = Mt_cam'*[0 0 -1 1]';
PZ_movido = -(Plano_mov(1)*PX + Plano_mov(2)*PY + Plano_mov(4))/Plano_mov(3);
surf(PX,PY,PZ_movido,0.5*ones(size(PZ_movido)),'EdgeAlpha',0.02,'FaceAlpha',0.5);

espiralProyeccion2 = P*espiral;
espiralZ = -(Plano_mov(1)*espiralProyeccion2(1,:) + Plano_mov(2)*espiralProyeccion2(2,:) + Plano_mov(4))/Plano_mov(3);
plot3(espiralProyeccion2(1,:),espiralProyeccion2(2,:),espiralZ,'b','LineWidth',2);






axis square

