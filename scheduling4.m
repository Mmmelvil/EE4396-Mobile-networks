clear all;
close all
load('Aggregate_bitrate.mat');

User = Aggregate_Y; %time domain only
 % time/frequency domain
User_ftd = Bit_rate;


%% scheme1 round robin
Num_user = 4;
m = floor(5000/Num_user)
User_throughput = zeros(Num_user,5000);


for N = 1:Num_user
for tti = 1:5000 
        if mod(tti,Num_user) == N
            User_throughput(N,tti)= User(10-Num_user+N,tti);
        elseif mod(tti,Num_user) == 0
            User_throughput(Num_user,tti)= User(10,tti);
        end
end
average_t(N) = sum(User_throughput(N,:))/5000
resource(N)= sum(sum(User_throughput(N,:)~=0))
end

Cell_t(1) = sum(average_t);
T_m(1) = (sum(average_t))^2/(Num_user*sum(average_t.^2));
R_m(1) = (sum(resource))^2/(Num_user*sum(resource.^2));

%% scheme 2 max rate
User_throughput2 = zeros(Num_user,5000)
for tti = 1:5000
[M,I(tti)] = max(User(11-Num_user:10,tti),[],'linear');
User_throughput2(I(tti),tti)= User(10-Num_user +I(tti),tti);
end

for N = 1:Num_user
average_t(N) = sum(User_throughput2(N,:))/5000;
resource(N)= sum(sum(User_throughput2(N,:)~=0));
end
Cell_t(2) = sum(average_t)
T_m(2) = (sum(average_t))^2/(Num_user*sum(average_t.^2));
R_m(2) = (sum(resource))^2/(Num_user*sum(resource.^2));


%% scheme 3 proportional fair

User_throughput2 = zeros(Num_user,5000)
for N = 1:Num_user
ratio_user(N,:) = User(10-Num_user +N,:)/mean(User(10-Num_user +N,:))
end
for tti = 1:5000
[M,I(tti)] = max(ratio_user(:,tti),[],'linear');
User_throughput3(I(tti),tti)= User(10-Num_user +I(tti),tti);
end

for N = 1:Num_user
average_t(N) = sum(User_throughput3(N,:))/5000;
resource(N)= sum(sum(User_throughput3(N,:)~=0));
end
Cell_t(3) = sum(average_t)
T_m(3) = (sum(average_t))^2/(Num_user*sum(average_t.^2))
R_m(3) = (sum(resource))^2/(Num_user*sum(resource.^2))



%% scheme 4 ft domain RR 



User_throughput = zeros(50,5000,Num_user);
for N = 1:Num_user
for tti = 1:5000 
    for prb = 1:50
        if mod((tti-1)+prb,Num_user) == N
            User_throughput4(prb,tti,N)= User_ftd(tti,prb,10-Num_user+N);
        elseif mod((tti-1)+prb,Num_user) == 0
            User_throughput4(prb,tti,Num_user)=User_ftd(tti,prb,10);
        end
    end
end
 average_t(N) = sum(sum(User_throughput4(:,:,N)))/5000
 resource(N)= sum(sum(User_throughput4(:,:,N)~=0))
end

Cell_t(4) = sum(average_t);
T_m(4) = (sum(average_t))^2/(Num_user*sum(average_t.^2));
R_m(4) = (sum(resource))^2/(Num_user*sum(resource.^2));

%% scheme 5 ft domain max rate



User_throughput5 = zeros(50,5000,Num_user);

for tti = 1:5000
    for prb =1:50
[M,I(prb,tti)] = max(User_ftd(tti,prb,11-Num_user:10),[],'linear');
%(I(tti),tti)= User(10-Num_user +I(tti),tti);
User_throughput5(prb,tti,I(prb,tti)) = User_ftd(tti,prb,10-Num_user+I(prb,tti));
    end
end
A=User_throughput5(:,:,1)
for N = 1:Num_user
 average_t(N) = sum(sum(User_throughput5(:,:,N)))/5000
 resource(N)= sum(sum(User_throughput5(:,:,N)~=0))
end

Cell_t(5) = sum(average_t);
T_m(5) = (sum(average_t))^2/(Num_user*sum(average_t.^2));
R_m(5) = (sum(resource))^2/(Num_user*sum(resource.^2));


%% scheme 5 ft domain max rate



User_throughput = zeros(50,5000,Num_user);
ratio_user = zeros(5000,50,Num_user);
for N = 1:Num_user
    ratio_user(:,:,N) = User_ftd(:,:,10-Num_user +N)/mean(User(10-Num_user +N,:));
end

for tti = 1:5000
    for prb =1:50
[M,I(prb,tti)] = max(ratio_user(tti,prb,:),[],'linear');
%(I(tti),tti)= User(10-Num_user +I(tti),tti);
User_throughput6(prb,tti,I(prb,tti)) = User_ftd(tti,prb,10-Num_user+I(prb,tti));
    end
end

for N = 1:Num_user
 average_t(N) = sum(sum(User_throughput6(:,:,N)))/5000;
 resource(N)= sum(sum(User_throughput6(:,:,N)~=0));
end

Cell_t(6) = sum(average_t);
T_m(6) = (sum(average_t))^2/(Num_user*sum(average_t.^2));
R_m(6) = (sum(resource))^2/(Num_user*sum(resource.^2));


A = [Cell_t;T_m;R_m]