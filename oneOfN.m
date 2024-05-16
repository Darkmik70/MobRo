% downsample a data matrix whose lines are time indexed, taking one line every N lines.
% If input matrix has at least one line, the output has at least one line
% (the first line of the input matrix).
function newMatrix = oneOfN( matrix , N )
    i = 1 ;
    j = 0 ;
    newMatrix = [] ;
    [nl,nc] = size(matrix) ;
    while( i<=nl )
        j = j+1 ;
        newMatrix(j,:) = matrix(i,:) ;
        i = i+N ;
    end
return
