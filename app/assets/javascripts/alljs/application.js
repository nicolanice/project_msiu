//= require_tree .

function getSelectedText(id){			    
				var s = document.getElementById(id);				 
				sindex = s.selectedIndex;
				if (sindex == -1 || sindex == 0) return "qq";        
				return s.options[sindex].text;
}


function insertTextFromSelect(class_name, select_id){			    
        text = ""
        var s = document.getElementById(select_id);				 
        if (s.selectedIndex == -1) text = "";
        text = s.options[s.selectedIndex].text;
        d = document.getElementsByClassName(class_name);
        if (d != null)
           d[0].value += text;
        return false;
}


var token_filter = function (results){  
            var is_find;
            $.each(results, function(index, value){                                             
                is_find = false;
                for(var i=0; i<tokens.length; i++){
                  if (tokens[i] == value.id){
                    is_find = true;
                    break;
                  }                             
                }
                if(is_find == false)
                  // delete token  
                  value.f = "";         
            });
            return results;            
}

// for nested forms

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("new_" + association, "g");
  var text=content.replace(regexp, new_id);
  var input_id=$(text).find("input.protocol_theme:first").attr("id");
  $(link).parent().before(text);  
  $("#"+input_id).tokenInputLoad("employees", null, false, null, token_filter);  
}

function add_theme_fields(link, association, content) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("new_" + association, "g");
  var text=content.replace(regexp, new_id);
  var input_id=$(text).find("input.protocol_theme:first").attr("id");
  addTheme(text);
}


// tokeninput

function token_format(item){
  return "<li>"+  item.f + " " + item.i + " " + item.o + "</li>";
}


$.fn.tokenInputLoad = function(json_file, limit) {
  $(this).tokenInput("/"+json_file+".json", {
    tokenLimit: limit,        
    prePopulate: $(this).data("pre"),      
    propertyToSearch: 'f',
    resultsFormatter: function(item){
      return token_format(item); 
    },    
    tokenFormatter: token_format
  });
};



$(function() {	
  $("#protocol_auditory_token").tokenInput("/auditories.json", {
    tokenLimit: 1,        
    prePopulate: $(this).data("pre"),      
    propertyToSearch: 'number',
    resultsFormatter: function(item){
      return "<li>" + item.number + "</li>"; 
    },    
    tokenFormatter: function(item){
      return "<li>" + item.number + "</li>"; 
    }
  });	
	
	
	
  $("#protocol_chairman_token").tokenInputLoad("employees", 1); 
  $("#protocol_secretary_token").tokenInputLoad("employees", 1);     
});


$.datepicker.regional['ru'] = {
	closeText: 'Закрыть',
	prevText: '<Пред',
	nextText: 'След>',
	currentText: 'Сегодня',
	monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
	'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
	monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
	'Июл','Авг','Сен','Окт','Ноя','Дек'],
	dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
	dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
	dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
	weekHeader: 'Не',
	dateFormat: 'dd.mm.yy',
  
	firstDay: 1,
	isRTL: false,
  
        ampm: true,
	showMonthAfterYear: false,
	yearSuffix: ''
};



$(function(){
  $("#datepicker").datetimepicker({
    timeOnlyTitle: 'Выберите время',
  	timeText: 'Время',
  	hourText: 'Часы',
	minuteText: 'Минуты',
  	secondText: 'Секунды',  	
	closeText: 'Закрыть',    
    minuteGrid: 10,
    stepMinute: 10,    
  });
});

$.datepicker.setDefaults($.datepicker.regional['ru']);
//$.datepicker.dateFormat("yyyy-mm-dd h m s");
   
function set_datetime(){
	$("#datepicker").datetimepicker({
		hour: 10		
	});
	return false;
}


$(document).ready( function() {
       $("#select_all").click( function() {
            if($('#select_all').attr('checked')){
                $('.people').attr('checked', true);
            } else {
                $('.people').attr('checked', false);
            }
       });            
});

$(document).ready(function() {
	   $("#select_all_themes").click( function() {
            if($('#select_all_themes').attr('checked')){
                $('.theme').attr('checked', true);
            } else {
                $('.theme').attr('checked', false);
            }
       });
});	

function getSelectedId(s){			    				 
        sindex = s.selectedIndex;
		if (sindex == -1) return -1;        
		if (s.options[sindex].value == -1) return -1;		
		return s.options[sindex].value;
}



autocompleteTextarea = function(data) {
    var _this = this;
    return $("textarea").autocomplete({
      wordCount: 1,
      mode: "outter",
      on: {
        query: function(text, cb) {
          var words, x, _i, _len;
          words = [];
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            x = data[_i];
            if (x.toLowerCase().indexOf(text.toLowerCase === 0)) words.push(x);
          }
          return cb(words);
        }
      }
    });
  };


$(function() {           
        
  $("#protocol_search").hide();
  
  
  $("select.chzn-select").change(function() {              
    var id = getSelectedId(this);    
    $.get($("#ajax_url").attr("value"), {"select_theme" : id }, null, "script");
    return false;
  });
  
  

  $("#search_link").click(function () {
    $("#protocol_search").slideToggle("slow");
      });
  
   $("#run_search").live("click",function() {
      $("#list").html("<img src = '/images/loader.gif'>");
      $.get($("#search_form").attr("action"), $("#search_form").serialize(), null, "script");
      return false;
   });
});


function addTheme(content){
    document.getElementById("add_themes").innerHTML += content
    document.getElementById("showadd").innerHTML = "Добавлено!"
    return false;
}









