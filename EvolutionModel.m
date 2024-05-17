% at time k, it should get k+1
% X is the posture get it from magnetloc.m
% and U. is 
% 
% multiplied 
% 
% with x and u

% jointToCartesian = [ rwheel/2           rwheel/2          ;
%                      rwheel/trackGauge -rwheel/trackGauge ] ;
% deltaq = [ qR(i) - qR(i-1) ; 
%                qL(i) - qL(i-1) ] ;
% U = jointToCartesian * deltaq ;
% 
% disp(U)
% disp(U(1,1))
% disp(U(2,1))
% 
% X = [ 0, 0, 0*pi/180 ].' ;
% disp(X(3,1))
% 


function new_X = EvolutionModel(X, U)
    % Calculate the new state variables
    theta = X(3) + U(2);
    x = X(1) + U(1)*cos(X(3));
    y = X(2) + U(1)*sin(X(3));

    % Assemble the new state vector
    new_X = [x; y; theta];
end



