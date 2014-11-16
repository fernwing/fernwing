angular.module \main
  ..factory \color, -> do
    list: <[red green cyan purple magenta black]>
    hash: red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0
    total: (v) -> v.total = @list.map(-> parseInt v[it]).reduce(((a,b) -> a + b), 0)
  ..filter \orderState, -> (input) -> <[建立中 待付款 已付款 已出貨 貨到付]>[input]

  ..controller \notify, <[$scope $http]> ++ ($scope, $http) ->
    $scope.notify = []
    $http do
      url: \/d/notify
      method: \GET
    .success (d) -> $scope.notify = d
    .error (e) -> console.error e
  ..controller \status, <[$scope $http stateIndicator]> ++ ($scope, $http, stateIndicator) ->
    $scope.state = stateIndicator.init!
    $scope.status = {status: -1}
    $scope.setStatus = (v) ->
      $scope.state.loading!
      $scope.status.status = v
      $http do
        url: \/d/status
        method: \POST
        data: JSON.stringify($scope.status)
      .success (d) -> $scope.state.done!
      .error (d) -> $scope.state.fail!
    $http do
      url: \/d/status
      method: \GET
    .success (d) -> $scope.status = d
    .error (d) ->
  ..controller \order, <[$scope $http stateIndicator $timeout]> ++ ($scope, $http, stateIndicator, $timeout) ->
    $scope.state = stateIndicator.init!
    $http.get \/d/order
    .success (d) -> 
      $scope.order = d
      #$scope.order.sort ((a,b) -> if a > b => -1 else if a==b => 0 else 1)
      $scope.order.sort (a,b) ->
        [c,d] = [a,b]map(-> new Date(it.{}init.MerchantTradeDate or 0))
        return if c > d => -1 else 1
      $scope.order.map ->
        if !it.info => return
        if /google/.exec it.info.referrer => it.info.ref = "G"
        else if /facebook/.exec it.info.referrer => it.info.ref = "F"
        else => it.info.ref = "-"
    $scope.show = (order) -> 
      $scope.corder = order
      setTimeout ( -> $ \#order-detail-modal .modal show: true), 100
    $scope.hide = (order) ->
      $scope.state.loading!
      payload = {MerchantTradeNo: order.init.MerchantTradeNo, hide: !!!order.hide}
      $http do
        url: \/d/debug/genmac
        method: \POST
        data: JSON.stringify(payload)
      .success (d) ->
        payload.CheckMacValue = d
        console.log payload
        $http do
          url: if order.hide => \/d/order/show else \/d/order/hide
          method: \POST
          data: JSON.stringify(payload)
        .success (d) ->
          order.hide = !!!order.hide
          $scope.state.done!
        .error (e) -> $scope.state.fail!
      .error (e) -> $scope.state.fail!

    $scope.ship = (order) ->
      $scope.state.loading!
      payload = {MerchantTradeNo: order.init.MerchantTradeNo}
      $http do
        url: \/d/debug/genmac
        method: \POST
        data: JSON.stringify(payload)
      .success (d) ->
        payload.CheckMacValue = d
        console.log payload
        $http do
          url: \/d/order/ship
          method: \POST
          data: JSON.stringify(payload)
        .success (d) -> 
          order.state = 3
          $scope.state.done!
        .error (e) -> $scope.state.fail!
      .error (e) -> $scope.state.fail!


  ..controller \sales, <[$scope $http stateIndicator $timeout color]> ++ ($scope, $http, stateIndicator, $timeout, color) ->
    $http.get \/d/stock
    .success (d) ->
      $scope.avail = d.avail
      color.total $scope.avail
    $http.get \/d/order
    .success (d) -> 
      [[\init 0] [\confirm 1] [\paid 2] [\shipped 3]]map (v) ->
        col = d.filter(-> it.state == v.1 and !it.hide)
        $scope[v.0] = count = {} <<< color.hash
        for o in col =>
          for k in color.list => count[k] += o.info.count[k]
        color.total count

  ..controller \stock, <[$scope $http stateIndicator $timeout color]> ++ ($scope, $http, stateIndicator, $timeout, color) ->
    $scope.stock = do
      count: {} <<< color.hash
      price: {} <<< color.hash

    $scope.state = stateIndicator.init!
      ..loading!
    
    $http do
      url: "/d/stock"
      method: "GET"
    .success (d) ->
      $scope.state.reset!
      $scope.stock = d
      color.total $scope.stock.count
      console.log d

    $scope.update = ->
      $scope.state.loading!
      color.total $scope.stock.count
      $http do
        url: "/d/stock"
        method: "POST"
        headers: "Content-Type": "application/json"
        data: JSON.stringify($scope.stock)
      .success (d) -> $timeout (-> $scope.state.done!), 500
