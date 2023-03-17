//+------------------------------------------------------------------+
//|                                              GridHedgingExample.mq4 |
//|                        Copyright 2023, RPNATION               |
//|                                              |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, Your Name"
#property link      "your@email.com"
#property strict

extern double TakeProfit = 100.0;
extern double StopLoss = 100.0;
extern double LotSize = 0.01;
extern int MagicNumber = 12345;
extern int GridSpacing = 50;

int OnInit()
{
  return(INIT_SUCCEEDED);
}

void OnTick()
{
  double currentAsk = MarketInfo(Symbol(), MODE_ASK);
  double currentBid = MarketInfo(Symbol(), MODE_BID);
  int totalOrders = OrdersTotal();

  bool longPositionExists = false;
  bool shortPositionExists = false;

  for (int i = 0; i < totalOrders; i++)
  {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    {
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
      {
        if (OrderType() == OP_BUY)
        {
          longPositionExists = true;
        }
        else if (OrderType() == OP_SELL)
        {
          shortPositionExists = true;
        }
      }
    }
  }

  if (!longPositionExists)
  {
    OrderSend(Symbol(), OP_BUY, LotSize, currentAsk, 3, currentAsk - StopLoss * Point, currentAsk + TakeProfit * Point, "Long Grid", MagicNumber, 0, Green);
  }

  if (!shortPositionExists)
  {
    OrderSend(Symbol(), OP_SELL, LotSize, currentBid, 3, currentBid + StopLoss * Point, currentBid - TakeProfit * Point, "Short Grid", MagicNumber, 0, Red);
  }
}
//+------------------------------------------------------------------+
