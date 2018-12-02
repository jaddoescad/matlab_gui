  
function [mass,min_von] = get_lowest_vonmises(r_i, F, plot_status, r_o)
  c = r_o;
  E=200*10^3;
  G=77*10^3;
  J=(pi/2)*(((r_o)^4)-((r_i)^4));
  A= (pi)*(((r_o)^2)-((r_i)^2));
  I=(pi/4)*(((r_o)^4)-((r_i)^4));
  total_length = 0;

nodes = [
253.1550842	200	50
253.1550842	200	300
153.1550842	200	300
53.15508424	200	300
53.15508424	200	50
153.1550842	200	50
306.3101685	0	-35
306.3101685	0	385
185.6425264	0	450
0	0	350
0	0	0
185.6425264	0	-100
185.6425264	-187.5	-100
185.6425264	-187.5	450
375.6776734	-325.862069	175
185.6425264	-375	-100
185.6425264	-375	450
0	-375	350
0	-375	0
0	-498.5294118	175
450	-675	-50
450	-675	400
185.64	-675	425
0	-675	425
0	-675	-75
185.64	-675	-75
1100	-1325	75
1100	-1325	275
185.64	-1325	475
0	-1325	475
0	-1325	350
0	-1325	0
0	-1325	-125
185.64	-1325	-125
185.64	-1325	-100
185.64	-1325	450
185.6412632	-1525	-100
185.6412632	-1525	450
185.6425264	-1725	-100
0	-1725	0
0	-1725	350
185.6425264	-1725	450
185.6425264	-1925	-100
0	-1925	0
0	-1925	350
185.6425264	-1925	450
];


elements = [
1  2
2  3
3	4
4	5
5	6
6	1
1	7
2	8
3	9
4	10
5	11
6	12
7	8
8	9
9	10
10	11
11	12
12	7
13	14
12	13
10	14
9	14
7	15
7	16
8	15
8	17
14	17
11	13
13	16
14	18
10	18
19	13
16	17
17	18
18	19
19	16
7	21
18	20
16	21
8 22
17	23
17	22
18	23
20 19
16	26
20	25
20	24
18	24
19	26
19	25
21	22
22	23
23	24
24	25
25	26
26	21
27	28
28	29
29	30
30	31
31	32
32	33
33	34
34	27
21	34
22	29
23	30
24	30
25	33
26	33
34	35
35	36
36	29
32	34
37	38
37	39
32	37
27	39
32	40
32	37
37	40
36	38
23	29
11	19
40 41
31	38
38	41
31	41
41 40
42	41
26	34
15	21
15	22
40	39
39	42
38	42
28	42
39	43
40	44
44	43
41 45
45	44
43	46
42	46
46	45
37 35
31 29
    ];

nn = size(nodes, 1);
ee = size(elements,1);
sdof = 6;
ndof = sdof*nn;

 isol = [1:(6*nn)];
 isol((43*6-5):46*6)=[];

 f=zeros(ndof,1);
%  
 f((1*6)-4)=F;
 f((2*6)-4)=F;
 f((3*6)-4)=F;
 f((4*6)-4)=F;
 f((5*6)-4)=F;
 f((6*6)-4)=F;



d=zeros(ndof, 1);

[rows, columns] = size(elements);
array_of_Ks = zeros(12,12,rows);
mat_stiff_global=zeros(ndof, ndof);
SF_matrix = [];

for r = 1:rows
element = elements(r,:);
node = [nodes(element(1),:), nodes(element(2),:)];
vector_2 = element(1)*sdof;
vector_1 = vector_2 - (sdof-1);
vector_4 = element(2)*sdof;
vector_3 = vector_4 - (sdof-1);

k = SpaceFrameElementStiffness(E,G,A,I,J,node(1),node(2),node(3),node(4),node(5),node(6));
array_of_Ks(:,:,r) = k;
mat_stiff_global([vector_1:vector_2, vector_3:vector_4], [vector_1:vector_2, vector_3:vector_4])=mat_stiff_global([vector_1:vector_2, vector_3:vector_4], [vector_1:vector_2, vector_3:vector_4])+k;
end

d(isol)=mat_stiff_global(isol, isol)\f(isol);

 
  for i=1:ee
    element = elements(i,:);
    node = [nodes(element(1),:), nodes(element(2),:)];
    Di = d([sdof*(elements(i,1))-(sdof-1):6*(elements(i,1)),sdof*(elements(i,2))-(sdof-1):sdof*(elements(i,2))]);
    Fi= SpaceFrameElementForces(E,G,A,I,J,node(1),node(2),node(3),node(4),node(5),node(6),Di);
    
      axial_stress = calculate_axial_stress(Fi(1), A);
      shear_stress = calculate_shear_stress(Fi(2), A);
      shear_stress_2 = calculate_shear_stress(Fi(3), A);
      torsional_stress = calculate_torsional_stress(Fi(4), J, r_o);
      bending_stress_2 = calculate_bending_stress(Fi(5), I, c);
      bending_stress_3 = calculate_bending_stress(Fi(6), I, c);
      v_term_2 = 3*((torsional_stress+max( shear_stress,  shear_stress_2))^2);
      v_term_1 = (axial_stress+max(bending_stress_2, bending_stress_3)^2);
      von_mises = ((v_term_1+v_term_2)^(1/2));
      SF = 305/von_mises;
      
      SF_matrix = [SF_matrix; [i, von_mises, SF]];
      %find smallest value in third column
      [minval, minidx] = min(SF_matrix(:,3));
      total_length = total_length + get_length_of_car(node(1),node(2),node(3),node(4),node(5),node(6));

  end
  mass = get_total_mass(total_length, A);
  min_von = minval;
  if plot_status == 1
      cla reset;
      sclf = 1000;
      
    disp('plotting')
    for e=1:rows

    n1=elements(e,1);
    n2=elements(e,2);
    
    x1=nodes(n1,1); 
    y1= nodes(n1,2);
    z1= nodes(n1,3);
    
    x2= nodes(n2,1); 
    y2=nodes(n2,2);
    z2=nodes(n2,3);
    
    u1 = d(sdof*n1-(sdof-5)); v1 = d(sdof*n1-(sdof-4));w1 = d(sdof*n1-(sdof-3));
    u2 = d(sdof*n2-(sdof-5)); v2 = d(sdof*n2-(sdof-4));w2 = d(sdof*n2-(sdof-3));
    
    plot3([x1, x2],[y1, y2],[z1,z2],'k--');
    plot3([x1, x2]+sclf*[u1, u2],[y1, y2]+sclf*[v1,v2],[z1,z2]+sclf*[w1, w2], 'b');
    hold on
    end
     title('Deformed plot')
 axis equal
 view(3)
rotate3d on
  end
end

function m= get_total_mass(total_length, A)
density =  7.86*10^(-6);
V = A*total_length;
m = density * V;
end

function L = get_length_of_car(x1,y1,z1,x2,y2,z2)
L = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1));
end

function y = SpaceFrameElementStiffness(E,G,A,I,J,x1,y1,z1,x2,y2,z2)
L = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1));
w1 = E*A/L;
w2 = 12*E*I/(L*L*L);
w3 = 6*E*I/(L*L);
w4 = 4*E*I/L;
w5 = 2*E*I/L;
w6 = 12*E*I/(L*L*L);
w7 = 6*E*I/(L*L);
w8 = 4*E*I/L;
w9 = 2*E*I/L;
w10 = G*J/L;
kprime = [w1 0 0 0 0 0 -w1 0 0 0 0 0 ;
   0 w2 0 0 0 w3 0 -w2 0 0 0 w3 ;
   0 0 w6 0 -w7 0 0 0 -w6 0 -w7 0 ;
   0 0 0 w10 0 0 0 0 0 -w10 0 0 ;
   0 0 -w7 0 w8 0 0 0 w7 0 w9 0 ;
   0 w3 0 0 0 w4 0 -w3 0 0 0 w5 ;
   -w1 0 0 0 0 0 w1 0 0 0 0 0 ;
   0 -w2 0 0 0 -w3 0 w2 0 0 0 -w3 ;
   0 0 -w6 0 w7 0 0 0 w6 0 w7 0 ;
   0 0 0 -w10 0 0 0 0 0 w10 0 0 ;
   0 0 -w7 0 w9 0 0 0 w7 0 w8 0 ;
   0 w3 0 0 0 w5 0 -w3 0 0 0 w4];
if x1 == x2 & y1 == y2
   if z2 > z1
      Lambda = [0 0 1 ; 0 1 0 ; -1 0 0];
   else
      Lambda = [0 0 -1 ; 0 1 0 ; 1 0 0];
   end
else
   CXx = (x2-x1)/L;
    CYx = (y2-y1)/L;
    CZx = (z2-z1)/L;
    D = sqrt(CXx*CXx + CYx*CYx);
    CXy = -CYx/D;
    CYy = CXx/D;
    CZy = 0;
    CXz = -CXx*CZx/D;
    CYz = -CYx*CZx/D;
    CZz = D;
    Lambda = [CXx CYx CZx ; CXy CYy CZy ; CXz CYz CZz];
end
R = [Lambda zeros(3) zeros(3) zeros(3) ; 
   zeros(3) Lambda zeros(3) zeros(3) ;
   zeros(3) zeros(3) Lambda zeros(3) ;
   zeros(3) zeros(3) zeros(3) Lambda];
y = R'*kprime*R;
end

function y = SpaceFrameElementForces(E,G,A,I,J,x1,y1,z1,x2,y2,z2,u)
L = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1));
w1 = E*A/L;
w2 = 12*E*I/(L*L*L);
w3 = 6*E*I/(L*L);
w4 = 4*E*I/L;
w5 = 2*E*I/L;
w6 = 12*E*I/(L*L*L);
w7 = 6*E*I/(L*L);
w8 = 4*E*I/L;
w9 = 2*E*I/L;
w10 = G*J/L;
kprime = [w1 0 0 0 0 0 -w1 0 0 0 0 0 ;
   0 w2 0 0 0 w3 0 -w2 0 0 0 w3 ;
   0 0 w6 0 -w7 0 0 0 -w6 0 -w7 0 ;
   0 0 0 w10 0 0 0 0 0 -w10 0 0 ;
   0 0 -w7 0 w8 0 0 0 w7 0 w9 0 ;
   0 w3 0 0 0 w4 0 -w3 0 0 0 w5 ;
   -w1 0 0 0 0 0 w1 0 0 0 0 0 ;
   0 -w2 0 0 0 -w3 0 w2 0 0 0 -w3 ;
   0 0 -w6 0 w7 0 0 0 w6 0 w7 0 ;
   0 0 0 -w10 0 0 0 0 0 w10 0 0 ;
   0 0 -w7 0 w9 0 0 0 w7 0 w8 0 ;
   0 w3 0 0 0 w5 0 -w3 0 0 0 w4];
if x1 == x2 & y1 == y2
   if z2 > z1
      Lambda = [0 0 1 ; 0 1 0 ; -1 0 0];
   else
      Lambda = [0 0 -1 ; 0 1 0 ; 1 0 0];
   end
else
   CXx = (x2-x1)/L;
    CYx = (y2-y1)/L;
    CZx = (z2-z1)/L;
    D = sqrt(CXx*CXx + CYx*CYx);
    CXy = -CYx/D;
    CYy = CXx/D;
    CZy = 0;
    CXz = -CXx*CZx/D;
    CYz = -CYx*CZx/D;
    CZz = D;
    Lambda = [CXx CYx CZx ; CXy CYy CZy ; CXz CYz CZz];
end
R = [Lambda zeros(3) zeros(3) zeros(3) ; 
   zeros(3) Lambda zeros(3) zeros(3) ;
   zeros(3) zeros(3) Lambda zeros(3) ;
   zeros(3) zeros(3) zeros(3) Lambda];
y = kprime*R* u;
end

 function axial_stress = calculate_axial_stress(F, A)
  axial_stress = abs(F/A);
 end
 
function shear_stress = calculate_shear_stress(F, A)
shear_stress = abs((4/3)*(F/A));
end
 
 function bending_stress = calculate_bending_stress(M, I, c)
 bending_stress = abs(M*c/I);
 end

 function torsional_stress = calculate_torsional_stress(T, J, R)
torsional_stress = abs((4/3)*(T*R/J));
 end