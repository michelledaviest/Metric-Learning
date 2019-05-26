% paper: http://papers.nips.cc/paper/2795-distance-metric-learning-for-large-margin-nearest-neighbor-classification.pdf
% code: https://bitbucket.org/mlcircus/lmnn/downloads/

clear all 
load fisheriris
% total number of samples = m;
% total number of features = n;
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

% calulate the covariance matrix % inbuilt function: C = cov(meas);
cov_mat = zeros(n);
% calulate the mean of every feature (column)
mean = zeros(1,n);
for i=1:n
    mean(i) = mean(i) + sum(meas(:,i));
end
mean = mean / m;
meas_mean = meas - mean;
cov_mat = (meas_mean.' * meas_mean)/(m - 1);

% % euclidean dist metric 
% euclid_metric = zeros(m);
% for i=1:m
%     for j=1:m
%         if(i ~= j && euclid_metric(i,j) == 0)
%             temp = meas(i,:) - meas(j,:);
%             t = sqrt(temp*temp');
%             euclid_metric(i,j) = t;
%             euclid_metric(j,i) = t;
%         end
%     end
% end

% % mahalanobis dist metric 
% mahal_metric = zeros(m);
% for i=1:m
%     for j=1:m
%         if(i ~= j && mahal_metric(i,j) == 0)
%             temp = meas(i,:) - meas(j,:);
%             t = sqrt(temp*cov_mat*temp');
%             mahal_metric(i,j) = t;
%             mahal_metric(j,i) = t;
%         end
%     end
% end

% similarity matrix: yij 
sim = zeros(m);
for i=1:m
    for j=1:m
        if(M(char(species(i))) == M(char(species(j))))
            sim(i,j) = 1;
            sim(j,i) = 1;
        end
    end
end

% requires 2017b optimization toolkit, but I currently only have 2017a :
% SD linear programming 
% needs to be checked

obj_fun = sum(sum(((meas(i)-meas(j))'*M*(meas(i)-meas(j))))+c*sum(sum(nij(1-sim(i,j))Eijl));
linprob = optimproblem('Objective',obj_fun);
linprob.Constraints.cons1 = (meas(i)-meas(l))'*M*(meas(i)-meas(l))-(meas(i)-meas(j))'*M*(meas(i)-meas(j)) >= 1 - Eijl; 
linprob.Constraints.cons1 = Eijl >= 0;
linprob.Constraints.cons1 = M >= 0; %SPD condition 
linsol = solve(linprob);