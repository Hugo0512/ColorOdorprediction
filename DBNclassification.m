clc
clear all
error=[];
feature=load('train3.txt');%����Ԫ��
train_x=feature;
% [m,n]=size(feature);
label=load('DBNtrainlabel3.txt');%�������
train_y=label;
feature1=load('test3.txt');%����Ԫ��
test_x=feature1;
testlabel=load('DBNtestlabel3.txt');
test_y=testlabel;
clear feature
clear feature1
clear label
clear testlabel

for index=1:size(test_x,2)
    test_x(:,index)=(test_x(:,index)-min(test_x(:,index)))/(max(test_x(:,index))-min(test_x(:,index)));
end
for index=1:size(train_x,2)
    train_x(:,index)=(train_x(:,index)-min(train_x(:,index)))/(max(train_x(:,index))-min(train_x(:,index)));
end
%���ݹ�һ��
for i=1:20 
    i
    for j=1:20
       j


% train_x = double(train_x) / 255;
% test_x  = double(test_x)  / 255;
% train_y = double(train_y);
% test_y  = double(test_y);
rand('state',0)
%train dbn
dbn.sizes = [2000,500];
opts.numepochs =   600;
opts.batchsize = 2898;
opts.momentum  =   0.05*i;
opts.alpha    =   0.05*j;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);
%unfold dbn to nn
nn = dbnunfoldtonn(dbn, 12);%ע������ĵڶ�������

nn.activation_function = 'sigm';
nn.output='softmax';
%train nn
opts.numepochs = 100;
opts.batchsize = 2898;
nn = nntrain(nn, train_x, train_y, opts);%�˴�Ϊ���������磬��������BP
[er, bad] = nntest(nn, test_x, test_y);

error(i,j)=er;
%assert(er < 0.10, 'Too big error');
    end
end
save DBNcolorerror2.txt -ascii error