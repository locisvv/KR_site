$(document).ready(function() {
	//Действие по умолчанию
	$(".tab_content").hide(); //Скрыть весь контент
	$("ul.tabs li:first").addClass("active").show(); //Активировать первую вкладку
	$(".tab_content:first").show(); //Показать контент первой вкладки
	//Обработка события "Onclick"
	$("ul.tabs li").click(function() {
 $("ul.tabs li").removeClass("active"); //Удалить любой "active" класс
 $(this).addClass("active"); //Добавить "active" класс к выбранной вкладке
 $(".tab_content").hide(); //Скрыть контент всех вкладок
 var activeTab = $(this).find("a").attr("href"); //Найти rel атрибут для определения активной вкладки+контента
 $(activeTab).fadeIn(); //Проявление активного содержимого
 return false;
	});
});