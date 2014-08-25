// Generated by LiveScript 1.2.0
var x$;
x$ = angular.module('main');
x$.factory('allpay', function(){
  return {
    empty: {
      MerchantID: "2000132",
      MerchantTradeNo: "zbryikt123458",
      MerchantTradeDate: "2014/08/12 10:00:00",
      PaymentType: "aio",
      TotalAmount: "100",
      TradeDesc: "測試",
      ItemName: "testitem1",
      ReturnURL: "http://staging.fernwing.com/api/paidnotify",
      OrderResultURL: "http://staging.fernwing.com/api/order",
      PaymentInfoURL: "",
      ChoosePayment: "ALL",
      CheckMacValue: ""
    },
    now: function(){
      var n, y, M, d, h, m, s;
      n = new Date();
      y = n.getYear() + 1900;
      M = n.getMonth() + 1;
      d = n.getDate();
      h = n.getHours();
      m = n.getMinutes();
      s = n.getSeconds();
      M = M < 10 ? "0" + M : M;
      d = d < 10 ? "0" + d : d;
      h = h < 10 ? "0" + h : h;
      m = m < 10 ? "0" + m : m;
      s = s < 10 ? "0" + s : s;
      return y + "/" + M + "/" + d + " " + h + ":" + m + ":" + s;
    },
    hash: {
      key: "5294y06JbISpM5x9",
      iv: "v77hoKGq4kWxNNIS"
    },
    _encode: function(data){
      return data;
    },
    encode: function(data){
      var list, k, v, chk;
      list = [];
      for (k in data) {
        v = data[k];
        if (k === 'CheckMacValue') {
          continue;
        }
        list.push(k + "=" + v);
      }
      list.sort(function(a, b){
        a = a.toUpperCase();
        b = b.toUpperCase();
        if (a > b) {
          return 1;
        }
        if (a < b) {
          return -1;
        }
        return 0;
      });
      chk = list.join("&");
      if (this.hash.key) {
        chk = encodeURIComponent("HashKey=" + this.hash.key + "&" + chk + "&HashIV=" + this.hash.iv);
        chk = chk.replace(/%20/g, "+");
        chk = md5(chk.toLowerCase()).toUpperCase();
      } else {
        chk = this._encode(chk);
      }
      data.CheckMacValue = chk;
      return chk;
    }
  };
});