clc
clear all
array=load('Unpleasant1.txt');%������

%���Σ����x�У�5270��
trianclass1=reshape(array,[],5270);
s=7;%���䱶��

trianlabel1=3*ones(1,size(trianclass1,1));%�������ǩ
artificialsamples=[];%�洢���ɵ��˹�����
k=floor(size(trianclass1,1)*0.3);%k���ڵĸ���
for index=1:size(trianclass1,1)%ֻ��������������
    distance=[];
   for index1=1:size(trianclass1,1) 
       distance(index1)=sqrt(sum((trianclass1(index,:)-trianclass1(index1,:)).^2));
   end
   
   mixarray=[distance' trianlabel1' [1:size(trianclass1,1)]'];
   
   for index2=1:size(mixarray,1)%���򣬰��վ���
       for index3=index2+1:size(mixarray,1)
           if mixarray(index2,1)>mixarray(index3,1)
               temp=mixarray(index2,:);
               mixarray(index2,:)=mixarray(index3,:);
               mixarray(index3,:)=temp;
           end
       end
   end
   for index4=2:s
        chosennumber=randint(1,1,[1,k]);
       artificialsample=trianclass1(index,:)+rand()*(trianclass1(mixarray(chosennumber,3),:)-trianclass1(index,:));
       artificialsamples(size(artificialsamples,1)+1,:)=artificialsample;
   end
end
SMOTEarray=[trianclass1;artificialsamples];
save Unpleasant2.txt -ascii SMOTEarray