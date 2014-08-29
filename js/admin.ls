angular.module \main
  ..factory \color, -> do
    list: <[red green cyan purple magenta black]>
    hash: red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0
    total: (v) -> v.total = @list.map(-> parseInt v[it]).reduce(((a,b) -> a + b), 0)
  ..filter \orderState, -> (input) -> <[建立中 待付款 已付款 已出貨]>[input]

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
    .success (d) -> $scope.order = d
    $scope.show = (order) -> 
      $scope.corder = order
      setTimeout ( -> $ \#detail .modal show: true), 100
    $scope.ship = (order) ->
      $scope.state.loading!
      console.log order
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
        .success (d) -> $scope.state.done!
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
        col = d.filter(-> it.state == v.1)
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
