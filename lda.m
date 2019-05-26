clear all
load fisheriris
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

mean_vecs = zeros(num_classes,n);
for i=1:m
    x = M(char(species(i)));
    mean_vecs(x,:) = mean_vecs(x,:) + meas(i,:);
end
mean_vecs = mean_vecs / 50;
overall_mean = sum(mean_vecs)/num_classes;

% between-class scatter matrix
Sb = zeros(n);
for i=1:num_classes
    temp = mean_vecs(i,:) - overall_mean;
    Sb = Sb + (samples_class(i)*temp'*temp);
end

% within-class scatter matrix
Sw = zeros(n);
i = 1;
while i<m
    temp = meas(i:i+50-1,:) - mean_vecs(M(char(species(i))),:);
    Sw = Sw + (temp'*temp);
    i = i+50;
end

f = figure;
gscatter(meas(:,1), meas(:,2), species, 'rgb'); hold on % plot the sepal length against the sepal width, grouped by classes 
gscatter(meas(:,3), meas(:,4), species, 'rgb'); hold on
% scatter(Sw(:,1), Sw(:,2), 'k', 'filled'); hold on
% scatter(Sw, 'k'); hold on
% gscatter(meas(:,3), meas(:,4), species, 'rgb'); hold on
grid on;
title('Original data distribution')

W = inv(Sw)*Sb;
[V D] = eig(W);

transform = -V; % implementation gives of eig() gives neg values which can be taken to  
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
title('Data distribution after LDA')
xlabel('Sepal length');
ylabel('Sepal width');
