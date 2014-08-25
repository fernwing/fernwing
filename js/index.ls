angular.module \main, if online => <[firebase ngAnimate ld.common]> else <[ngAnimate ld.common]>
if !online => angular.module \main .factory \$firebase, -> ->
if !online =>
  Firebase = ->
  FirebaseSimpleLogin = ->
  ga = ->

fast-debug = true

angular.module \main
  ..config ->
    $('a[href*=#]:not([href=#])').click ->
      if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//,'') and location.hostname == @hostname =>
        ga \send, \event, \click, "\##{@hash.slice(1)}"
        target = $(@hash)
        target = if target.length => target else $("[name=#{@hash.slice 1}]")
        if target.length => $("html,body").animate(do
          scrollTop: target.offset!top
        , 1000)
        false

  ..directive \delayBk, -> do
    restrict: \A
    link: (scope, e, attrs, ctrl) ->
      url = attrs["delayBk"]
      $ \<img/> .attr \src url .load ->
        $(@)remove!
        e.css "background-image": "url(#url)"
        setTimeout (-> e.toggle-class \visible), 100

  ..controller \notify, ($scope, $firebase, $timeout) ->
    $scope.db-ref = new Firebase \https://fern.firebaseIO.com/notify/
    $scope.notify = $firebase $scope.db-ref
    $scope.need-fix = false
    $scope.state = 0
    $scope.post-submitted = -> $scope.state = 2
    $scope.fix = (it) ->
      if $scope.need-fix and !$scope[it] => "has-error" else ""
    $scope.submit = ->
      if not ($scope.email) => return $scope.need-fix = true
      $scope.need-fix = false
      $scope.state = 1
      id = $scope.notify.$add $scope.email
      #$scope.notify.$save!
      ga \send, \event, \notify, \submit
      $timeout ( -> $scope.post-submitted! ), 2000


  ..controller \main, ($scope, $http, $firebase, $timeout, dbref, allpay) ->
    $scope.db = order: null, count: null

    /*$scope.auth = dbref.auth \fern, (e, u) -> $scope.$apply ->
      if e => console.log "get user fail: ", e
      $scope.user = u
      if $scope.user => $scope.email = $scope.user.email
      if $scope.state == 1 => 
        if !$scope.user => $scope.password = ""
        $scope.submit!
    */
    $scope.price = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
    $scope.count = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
    $scope.avail = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
    $scope.choiceName = ->
      list = [<[red 紅色]> <[green 綠色]> <[cyan 藍色]> <[purple 紫色]> <[magenta 紫紅色]> <[black 黑色]>]
      list = list.filter -> $scope.count[it.0]
      list = list.map -> "#{it.1} #{$scope.count[it.0]} 個"
      list.join \#
        
    $scope.priceTotal = ->
      <[red green cyan purple magenta black]>map(-> $scope.price[it] * $scope.count[it])reduce ((a,b) -> a + b), 0
    $scope.choicelist = {}
    $scope.want = true
    $scope.need-fix = false
    $scope.state = 0
    $scope.submitted = false
    $scope.fix = (it) ->
      if $scope.need-fix and !$scope[it] => "has-error" else ""
    
    $scope.dbref = dbref
    $scope.loadcount = ->
      $http do
        url: \/api/stock
        method: \GET
      .success (d) ->
        $scope.price = d.price
        $scope.avail = d.avail
        for k,v of $scope.avail =>
          $scope.avail[k] = $scope.avail[k]>?0
          $scope.choicelist[k] = [i for i from 0 to (v<?20>?0)]

    $scope.loadcount!
    $scope.logout = -> if $scope.user =>
      $scope.auth.logout!
      $scope <<< {email: "", password: "", user: null}
    $scope.clearForm = ->
      $scope{name,addr,email,password,phone,payment} = name: "", addr: "", email: "", password: "", phone: "", payment: "1"
      if $scope.user => $scope.email = $scope.user.email
      $scope.state = 0

    $scope.post-submitted = ->
      $scope.state = 2
    $scope.submit = ->
      if not ($scope.name and $scope.addr and $scope.email and ($scope.user or $scope.password) and $scope.phone and $scope.priceTotal()) => 
        return $scope <<< {need-fix: true, state: 0}
      $scope.need-fix = false
      $scope.state = 1

      payload = $scope{name, email, addr, phone, count}
      #ga \send, \event, \form, \submit
      $scope.allpay payload
      $timeout ( -> $scope.post-submitted! ), 2000

    $scope.allpay = (payload) ->
      $http do
        url: \/api/order/init
        method: \POST
        headers: "Content-Type": "application/json"
        data: payload
      .success (d) ->
        console.log "payload information (to allpay): #d"
        $scope.allPayData = d
        $timeout (-> $(\#allpayform).submit!), 100
      #TODO error handling 
      .error (e) -> console.error e

    if typeof(fast-debug)!="undefined" and fast-debug =>
      $scope <<< {name: "薄瓜瓜", addr: "在大陸的薄瓜瓜的家", phone: "0110101011"}
    $scope.payment = 1

    zoomed = false
    shown = false
    $scope.st = {}
    $scope.anchor = <[wing-feature order order-info about gallery]>
    $scope.anchor.map -> $scope.st["\##it"] = ($("\##it").offset! or {})top
    $scope.reach = {}
    $(window)scroll (e) ->
      h = $(window)height!
      t = $(window)scroll-top!
      if t > $scope.st['#wing-feature'] - (h/2) and !zoomed =>
        zoomed := true
        $('#feature img').add-class \zoom
        $('#feature .feature').add-class \zoom
      if t > $scope.st['#order-info'] - (h/2) and !shown =>
        shown := true
        $('#order').add-class \shown
        ga \send, \event, \form, \reach
      for item in $scope.anchor =>
        if t > $scope.st[item] and !$scope.reach[item] =>
          ga \send, \event, \scroll, item
    count = 100
    x = new Array count
    y = new Array count
    v = new Array count
    r = new Array count
    s = new Array count
    m = new Array count
    idx = new Array count
    jdx = new Array count
    n = for i from 0 til 100 => $("<div class='feather'><div class='bk'></div><div class='img'></div></div>")
    w = $(window)width!
    h = $(window)height!
    for i from 0 til 30 =>
      x[i] = Math.random! * -500
      v[i] = Math.random! * 14
      y[i] = Math.random! * 3 * h/4 + h/4
      s[i] = Math.random! * 1
      r[i] = parseInt(Math.random! * 360)
      idx[i] = Math.random! * 6.28
      jdx[i] = Math.random! * 0.5
      $(\#feathers)append n[i]
      m[i] = n[i].find \div

    if false => 
      <- set-interval _, 50
      for i from 0 til 50 =>
        x[i] += ( v[i] / 2 +  v[i] * Math.cos idx[i] )
        cy = y[i] + (h/6) * Math.sin (jdx[i])
        r[i] += parseInt(Math.random! * 3)
        idx[i] += 0.011
        jdx[i] += 0.007
        n[i].css top: cy, left: x[i],  opacity: s[i] #, "box-shadow": "0px 30px 50px rgba(0,0,0,0.5)"
        if m[i] => m[i].css "-webkit-transform": "rotate(#{r[i]}deg) scale(#{s[i]})"
        if x[i]>=w => x[i] = Math.random! * -100
    
