% -----------------------------------------------------------------------------
% Copyright (c) Alexandre Turenne - All Rights Reserved
% Unauthorized distribution of this file, via any medium is strictly prohibited
% Usage and modification for RITC is permitted
% Written by Alexandre Turenne <alexandre.turenne@gmail.com>, February 2019
% -----------------------------------------------------------------------------

%% Closing with limits 
function r = closelimits_2019(rit)
if rit.timeRemaining < 299 && rit.timeRemaining > 2
    
    % Depth of the limits order in the book 
    % General Rule : the more the other people hit the market,the more 
    %agVolDecision can be high (also take into account the avg volume per sec.)
    agVolDecision = 5000; %(INPUT) --> between 3000 and 10000
    
    %If current limits are too deep in the book we cancel all orders and
    %put new limits at agVolDecision as the depth in the book.
    agVolMonitor = 15000; %(INPUT) --> between 13000 and 20000
    position = rit.ritc_position;

    if position ~= 0
        BuyorSell = 'NAN';

        OrderInfos = getOrderInfo(rit)
        NumberofOrders = size(OrderInfos);
        currentbid = nan(1,10);
        currentvolbid = nan(1,10);
        currentask = nan(1,10);
        currentvolask = nan(1,10);
        
        for i=1:10
            currentbid(1,i) = eval(['rit.ritc_agbid_', num2str(i)]);
            currentvolbid(1,i) = eval(['rit.ritc_agbsz_', num2str(i)]);
            currentask(1,i) = eval(['rit.ritc_agask_', num2str(i)]);
            currentvolask(1,i) = eval(['rit.ritc_agasz_', num2str(i)]);
        end
       %if 1 order get price
        if  NumberofOrders(1) == 1 
            if strcmp(OrderInfos.Ticker, 'RITC')
                OrderLimitPrice = OrderInfos.Price;
                BuyorSell = OrderInfos.Type;         
            end

       % if more than 1 orders get price
        elseif NumberofOrders(1) > 1
            for j = 1:NumberofOrders(1)
                if strcmp(OrderInfos.Ticker{j}, 'RITC')
                    OrderLimitPrice = OrderInfos.Price(j);
                    BuyorSell = OrderInfos.Type{j}; 
                end
            end
        end
       
       %Close old limits if we accept tenders and become exposed to the
       %other side (net long becomes net short after accepting tender)
        if NumberofOrders(1) >= 1
            if position < 0 && strcmp(BuyorSell,'SELL')
                cancelOrderExpr(rit,'ticker = ''RITC''') 
            elseif position > 0 && strcmp(BuyorSell,'BUY')
                cancelOrderExpr(rit,'ticker = ''RITC''') 
            end
        end
        %no orders in the book
        if NumberofOrders(1) == 0 || strcmp(BuyorSell,'NAN')
            if position > 1 
                s = 0;
                i=0;
                while s < agVolDecision
                    i=i+1;
                    s = s + currentvolask(1,i);
                end
                askfororder = currentask(1,i)-0.01;

                if position >= 10000
                    r(1) = limitOrder(rit, 'RITC', -5000, askfororder);
                    r(2) = limitOrder(rit, 'RITC', -5000, askfororder);
                else 
                    r(1) = limitOrder(rit, 'RITC', -position, askfororder);
                end

            elseif position < -1 
                s = 0;
                i=0;
                while s < agVolDecision
                    i=i+1;
                    s = s + currentvolbid(1,i);
                end
                bidfororder = currentbid(1,i)+0.01;

                if position <= -10000
                    r(1) = limitOrder(rit, 'RITC', 5000, bidfororder);
                    r(2) = limitOrder(rit, 'RITC', 5000, bidfororder);
                else 
                    r(1) = limitOrder(rit, 'RITC', -position, bidfororder);
                end
            end

        %if orders already in the book
        elseif NumberofOrders(1) ~= 0 && ~strcmp(BuyorSell,'NAN')

            if position > 1 
                s = 0;
                i=0;
                while s < agVolMonitor
                    i=i+1;
                    s = s + currentvolask(1,i);
                end
                maxask = currentask(1,i);
                if OrderLimitPrice > maxask
                    cancelOrderExpr(rit,'ticker = ''RITC''') 
                end

            elseif position < -1 
                s = 0;
                i=0;
                while s < agVolMonitor
                    i=i+1;
                    s = s + currentvolbid(1,i);
                end
                maxbid = currentbid(1,i);
                if OrderLimitPrice < maxbid
                    cancelOrderExpr(rit,'ticker = ''RITC''') 
                end
            end
        end
    end
end
end
            

