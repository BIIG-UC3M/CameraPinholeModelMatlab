%% Modelado de la c�mara PinHole
close all
clc
clear all
% En coordenadas homog�neas
C = [0,0,0,1]';C1 = [0,0,1,1];
PlanoProyeccion = [0 0 -1 1]';

% Coordenadas del Centro de visi�n (c�mara)
C = [0,0,0,1];
C1 = [0,0,1,1];
figure
plot3([C(1) C1(1)],[C(2) C1(2)],[C(3) C1(3)]);
scatter3(C(1),C(2),C(3),'rx','LineWidth',4);
hold on;

% Plano de proyecci�n Z = 1;
[PX,PY] = meshgrid(linspace(-1,1,50),linspace(-1,1,50));
PZ = -(PlanoProyeccion(1)*PX + PlanoProyeccion(2)*PY + PlanoProyeccion(4))/PlanoProyeccion(3);
surf(PX,PY,PZ,0.5*ones(size(PZ)),'EdgeAlpha',0,'FaceAlpha',0.1,'FaceColor','b');


% Para un punto P
P = [0.5 0.5 2 1]';

% Su proyecci�n vendr� dada seg�n la distancia f del punto C al plano

fx = 1;
fy = 1;

K = [fx 0 0 0; 0 fy 0 0; 0 0 1 0];

Pproyectado = (K*P)';
Pproyectado = Pproyectado/Pproyectado(3);

scatter3(P(1),P(2),P(3),'gx','LineWidth',4);
scatter3(Pproyectado(1),Pproyectado(2),Pproyectado(3),'gx','LineWidth',4);
plot3([P(1) C(1)],[P(2) C(2)],[P(3) C(3)],'g')
axis equal
hold off
%%
% Ahora para una figura cualquiera
figure
N = 100;
t = linspace(5,25,N);
X = 10*cos(t)./(2*t);
Y = 10*sin(t)./(2*t);
Z = 2*sin(1.05*X)./X;
espiral = [X;Y;Z;ones(size(X))]';
plot3(espiral(:,1),espiral(:,2),espiral(:,3),'LineWidth',2);
grid on
hold on
% Modelo c�mara
plot3([C(1) C1(1)],[C(2) C1(2)],[C(3) C1(3)]);
scatter3(C(1),C(2),C(3),'rx','LineWidth',4);
surf(PX,PY,PZ,0.5*ones(size(PZ)),'EdgeAlpha',0,'FaceAlpha',0.1,'FaceColor','g');

% Dibujamos las l�neas de proyecci�n

for i=1:5:length(espiral)
    A = espiral(i,:);
    plot3([A(1) C(1)],[A(2) C(2)],[A(3) C(3)],'-.b','LineWidth',0.5);
end


% Calculamos con K los puntos proyectados
Espiral_proyectada = (K*espiral')';
Espiral_proyectada = Espiral_proyectada./repmat(Espiral_proyectada(:,3),[1,3]);
plot3(Espiral_proyectada(:,1),Espiral_proyectada(:,2),Espiral_proyectada(:,3),'r','LineWidth',2);
hold off
axis equal


%%
% Ahora vamos a meter un offset a la c�mara para que concuerde con los p�xeles de la imagen proyectada
% Supongamos que el centro de la proyecci�n de la c�mara est� en:
figure
Pcentro = [0.4 -0.5 1];
px = Pcentro(1);
py = Pcentro(2);
% Ahora K

K = [fx 0 px 0; 0 fy py 0; 0 0 1 0];

% Figura
plot3(espiral(:,1),espiral(:,2),espiral(:,3),'LineWidth',2);
grid on
hold on
% Modelo c�mara
plot3([C(1) C1(1)],[C(2) C1(2)],[C(3) C1(3)]);
scatter3(C(1),C(2),C(3),'rx','LineWidth',4);
surf(PX,PY,PZ,0.5*ones(size(PZ)),'EdgeAlpha',0,'FaceAlpha',0.1,'FaceColor','g');

Espiral_proyectada2 = (K*espiral')';
Espiral_proyectada2 = Espiral_proyectada2./repmat(Espiral_proyectada2(:,3),[1,3]);
plot3(Espiral_proyectada2(:,1),Espiral_proyectada2(:,2),Espiral_proyectada2(:,3),'r','LineWidth',2);
hold off
axis equal

% Ahora movamos la c�mara a otro sitio y comprobemos la proyecci�n y el modelo
% de par�metros intr�nsecos junto con el de extr�nsecos.
figure
% Supongamos que la c�mara se ha movido a otra posici�n /traslaci�n

T = [0.5 0.5 0.5]';

% Podemos aplicarlo a la matriz de calibraci�n invirtiendo la traslaci�n
TrMat = [eye(3) T; 0 0 0 1];

% Aplicamos la transformaci�n al modelo de la c�mara
C_tras = TrMat*C';
C1_tras = TrMat*C1';

% N�tese que para mover el plano se aplica el inverso de la transformada de la matriz de transformaci�n para un plano DUALIDAD
Plano_tras = (TrMat')\PlanoProyeccion; 
PZ_tras = -(Plano_tras(1)*PX + Plano_tras(2)*PY + Plano_tras(4))/Plano_tras(3);

plot3([C(1) C1(1)],[C(2) C1(2)],[C(3) C1(3)],'r');
hold on
scatter3(C(1),C(2),C(3),'rx','LineWidth',4);
surf(PX,PY,PZ,0.5*ones(size(PZ)),'EdgeAlpha',0,'FaceAlpha',0.2,'FaceColor','r');
plot3([C_tras(1) C1_tras(1)],[C_tras(2) C1_tras(2)],[C_tras(3) C1_tras(3)],'b');
scatter3(C_tras(1),C_tras(2),C_tras(3),'bx','LineWidth',4);
surf(PX,PY,PZ_tras,0.5*ones(size(PZ_tras)),'EdgeAlpha',0,'FaceAlpha',0.2,'FaceColor','b');


%%
% Ahora hay que aplicar la transformaci�n inversa al objeto antes de
% transformarlo

% K volvemos a K sin movimiento
px = 0;
py = 0;
K = [fx 0 px 0; 0 fy py 0; 0 0 1 0;0 0 0 1];

% Invertimos la transformaci�n
invTrMat = inv(TrMat);

% La nueva matriz de modelado de la proyecci�n es:
% Primero trasladamos el objeto y luego le aplicamos el modelo
P = K*invTrMat;

plot3(espiral(:,1),espiral(:,2),espiral(:,3),'LineWidth',2);
% Se crea la proyecci�n
Espiral_proyectada3 = (P*espiral')'; 
% Se transforman a coordenadas de la imagen
Espiral_proyectada3(:,1:3) = Espiral_proyectada3(:,1:3)./repmat(Espiral_proyectada3(:,3),[1,3]);
% Se transforman las coordenadas de la imagen a las del plano moviendo la
% imagen del plano Z a la nueva posici�n siguiendo el movimiento de la
% c�mara
Espiral_proyectada3 = (TrMat*Espiral_proyectada3')';
plot3(Espiral_proyectada3(:,1),Espiral_proyectada3(:,2),Espiral_proyectada3(:,3),'r','LineWidth',2);
hold off
axis equal
% Probemos ahora a mover la c�mara libremente sobre el espacio.
figure
rots = [pi/3 0 0]';
T = [0 0 0]';

Rt = [cos(rots(3)) sin(rots(3)) 0 ; -sin(rots(3)) cos(rots(3)) 0 ; 0 0 1] * ...
             [cos(rots(2)) 0 sin(rots(2)) ;0 1 0 ; -sin(rots(2)) 0 cos(rots(2))] * ...
             [1 0 0 ; 0 cos(rots(1)) sin(rots(1)) ; 0 -sin(rots(1)) cos(rots(1))];         
         
% Primero rotamos y luego trasladamos
TrMat = [eye(3) T; 0 0 0 1]*[Rt zeros(3,1);0 0 0 1];

% K volvemos a K sin movimiento
px = 0;
py = 0;
K = [fx 0 px 0; 0 fy py 0; 0 0 1 0;0 0 0 1];


% Aplicamos la transformaci�n al modelo de la c�mara
C_tras = TrMat*C';
C1_tras = TrMat*C1';

% N�tese que para mover el plano se aplica el inverso de la transformada de la matriz de transformaci�n para un plano DUALIDAD
Plano_tras = (TrMat')\PlanoProyeccion; 
PZ_tras = -(Plano_tras(1)*PX + Plano_tras(2)*PY + Plano_tras(4))/Plano_tras(3);

plot3([C(1) C1(1)],[C(2) C1(2)],[C(3) C1(3)],'r');
hold on
scatter3(C(1),C(2),C(3),'rx','LineWidth',4);
surf(PX,PY,PZ,0.5*ones(size(PZ)),'EdgeAlpha',0,'FaceAlpha',0.2,'FaceColor','r');
plot3([C_tras(1) C1_tras(1)],[C_tras(2) C1_tras(2)],[C_tras(3) C1_tras(3)],'b');
scatter3(C_tras(1),C_tras(2),C_tras(3),'bx','LineWidth',4);
surf(PX,PY,PZ_tras,0.5*ones(size(PZ_tras)),'EdgeAlpha',0,'FaceAlpha',0.2,'FaceColor','b');

% Invertimos la transformaci�n
invTrMat = [Rt' -Rt'*T; 0 0 0 1];

% La nueva matriz de modelado de la proyecci�n es:
% Primero trasladamos el objeto y luego le aplicamos el modelo
P = K*invTrMat;

plot3(espiral(:,1),espiral(:,2),espiral(:,3),'LineWidth',2);
% Se crea la proyecci�n
Espiral_proyectada3 = (P*espiral')'; 
% Se transforman a coordenadas de la imagen
Espiral_proyectada3(:,1:3) = Espiral_proyectada3(:,1:3)./repmat(Espiral_proyectada3(:,3),[1,3]);
% Se transforman las coordenadas de la imagen a las del plano moviendo la
% imagen del plano Z a la nueva posici�n siguiendo el movimiento de la
% c�mara
Espiral_proyectada3 = (TrMat*Espiral_proyectada3')';
plot3(Espiral_proyectada3(:,1),Espiral_proyectada3(:,2),Espiral_proyectada3(:,3),'r','LineWidth',2);

hold off
axis equal