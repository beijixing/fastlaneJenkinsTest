
/* **********************检查当前客户端类型********************** */

var common = {};
common.userAgent = navigator.userAgent;
common.osName = function () {
	if(this.userAgent.toLowerCase().indexOf('android')>-1){
		return "android";
	}else if(this.userAgent.toLowerCase().indexOf('iphone')>-1){
		return "iphone";
	}else{
		return "other";
	}
}

/* *********************定义IOS相关的桥接方法********************* */

function setupWebViewJavascriptBridge(callback) {
	if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

/* *********************定义登陆失效的退出方法********************* */

function loginOutWithInvalid(){
	if(common.osName()=="iphone"){
		setupWebViewJavascriptBridge(function(bridge) {
        	bridge.callHandler('reLogin', function responseCallback(responseData) {});
        });
	}else if(common.osName()=="android"){
		returnLog.returnLogActivity();
	}else{
		
	}
}


/* *********************定义页面使用的常用函数********************* */

// 获取Ajax请求对象
function getajaxHttp() {
	var xmlHttp = null;
    try {
        xmlHttp = new XMLHttpRequest();
   	} catch (e) {
	    try {
	        xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	    } catch (e) {
		    try {
		        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		    } catch (e) {
		        alert("您的浏览器不支持AJAX！");
		        return false;
		    }
    	}
	}
    return xmlHttp;
}

// 字符串拼接函数
function removethousand(obj){
    var a = [obj.length];
    for(var i=0; i<obj.length; i++){
    	if(typeof obj[i] == 'number'){
            a[i] = obj[i];
        }else{
            if(obj[i] == '--'){
              a[i] = 0;
            }else{
              a[i] = parseFloat(obj[i].replace(/,/g,''));
            }
        }
    }
    return a;
}

function formatThousand(num) {
    return (num+'').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
}

// 转换为Float数值函数
function tofloat(obj){
    var a = [obj.length];
    for(var i=0; i<obj.length; i++){
    	if(obj[i] == '--'){
            a[i] = 0;
        }else{
            a[i] = parseFloat(obj[i]);
        }
    }
    return a;
}

// 日期转换：yyyy年MM月dd日
function formatYMD(sdate){
  	return sdate.substr(0,4) + '年' + sdate.substr(4,2) + '月' + sdate.substr(6,2) + '日';
}

// 日期转换：yy年MM月dd日
function formatYMD2(sdate){
  	return sdate.substr(2,2) + '年' + sdate.substr(4,2) + '月' + sdate.substr(6,2) + '日';
}

// 日期转换：yyyy年MM月
function formatYM(sdate){
  	return sdate.substr(0,4) + '年' + sdate.substr(4,2) + '月';
}

// 日期转换：yy-MM
function formatYM2(sdate){
  	return sdate.substr(2,2) + '-' + sdate.substr(4,2);
}

// 日期转换：yy-MM-DD
function formatMD(sdate){
  	return sdate.substr(2,2) + '-' + sdate.substr(4,2) + '-' + sdate.substr(6,2);
}

// 日期转换：MM月dd日
function formatMD2(sdate){
  	return sdate.substr(4,2) + '月' + sdate.substr(6,2) + '日';
}

// Android获取url参数
function getUrlA(url){
	if(url.indexOf("?") != -1) {
    	url = url.replace('?','');
    	var url_a = url.split('&');
    	var request = new Array(url_a.length);
    	for(i = 0; i<url_a.length ; i++){
      		request[url_a[i].split('=')[0]] = url_a[i].split('=')[1];
    	}
    	return request;
  	}else{
    	return null;
  	}
}

function initLoadingImage(){
	if($("#loadingDiv").length>0){
		$("#loadingDiv").html('<img src="images/jzh3.gif"/><span></span>');
	}else{
		var loadingHtml='<div id="loadingDiv" class="loadingDiv"><img src="images/jzh3.gif"/><span></span></div>';
		$(".fulls").prepend(loadingHtml);
	}
}

function removeLoadingImage(){
	if($("#loadingDiv").length==0){return;}
	$("#loadingDiv").remove();
}

function resetTableTdCss(tabColNamesList){
	if(tabColNamesList.length==2){
		$(".valuedata1 td:first-child").css("width","40%");
		$(".valuedata1 td:nth-child(2)").css("width","60%");
		$(".valuedata1 td:last-child").attr("display","none");
	}
	if(tabColNamesList.length==3){
		$(".valuedata1 td:first-child").css("width","30%");
		$(".valuedata1 td:nth-child(2)").css("width","30%");
		$(".valuedata1 td:last-child").css("width","40%");
	}
}
























