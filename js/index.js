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
x$.controller('main', function($scope, $firebase, $timeout){
  var k, ref$, v, i, zoomed, shown, count, x, y, r, s, m, idx, jdx, n, res$, i$, w, h, results$ = [];
  $scope.dbRef = new Firebase('https://fern.firebaseIO.com/order');
  $scope.orders = $firebase($scope.dbRef);
  $scope.auth = new FirebaseSimpleLogin($scope.dbRef, function(e, u){
    return $scope.$apply(function(){
      $scope.user = u;
      console.log(")))", $scope.user, e, u, $scope.state);
      if ($scope.state === 1) {
        if (!$scope.user) {
          $scope.password = "";
        }
        return $scope.submit();
      }
    });
  });
  $scope.count = {
    red: 0,
    green: 0,
    cyan: 0,
    purple: 0,
    magenta: 0,
    black: 0
  };
  $scope.avail = {
    red: 5,
    green: 4,
    cyan: 0,
    purple: 2,
    magenta: 1,
    black: 0
  };
  $scope.choicelist = {};
  for (k in ref$ = $scope.avail) {
    v = ref$[k];
    $scope.choicelist[k] = (fn$());
  }
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
  $scope.clearForm = function(){
    var ref$;
    ref$ = {
      name: "",
      addr: "",
      email: "",
      password: "",
      phone: ""
    }, $scope.name = ref$.name, $scope.addr = ref$.addr, $scope.email = ref$.email, $scope.password = ref$.password, $scope.phone = ref$.phone;
    return $scope.state = 0;
  };
  $scope.postSubmitted = function(){
    return $scope.state = 2;
  };
  $scope.submit = function(){
    console.log("submitting");
    if (!($scope.name && $scope.addr && $scope.email && $scope.password && $scope.phone)) {
      return $scope.needFix = true, $scope.state = 0, $scope;
    }
    $scope.needFix = false;
    $scope.state = 1;
    console.log("[1]", $scope.auth.uid);
    if (!$scope.user) {
      console.log($scope.password);
      $scope.auth.createUser($scope.email, $scope.password, function(e, u){
        var r;
        if (e && e.code === 'EMAIL_TAKEN') {
          r = $scope.auth.login('password', {
            email: $scope.email,
            password: $scope.password
          });
          console.log(">>>", r);
          return console.log("[2]", $scope.auth.uid);
        } else {
          console.log(u);
          return $scope.submit();
        }
      });
    } else {
      console.log('ok');
    }
    return $timeout(function(){
      return $scope.postSubmitted();
    }, 2000);
  };
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
  console.log(w);
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
    results$.push(m[i] = n[i].find('div'));
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