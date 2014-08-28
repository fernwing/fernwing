angular.module \main
  ..controller \login, <[$scope $http stateIndicator context]> ++ ($scope, $http, stateIndicator, context) ->
    $scope.user = context.user
    $scope.state = stateIndicator.init!
    $scope.info = do
      username: ""
      password: ""
    $scope.login = ->
      $scope.state.loading!
      $http do
        url: \/d/login
        method: \POST
        data: JSON.stringify($scope.info)
      .success (d) ->
        $scope.state.done!
        $scope.user = d
        $scope.fail = null
      .error (e) ->
        $scope.state.done!
        $scope.fail = {detail: "login failed"}

