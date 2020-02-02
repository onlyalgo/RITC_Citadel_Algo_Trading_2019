% ------------------------------------------------------------------------------
% Copyright (c) Alexandre Turenne - All Rights Reserved
% Unauthorized distribution of this file, via any medium is strictly prohibited
% Usage and modification for RITC is permitted
% Written by Alexandre Turenne <alexandre.turenne@gmail.com>, February 2019
% ------------------------------------------------------------------------------

%% Tender 
function z = tenderoffers_2019(rit)

if rit.timeRemaining > 299 || rit.timeRemaining < 2
    return
end

disp('J U I C Y Tenders by onlyalgo')

if  ~isempty(rit.tenderinfo_1) 
%if ~id == 0
   %display the order when there is one
  id = getActiveTenders(rit);
  T = getActiveTenderInfo(rit,id)
  
  B_VWAP = eval(['rit.ritc_mktbuy_',num2str(15000)]);  %(INPUT) -> 10000 or 15000
  S_VWAP = eval(['rit.ritc_mktsell_', num2str(15000)]); %(INPUT) -> 10000 or 15000
   current_position = rit.ritc_position;

    if T.Quantity > 0 && T.Price < S_VWAP
        if current_position < 15000
            while (T.Quantity+current_position) > 100000
                sell(rit,'RITC',5000)
                current_position=current_position - 5000;
            end 
        end
        z=acceptActiveTender(rit,id,1);
    elseif T.Quantity < 0 && T.Price > B_VWAP
        if current_position > -15000
            while (T.Quantity+current_position) < -100000
                buy(rit,'RITC', 5000)
                current_position = current_position +5000;
            end
        end
        z=acceptActiveTender(rit,id,1);
    end
end
end