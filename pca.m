clear all
% addpath('C:\Users\Michelle\Documents\Research\Metric learning\code');
load fisheriris
[m d] = size(meas);

% plot the original data distribution showing classes 
f = figure;
gscatter(meas(:,1), meas(:,2), species, 'rgb'); hold on %plot the sepal length against the sepal width, grouped by classes 
gscatter(meas(:,3), meas(:,4), species, 'rgb'); hold on
grid on;
title('Original data distribution')
xlabel('Sepal length');
ylabel('Sepal width');

% classification on original data
Mdl = fitcknn(meas,species,'NumNeighbors',4);
rloss = 100 - resubLoss(Mdl)*100;
disp('The original data distibution has accuracy: ');
disp(rloss);

% data pre-processing: perform mean normalization and feature scaling 
for i=1:d % mean normalization 
    mean = sum(meas(:,i))/m;
    meas(:,i) = meas(:,i) - mean;
end

% pca
sigma = (1/m).*(meas')*meas; % compute covariance matrix
[U,S,V] = svd(sigma); % perform singular value decomposition 
Ureduce = U(:,1:2);
Z = -1*meas*Ureduce; 
% -1 because the eigen vectors over here come to be negative which makes the
% plot a mirror of the 'correct' plot
% depending on the eigen solver, the eigen vectors can have negative or
% positive results

% plot data again
f = figure;
gscatter(Z(:,1), Z(:,2), species); hold on %plot the sepal length against the sepal width, grouped by classes 
grid on;
title('Data distribution after PCA')
xlabel('Sepal length');
ylabel('Sepal width');

%classification on projected data
Mdl = fitcknn(Z,species,'NumNeighbors',4);
rloss = 100 - resubLoss(Mdl)*100;
disp('The projected data distibution has accuracy:');
disp(rloss);
