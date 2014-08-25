angular.module \main
  ..factory \color, -> do
    list: <[red green cyan purple magenta black]>
    hash: red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0
    total: (v) -> v.total = @list.map(-> parseInt v[it]).reduce(((a,b) -> a + b), 0)
  ..filter \orderState, -> (input) -> <[建立中 待付款 已付款 已出貨]>[input]

  ..controller \order, <[$scope $http stateIndicator $timeout]> ++ ($scope, $http, stateIndicator, $timeout) ->
    $http.get \/api/order
    .success (d) -> $scope.order = d
  ..controller \sales, <[$scope $http stateIndicator $timeout color]> ++ ($scope, $http, stateIndicator, $timeout, color) ->
    $http.get \/api/order
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
      url: "/api/stock"
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
        url: "/api/stock"
        method: "POST"
        headers: "Content-Type": "application/json"
        data: JSON.stringify($scope.stock)
      .success (d) -> $timeout (-> $scope.state.done!), 500
