clear all
% Obtaining image and label data from http://yann.lecun.com/exdb/mnist/
% Unzip the files. For this example, use the |t10k-images| data.
imageFileName = 't10k-images.idx3-ubyte';
labelFileName = 't10k-labels.idx1-ubyte';

% Process the files to load them in the workspace.
cd(fullfile(matlabroot,'examples','stats'));
[X,L] = processMNISTdata(imageFileName,labelFileName);

% Obtain two-dimensional analogues of the data clusters using t-SNE.
% Use the Barnes-Hut variant of the t-SNE algorithm to save time on this relatively large data set.
rng default % for reproducibility
Y = tsne(X,'Algorithm','barneshut','NumPCAComponents',50);

% visualize the data
figure
gscatter(Y(:,1),Y(:,2),L)
title('MNIST Dataset reduced to two dimensions')

% Reduce Dimension of Data to Three
% t-SNE can also reduce the data to three dimensions. 
rng default % for fair comparison
Y3 = tsne(X,'Algorithm','barneshut','NumPCAComponents',50,'NumDimensions',3);
figure
scatter3(Y3(:,1),Y3(:,2),Y3(:,3),15,L,'filled');
title('MNIST Dataset reduced to three dimensions')
view(-93,14)