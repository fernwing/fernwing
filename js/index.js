// Generated by LiveScript 1.2.0
var x$;
angular.module('main', online
  ? ['firebase', 'ngAnimate']
  : ['ngAnimate']);
if (!online) {
  angular.module.factory('$firebase', function(){
    return {};
  });
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
  var zoomed, shown, count, x, y, v, r, s, m, idx, jdx, n, res$, i$, i, w, h, results$ = [];
  $scope.dbRef = new Firebase('https://fern.firebaseIO.com/order');
  $scope.orders = $firebase($scope.dbRef);
  $scope.auth = new FirebaseSimpleLogin($scope.dbRef, function(e, u){
    return $scope.user = u;
  });
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
      phone: ""
    }, $scope.name = ref$.name, $scope.addr = ref$.addr, $scope.email = ref$.email, $scope.phone = ref$.phone;
    return $scope.state = 0;
  };
  $scope.postSubmitted = function(){
    return $scope.state = 2;
  };
  $scope.submit = function(){
    var id, ref$;
    if (!($scope.name && $scope.addr && $scope.email && $scope.phone)) {
      return $scope.needFix = true;
    }
    $scope.needFix = false;
    $scope.state = 1;
    id = ((ref$ = $scope.orders).pending || (ref$.pending = [])).push([$scope.name, $scope.addr, $scope.email, $scope.phone]);
    $scope.orders.$save();
    ga('send', 'event', 'form', 'submit');
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
});