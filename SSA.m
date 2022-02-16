
function [Best_score,Best_pos,curve]=SSA(popsize,maxIter,lb,ub,dim,fobj)
global initialX
lb = lb.*ones(1,dim);
ub = ub.*ones(1,dim);

ST = 0.6;
PD = 0.7;
SD = 0.2;

PDNumber = round(popsize*PD); 
SDNumber = popsize - round(popsize*SD);
if(max(size(ub)) == 1)
   ub = ub.*ones(1,dim);
   lb = lb.*ones(1,dim);  
end

X0=initialX;
X = X0;
fitness = zeros(1,popsize);
for i = 1:popsize
   fitness(i) =  fobj(X(i,:));
end
 [fitness, index]= sort(fitness);
BestF = fitness(1);
WorstF = fitness(end);
GBestF = fitness(1);
for i = 1:popsize
    X(i,:) = X0(index(i),:);
end
curve=zeros(1,maxIter);
curve(1) = BestF;
GBestX = X(1,:);
X_new = X;
for i = 2: maxIter
        
    R2 = rand(1);
   for j = 1:PDNumber
      if(R2<ST)
          X_new(j,:) = X(j,:).*exp(-j/(rand(1)*maxIter));
      else
          X_new(j,:) = X(j,:) + randn()*ones(1,dim);
      end     
   end
   for j = PDNumber+1:popsize
        if(j>(popsize - PDNumber)/2 + PDNumber)
          X_new(j,:)= randn().*exp((X(end,:) - X(j,:))/j^2);
       else
          
          A = ones(1,dim);
          for a = 1:dim
            if(rand()>0.5)
                A(a) = -1;
            end
          end 
          AA = A'*inv(A*A');     
          X_new(j,:)= X(1,:) + abs(X(j,:) - X(1,:)).*AA';
       end
   end
   Temp = randperm(popsize);
   SDchooseIndex = Temp(1:SDNumber); 
   for j = 1:SDNumber
       if(fitness(SDchooseIndex(j))>BestF)
           X_new(SDchooseIndex(j),:) = X(1,:) + randn().*abs(X(SDchooseIndex(j),:) - X(1,:));
       elseif(fitness(SDchooseIndex(j))== BestF)
           K = 2*rand() -1;
           X_new(SDchooseIndex(j),:) = X(SDchooseIndex(j),:) + K.*(abs( X(SDchooseIndex(j),:) - X(end,:))./(fitness(SDchooseIndex(j)) - fitness(end) + 10^-8));
       end
   end
   for j = 1:popsize
       for a = 1: dim
           if(X_new(j,a)>ub(a))
               X_new(j,a) =ub(a);
           end
           if(X_new(j,a)<lb(a))
               X_new(j,a) =lb(a);
           end
       end
   end 
   for j=1:popsize
    fitness_new(j) = fobj(X_new(j,:));
   end
   for j = 1:popsize
    if(fitness_new(j) < GBestF)
       GBestF = fitness_new(j);
        GBestX = X_new(j,:);   
    end
   end
   X = X_new;
   fitness = fitness_new;
   [fitness, index]= sort(fitness);
   BestF = fitness(1);
   for j = 1:popsize
      X(j,:) = X(index(j),:);
   end
   curve(i) = GBestF;
end
Best_pos =GBestX;
Best_score = curve(end);
end



