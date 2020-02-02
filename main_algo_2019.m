% ------------------------------------------------------------------------------
% Copyright (c) Alexandre Turenne - All Rights Reserved
% Unauthorized distribution of this file, via any medium is strictly prohibited
% Usage and modification for RITC is permitted
% Written by Alexandre Turenne <alexandre.turenne@gmail.com>, February 2019
% ------------------------------------------------------------------------------

%% MAIN FILE
delete(timerfind('Name','RotmanTrader'))
delete rit
clear all
close all
clc

%% Initialize connection
rit= rotmanTrader;

%%Variables
global quant  Tickers Ask_Bid premierappel 
quant = 5000;
premierappel = 1;

%% Data subscription
Tickers={'RITC','BULL','BEAR', 'USD'};
Operation = {'MKTSELL','MKTBUY'};
Ask_Bid = {'BID', 'ASK'};

%VWAP for RITC tender
tenderquant = 10000;
for i=1:19
    for j=1:2
        subscribe(rit, ['RITC|', char(Operation(1,j)),'|',num2str(tenderquant)]);
    end
    tenderquant = tenderquant + 5000;
end
%Position in each stock
for i=1:3
    subscribe(rit,[char(Tickers(1,i)), '|Position']); 
end

%ASK et BID for each stock
for i=1:3
    for j=1:2
        subscribe(rit,[char(Tickers(1,i)), '|', Ask_Bid{j}]);
    end
end

%Last price
for i=1:4
    subscribe(rit,[Tickers{i}, '|LAST']); 
end
%Tender
subscribe(rit,'TENDERINFO|1')
%1st to 10th bid/ask vol and price (For RITC)
for j = 1:3
    for i = 1:10
        subscribe(rit,[Tickers{j},'|AGBID|',num2str(i)])
    end
    for i = 1:10
        subscribe(rit,[Tickers{j},'|AGASK|',num2str(i)])
    end
    for i = 1:10
        subscribe(rit,[Tickers{j},'|AGBSZ|',num2str(i)])
    end
    for i = 1:10
        subscribe(rit,[Tickers{j},'|AGASZ|',num2str(i)])
    end
end
rit.updateFreq = 1;

            
%tenders
Tend=@(rit) tenderoffers_2019(rit);
addUpdateFcn(rit,Tend);


%Closewith limits RITC
LMT = @(rit) closelimits_2019(rit);
addUpdateFcn(rit,LMT);
