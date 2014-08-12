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
      ReturnURL: "http://staging.fernwing.com/api/paidnotify"
      OrderResultURL: "http://staging.fernwing.com/api/order"
      ChoosePayment: "ALL"
      CheckMacValue: ""
    # TODO this should not be here.
    hash: do
      key: "5294y06JbISpM5x9"
      iv: "v77hoKGq4kWxNNIS"
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


/*main = ($scope) ->
  $scope.data = do
    MerchantID: "2000132"
    MerchantTradeNo: "zbryikt123458"
    MerchantTradeDate: "2014/08/12 10:00:00"
    PaymentType: "aio"
    TotalAmount: "100"
    TradeDesc: "測試"
    ItemName: "testitem1"
    ReturnURL: "http://ec2-54-191-122-159.us-west-2.compute.amazonaws.com:9999/paidnotify"
    OrderResultURL: "http://ec2-54-191-122-159.us-west-2.compute.amazonaws.com:9999/order"
    ChoosePayment: "ALL"
    CheckMacValue: ""
  $scope.hash = do
    key: "5294y06JbISpM5x9"
    iv: "v77hoKGq4kWxNNIS"

  $scope.checkcode = ->
    list = []
    for k,v of $scope.data =>
      if k == 'CheckMacValue' => continue
      list.push "#k=#v"
    console.log list
    list.sort (a,b) -> 
      a = a.toUpperCase! 
      b = b.toUpperCase!
      if a > b => return 1
      if a < b => return -1
      return 0
    chk = list.join("&")
    chk = encodeURIComponent("HashKey=#{$scope.hash.key}&#chk&HashIV=#{$scope.hash.iv}")
    chk = chk.replace /%20/g, "+"
    chk = md5(chk.toLowerCase!).toUpperCase!
    $scope.data.CheckMacValue = chk
*/
