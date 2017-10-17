/*
	用于验证表单不为空的公用方法
	请在form的submit事件中return这个方法，若有原有的invalidTest，可在本方法的参数填入方法名：
	例如：
	<form submit="return invalidTest(testUserName)"></form>
	需要在对应的input中填入data-required属性，值为空
	需要在对应的input的placeholder属性中填入要显示在alert中的名
	需要在对应的select中填入data-name属性，值为需要显示在alert中的名
*/
var formData=$("[data-required]");
function invalidTest(fn){
	for(var i=0;i<formData.length;i++){
		if(formData[i].value==""){
			alert((formData[i].placeholder||formData[i].dataset.name)+"不能为空");
			formData[i].focus();
			break;
		}
	}
	if(i==formData.length){
		return fn();
	}else{
		return false;
	}
}