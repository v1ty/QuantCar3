%% Parametersof quarter car
g  = 9.81;       % gravitational acceleration, m/s^2
ms = 300;           % sprung mass, kg
mu = 60;            % unsprung mass, kg
ks = 16000;         % suspension stiffness, N/m
cs = 1000;          % suspension damping, N*s/m
kt = 190000;       % tire stiffness, N/m
ct = 0;             % tire damping, N*s/m
Ls = 0.50;          % lengt of spring uncompressed for suspension, m 
Lt = 0.30;          % tire length in equilibirum, m 


tireStaticCompression = ((ms + mu) * g) / kt; % Compression = force/stiffness
suspStaticCompression = (ms * g) / ks;

tireJointPosition0 = Lt - tireStaticCompression; %length - gravity
suspJointPosition0 = Ls - suspStaticCompression;

% Absolute flat-road body-center heights used for checking results.
flatRoadTireH = tireJointPosition0;  
flatRoadBodyH = tireJointPosition0 + suspJointPosition0;

% Dimensions for simulation
sprungDimensions   = [0.70 0.50 0.18];  
unsprungDimensions = [0.35 0.30 0.14];  
sprungColor        = [0.20 0.45 0.85];
unsprungColor      = [0.20 0.20 0.20];

% Simulation settings
stopTime = 10;      
dt       = 0.001;   
maxStep  = 1e-2;   
roadFilterTimeConstant = 0.005;

% 
bodyModeHzApprox = (1/(2*pi)) * sqrt(ks/ms);
wheelHopHzApprox = (1/(2*pi)) * sqrt((ks + kt)/mu);
bodyDampingRatioApprox = cs / (2*sqrt(ks*ms));

%% Build all road cases and choose the default input
roads = roadSuite(stopTime, dt);
roadInput = roads.speedBump;
fprintf('Quarter-car parameters loaded.\n');
fprintf('  Sprung mass: %.1f kg\n', ms);
fprintf('  Unsprung mass: %.1f kg\n', mu);
fprintf('  Flat-road wheel height zu0: %.4f m\n', flatRoadTireH);
fprintf('  Flat-road body height  zs0: %.4f m\n', flatRoadBodyH);

fprintf('  roadInput: roads.speedBump\n');
