// Generated by LiveScript 1.2.0
var Firebase, FirebaseSimpleLogin, ga, x$;
angular.module('main', online
  ? ['firebase', 'ngAnimate']
  : ['ngAnimate']);
if (!online) {
  angular.module('main').factory('$firebase', function(){
    return function(){};
  });
}
if (!online) {
  Firebase = function(){};
  FirebaseSimpleLogin = function(){};
  ga = function(){};
}
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
x$.directive('delayBk', function(){
  return {
    restrict: 'A',
    link: function(scope, e, attrs, ctrl){
      var url;
      url = attrs["delayBk"];
      return $('<img/>').attr('src', url).load(function(){
        $(this).remove();
        e.css({
          "background-image": "url(" + url + ")"
        });
        return setTimeout(function(){
          return e.toggleClass('visible');
        }, 100);
      });
    }
  };
});
x$.controller('notify', function($scope, $firebase, $timeout){
  $scope.dbRef = new Firebase('https://fern.firebaseIO.com/notify/');
  $scope.notify = $firebase($scope.dbRef);
  $scope.needFix = false;
  $scope.state = 0;
  $scope.postSubmitted = function(){
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
    var id;
    if (!$scope.email) {
      return $scope.needFix = true;
    }
    $scope.needFix = false;
    $scope.state = 1;
    id = $scope.notify.$add($scope.email);
    ga('send', 'event', 'notify', 'submit');
    return $timeout(function(){
      return $scope.postSubmitted();
    }, 2000);
  };
});
x$.controller('main', function($scope, $firebase, $timeout, dbref){
  var zoomed, shown, count, x, y, v, r, s, m, idx, jdx, n, res$, i$, i, w, h;
  $scope.db = {
    order: null,
    count: null
  };
  $scope.auth = dbref.auth('fern', function(e, u){
    return $scope.$apply(function(){
      if (e) {
        console.log("get user fail: ", e);
      }
      $scope.user = u;
      if ($scope.user) {
        $scope.email = $scope.user.email;
      }
      if ($scope.state === 1) {
        if (!$scope.user) {
          $scope.password = "";
        }
        return $scope.submit();
      }
    });
  });
  $scope.price = {
    red: 583,
    green: 583,
    cyan: 583,
    purple: 583,
    magenta: 583,
    black: 583
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
  $scope.priceTotal = function(){
    return ['red', 'green', 'cyan', 'purple', 'magenta', 'black'].map(function(it){
      return $scope.price[it] * $scope.count[it];
    }).reduce(function(a, b){
      return a + b;
    }, 0);
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
  $scope.dbref = dbref;
  $scope.loadcount = function(){
    return dbref.get('fern', "admin/count/").$on('loaded', function(total){
      return dbref.get('fern', "count/").$on('loaded', function(consumed){
        return $scope.$apply(function(){
          var c, uid, ref$, list, k, v, i, results$ = [];
          for (c in $scope.avail) {
            $scope.avail[c] = total[c];
          }
          for (uid in ref$ = consumed) {
            list = ref$[uid];
            if (/^\d+$/.exec(uid)) {
              for (k in list) {
                v = list[k];
                for (c in $scope.avail) {
                  $scope.avail[c] -= v.count[c];
                }
              }
            }
          }
          for (k in ref$ = $scope.avail) {
            v = ref$[k];
            results$.push($scope.choicelist[k] = (fn$()));
          }
          return results$;
          function fn$(){
            var i$, to$, results$ = [];
            for (i$ = 0, to$ = v; i$ <= to$; ++i$) {
              i = i$;
              results$.push(i);
            }
            return results$;
          }
        });
      });
    });
  };
  $scope.loadcount();
  $scope.logout = function(){
    if ($scope.user) {
      $scope.auth.logout();
      return $scope.email = "", $scope.password = "", $scope.user = null, $scope;
    }
  };
  $scope.clearForm = function(){
    var ref$;
    ref$ = {
      name: "",
      addr: "",
      email: "",
      password: "",
      phone: ""
    }, $scope.name = ref$.name, $scope.addr = ref$.addr, $scope.email = ref$.email, $scope.password = ref$.password, $scope.phone = ref$.phone;
    if ($scope.user) {
      $scope.email = $scope.user.email;
    }
    return $scope.state = 0;
  };
  $scope.postSubmitted = function(){
    return $scope.state = 2;
  };
  $scope.submit = function(){
    var payload, key;
    if (!($scope.name && $scope.addr && $scope.email && ($scope.user || $scope.password) && $scope.phone && $scope.priceTotal())) {
      return $scope.needFix = true, $scope.state = 0, $scope;
    }
    $scope.needFix = false;
    $scope.state = 1;
    if (!$scope.user) {
      $scope.auth.createUser($scope.email, $scope.password, function(e, u){
        if (e && e.code === 'EMAIL_TAKEN') {
          return $scope.auth.login('password', {
            email: $scope.email,
            password: $scope.password
          });
        } else if (e) {
          return console.log("create user error: ", e);
        } else {
          return $scope.submit();
        }
      });
      return;
    }
    $scope.db.order = dbref.get('fern', "user/" + $scope.user.id + "/order/pending/");
    $scope.db.count = dbref.get('fern', "count/" + $scope.user.id + "/");
    payload = {
      name: $scope.name,
      email: $scope.email,
      addr: $scope.addr,
      phone: $scope.phone,
      count: $scope.count
    };
    key = $scope.db.order.$add(payload).name();
    $scope.db.count.$add({
      count: $scope.count,
      key: key
    });
    ga('send', 'event', 'form', 'submit');
    return $timeout(function(){
      return $scope.postSubmitted();
    }, 2000);
  };
  if (typeof fastDebug !== "undefined" && fastDebug) {
    $scope.name = "薄瓜瓜";
    $scope.addr = "在大陸的薄瓜瓜的家";
    $scope.phone = "0110101011";
    $scope.count.purple = 2;
  }
  zoomed = false;
  shown = false;
  $scope.st = {};
  $scope.anchor = ['wing-feature', 'order', 'order-info', 'about', 'gallery'];
  $scope.anchor.map(function(it){
    return $scope.st["#" + it] = ($("#" + it).offset() || {}).top;
  });
  $scope.reach = {};
  $(window).scroll(function(e){
    var h, t, i$, ref$, len$, item, results$ = [];
    h = $(window).height();
    t = $(window).scrollTop();
    if (t > $scope.st['#wing-feature'] - h / 2 && !zoomed) {
      zoomed = true;
      $('#feature img').addClass('zoom');
      $('#feature .feature').addClass('zoom');
    }
    if (t > $scope.st['#order-info'] - h / 2 && !shown) {
      shown = true;
      $('#order').addClass('shown');
      ga('send', 'event', 'form', 'reach');
    }
    for (i$ = 0, len$ = (ref$ = $scope.anchor).length; i$ < len$; ++i$) {
      item = ref$[i$];
      if (t > $scope.st[item] && !$scope.reach[item]) {
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
    return setInterval(function(){
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
});