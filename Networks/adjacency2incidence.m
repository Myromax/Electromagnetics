function [U,I,Ic] = adjacency2incidence(A)

% adjacency2incidence - convert an adjacency matrix to an incidence matrix
%
%   Ic = adjacency2incidence(A);
%
%   A(i,j) = 1 iff (i,j) is an edge of the graph.
%   For each edge number k of the graph linking (i,j)
%       Ic(i,k)=1 and Ic(j,k)=-1 
%
%   Ic is a sparse matrix.
%   Ic is also known as the graph gradient.
%
%   Copyright (c) 2006 Gabriel Peyre

%% compute list of edges
[i,j,s] = find(sparse(A));
I = find(i<=j);
i = i(I);
j = j(I);
% number of edges
n = length(i);
% number of vertices
nverts = size(A,1);

%% build sparse matrix
s = [ones(n,1); -ones(n,1)];
is = [(1:n)'; (1:n)'];
js = [i(:); j(:)];
Ic = sparse(is,js,s,n,nverts);
%converting to full matrix
Ic = full(Ic)

% fix self-linking problem (0)
a = find(i==j);
if not(isempty(a))
    for t=a'
        Ic(i(t),t) = 1;
    end
end   
%current Law
I=zeros(length(Ic),1);
f=zeros(length(Ic),1);
for i= 1:length(Ic)
    d=inputdlg('Enter value of current at Node',num2str(i));
    f(i,1)=str2double(d);
end                                
I=-f\Ic'

%voltage Law
U=zeros(length(Ic),1);  
phi=zeros(length(Ic),1);
for i= 1:length(Ic)
    d=inputdlg('Enter value of voltage at Node',num2str(i));
    phi(i,1)=str2double(d);
end 

U=-Ic*phi





end

