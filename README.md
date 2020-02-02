# RITC_Citadel_Algo_Trading_2019
Algorithm used in 2019 (4th place)

This is the algorithm I wrote for the Citadel Securities Algo Trading Case in the 2019 edition of the Rotman International Trading Competition.

This version keeps the bare minium of what was used during competition. Different things were tried (e.g., market making, arbitrage) but the final version only used tenders and postion management.

Features: 
It modelizes the order book to implement optimal limit orders management. Depth of the limits in the book can be change (Inputs) in the closelimits_2019.m file depending on volume hitting the market. The more traders hitting the market, the more limits should be put deep in the book.

Future improvement:
- Automatically reduce/increase the depth of the limits depending on how much time since they have been sent (if not filled).
- Take opportunity of the arbitrage between the ETF and the components.









