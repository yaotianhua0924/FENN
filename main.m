
clc
clear all
global net
AA=xlsread('data1.xlsx');
data=AA(:,1)';
numTimeStepsTrain = floor(numel(data(1:132)));
dataTrain = data(1:numTimeStepsTrain);
dataTest = data(numTimeStepsTrain+1:end);
mu = mean(dataTrain);
sig = std(dataTrain);
dataTrainStandardized = (dataTrain - mu) / sig;
SearchAgents_no=30; 
dim=5;
lb= [1 0.0001 0.0001 200 200];  
ub= [13 1 1 800 400];  
Max_iteration=50; 
%initialX=initialization(SearchAgents_no,dim,ub,lb); 
fobj=@(x) ClusteringCost(x,dataTrainStandardized,dataTest,mu,sig); 
[Best_pos,Best_score,TSO_curve]=ICHIO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%[Best_score,Best_pos,TSO_curve]=SSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
semilogx(TSO_curve,'Color','r','linewidth',1.5);
title('Objective space')
xlabel('Iteration');
ylabel('Best score obtained so far');
axis tight
grid on
box on
legend('ICHIO')
a=round(Best_pos(1));
b=Best_pos(2);
c=Best_pos(3);
d=round(Best_pos(4));
e=round(Best_pos(5));
disp(['步长a=',num2str(a)])
disp(['学习率1=',num2str(b)])
disp(['学习率2=',num2str(c)])
disp(['网络层数=',num2str(d)])
disp(['迭代次数=',num2str(e)])
num4=12;
mse4 = sqrt(sum((YPred-YTest).^2)) ./ num4;
mae4 = mean(abs(YPred-YTest));
rmse4 = sqrt(mean((YTest-YPred).^2));
R4 = 1 - (sum((YPred-YTest).^2) / sum((YTest- mean(YTest)).^2));
disp(['2019年预测发病率均方误差MSE为：',num2str(mse4)])
disp(['2019年预测发病率平均绝对误差MAE为：',num2str(mae4)])
disp(['2019年预测发病率均方根误差RMSE为：',num2str(rmse4)])
disp(['2019年预测发病率决定系数为：',num2str(R4)])
figure
plot(YPred,'r--','LineWidth',1.5)
hold on
plot(YTest,'b','LineWidth',2)
axis tight
title('2019年SARIMA预测丙肝发病率曲线')
legend('预测值','真实值','Location','NorthWest')
hold off


