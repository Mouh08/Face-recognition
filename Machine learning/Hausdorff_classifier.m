function itrfin = Hausdorff_classifier(X, Y, classe)
A = [45, 18, 59, 25, 69, 28, 82];    %A = [30 29 32 31 30 31 27];
n = length(Y);
list = [];

for k = 1 : size(X, 2) 
  A     = X(:, k);
  B     = Y;
  mhd   = ModHausdorffDist( A, B );
  Dist =  mhd; 
  list = [list; Dist];
end

itrfin  =  find(list == min(list));%find(Vec == max(Vec));
itrfin  = classe(itrfin);
%itrfin  = appartient(itrfin, A);
end

function j = appartient(i, A)
%if m == 1
   if i <= A(1)
    j = 1
   elseif i <= A(1) + A(2)
    j = 2
   elseif i <= A(1) + A(2) + A(3)
    j = 3
   elseif i <= A(1) + A(2) + A(3) + A(4)
    j = 4
   elseif i <= A(1) + A(2) + A(3) + A(4) + A(5)
    j = 5
   elseif i <= A(1) + A(2) + A(3) + A(4) + A(5) + A(6)
    j = 6
   elseif i <= A(1) + A(2) + A(3) + A(4) + A(5) + A(6) + A(7)
    j = 7    
   end   
end

