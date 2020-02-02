# RITC_Citadel_Algo_Trading_2019
Algorithm used in 2019 (4th place)

This is the algorithm I wrote for the Citadel Securities Algo Trading Case in the 2019 edition of the Rotman International Trading Competition.

The code is far from clean and a lot of things in comments are not used but in the end, it is a really simple algo.

It modelizes the order book to implement optimal limit orders management. Depth of the limits in the book can be change depending on volum hitting the market. The more traders hitting the market, the more limits should be put deep in the book.

Future improvement:
- Automatically reduce/increase the depth of the limits depending on how much time since they have been sent (if not filled).
- Take opportunity of the arbitrage between the ETF and the components.









