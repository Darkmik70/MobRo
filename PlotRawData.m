% A script to display the raw data of a dataset
% Graphs displayed:
% Figure 1: 
%   - The path calculated by odometry only.
% Figure 2: 
%   - Speed and rotation speed, as estimated using the encoders.
% Figure 3:
%   - Number of magnets detected at each time instant.
% Figure 4:
%   - Raw sensor measurements as a function of the curvilinear abscissa
%       (distance traveled by point M). The vertical axis represents the
%       state of each Reed sensor. A vertical line indicates a closed 
%       sensor (a sensor which detects a magnet).
%   - You may comment out this graph when you don't need it anymore 
%       (when you're done estimating the measurement noise).

%function PlotRawData

RobotAndSensorDefinition ;

% Set the initial posture of the robot according to information given
% in file "Programs and data".

Xodo(:,1) = [ 0, 0, 0*pi/180 ].' ;    

%Load the data file
dataFile = uigetfile('data/*.txt','Select data file') ;
if isunix 
    eval(['load data/' , dataFile]) ;
else
    eval(['load data\' , dataFile]) ;
end
dataFile = strrep(dataFile, '.txt', '') ;
eval(['data = ',dataFile,'; clear ',dataFile]) ;
 
[nbLoops,t,qL,qR,sensorReadings] = PreprocessData(data, dots2rad, dumbFactor, subSamplingFactor ) ;

U(:,1) = [0,0].';

for i = 2 : nbLoops 
    
    waitbar(i/nbLoops) ;

    % Calculate input vector from proprioceptive sensors
    deltaq = [ qR(i) - qR(i-1) ; 
               qL(i) - qL(i-1) ] ;
    U(:,i) = jointToCartesian * deltaq ;  % joint speed to Cartesian speed.
       
    % Predic state (here odometry)
    Xodo(:,i) = EvolutionModel( Xodo(:,i-1) , U(:,i) ) ;
    
end

% Plot robot path, Kalman fiter estimation and odometry only estimation

figure; 
plot( Xodo(1,:), Xodo(2,:) , 'r' , 'LineWidth', 2 ) ;
zoom on ; grid on; axis('equal');
title('Path estimated by odometry');
xlabel('x (mm)');
ylabel('y (mm)');

% Plot odometry-estimated speed and rotation speed

figure; 
subplot(2,1,1);
plot( t,U(1,:)/samplingPeriod , 'LineWidth',2 );
xlabel('t (s)');
ylabel('v (mm/s)');
title('Odometry-estimated speed');
zoom on ; grid on;
subplot(2,1,2);
plot( t,U(2,:)*180/pi/samplingPeriod , 'LineWidth',2 );
xlabel('t (s)')
ylabel('w (deg/s)' , 'LineWidth',2 );
title('Odometry-estimated rotation speed');
zoom on ; grid on;

% Plot raw sensor measurements
nbPeriods = size( sensorReadings , 1 ) ;
rawMeas = zeros( nbReedSensors , nbPeriods ) ;
travDistance(1) = 0 ;
for k = 2 : nbPeriods
    travDistance(k) = travDistance(k-1) + U(1,k) ;
end
for k = 1 : nbPeriods
    rawMeas( : , k ) = bitget( sensorReadings(k) , 1:8 ) ;
end
figure; 
for n = 1 : nbReedSensors
    for k = 1 : nbPeriods
        if rawMeas(n,k) == 0
            hold on ;
            line([travDistance(k) travDistance(k)],[n-0.5 n+0.5],'Color','b','LineStyle','-' , 'LineWidth', 2 );
        end
    end
end
set(gca,'YLim',[0 nbReedSensors+1]) ;
xlabel('Travelled distance of point M (mm)');
ylabel('Reed sensor number') ;
title('State of Reed sensors (blue = magnet dectected)') ;
zoom on; grid on;

% Calculate and display odometry error (assuming KF is right).

fprintf('\nTotal travelled distance: %d mm\n',round(travDistance(length(travDistance))));