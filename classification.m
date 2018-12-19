clc
clear all
% load fisheriris
% model=TreeBagger(100,meas,species);
% Y=predict(model,meas);
traindata=load('train4.txt');
trainlabel=load('trainlabel4.txt');
% index=load('odorindex1.txt');
testlabel=load('testlabel4.txt');
testdata=load('test4.txt');
% traindata=traindata(:,index);
% testdata=testdata(:,index);
model=TreeBagger(100,traindata,trainlabel);
Y=predict(model,testdata);
for index=1:numel(Y)
    Y{index}=str2num(Y{index});
end
result=cell2mat(Y)-testlabel;
correct=0;
for index=1:numel(result)
    if result(index)==0
        correct=correct+1;
    end
end
correct/numel(result)
confusionmatrix=zeros(12);
for indexc=1:numel(testlabel)
        confusionmatrix(testlabel(indexc),Y{indexc})=confusionmatrix(testlabel(indexc),Y{indexc})+1;
end
for indexv=1:size(confusionmatrix,2)
    confusionmatrix(indexv,:)=confusionmatrix(indexv,:)/sum(confusionmatrix(indexv,:));
end