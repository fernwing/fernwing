angular.module \main, <[ngAnimate ld.common backend]>
fast-debug = false

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

  ..controller \notify, <[$scope $timeout stateIndicator $http]> ++ ($scope, $timeout, stateIndicator, $http) ->
    $scope.need-fix = false
    $scope.state = 0
    $scope.status = stateIndicator.init!
    $scope.post-submitted = -> 
      $scope.status.done!
      $scope.state = 2
    $scope.fix = (it) ->
      if $scope.need-fix and !$scope[it] => "has-error" else ""
    $scope.submit = ->
      if not ($scope.email) => return $scope.need-fix = true
      $scope.need-fix = false
      $scope.state = 1
      $scope.status.loading!
      $http do
        url: \/d/notify
        method: \POST
        data: {email: $scope.email}
      .success -> 
      .error ->
      ga \send, \event, \notify, \submit
      $timeout ( -> $scope.post-submitted! ), 2000


  ..controller \main, ($scope, $http, $timeout, allpay, context) ->
    $scope.db = order: null, count: null
    $scope.user = context.user
    #$scope.$watch 'user', -> if $scope.user => $scope.email = $scope.user.email

    $scope.price = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
    $scope.count = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
    $scope.avail = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
    $scope.choiceName = ->
      list = [<[red 紅色]> <[green 綠色]> <[cyan 藍色]> <[purple 紫色]> <[magenta 紫紅色]> <[black 黑色]>]
      list = list.filter -> $scope.count[it.0]
      list = list.map -> "#{it.1} #{$scope.count[it.0]} 個"
      list.join \#
    $scope.status = {status: -1}
    $http do
      url: \/d/status
      method: \GET
    .success (d) -> $scope.status = d
    $scope.priceTotal = ->
      ret = <[red green cyan purple magenta black]>map(-> $scope.price[it] * $scope.count[it])reduce ((a,b) -> a + b), 0
      if ret > 0 => ret += 50
    $scope.choicelist = {}
    $scope.want = true
    $scope.need-fix = false
    $scope.state = 0
    $scope.submitted = false
    $scope.fix = (it) ->
      if $scope.need-fix and !$scope[it] => "has-error" else ""
    
    $scope.loadcount = ->
      $http do
        url: \/d/stock
        method: \GET
      .success (d) ->
        $scope.price = d.price
        $scope.avail = d.avail
        for k,v of $scope.avail =>
          $scope.avail[k] = $scope.avail[k]>?0
          $scope.choicelist[k] = [i for i from 0 to (v<?20>?0)]

    $scope.loadcount!

    $scope.logout = -> if $scope.user =>
      $http do
        url: \/d/logout
        method: \GET
      .success (d) ->
        $scope.user = null
        $scope <<< {email: "", password: "", user: null}
      .error (d) ->
    $scope.clearForm = ->
      $scope{name,addr,email,password,phone,payment} = name: "", addr: "", email: "", password: "", phone: "", payment: "1"
      $scope.count = {red: 0, green: 0, cyan: 0, purple: 0, magenta: 0, black: 0}
      if $scope.user => $scope.email = $scope.user.email
      $scope.state = 0
      target = $(\#order)
      setTimeout ->
        if target.length => $("html,body").animate(do
          scrollTop: target.offset!top
        , 500)
      , 100

    $scope.post-submitted = ->
      $scope.state = 2
      target = $(\#order-complete-anchor)
      setTimeout ->
        if target.length => $("html,body").animate(do
          scrollTop: target.offset!top
        , 500)
      , 100
    $scope.submit = (paytype) ->
      #if not ($scope.name and $scope.addr and $scope.email and ($scope.user or $scope.password) and $scope.phone and $scope.priceTotal()) =>
      if not ($scope.name and $scope.addr and $scope.email and $scope.phone and $scope.priceTotal()) =>
        return $scope <<< {need-fix: true, state: 0}
      $scope.need-fix = false
      $scope.state = 1
      #if !$scope.user =>
      #  $http do
      #    url: \/d/login
      #    method: \POST
      #    data: JSON.stringify({username: $scope.email, password: $scope.password})
      #  .success (d) -> $scope.user = d
      #  .error (d) ->

      payload = $scope{name, email, addr, phone, count}
      payload.paytype = paytype
      payload.referrer = document.referrer
      #ga \send, \event, \form, \submit
      $scope.allpay payload
      #$timeout ( -> $scope.post-submitted! ), 2000
    # conversion injection code for google adwords
    adwords-conversion = ->
      $('#tracking-adwords').html("""
      <!-- Google Code for &#24314;&#31435;&#35330;&#21934; Conversion Page -->
      <script type="text/javascript">
      /* <![CDATA[ */
      var google_conversion_id = 972490556;
      var google_conversion_language = "en";
      var google_conversion_format = "3";
      var google_conversion_color = "ffffff";
      var google_conversion_label = "NRqYCL-kzVcQvI7czwM";
      var google_conversion_value = """ + $scope.priceTotal! + """;
      var google_conversion_currency = "TWD";
      var google_remarketing_only = false;
      /* ]]> */
      </script>
      <script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
      </script>
      <noscript>
      <div style="display:inline;">
      <img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/972490556/?value=300.00&amp;currency_code=TWD&amp;label=NRqYCL-kzVcQvI7czwM&amp;guid=ON&amp;script=0"/>
      </div>
      </noscript>
      """)

    $scope.allpay = (payload) ->
      $http do
        url: \/d/order/init
        method: \POST
        headers: "Content-Type": "application/json"
        data: payload
      .success (d) ->
        ga \send, \event, \form, \submit, \order, $scope.priceTotal!
        adwords-conversion!
        if payload.paytype!=0 => return $timeout $scope.post-submitted, 1000
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
    $scope.anchor = <[ship-info feature-trilogy detail spec order-now order order-info about gallery]>
    $scope.anchor.map -> $scope.st["\##it"] = ($("\##it").offset! or {})top
    $scope.reach = {}
    $scope.$watch 'count', (->
      c = [it[k] for k of it]reduce(((a,b)->a+b),0)
      if !c or $scope.reach["-form-count"] => return
      $scope.reach["-form-count"] = true
      ga \send, \event, \form, \choose-count
    ), true
    $scope.$watch 'name', ->
      if !it or $scope.reach["-form-name"] => return
      $scope.reach["-form-name"] = true
      ga \send, \event, \form, \fill-name
    $(window)scroll (e) ->
      h = $(window)height!
      t = $(window)scroll-top!
      if t > $scope.st['#order-now'] - (h/2) and !zoomed =>
        zoomed := true
        $('#feature img').add-class \zoom
        $('#feature .feature').add-class \zoom
      if t > $scope.st['#order-info'] - (h/2) and !shown =>
        shown := true
        #$('#order').add-class \shown
        ga \send, \event, \form, \reach
      for item in $scope.anchor =>
        if t > $scope.st["\##item"] - (h/2) and !$scope.reach[item] =>
          $scope.reach[item] = true
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
    
