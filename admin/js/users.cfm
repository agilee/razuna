<script type="text/javascript">
	// Fire the form submit for new or update user
	function saveuserform(form){
		if (Spry.Widget.Form.validate(form) == true){
			Spry.Utils.submitForm(form, saveuser);
		}
			return false;
	}
	function updateuserform(form){
		if (Spry.Widget.Form.validate(form) == true){
			Spry.Utils.submitForm(form, updateusersdiv);
		}
			return false;
	}
	// Feedback for updating user
	function updateusersdiv(){
		// Hide window
		thewindow.hide();
		// Show the user list
		Spry.Utils.updateContent('rightside', '<cfoutput>#myself#</cfoutput>c.users');
	}
	// Feedback for new user
	function saveuser(){
		document.getElementById('updatetext').style.display = "block";
		document.getElementById('updatetext').innerHTML='<cfoutput>#defaultsObj.trans("success")#</cfoutput>';
		// document.getElementById('updatetext2').style.visibility = "visible";
		//document.getElementById('updatetext2').innerHTML='<cfoutput>#defaultsObj.trans("success")#</cfoutput><br>';
	}
	
	function checkemail(){
		Spry.Utils.updateContent('checkemaildiv', '<cfoutput>#myself#</cfoutput>c.checkemail&user_email=' + document.userdetailadd.user_email.value + '&user_id=' + document.userdetailadd.user_id.value);
	}
	
	function checkusername(){
		Spry.Utils.updateContent('checkusernamediv', '<cfoutput>#myself#</cfoutput>c.checkusername&user_login_name=' + escape(document.userdetailadd.user_login_name.value) + '&user_id=' + document.userdetailadd.user_id.value);
	}
</script>
