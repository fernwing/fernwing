angular.module \main, if online => <[firebase ngAnimate]> else <[ngAnimate]>
if !online => angular.module.factory \$firebase, -> {}
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


  ..controller \main, ($scope, $firebase, $timeout) ->
    $scope.db-ref = new Firebase \https://fern.firebaseIO.com/order
    $scope.orders = $firebase $scope.db-ref
    $scope.auth = new FirebaseSimpleLogin $scope.db-ref, (e,u) -> $scope.user = u
    $scope.want = true
    $scope.need-fix = false
    $scope.state = 0
    $scope.submitted = false
    $scope.fix = (it) ->
      if $scope.need-fix and !$scope[it] => "has-error" else ""
    
    $scope.clearForm = ->
      $scope{name,addr,email,phone} = name: "", addr: "", email: "", phone: ""
      $scope.state = 0

    $scope.post-submitted = ->
      $scope.state = 2
    $scope.submit = ->
      if not ($scope.name and $scope.addr and $scope.email and $scope.phone) => return $scope.need-fix = true
      $scope.need-fix = false
      $scope.state = 1
      id = $scope.orders.[]pending.push [$scope.name, $scope.addr, $scope.email, $scope.phone]
      $scope.orders.$save!
      ga \send, \event, \form, \submit
      $timeout ( -> $scope.post-submitted! ), 2000

    zoomed = false
    shown = false
    $scope.st = {}
    $scope.anchor = <[wing-feature order about gallery]>
    $scope.anchor.map -> $scope.st["\##it"] = $("\##it").offset!top
    $scope.reach = {}
    $(window)scroll (e) ->
      h = $(window)height!
      t = $(window)scroll-top!
      if t > $scope.st['#wing-feature'] - (h/2) and !zoomed =>
        zoomed := true
        $('#feature img').add-class \zoom
        $('#feature .feature').add-class \zoom
      if t > $scope.st['#order'] and !shown =>
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
    console.log w
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
    /*set-interval ->
      for i from 0 til 50 =>
        x[i] += ( v[i] / 2 +  v[i] * Math.cos idx[i] )
        cy = y[i] + (h/6) * Math.sin (jdx[i])
        r[i] += parseInt(Math.random! * 3)
        idx[i] += 0.011
        jdx[i] += 0.007
        n[i].css top: cy, left: x[i],  opacity: s[i] #, "box-shadow": "0px 30px 50px rgba(0,0,0,0.5)"
        if m[i] => m[i].css "-webkit-transform": "rotate(#{r[i]}deg) scale(#{s[i]})"
        if x[i]>=w => x[i] = Math.random! * -100
    , 50*/
    
    /*
    ani1 = {idx: 0, jdx: 0, kdx: 0, x: 0, y: 0}
    ani2 = {idx: 0, jdx: 0, kdx: 0, x: 0, y: 0}
    set-interval ->
      ani1.idx = ( ani1.idx + 0.011 )
      ani1.jdx = ( ani1.jdx + 0.005 )
      ani1.kdx = 1
      ani1.x = 5 + Math.sin(ani1.kdx) * 25 * Math.cos ani1.idx
      ani1.y = 5 + Math.sin(ani1.kdx) * 20 * Math.sin ani1.jdx
      n = $(\.logo-word)
      n.css top: ani1.y, left: ani1.x
      ani2.idx = ( ani2.idx + 0.007 )
      ani2.jdx = ( ani2.jdx + 0.008 )
      ani2.kdx = 1
      ani2.x = 5 - Math.sin(ani2.kdx) * 23 * Math.cos ani2.idx
      ani2.y = 5 + Math.sin(ani2.kdx) * 17 * Math.sin ani2.jdx
      n = $(\.logo-wing)
      n.css top: ani2.y, left: ani2.x
    ,10
    */


