Select InputTable.StockCode,
       InputTable.Description,
       Case When InputTable.QuantityUsed < 0 Then '0' Else InputTable.QuantityUsed
       End As QuantityUsed,
       InputTable.OurRef,
       InputTable.Supplier,
       Case When InputTable.EnterYear = 114 Then '2014'
            When InputTable.EnterYear = 115 Then '2015'
            When InputTable.EnterYear = 116 Then '2016'
            When InputTable.EnterYear = 117 Then '2017' End As Year,
       Case When InputTable.EnterPeriod = 9 Then 'January'
            When InputTable.EnterPeriod = 10 Then 'February'
            When InputTable.EnterPeriod = 11 Then 'March'
            When InputTable.EnterPeriod = 12 Then 'April'
            When InputTable.EnterPeriod = 1 Then 'May'
            When InputTable.EnterPeriod = 2 Then 'June'
            When InputTable.EnterPeriod = 3 Then 'July'
            When InputTable.EnterPeriod = 4 Then 'August'
            When InputTable.EnterPeriod = 5 Then 'September'
            When InputTable.EnterPeriod = 6 Then 'October'
            When InputTable.EnterPeriod = 7 Then 'November'
            When InputTable.EnterPeriod = 8 Then 'December' End As Month,
       InputTable.EnterYear,
       InputTable.EnterPeriod
From (Select TransactionLines.tlYear As EnterYear,
             TransactionLines.tlPeriod As EnterPeriod,
             T2.StockCode,
             Stock.stDesc1 As Description,
             (Case When TransactionLines.tlDocType In (0, 6) Then '1' Else '-1'
             End) * TransactionLines.tlQty As QuantityUsed,
             TransactionLines.tlOurRef As OurRef,
             Stock.IdxSupplier As Supplier
     From (Select T1.StockCode
          From (Select Stock.IdxStockCode As StockCode,
                       TransactionLines.tlYear As Year,
                       TransactionLines.tlPeriod As Period,
                       TransactionLines.tlAcCode As AccountCode,
                       TransactionLines.tlQty As Quantity,
                       TransactionLines.tlOurRef As OurRef,
                       TransactionLines.tlDocType As DocType
               From Stock
                    Inner Join TransactionLines
                                                On Stock.IdxStockCode = TransactionLines.IdxStockCode
               Where Stock.IdxStockCode <> 'CARRIAGE-SUP' And Stock.IdxStockCode <>
                     'BUMPER ROLLS' And Stock.IdxStockCode <> 'BUMPER ROLLS2') As T1
          Group By T1.StockCode) As T2
          Inner Join TransactionLines On T2.StockCode = TransactionLines.tlIdxStockCode
          Inner Join Stock On T2.StockCode = Stock.IdxStockCode
     Where T2.StockCode Not In ('TNTND', 'CARRIAGE-SAL', 'POST1') And
           TransactionLines.tlDocType In (0, 2, 5, 6, 30, 35)) As InputTable
Where InputTable.Supplier In ('ACC01', 'PAC04', 'TUR01', 'LAS02', 'HYP02',
      'HOS02', 'CAL04', 'RED01', 'HEN01', 'WEL002', 'OWE01', 'CHA04', 'HOS03',
      'EAR01', 'ZAG02', 'ROG01', 'WUR01', 'FAS01', 'SPH01', 'EXA01', 'EAS01') And
      InputTable.EnterYear In (116, 117) And InputTable.EnterPeriod In (1, 2, 3, 4, 5,
      6, 7, 8, 9, 10, 11, 12)