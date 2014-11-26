// Generated by LiveScript 1.2.0
var fastDebug, x$;
angular.module('main', ['ngAnimate', 'ld.common', 'backend']);
fastDebug = false;
x$ = angular.module('main');
x$.config(function(){
  return $('a[href*=#]:not([href=#])').click(function(){
    var target;
    if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname) {
      ga('send', 'event', 'click', "#" + this.hash.slice(1));
      target = $(this.hash);
      target = target.length
        ? target
        : $("[name=" + this.hash.slice(1) + "]");
      if (target.length) {
        $("html,body").animate({
          scrollTop: target.offset().top
        }, 1000);
      }
      return false;
    }
  });
});
x$.controller('notify', ['$scope', '$timeout', 'stateIndicator', '$http'].concat(function($scope, $timeout, stateIndicator, $http){
  $scope.needFix = false;
  $scope.state = 0;
  $scope.status = stateIndicator.init();
  $scope.postSubmitted = function(){
    $scope.status.done();
    return $scope.state = 2;
  };
  $scope.fix = function(it){
    if ($scope.needFix && !$scope[it]) {
      return "has-error";
    } else {
      return "";
    }
  };
  return $scope.submit = function(){
    if (!$scope.email) {
      return $scope.needFix = true;
    }
    $scope.needFix = false;
    $scope.state = 1;
    $scope.status.loading();
    $http({
      url: '/d/notify',
      method: 'POST',
      data: {
        email: $scope.email
      }
    }).success(function(){}).error(function(){});
    ga('send', 'event', 'notify', 'submit');
    return $timeout(function(){
      return $scope.postSubmitted();
    }, 2000);
  };
}));
x$.controller('main', function($scope, $http, $timeout, allpay, context){
  var adwordsConversion, zoomed, shown, count, x, y, v, r, s, m, idx, jdx, n, res$, i$, i, w, h;
  $scope.db = {
    order: null,
    count: null
  };
  $scope.user = context.user;
  $scope.price = {
    red: 0,
    green: 0,
    cyan: 0,
    purple: 0,
    magenta: 0,
    black: 0
  };
  $scope.count = {
    red: 0,
    green: 0,
    cyan: 0,
    purple: 0,
    magenta: 0,
    black: 0
  };
  $scope.avail = {
    red: 0,
    green: 0,
    cyan: 0,
    purple: 0,
    magenta: 0,
    black: 0
  };
  $scope.choiceName = function(){
    var list;
    list = [['red', '紅色'], ['green', '綠色'], ['cyan', '藍色'], ['purple', '紫色'], ['magenta', '紫紅色'], ['black', '黑色']];
    list = list.filter(function(it){
      return $scope.count[it[0]];
    });
    list = list.map(function(it){
      return it[1] + " " + $scope.count[it[0]] + " 個";
    });
    return list.join('#');
  };
  $scope.status = {
    status: -1
  };
  $http({
    url: '/d/status',
    method: 'GET'
  }).success(function(d){
    return $scope.status = d;
  });
  $scope.priceTotal = function(){
    var ret;
    ret = ['red', 'green', 'cyan', 'purple', 'magenta', 'black'].map(function(it){
      return $scope.price[it] * $scope.count[it];
    }).reduce(function(a, b){
      return a + b;
    }, 0);
    if (ret > 0) {
      return ret += 50;
    }
  };
  $scope.choicelist = {};
  $scope.want = true;
  $scope.needFix = false;
  $scope.state = 0;
  $scope.submitted = false;
  $scope.fix = function(it){
    if ($scope.needFix && !$scope[it]) {
      return "has-error";
    } else {
      return "";
    }
  };
  $scope.loadcount = function(){
    return $http({
      url: '/d/stock',
      method: 'GET'
    }).success(function(d){
      var k, ref$, v, ref1$, i, results$ = [];
      $scope.price = d.price;
      $scope.avail = d.avail;
      for (k in ref$ = $scope.avail) {
        v = ref$[k];
        $scope.avail[k] = (ref1$ = $scope.avail[k]) > 0 ? ref1$ : 0;
        results$.push($scope.choicelist[k] = (fn$()));
      }
      return results$;
      function fn$(){
        var i$, to$, ref$, results$ = [];
        for (i$ = 0, to$ = (ref$ = v < 20 ? v : 20) > 0 ? ref$ : 0; i$ <= to$; ++i$) {
          i = i$;
          results$.push(i);
        }
        return results$;
      }
    });
  };
  $scope.loadcount();
  $scope.logout = function(){
    if ($scope.user) {
      return $http({
        url: '/d/logout',
        method: 'GET'
      }).success(function(d){
        $scope.user = null;
        return $scope.email = "", $scope.password = "", $scope.user = null, $scope;
      }).error(function(d){});
    }
  };
  $scope.clearForm = function(){
    var ref$, target;
    ref$ = {
      name: "",
      addr: "",
      email: "",
      password: "",
      phone: "",
      payment: "1"
    }, $scope.name = ref$.name, $scope.addr = ref$.addr, $scope.email = ref$.email, $scope.password = ref$.password, $scope.phone = ref$.phone, $scope.payment = ref$.payment;
    $scope.count = {
      red: 0,
      green: 0,
      cyan: 0,
      purple: 0,
      magenta: 0,
      black: 0
    };
    if ($scope.user) {
      $scope.email = $scope.user.email;
    }
    $scope.state = 0;
    target = $('#order');
    return setTimeout(function(){
      if (target.length) {
        return $("html,body").animate({
          scrollTop: target.offset().top
        }, 500);
      }
    }, 100);
  };
  $scope.postSubmitted = function(){
    var target;
    $scope.state = 2;
    target = $('#order-complete-anchor');
    return setTimeout(function(){
      if (target.length) {
        return $("html,body").animate({
          scrollTop: target.offset().top
        }, 500);
      }
    }, 100);
  };
  $scope.submit = function(paytype){
    var payload;
    if (!($scope.name && $scope.addr && $scope.email && $scope.phone && $scope.priceTotal())) {
      return $scope.needFix = true, $scope.state = 0, $scope;
    }
    $scope.needFix = false;
    $scope.state = 1;
    payload = {
      name: $scope.name,
      email: $scope.email,
      addr: $scope.addr,
      phone: $scope.phone,
      count: $scope.count
    };
    payload.paytype = paytype;
    payload.referrer = document.referrer;
    return $scope.allpay(payload);
  };
  adwordsConversion = function(){
    return $('#tracking-adwords').html("<!-- Google Code for &#24314;&#31435;&#35330;&#21934; Conversion Page -->\n<script type=\"text/javascript\">\n/* <![CDATA[ */\nvar google_conversion_id = 972490556;\nvar google_conversion_language = \"en\";\nvar google_conversion_format = \"3\";\nvar google_conversion_color = \"ffffff\";\nvar google_conversion_label = \"NRqYCL-kzVcQvI7czwM\";\nvar google_conversion_value = " + $scope.priceTotal() + ";\nvar google_conversion_currency = \"TWD\";\nvar google_remarketing_only = false;\n/* ]]> */\n</script>\n<script type=\"text/javascript\" src=\"//www.googleadservices.com/pagead/conversion.js\">\n</script>\n<noscript>\n<div style=\"display:inline;\">\n<img height=\"1\" width=\"1\" style=\"border-style:none;\" alt=\"\" src=\"//www.googleadservices.com/pagead/conversion/972490556/?value=300.00&amp;currency_code=TWD&amp;label=NRqYCL-kzVcQvI7czwM&amp;guid=ON&amp;script=0\"/>\n</div>\n</noscript>");
  };
  $scope.allpay = function(payload){
    return $http({
      url: '/d/order/init',
      method: 'POST',
      headers: {
        "Content-Type": "application/json"
      },
      data: payload
    }).success(function(d){
      ga('send', 'event', 'form', 'submit', 'order', $scope.priceTotal());
      adwordsConversion();
      if (payload.paytype !== 0) {
        return $timeout($scope.postSubmitted, 1000);
      }
      console.log("payload information (to allpay): " + d);
      $scope.allPayData = d;
      return $timeout(function(){
        return $('#allpayform').submit();
      }, 100);
    }).error(function(e){
      return console.error(e);
    });
  };
  if (typeof fastDebug !== "undefined" && fastDebug) {
    $scope.name = "薄瓜瓜";
    $scope.addr = "在大陸的薄瓜瓜的家";
    $scope.phone = "0110101011";
  }
  $scope.payment = 1;
  zoomed = false;
  shown = false;
  $scope.st = {};
  $scope.anchor = ['ship-info', 'feature-trilogy', 'detail', 'spec', 'order-now', 'order', 'order-info', 'about', 'gallery'];
  $scope.anchor.map(function(it){
    return $scope.st["#" + it] = ($("#" + it).offset() || {}).top;
  });
  $scope.reach = {};
  $scope.$watch('count', function(it){
    var c, k;
    c = (function(){
      var results$ = [];
      for (k in it) {
        results$.push(it[k]);
      }
      return results$;
    }()).reduce(function(a, b){
      return a + b;
    }, 0);
    if (!c || $scope.reach["-form-count"]) {
      return;
    }
    $scope.reach["-form-count"] = true;
    return ga('send', 'event', 'form', 'choose-count');
  }, true);
  $scope.$watch('name', function(it){
    if (!it || $scope.reach["-form-name"]) {
      return;
    }
    $scope.reach["-form-name"] = true;
    return ga('send', 'event', 'form', 'fill-name');
  });
  $(window).scroll(function(e){
    var h, t, i$, ref$, len$, item, results$ = [];
    h = $(window).height();
    t = $(window).scrollTop();
    if (t > $scope.st['#order-now'] - h / 2 && !zoomed) {
      zoomed = true;
      $('#feature img').addClass('zoom');
      $('#feature .feature').addClass('zoom');
    }
    if (t > $scope.st['#order-info'] - h / 2 && !shown) {
      shown = true;
      ga('send', 'event', 'form', 'reach');
    }
    for (i$ = 0, len$ = (ref$ = $scope.anchor).length; i$ < len$; ++i$) {
      item = ref$[i$];
      if (t > $scope.st["#" + item] - h / 2 && !$scope.reach[item]) {
        $scope.reach[item] = true;
        results$.push(ga('send', 'event', 'scroll', item));
      }
    }
    return results$;
  });
  count = 100;
  x = new Array(count);
  y = new Array(count);
  v = new Array(count);
  r = new Array(count);
  s = new Array(count);
  m = new Array(count);
  idx = new Array(count);
  jdx = new Array(count);
  res$ = [];
  for (i$ = 0; i$ < 100; ++i$) {
    i = i$;
    res$.push($("<div class='feather'><div class='bk'></div><div class='img'></div></div>"));
  }
  n = res$;
  w = $(window).width();
  h = $(window).height();
  for (i$ = 0; i$ < 30; ++i$) {
    i = i$;
    x[i] = Math.random() * -500;
    v[i] = Math.random() * 14;
    y[i] = Math.random() * 3 * h / 4 + h / 4;
    s[i] = Math.random() * 1;
    r[i] = parseInt(Math.random() * 360);
    idx[i] = Math.random() * 6.28;
    jdx[i] = Math.random() * 0.5;
    $('#feathers').append(n[i]);
    m[i] = n[i].find('div');
  }
  if (false) {
    setInterval(function(){
      var i$, i, cy, results$ = [];
      for (i$ = 0; i$ < 50; ++i$) {
        i = i$;
        x[i] += v[i] / 2 + v[i] * Math.cos(idx[i]);
        cy = y[i] + (h / 6) * Math.sin(jdx[i]);
        r[i] += parseInt(Math.random() * 3);
        idx[i] += 0.011;
        jdx[i] += 0.007;
        n[i].css({
          top: cy,
          left: x[i],
          opacity: s[i]
        });
        if (m[i]) {
          m[i].css({
            "-webkit-transform": "rotate(" + r[i] + "deg) scale(" + s[i] + ")"
          });
        }
        if (x[i] >= w) {
          results$.push(x[i] = Math.random() * -100);
        }
      }
      return results$;
    }, 50);
  }
  return $scope.inited = 1;
});