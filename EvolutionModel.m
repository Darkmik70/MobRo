function newOdom = EvolutionModel( oldOdom , U )
    newOdom = zeros(3,1);
    newOdom(1,1) = oldOdom(1)+U(1)*cos(oldOdom(3));
    newOdom(2,1) = oldOdom(2)+U(1)*sin(oldOdom(3));
    newOdom(3,1) = oldOdom(3)+U(2);
return
