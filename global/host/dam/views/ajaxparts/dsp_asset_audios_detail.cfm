<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Razuna is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU Affero Public License
* along with Razuna. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the AGPL as described in Razuna's
* FLOSS exception. You should have received a copy of the FLOSS exception
* along with Razuna. If not, see <http://www.razuna.com/licenses/>.
*
--->
<cfoutput>
	<form name="form#attributes.file_id#" id="form#attributes.file_id#" method="post" action="#self#" onsubmit="filesubmit();return false;">
	<input type="hidden" name="#theaction#" value="#xfa.save#">
	<input type="hidden" name="langcount" value="#valuelist(qry_langs.lang_id)#">
	<input type="hidden" name="folder_id" value="#qry_detail.detail.folder_id_r#">
	<input type="hidden" name="file_id" id="file_id" value="#attributes.file_id#">
	<input type="hidden" name="theorgname" id="theorgname" value="#qry_detail.detail.aud_name#">
	<input type="hidden" name="theorgext" id="theorgext" value="#qry_detail.detail.aud_extension#">
	<input type="hidden" name="thepath" id="thepath" value="#thisPath#">
	<input type="hidden" name="theos" value="#server.os.name#">
	<input type="hidden" name="filenameorg" value="#qry_detail.detail.aud_name_org#">
	<input type="hidden" name="customfields" value="#qry_cf.recordcount#">
	<input type="hidden" name="convert_width_3gp" value="">
	<input type="hidden" name="convert_height_3gp" value="">
	<input type="hidden" name="link_kind" id="link_kind" value="#qry_detail.detail.link_kind#">
	<div id="tab_detail#file_id#">
		<ul>
			<li><a href="##detailinfo" onclick="loadcontent('relatedaudios','#myself#c.audios_detail_related&file_id=#attributes.file_id#&what=audios&loaddiv=#attributes.loaddiv#&folder_id=#qry_detail.detail.folder_id_r#&s=#qry_detail.detail.shared#');loadcontent('additionalversions','#myself#c.av_load&file_id=#attributes.file_id#');">#myFusebox.getApplicationData().defaults.trans("asset_information")#</a></li>
			<!--- Convert --->
			<cfif qry_detail.detail.link_kind NEQ "url" AND cs.tab_convert_files>
				<li><a href="##convertt" onclick="loadrenaud();">#myFusebox.getApplicationData().defaults.trans("convert")#</a></li>
			</cfif>
			<!--- Metadata --->
			<cfif cs.tab_metadata>
				<li><a href="##meta">Meta Data</a></li>
			</cfif>
			<cfif attributes.folderaccess NEQ "R" AND qry_detail.detail.link_kind NEQ "url" AND qry_detail.detail.link_kind NEQ "lan">
				<cfif cs.tab_versions>
					<li><a href="##divversions" onclick="loadcontent('divversions','#myself#c.versions&file_id=#attributes.file_id#&type=#attributes.cf_show#&folder_id=#attributes.folder_id#');">#myFusebox.getApplicationData().defaults.trans("versions_header")#</a></li>
				</cfif>
			</cfif>
			<!--- Comments --->
			<cfif cs.tab_comments>
				<li><a href="##divcomments" onclick="loadcontent('divcomments','#myself#c.comments&file_id=#attributes.file_id#&type=#attributes.cf_show#&folder_id=#qry_detail.detail.folder_id_r#');">#myFusebox.getApplicationData().defaults.trans("comments")# (#qry_comments_total#)</a></li>
			</cfif>
			<cfif attributes.folderaccess NEQ "R">
				<cfif cs.tab_sharing_options>
					<li><a href="##shareoptions" onclick="loadcontent('shareoptions','#myself#c.share_options&file_id=#attributes.file_id#&folder_id=#attributes.folder_id#&type=#attributes.cf_show#');">#myFusebox.getApplicationData().defaults.trans("tab_sharing_options")#</a></li>
				</cfif>
				<cfif cs.tab_history>
					<li><a href="##history" onclick="loadcontent('history','#myself#c.log_history&id=#attributes.file_id#');">History</a></li>
				</cfif>
			</cfif>
		</ul>
		<div id="detailinfo">
			<!--- The Buttons --->
			<cfset what = "audios">
			<cfinclude template="inc_detail_buttons.cfm" />
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<!--- Description when url is a link --->
				<cfif qry_detail.detail.link_kind NEQ "">
					<tr>
						<td colspan="2"><strong>#myFusebox.getApplicationData().defaults.trans("link_url_desc")#</strong></td>
					</tr>
				</cfif>
				<!--- If cloud url is empty --->
				<cfif (application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix") AND qry_detail.detail.cloud_url_org EQ "" AND qry_detail.detail.link_kind NEQ "url">
					<tr>
						<td colspan="2"><h2 style="color:red;">It looks like this file could not be added to the system properly. Please delete it and add it again!</h2></td>
					</tr>
				</cfif>
				<tr>
					<td width="100%" nowrap="true" valign="top" align="center" style="padding-top:20px;padding-right:10px;">
						<iframe src="#myself#ajax.audios_detail_flash&file_id=#attributes.file_id#&path_to_asset=#qry_detail.detail.path_to_asset#&aud_name=#qry_detail.detail.aud_name_org#&aud_extension=#qry_detail.detail.aud_extension#&link_kind=#qry_detail.detail.link_kind#&link_path_url=#URLEncodedFormat(qry_detail.detail.link_path_url)#&fromdetail=T<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix">&cloud_url=#urlencodedformat(qry_detail.detail.cloud_url)#&cloud_url_org=#urlencodedformat(qry_detail.detail.cloud_url_org)#</cfif>" frameborder="false" scrolling="false" style="border:0px;width:400px;height:150px;" id="ifupload"></iframe>
						<cfif qry_detail.detail.link_kind EQ "url">
							<br /><a href="#qry_detail.detail.link_path_url#" target="_blank">#qry_detail.detail.link_path_url#</a>
						<cfelseif qry_detail.detail.link_kind EQ "lan">
							<br />#qry_detail.detail.link_path_url#
						</cfif>
					</td>
					<td colspan="2" style="padding-top:20px;">
						<table border="0" width="100%" cellpadding="0" cellspacing="0" class="grid">
							<!--- Filename --->
							<tr>
								<td width="1%" nowrap="true"><strong>#myFusebox.getApplicationData().defaults.trans("file_name")#</strong></td>
								<td width="1%" nowrap="true"><input type="text" style="width:400px;" name="fname" value="#qry_detail.detail.aud_name#" onchange="document.form#attributes.file_id#.file_name.value = document.form#attributes.file_id#.fname.value;"> <a href="##" onclick="loadcontent('thedropfav','#myself##xfa.tofavorites#&favid=#attributes.file_id#&favtype=file&favkind=aud');flash_footer();return false;"><img src="#dynpath#/global/host/dam/images/favs_16.png" width="16" height="16" border="0" /></a></td>
							</tr>
							<!--- Desc --->
							<cfloop query="qry_langs">
								<cfif lang_id EQ 1>
									<cfset thisid = lang_id>
									<tr>
										<td valign="top" width="1%" nowrap="true"><strong>#myFusebox.getApplicationData().defaults.trans("description")#</strong></td>
										<td width="100%"><textarea name="desc_#thisid#" class="text" style="width:400px;height:30px;" onchange="document.form#attributes.file_id#.aud_desc_#thisid#.value = document.form#attributes.file_id#.desc_#thisid#.value;"><cfloop query="qry_detail.desc"><cfif lang_id_r EQ thisid>#aud_description#</cfif></cfloop></textarea></td>
									</tr>
									<tr>
										<td valign="top" width="1%" nowrap="true"><strong>#myFusebox.getApplicationData().defaults.trans("keywords")#</strong></td>
										<td width="100%"><textarea name="keywords_#thisid#" class="text" style="width:400px;height:30px;" onchange="document.form#attributes.file_id#.aud_keywords_#thisid#.value = document.form#attributes.file_id#.keywords_#thisid#.value;"><cfloop query="qry_detail.desc"><cfif lang_id_r EQ thisid>#aud_keywords#</cfif></cfloop></textarea></td>
									</tr>
								</cfif>
							</cfloop>
							<cfif cs.tab_labels>
								<tr>
									<td><strong>#myFusebox.getApplicationData().defaults.trans("labels")#</strong></td>
									<td width="100%" nowrap="true" colspan="5">
										<select data-placeholder="Choose a label" class="chzn-select" style="width:400px;" id="tags_aud" onchange="razaddlabels('tags_aud','#attributes.file_id#','aud');" multiple="multiple">
											<option value=""></option>
											<cfloop query="attributes.thelabelsqry">
												<option value="#label_id#"<cfif ListFind(qry_labels,'#label_id#') NEQ 0> selected="selected"</cfif>>#label_path#</option>
											</cfloop>
										</select>
										<cfif qry_label_set.set2_labels_users EQ "t" OR (Request.securityobj.CheckSystemAdminUser() OR Request.securityobj.CheckAdministratorUser())>
											<a href="##" onclick="showwindow('#myself#c.admin_labels_add&label_id=0&closewin=2','Create new label',450,2);return false"><img src="#dynpath#/global/host/dam/images/list-add-3.png" width="24" height="24" border="0" style="margin-left:-2px;" /></a>
										</cfif>
									</td>
								</tr>
							</cfif>
							<tr>
								<td width="1%" nowrap="true">#myFusebox.getApplicationData().defaults.trans("file_size")#</td>
								<td width="1%" nowrap="true"><cfif qry_detail.detail.link_kind NEQ "url">#qry_detail.thesize# MB<cfelse>n/a</cfif></td>
							</tr>
							<tr>
								<td width="1%" nowrap="true">#myFusebox.getApplicationData().defaults.trans("date_created")#</td>
								<td width="1%" nowrap="true">#dateformat(qry_detail.detail.aud_create_time, "#myFusebox.getApplicationData().defaults.getdateformat()#")#</td>
							</tr>
							<tr>
								<td width="1%" nowrap="true" valign="top">#myFusebox.getApplicationData().defaults.trans("date_changed")#</td>
								<td width="1%" nowrap="true" valign="top">#dateformat(qry_detail.detail.aud_change_time, "#myFusebox.getApplicationData().defaults.getdateformat()#")#</td>
							</tr>
							<tr>
								<td width="1%" nowrap="true" valign="top">#myFusebox.getApplicationData().defaults.trans("located_in")#</td>
								<td width="1%" nowrap="true" valign="top">#qry_detail.detail.folder_name# <a href="" onclick="loadcontent('thedropfav','#myself##xfa.tofavorites#&favid=#qry_detail.detail.folder_id_r#&favtype=folder&favkind=');flash_footer();return false;"><img src="#dynpath#/global/host/dam/images/favs_16.png" width="16" height="16" border="0" /></a></td>
							</tr>
							<tr>
								<td width="1%" nowrap="true" valign="top">#myFusebox.getApplicationData().defaults.trans("created_by")#</td>
								<td width="1%" nowrap="nowrap">#qry_detail.detail.user_first_name# #qry_detail.detail.user_last_name#</td>
							</tr>
							<tr>
								<td nowrap="true" valign="top">ID</td>
								<td  nowrap="true" valign="top" colspan="5">#attributes.file_id#</td>
							</tr>
						</table>
					</td>
				</tr>
				<!--- Submit Button --->
				<tr>
					<td colspan="3" width="100%">
						<cfif attributes.folderaccess NEQ "R">
							<div style="float:right;padding:10px;"><input type="submit" name="submit" value="#myFusebox.getApplicationData().defaults.trans("button_save")#" class="button"></div>
						<cfelse>
							<div style="float:right;padding:20px;"></div>
						</cfif>
					</td>
				</tr>
			</table>
		</div>
		<!--- Comments --->
		<div id="divcomments"></div>
		<!--- Meta Data --->
		<cfif cs.tab_metadata>
			<div id="meta" class="collapsable">
				<!--- Description & Keywords --->
				<cfif cs.tab_description_keywords>
					<!--- Description & Keywords --->
					<a href="##" onclick="$('##detaildesc').slideToggle('slow');return false;"><div class="headers">&gt; #myFusebox.getApplicationData().defaults.trans("asset_desc")#</div></a>
					<div id="detaildesc">
						<table border="0" cellpadding="0" cellspacing="0" width="100%" class="grid">
							<!--- Filename --->
							<tr>
								<td width="1%" nowrap="true"><strong>#myFusebox.getApplicationData().defaults.trans("file_name")#</strong></td>
								<td width="1%" nowrap="true"><input type="text" style="width:400px;" name="file_name" value="#qry_detail.detail.aud_name#" onchange="document.form#attributes.file_id#.fname.value = document.form#attributes.file_id#.file_name.value;"> <a href="##" onclick="loadcontent('thedropfav','#myself##xfa.tofavorites#&favid=#attributes.file_id#&favtype=file&favkind=aud');flash_footer();return false;"><img src="#dynpath#/global/host/dam/images/favs_16.png" width="16" height="16" border="0" /></a></td>
							</tr>
							<cfloop query="qry_langs">
								<cfset thisid = lang_id>
								<tr>
									<td valign="top" width="1%" nowrap="true"><strong>#myFusebox.getApplicationData().defaults.trans("description")#</strong></td>
									<td width="100%"><textarea name="aud_desc_#thisid#" class="text" style="width:400px;height:30px;" <cfif lang_id EQ 1>onchange="document.form#attributes.file_id#.desc_#thisid#.value = document.form#attributes.file_id#.aud_desc_#thisid#.value;"</cfif>><cfloop query="qry_detail.desc"><cfif lang_id_r EQ thisid>#aud_description#</cfif></cfloop></textarea></td>
								</tr>
								<tr>
									<td valign="top" width="1%" nowrap="true"><strong>#myFusebox.getApplicationData().defaults.trans("keywords")#</strong></td>
									<td width="100%"><textarea name="aud_keywords_#thisid#" class="text" style="width:400px;height:30px;" <cfif lang_id EQ 1>onchange="document.form#attributes.file_id#.keywords_#thisid#.value = document.form#attributes.file_id#.aud_keywords_#thisid#.value;"</cfif>><cfloop query="qry_detail.desc"><cfif lang_id_r EQ thisid>#aud_keywords#</cfif></cfloop></textarea></td>
								</tr>
							</cfloop>
						</table>
					</div>
					<div stlye="clear:both;"></div>
				</cfif>
				<!--- CUSTOM FIELDS --->
				<cfif qry_cf.recordcount NEQ 0 AND cs.tab_custom_fields>
					<br />
					<a href="##" onclick="$('##customfields').slideToggle('slow');return false;"><div class="headers">&gt; #myFusebox.getApplicationData().defaults.trans("custom_fields_asset")#</div></a>
					<div id="customfields">
						<cfinclude template="inc_custom_fields.cfm">
					</div>
					<div stlye="clear:both;"></div>
				</cfif>
				<!--- Raw Metadata --->
				<cfif qry_detail.detail.link_kind NEQ "url">
					<br />
					<a href="##" onclick="$('##rawmetadata').slideToggle('slow');return false;"><div class="headers">&gt; Raw Metadata</div></a>
					<div id="rawmetadata" style="display:none;padding-top:10px;">
						<textarea class="text" style="width:700px;height:400px;">#qry_detail.detail.aud_meta#</textarea>
					</div>
				</cfif>
				<!--- Submit Button --->
				<cfif attributes.folderaccess NEQ "R">
					<div stlye="clear:both;"></div>
					<div style="float:right;padding:10px;"><input type="submit" name="submit" value="#myFusebox.getApplicationData().defaults.trans("button_save")#" class="button"></div>
				</cfif>
			</div>
		</cfif>
		<!--- Convert Audios --->
		<cfif qry_detail.detail.link_kind NEQ "url" AND cs.tab_convert_files>
			<div id="convertt">
				<cfif session.hosttype EQ 0>
					<cfinclude template="dsp_host_upgrade.cfm">
				<cfelse>
					<cfinclude template="dsp_asset_audios_convert.cfm">
				</cfif>
			</div>
			<!--- VERSIONS --->
			<cfif qry_detail.detail.link_kind NEQ "lan">
				<div id="divversions"></div>
			</cfif>
		</cfif>
		<!--- SHARING OPTIONS --->
		<cfif attributes.folderaccess NEQ "R">
			<div id="shareoptions"></div>
			<div id="history"></div>
		</cfif>
		</div>
		<cfif attributes.folderaccess NEQ "R">
			<div id="updatefile" style="float:left;padding:10px;color:green;font-weight:bold;display:none;"></div>
		</cfif>
	</form>
	<!--- Activate the Tabs --->
	<script language="JavaScript" type="text/javascript">
		jqtabs("tab_detail#attributes.file_id#");
		// Load renditions
		function loadrenaud(){
			<cfif qry_detail.detail.link_kind NEQ "url">
				$('##relatedaudios').load('#myself#c.audios_detail_related&file_id=#attributes.file_id#&what=audios&loaddiv=#attributes.loaddiv#&folder_id=#qry_detail.detail.folder_id_r#&s=#qry_detail.detail.shared#<cfif application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix">&cloud_url_org=#urlencodedformat(qry_detail.detail.cloud_url_org)#</cfif>');
			</cfif>
			$('##additionalversions').load('#myself#c.av_load&file_id=#attributes.file_id#');
			<cfif cs.tab_additional_renditions>
				$('##moreversions').load('#myself#c.adi_versions&file_id=#attributes.file_id#&folder_id=#attributes.folder_id#&type=#attributes.cf_show#');
			</cfif>
		};
		// Submit form
		function filesubmit(){
			$("##updatefile").css("display","");
			loadinggif('updatefile');
			$("##updatefile").fadeTo("fast", 100);
			var url = formaction("form#attributes.file_id#");
			var items = formserialize("form#attributes.file_id#");
			// Submit Form
	       	$.ajax({
				type: "POST",
				url: url,
			   	data: items,
			   	success: function(){
					// Update Text
					$("##updatefile").html("#myFusebox.getApplicationData().defaults.trans("success")#");
					$("##updatefile").animate({opacity: 1.0}, 3000).fadeTo("slow", 0);
			   	}
			});
	        return false; 
		};
		// Activate Chosen
		$(".chzn-select").chosen();
	</script>
</cfoutput>