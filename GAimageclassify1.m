clc
clear all
result1=[];
result2=[];
for index00012=1:15
    index00012
population=[];%种群
populationsize=30;
historybestfitness=-Inf;
historybestchromosome=[];
featurenumber=5270;%特征个数,待定
maxgeneration=200;%最大迭代次数
newpopulation=[];
crossoverrate=0.7;
mutationrate=0.3;
fitness=[];
for index1=1:populationsize
    for index2=1:featurenumber
        if rand()>=0.5
            population(index1,index2)=1;
        else
            population(index1,index2)=0;
        end
    end
end

for k=1:maxgeneration 
    k
   %计算适应度
   for index9=1:populationsize
      currentchromosome=population(index9,:);
      tempaccuracy=[];
      parfor index100=1:4
          triandata=load(strcat(strcat('train',num2str(index100)),'.txt'));
          trianlabel=load(strcat(strcat('trainlabel',num2str(index100)),'.txt'));
          testdata=load(strcat(strcat('test',num2str(index100)),'.txt'));
          testlabel=load(strcat(strcat('testlabel',num2str(index100)),'.txt'));
                  temptriandata=[];
                  temptestdata=[];
                      featurecount=0;
                  for index10=1:featurenumber%准备特征
                      if currentchromosome(index10)==1
                          temptriandata(:,featurecount+1)=triandata(:,index10);
                          temptestdata(:,featurecount+1)=testdata(:,index10);
                          featurecount=featurecount+1;
                      end
                  end
                  %此处使用SVM分类，获得准确率
                  model=TreeBagger(100,temptriandata,trianlabel);
                  Y=predict(model,temptestdata);
%               model = svmtrain(trianlabel,temptriandata, '-s 0 -t 0 -e 0.001 -m 500 -b 1');
%               [predict_label, accuracy, dec_values] =svmpredict(testlabel, temptestdata, model,'-b 1');
%               tempaccuracy(index100)=accuracy(1);
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
tempaccuracy(index100)=correct/numel(result);
      end
      fitness(index9)=mean(tempaccuracy);
   end
   if max(fitness)>historybestfitness
       historybestfitness=max(fitness);
   end
   maxchromosome=find(fitness==max(fitness));
   historybestchromosome=population(maxchromosome(randint(1,1,[1,numel(maxchromosome)])),:);

   fitness=fitness./sum(fitness);
   %组成轮盘
       lunpan=[];
       lunpan(1)=fitness(1);
       for i=2:populationsize
         lunpan(i)=lunpan(i-1)+fitness(i);
       end
       %轮盘赌选择
    for i=1:populationsize 
        selectedposition=[];
        mark=rand();
        for index3=1:populationsize
            if lunpan(index3)>=mark
                selectedposition=index3;
                break;
            end
        end
        newpopulation(i,:)=population(selectedposition,:);
    end
       %交叉
       for index4=1:crossoverrate*populationsize
           temparray=randperm(populationsize);
           chromosome1=newpopulation(temparray(1),:);
           chromosome2=newpopulation(temparray(2),:);
           crossoverpoint=randint(1,1,[1,featurenumber]);
           tempelement=chromosome1(1:crossoverpoint);
           chromosome1(1:crossoverpoint)=chromosome2(1:crossoverpoint);
           chromosome2(1:crossoverpoint)=tempelement;
       end
       %变异
         for index5=1:mutationrate*populationsize
          mutationposition=randint(1,1,[1,featurenumber]);
          chosenchromosome=randint(1,1,[1,populationsize]);
          character=newpopulation(chosenchromosome,mutationposition);
              if character==1
                  newpopulation(chosenchromosome,mutationposition)=0;
              else
                  newpopulation(chosenchromosome,mutationposition)=1;
              end
         end
         population=newpopulation;
end
%最后获得的结果分类
   
Accuracy=zeros(1,4);

     for index100=1:4
          triandata=load(strcat(strcat('train',num2str(index100)),'.txt'));
          trianlabel=load(strcat(strcat('trainlabel',num2str(index100)),'.txt'));
          testdata=load(strcat(strcat('test',num2str(index100)),'.txt'));
          testlabel=load(strcat(strcat('testlabel',num2str(index100)),'.txt'));
                  temptriandata=[];
                  temptestdata=[];
                      featurecount=0;
                  for index10=1:featurenumber%准备特征
                      if historybestchromosome(index10)==1
                          temptriandata(:,featurecount+1)=triandata(:,index10);
                          temptestdata(:,featurecount+1)=testdata(:,index10);
                          featurecount=featurecount+1;
                      end
                  end
                  %此处使用SVM分类，获得准确率
               model=TreeBagger(100,temptriandata,trianlabel);
                  Y=predict(model,temptestdata);
%               model = svmtrain(trianlabel,temptriandata, '-s 0 -t 0 -e 0.001 -m 500 -b 1');
%               [predict_label, accuracy, dec_values] =svmpredict(testlabel, temptestdata, model,'-b 1');
%               tempaccuracy(index100)=accuracy(1);
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
              Accuracy(index100)=correct/numel(result);
              %计算正常和不正常样本个数
              
     end   
     result1(index00012,:)=historybestchromosome;
     result2(index00012)=historybestfitness;
end