//+------------------------------------------------------------------+
//|                                              AlligatorEA.mq5     |
//|                              Copyright 2023, MetaQuotes Software |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, MetaQuotes Software"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double StopLossMultiplier = 3.0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int i;
   double alligatorJaw[];
   double alligatorTeeth[];
   double alligatorLips[];
   double stopLoss;
   double currentPrice;

   ArraySetAsSeries(alligatorJaw, true);
   ArraySetAsSeries(alligatorTeeth, true);
   ArraySetAsSeries(alligatorLips, true);

   iAlligator(0, 0, 13, 8, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, alligatorJaw);
   iAlligator(0, 0, 13, 8, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORTEETH, alligatorTeeth);
   iAlligator(0, 0, 13, 8, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORLIPS, alligatorLips);

   if (alligatorJaw[0] > alligatorTeeth[0] && alligatorTeeth[0] > alligatorLips[0])
     {
      currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      stopLoss = currentPrice + StopLossMultiplier * (alligatorJaw[0] - alligatorLips[0]);
      OrderSend(_Symbol, ORDER_TYPE_BUY, 0.01, currentPrice, 0, stopLoss, 0, NULL, 0);
     }
   else if (alligatorJaw[0] < alligatorTeeth[0] && alligatorTeeth[0] < alligatorLips[0])
     {
      currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      stopLoss = currentPrice - StopLossMultiplier * (alligatorLips[0] - alligatorJaw[0]);
      OrderSend(_Symbol, ORDER_TYPE_SELL, 0.01, currentPrice, 0, stopLoss, 0, NULL, 0);
     }
  }
//+------------------------------------------------------------------+
