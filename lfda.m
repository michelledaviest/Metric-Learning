% paper: http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=BF6A5033EAA46C87448B80973657820B?doi=10.1.1.75.3380&rep=rep1&type=pdf
% official code: https://github.com/jk123vip/cdSRC_matlab_code/blob/master/LFDA.m

clear all 
load fisheriris
% total number of samples = m;
[m n] = size(meas);

keySet = unique(species)';
valueSet = [1 2 3];
M = containers.Map(keySet,valueSet);
num_classes = length(unique(species));

samples_class = zeros(1,num_classes);
for i=1:m
    x = M(char(species(i)));
    samples_class(x) = samples_class(x)+1;
end

% affinity matrixes 
Aw=zeros(m);
Ab=zeros(m);
for i=1:m
    for j=1:m
        yi = M(char(species(i)));
        yj = M(char(species(j)));
        if(yi == yj)
            num = samples_class(yi);
            Aw(i,j) = 1/num;
            Ab(i,j) = (1/m) - (1/num);
        else
            Ab(i,j) = 1/m;
        end
    end
end

tAw=zeros(m);
tAb=zeros(m);
for i=1:m
    for j=1:m
        yi = M(char(species(i)));
        yj = M(char(species(j)));
        if(yi == yj)
            num = samples_class(yi);
            tAw(i,j) = Aw(i,j)/num;
            tAb(i,j) = Ab(i,j)*((1/m) - (1/num));
        else
            Ab(i,j) = 1/m;
        end
    end
end

% calulate the scatter matrixes 
Sw = zeros(n);
Sb = zeros(n);
for i=1:m
    for j=1:m
        temp = meas(i,:) - meas(j,:);
        tSb = tAb(i,j)*(temp'*temp);
        tSw = tAw(i,j)*(temp'*temp);
        Sb = Sb + tSb;
        Sw = Sw + tSw;
    end
end
Sb = 0.5*Sb;
Sw = 0.5*Sw;

W = inv(Sw)*Sb;
[V D] = eig(W);

transform = - V; % implementation gives of eig() gives neg values which can be taken to  
for i=1:n
    max = i;
    for j = i:4
        if(D(j,j)>D(max,max))
           max = j; 
        end
    end
    
    temp = D(max,max);
    D(max,max) = D(i,i);
    D(i,i) = temp;    
    
    temp = transform(:,max);
    transform(:,max) = transform(:,i);
    transform(:,i) = temp;    
end

Y = meas*transform(:,1:2);
f = figure;
gscatter(Y(:,1), Y(:,2), species); hold on 
grid on;
title('Data distribution after LFDA')
xlabel('Sepal length');
ylabel('Sepal width');

% S = zeros(m,1);
% for i=1:m
%     S(i) = M(char(species(i)));
% end
% 
% [T Z] = test(meas,S,2,'weighted',7);
% 
