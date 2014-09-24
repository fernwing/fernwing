angular.module \main
  ..factory \allpay, -> do
    empty: do
      MerchantID: "2000132"
      MerchantTradeNo: "zbryikt123458"
      MerchantTradeDate: "2014/08/12 10:00:00"
      PaymentType: "aio"
      TotalAmount: "100"
      TradeDesc: "測試"
      ItemName: "testitem1"
      ReturnURL: "https://www.fernwing.com/api/paidnotify"
      OrderResultURL: "https://www.fernwing.com/api/order"
      PaymentInfoURL: ""
      ChoosePayment: "ALL"
      CheckMacValue: ""
    now: ->
      n = new Date!
      y = n.getYear! + 1900
      M = n.getMonth! + 1
      d = n.getDate!
      h = n.getHours!
      m = n.getMinutes!
      s = n.getSeconds!
      M = if M < 10 => "0#M" else M
      d = if d < 10 => "0#d" else d
      h = if h < 10 => "0#h" else h
      m = if m < 10 => "0#m" else m
      s = if s < 10 => "0#s" else s
      return "#y/#M/#d #h:#m:#s"
      
    # TODO this should not be here.
    hash: do
      key: ""
      iv: ""
    _encode: (data) -> data
    encode: (data) ->
      list = []
      for k,v of data =>
        if k == 'CheckMacValue' => continue
        list.push "#k=#v"
      list.sort (a,b) -> 
        a = a.toUpperCase! 
        b = b.toUpperCase!
        if a > b => return 1
        if a < b => return -1
        return 0
      chk = list.join("&")
      if @hash.key => 
        chk = encodeURIComponent("HashKey=#{@hash.key}&#chk&HashIV=#{@hash.iv}")
        chk = chk.replace /%20/g, "+"
        chk = md5(chk.toLowerCase!).toUpperCase!
      else => chk = @_encode chk
      data.CheckMacValue = chk
      return chk

