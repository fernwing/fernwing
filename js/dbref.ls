angular.module \main
  ..factory \dbref, ($firebase) -> do
    ref: {}
    anf: {}
    data: {}
    update: (data) ->
      ret = []
      for item of data => if item.indexOf("$")!=0 =>
        ret.push [item, data[item]]
      ret
    auth: (app, cb) -> new FirebaseSimpleLogin new Firebase("https://#app.firebaseio.com/"), cb
    get: (app,path) ->
      name = "#app//#path"
      if @anf[name] => return @anf[name]
      @ref[name] = new Firebase "https://#app.firebaseio.com/#path"
      @anf[name] = $firebase @ref[name]
      @anf[name].$on \loaded, (v) ~> @data[name] = @update v
      @anf[name].$on \change, (v) ~> if v => @data[name] = [[v, @anf[id][v]]] ++ (@data[name] or [])
      @anf[name]

    /*$scope.db = do
      order: db.get \fern, "user/$id/order"
      pending: db.get \fern, "admin/order/pending"
      count: db.get \fern, "count/$order"

    payload = $scope{name, email, addr, phone, count}
    $scope.db.order.$add payload
    $scope.db.count.$add {count: $scope.count, email: $scope.email}
    $scope.db.pending.$add {id: "???", email: $scope.email}*/
