function BestInPlaceEditor(t){this.element=t,this.initOptions(),this.bindForm(),this.initNil(),jQuery(this.activator).bind("click",{editor:this},this.clickHandler)}BestInPlaceEditor.prototype={activate:function(){var t="";t=this.isNil()?"":this.original_content?this.original_content:this.sanitize?this.element.text():this.element.html(),this.oldValue=this.isNil()?"":this.element.html(),this.display_value=t,jQuery(this.activator).unbind("click",this.clickHandler),this.activateForm(),this.element.trigger(jQuery.Event("best_in_place:activate"))},abort:function(){this.activateText(this.oldValue),jQuery(this.activator).bind("click",{editor:this},this.clickHandler),this.element.trigger(jQuery.Event("best_in_place:abort")),this.element.trigger(jQuery.Event("best_in_place:deactivate"))},abortIfConfirm:function(){return this.useConfirm?(confirm("Are you sure you want to discard your changes?")&&this.abort(),void 0):(this.abort(),void 0)},update:function(){var t=this;if(this.formType in{input:1,textarea:1}&&this.getValue()==this.oldValue)return this.abort(),!0;if(t.ajax({type:"post",dataType:"text",data:t.requestData(),success:function(e){t.loadSuccessCallback(e)},error:function(e,i){t.loadErrorCallback(e,i)}}),"select"==this.formType){var e=this.getValue();this.previousCollectionValue=e,jQuery.each(this.values,function(i,n){e==n[0]&&t.element.html(n[1])})}else"checkbox"==this.formType?t.element.html(this.getValue()?this.values[1]:this.values[0]):""!==this.getValue()?t.element.text(this.getValue()):t.element.html(this.nil);t.element.trigger(jQuery.Event("best_in_place:update"))},activateForm:function(){alert("The form was not properly initialized. activateForm is unbound")},activateText:function(t){this.element.html(t),this.isNil()&&this.element.html(this.nil)},initOptions:function(){var t=this;t.element.parents().each(function(){$parent=jQuery(this),t.url=t.url||$parent.attr("data-url"),t.collection=t.collection||$parent.attr("data-collection"),t.formType=t.formType||$parent.attr("data-type"),t.objectName=t.objectName||$parent.attr("data-object"),t.attributeName=t.attributeName||$parent.attr("data-attribute"),t.activator=t.activator||$parent.attr("data-activator"),t.okButton=t.okButton||$parent.attr("data-ok-button"),t.okButtonClass=t.okButtonClass||$parent.attr("data-ok-button-class"),t.cancelButton=t.cancelButton||$parent.attr("data-cancel-button"),t.cancelButtonClass=t.cancelButtonClass||$parent.attr("data-cancel-button-class"),t.nil=t.nil||$parent.attr("data-nil"),t.inner_class=t.inner_class||$parent.attr("data-inner-class"),t.html_attrs=t.html_attrs||$parent.attr("data-html-attrs"),t.original_content=t.original_content||$parent.attr("data-original-content"),t.collectionValue=t.collectionValue||$parent.attr("data-value")}),t.element.parents().each(function(){var e=this.id.match(/^(\w+)_(\d+)$/i);e&&(t.objectName=t.objectName||e[1])}),t.url=t.element.attr("data-url")||t.url||document.location.pathname,t.collection=t.element.attr("data-collection")||t.collection,t.formType=t.element.attr("data-type")||t.formtype||"input",t.objectName=t.element.attr("data-object")||t.objectName,t.attributeName=t.element.attr("data-attribute")||t.attributeName,t.activator=t.element.attr("data-activator")||t.element,t.okButton=t.element.attr("data-ok-button")||t.okButton,t.okButtonClass=t.element.attr("data-ok-button-class")||t.okButtonClass||"",t.cancelButton=t.element.attr("data-cancel-button")||t.cancelButton,t.cancelButtonClass=t.element.attr("data-cancel-button-class")||t.cancelButtonClass||"",t.nil=t.element.attr("data-nil")||t.nil||"—",t.inner_class=t.element.attr("data-inner-class")||t.inner_class||null,t.html_attrs=t.element.attr("data-html-attrs")||t.html_attrs,t.original_content=t.element.attr("data-original-content")||t.original_content,t.collectionValue=t.element.attr("data-value")||t.collectionValue,t.sanitize=t.element.attr("data-sanitize")?"true"==t.element.attr("data-sanitize"):!0,t.useConfirm=t.element.attr("data-use-confirm")?"false"!=t.element.attr("data-use-confirm"):!0,"select"!=t.formType&&"checkbox"!=t.formType||null===t.collection||(t.values=jQuery.parseJSON(t.collection))},bindForm:function(){this.activateForm=BestInPlaceEditor.forms[this.formType].activateForm,this.getValue=BestInPlaceEditor.forms[this.formType].getValue},initNil:function(){""===this.element.html()&&this.element.html(this.nil)},isNil:function(){return""===this.element.html()||this.element.html()===this.nil},getValue:function(){alert("The form was not properly initialized. getValue is unbound")},sanitizeValue:function(t){return jQuery.trim(t)},requestData:function(){csrf_token=jQuery("meta[name=csrf-token]").attr("content"),csrf_param=jQuery("meta[name=csrf-param]").attr("content");var t="_method=put";return t+="&"+this.objectName+"["+this.attributeName+"]="+encodeURIComponent(this.getValue()),void 0!==csrf_param&&void 0!==csrf_token&&(t+="&"+csrf_param+"="+encodeURIComponent(csrf_token)),t},ajax:function(t){return t.url=this.url,t.beforeSend=function(t){t.setRequestHeader("Accept","application/json")},jQuery.ajax(t)},loadSuccessCallback:function(t){if(t=jQuery.trim(t),t&&""!=t){var e=jQuery.parseJSON(jQuery.trim(t));null!==e&&e.hasOwnProperty("display_as")&&(this.element.attr("data-original-content",this.element.text()),this.original_content=this.element.text(),this.element.html(e.display_as)),this.element.trigger(jQuery.Event("best_in_place:success"),t),this.element.trigger(jQuery.Event("ajax:success"),t)}else this.element.trigger(jQuery.Event("best_in_place:success")),this.element.trigger(jQuery.Event("ajax:success"));jQuery(this.activator).bind("click",{editor:this},this.clickHandler),this.element.trigger(jQuery.Event("best_in_place:deactivate")),null!==this.collectionValue&&"select"==this.formType&&(this.collectionValue=this.previousCollectionValue,this.previousCollectionValue=null)},loadErrorCallback:function(t,e){this.activateText(this.oldValue),this.element.trigger(jQuery.Event("best_in_place:error"),[t,e]),this.element.trigger(jQuery.Event("ajax:error"),t,e),jQuery(this.activator).bind("click",{editor:this},this.clickHandler),this.element.trigger(jQuery.Event("best_in_place:deactivate"))},clickHandler:function(t){t.preventDefault(),t.data.editor.activate()},setHtmlAttributes:function(){var t=this.element.find(this.formType);if(this.html_attrs){var e=jQuery.parseJSON(this.html_attrs);for(var i in e)t.attr(i,e[i])}}},BestInPlaceEditor.forms={input:{activateForm:function(){var t=jQuery(document.createElement("form")).addClass("form_in_place").attr("action","javascript:void(0);").attr("style","display:inline"),e=jQuery(document.createElement("input")).attr("type","text").attr("name",this.attributeName).val(this.display_value);null!==this.inner_class&&e.addClass(this.inner_class),t.append(e),this.okButton&&t.append(jQuery(document.createElement("input")).attr("type","submit").attr("class",this.okButtonClass).attr("value",this.okButton)),this.cancelButton&&t.append(jQuery(document.createElement("input")).attr("type","button").attr("class",this.cancelButtonClass).attr("value",this.cancelButton)),this.element.html(t),this.setHtmlAttributes(),this.element.find("input[type='text']")[0].select(),this.element.find("form").bind("submit",{editor:this},BestInPlaceEditor.forms.input.submitHandler),this.cancelButton&&this.element.find("input[type='button']").bind("click",{editor:this},BestInPlaceEditor.forms.input.cancelButtonHandler),this.element.find("input[type='text']").bind("blur",{editor:this},BestInPlaceEditor.forms.input.inputBlurHandler),this.element.find("input[type='text']").bind("keyup",{editor:this},BestInPlaceEditor.forms.input.keyupHandler),this.blurTimer=null,this.userClicked=!1},getValue:function(){return this.sanitizeValue(this.element.find("input").val())},inputBlurHandler:function(t){t.data.editor.okButton?t.data.editor.blurTimer=setTimeout(function(){t.data.editor.userClicked||t.data.editor.abort()},500):t.data.editor.cancelButton?t.data.editor.blurTimer=setTimeout(function(){t.data.editor.userClicked||t.data.editor.update()},500):t.data.editor.update()},submitHandler:function(t){t.data.editor.userClicked=!0,clearTimeout(t.data.editor.blurTimer),t.data.editor.update()},cancelButtonHandler:function(t){t.data.editor.userClicked=!0,clearTimeout(t.data.editor.blurTimer),t.data.editor.abort(),t.stopPropagation()},keyupHandler:function(t){27==t.keyCode&&t.data.editor.abort()}},date:{activateForm:function(){var t=this,e=jQuery(document.createElement("form")).addClass("form_in_place").attr("action","javascript:void(0);").attr("style","display:inline"),i=jQuery(document.createElement("input")).attr("type","text").attr("name",this.attributeName).attr("value",this.sanitizeValue(this.display_value));null!==this.inner_class&&i.addClass(this.inner_class),e.append(i),this.element.html(e),this.setHtmlAttributes(),this.element.find("input")[0].select(),this.element.find("form").bind("submit",{editor:this},BestInPlaceEditor.forms.input.submitHandler),this.element.find("input").bind("keyup",{editor:this},BestInPlaceEditor.forms.input.keyupHandler),this.element.find("input").datepicker({onClose:function(){t.update()}}).datepicker("show")},getValue:function(){return this.sanitizeValue(this.element.find("input").val())},submitHandler:function(t){t.data.editor.update()},keyupHandler:function(t){27==t.keyCode&&t.data.editor.abort()}},select:{activateForm:function(){var t=jQuery(document.createElement("form")).attr("action","javascript:void(0)").attr("style","display:inline");selected="",oldValue=this.oldValue,select_elt=jQuery(document.createElement("select")).attr("class",null!==this.inned_class?this.inner_class:""),currentCollectionValue=this.collectionValue,jQuery.each(this.values,function(t,e){var i=jQuery(document.createElement("option")).val(e[0]).html(e[1]);e[0]==currentCollectionValue&&i.attr("selected","selected"),select_elt.append(i)}),t.append(select_elt),this.element.html(t),this.setHtmlAttributes(),this.element.find("select").bind("change",{editor:this},BestInPlaceEditor.forms.select.blurHandler),this.element.find("select").bind("blur",{editor:this},BestInPlaceEditor.forms.select.blurHandler),this.element.find("select").bind("keyup",{editor:this},BestInPlaceEditor.forms.select.keyupHandler),this.element.find("select")[0].focus()},getValue:function(){return this.sanitizeValue(this.element.find("select").val())},blurHandler:function(t){t.data.editor.update()},keyupHandler:function(t){27==t.keyCode&&t.data.editor.abort()}},checkbox:{activateForm:function(){this.collectionValue=!this.getValue(),this.setHtmlAttributes(),this.update()},getValue:function(){return this.collectionValue}},textarea:{activateForm:function(){width=this.element.css("width"),height=this.element.css("height");var t=jQuery(document.createElement("form")).attr("action","javascript:void(0)").attr("style","display:inline").append(jQuery(document.createElement("textarea")).val(this.sanitizeValue(this.display_value)));this.okButton&&t.append(jQuery(document.createElement("input")).attr("type","submit").attr("value",this.okButton)),this.cancelButton&&t.append(jQuery(document.createElement("input")).attr("type","button").attr("value",this.cancelButton)),this.element.html(t),this.setHtmlAttributes(),jQuery(this.element.find("textarea")[0]).css({"min-width":width,"min-height":height}),jQuery(this.element.find("textarea")[0]).elastic(),this.element.find("textarea")[0].focus(),this.element.find("form").bind("submit",{editor:this},BestInPlaceEditor.forms.textarea.submitHandler),this.cancelButton&&this.element.find("input[type='button']").bind("click",{editor:this},BestInPlaceEditor.forms.textarea.cancelButtonHandler),this.element.find("textarea").bind("blur",{editor:this},BestInPlaceEditor.forms.textarea.blurHandler),this.element.find("textarea").bind("keyup",{editor:this},BestInPlaceEditor.forms.textarea.keyupHandler),this.blurTimer=null,this.userClicked=!1},getValue:function(){return this.sanitizeValue(this.element.find("textarea").val())},blurHandler:function(t){t.data.editor.okButton?t.data.editor.blurTimer=setTimeout(function(){t.data.editor.userClicked||t.data.editor.abortIfConfirm()},500):t.data.editor.cancelButton?t.data.editor.blurTimer=setTimeout(function(){t.data.editor.userClicked||t.data.editor.update()},500):t.data.editor.update()},submitHandler:function(t){t.data.editor.userClicked=!0,clearTimeout(t.data.editor.blurTimer),t.data.editor.update()},cancelButtonHandler:function(t){t.data.editor.userClicked=!0,clearTimeout(t.data.editor.blurTimer),t.data.editor.abortIfConfirm(),t.stopPropagation()},keyupHandler:function(t){27==t.keyCode&&t.data.editor.abortIfConfirm()}}},jQuery.fn.best_in_place=function(){function t(t){return t.data("bestInPlaceEditor")?void 0:(t.data("bestInPlaceEditor",new BestInPlaceEditor(t)),!0)}return jQuery(this.context).delegate(this.selector,"click",function(){var e=jQuery(this);t(e)&&e.click()}),this.each(function(){t(jQuery(this))}),this},function(t){"undefined"==typeof t.fn.elastic&&t.fn.extend({elastic:function(){var e=["paddingTop","paddingRight","paddingBottom","paddingLeft","fontSize","lineHeight","fontFamily","width","fontWeight"];return this.each(function(){function i(t,e){curratedHeight=Math.floor(parseInt(t,10)),r.height()!=curratedHeight&&r.css({height:curratedHeight+"px",overflow:e})}function n(){var t=r.val().replace(/&/g,"&amp;").replace(/  /g,"&nbsp;").replace(/<|>/g,"&gt;").replace(/\n/g,"<br />"),e=s.html().replace(/<br>/gi,"<br />");if(t+"&nbsp;"!=e&&(s.html(t+"&nbsp;"),Math.abs(s.height()+o-r.height())>3)){var n=s.height()+o;n>=l?i(l,"auto"):a>=n?i(a,"hidden"):i(n,"hidden")}}if("textarea"!=this.type)return!1;var r=t(this),s=t("<div />").css({position:"absolute",display:"none","word-wrap":"break-word"}),o=parseInt(r.css("line-height"),10)||parseInt(r.css("font-size"),"10"),a=parseInt(r.css("height"),10)||3*o,l=parseInt(r.css("max-height"),10)||Number.MAX_VALUE,h=0;for(0>l&&(l=Number.MAX_VALUE),s.appendTo(r.parent()),h=e.length;h--;)s.css(e[h].toString(),r.css(e[h].toString()));r.css({overflow:"hidden"}),r.bind("keyup change cut paste",function(){n()}),r.bind("blur",function(){l>s.height()&&(s.height()>a?r.height(s.height()):r.height(a))}),r.on("input paste",function(){setTimeout(n,250)}),n()})}})}(jQuery);