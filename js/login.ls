angular.module \main
  ..controller \login, <[$scope $http $timeout $location stateIndicator context]> ++ ($scope, $http, $timeout, $location, stateIndicator, context) ->
    $scope.user = context.user
    $scope.state = stateIndicator.init!
    $scope.info = do
      email: ""
      passwd: ""
    $scope.login = (url) ->
      $scope.state.loading!
      $timeout ->
        $http do
          url: \/d/login
          method: \POST
          data: JSON.stringify($scope.info)
        .success (d) ->
          $scope.state.done!
          $scope.user = d
          $scope.fail = null
          if url => window.location.href = url
        .error (e) ->
          $scope.state.fail!
          $scope.fail = {detail: "login failed"}
      , 500
