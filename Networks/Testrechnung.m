%% Construction of example and sufficient output of GUI 

%            1-------<---                            R12= 1[Ohm]
%           - -         -                            R13= 1[Ohm]
%          -   -        -                            R24= 2[Ohm]
%         2     3      (-) Currentsource I = 4A      R34= 2[Ohm]
%          -   -        -
%           - -         -
%            4----------- 


P=4;                            %number nodes
Pot = sym('q', [P 1]);          %[q1 q2 q3 ... qP]  vector with all potentials                                              
CurrentsN = sym('f', [P 1]);    %[f1 f2 f3 ... fP]  vector with all incoming currents
CurrentsN(1) = 4;               %4 Ampere input at node 1 (Can be adjusted to get different results)
CurrentsN = [4 0 0 0]';         %Nodes where no current is additionally flowing in become 0
Pot(P,1) = 0;                   %grounding at node P (in this case node 4)

%% resistance-/adjacency-/incidencematrix (just for this example!)


r1=1;              %Values of resistances can be adjusted
r2=1;              %to compare different behaviours of 
r3=2;              %the circuit
r4=2;
v = [r1 r2 r3 r4];
RMatrix = diag(v);      %Resistancy-Matrix

AMatrix =[0 1 1 0       %Adjacency-Matrix
         1 0 0 1
         1 0 0 1
         0 1 1 0];
     
IMatrix= [1 -1 0 0      %Incidence-Matrix
          1 0 -1 0
          0 1 0 -1
          0 0 1 -1];
      
 %% calculating of Potencial at Nodes 1 2 3
 
 S = IMatrix'*inv(RMatrix)*IMatrix;
 k = find(Pot); %all non-grounded potencial
 Pot1 = S(k,k)*Pot(k);
 CurrentsN = CurrentsN(k);
 [A,B] = equationsToMatrix(Pot1, Pot(k));
 X = linsolve(A,CurrentsN);
 Pot(k)=X;
 Pot 
 
 %% calculation of Voltages at edges 12 13 24 34

 U = IMatrix*Pot
 
 %% calculation of currents at edges 12 13 24 34
 
 I = inv(RMatrix)*U
 




