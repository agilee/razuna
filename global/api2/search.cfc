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
<cfcomponent output="false" extends="authentication">
	
	<!--- Retrieve assets from a folder --->
	<cffunction name="searchassets" access="remote" output="false" returntype="query" returnformat="json">
		<cfargument name="api_key" type="string" required="true">
		<cfargument name="searchfor" type="string" required="true">
		<cfargument name="show" type="string" required="false" default="all">
		<cfargument name="doctype" type="string" required="false" default="">
		<!--- Check key --->
		<cfset var thesession = checkdb(arguments.api_key)>
		<!--- Check to see if session is valid --->
		<cfif thesession>
			<!--- Params --->
			<cfset var imgc = false>
			<cfset var vidc = false>
			<cfset var audc = false>
			<cfset var docc = false>
			<!--- Images --->
			<cfif arguments.show EQ "ALL" OR arguments.show EQ "img">
				<!--- Search in Lucene --->
				<cfinvoke component="global.cfc.lucene" method="search" criteria="#arguments.searchfor#" category="img" hostid="#application.razuna.api.hostid["#arguments.api_key#"]#" returnvariable="qryluceneimg">
				<!--- If lucene returns no records --->
				<cfif qryluceneimg.recordcount NEQ 0>
					<!--- Sometimes it can happen that the category tree is empty thus we filter them with a QoQ here --->
					<cfquery dbtype="query" name="cattreeimg">
					SELECT categorytree
					FROM qryluceneimg
					WHERE categorytree != ''
					GROUP BY categorytree
					ORDER BY categorytree
					</cfquery>
				</cfif>
			</cfif>
			<!--- Videos --->
			<cfif arguments.show EQ "ALL" OR arguments.show EQ "vid">
				<!--- Search in Lucene --->
				<cfinvoke component="global.cfc.lucene" method="search" criteria="#arguments.searchfor#" category="vid" hostid="#application.razuna.api.hostid["#arguments.api_key#"]#" returnvariable="qrylucenevid">
				<!--- If lucene returns no records --->
				<cfif qrylucenevid.recordcount NEQ 0>
					<!--- Sometimes it can happen that the category tree is empty thus we filter them with a QoQ here --->
					<cfquery dbtype="query" name="cattreevid">
					SELECT categorytree
					FROM qrylucenevid
					WHERE categorytree != ''
					GROUP BY categorytree
					ORDER BY categorytree
					</cfquery>
				</cfif>
			</cfif>
			<!--- Audios --->
			<cfif arguments.show EQ "ALL" OR arguments.show EQ "aud">
				<!--- Search in Lucene --->
				<cfinvoke component="global.cfc.lucene" method="search" criteria="#arguments.searchfor#" category="aud" hostid="#application.razuna.api.hostid["#arguments.api_key#"]#" returnvariable="qryluceneaud">
				<!--- If lucene returns no records --->
				<cfif qryluceneaud.recordcount NEQ 0>
					<!--- Sometimes it can happen that the category tree is empty thus we filter them with a QoQ here --->
					<cfquery dbtype="query" name="cattreeaud">
					SELECT categorytree
					FROM qryluceneaud
					WHERE categorytree != ''
					GROUP BY categorytree
					ORDER BY categorytree
					</cfquery>
				</cfif>
			</cfif>
			<!--- Doc --->
			<cfif arguments.show EQ "ALL" OR arguments.show EQ "doc">
				<!--- Search in Lucene --->
				<cfinvoke component="global.cfc.lucene" method="search" criteria="#arguments.searchfor#" category="doc" hostid="#application.razuna.api.hostid["#arguments.api_key#"]#" returnvariable="qrylucenedoc">
				<!--- If lucene returns no records --->
				<cfif qrylucenedoc.recordcount NEQ 0>
					<!--- Sometimes it can happen that the category tree is empty thus we filter them with a QoQ here --->
					<cfquery dbtype="query" name="cattreedoc">
					SELECT categorytree
					FROM qrylucenedoc
					WHERE categorytree != ''
					GROUP BY categorytree
					ORDER BY categorytree
					</cfquery>
				</cfif>
			</cfif>
			<!--- Query --->
			<cfquery datasource="#application.razuna.api.dsn#" name="qry">
				<!--- Images --->
				<cfif arguments.show EQ "ALL" OR arguments.show EQ "img">
					<cfset imgc = true>
					SELECT <cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(i.img_id, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(i.img_id, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(i.img_id, '0')</cfif> id, 
					i.img_filename filename, 
					i.folder_id_r folder_id, 
					i.img_extension extension, 
					'dummy' as video_image,
					i.img_filename_org filename_org, 
					'img' as kind, 
					i.thumb_extension extension_thumb, 
					i.path_to_asset, 
					i.cloud_url, 
					i.cloud_url_org,
					<cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(i.img_size, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(i.img_size, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(i.img_size,'0')</cfif> AS size,
					i.img_width AS width,
					i.img_height AS height,
					it.img_description description, 
					it.img_keywords keywords,
                    <cfif application.razuna.api.thedatabase EQ "oracle" OR application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">
					    concat('http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/',i.path_to_asset,'/',i.img_filename_org) AS local_url_org,
					    concat('http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/',i.path_to_asset,'/','thumb_',i.img_id,'.',i.thumb_extension) AS local_url_thumb
                    <cfelseif application.razuna.api.thedatabase EQ "mssql">
                        'http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/' + i.path_to_asset + '/'  + i.img_filename_org AS local_url_org,
                        'http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/' + i.path_to_asset + '/' + 'thumb_' + i.img_id + '.' + i.thumb_extension AS local_url_thumb
                    </cfif>
					FROM #application.razuna.api.prefix["#arguments.api_key#"]#images i 
					LEFT JOIN #application.razuna.api.prefix["#arguments.api_key#"]#images_text it ON i.img_id = it.img_id_r AND it.lang_id_r = 1
					WHERE i.img_id IN (<cfif qryluceneimg.recordcount EQ 0>'0'<cfelse><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#valuelist(cattreeimg.categorytree)#" list="Yes"></cfif>)
					AND i.host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#application.razuna.api.hostid["#arguments.api_key#"]#">
					AND (i.img_group IS NULL OR i.img_group = '')
				</cfif>
				<cfif arguments.show EQ "ALL">
					UNION ALL
				</cfif>
				<!--- Videos --->
				<cfif arguments.show EQ "ALL" OR arguments.show EQ "vid">
					<cfset vidc = true>
					SELECT <cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(v.vid_id, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(v.vid_id, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(v.vid_id, '0')</cfif> id, 
					v.vid_filename filename, 
					v.folder_id_r folder_id, 
					v.vid_extension extension, 
					v.vid_name_image as video_image,
					v.vid_name_org filename_org, 
					'vid' as kind, 
					v.vid_name_image extension_thumb, 
					v.path_to_asset, 
					v.cloud_url, 
					v.cloud_url_org,
					<cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(v.vid_size, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(v.vid_size, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(v.vid_size, '0')</cfif> AS size, 
					v.vid_width AS width,
					v.vid_height AS height,
					vt.vid_description description, 
					vt.vid_keywords keywords,
	                <cfif application.razuna.api.thedatabase EQ "oracle" OR application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">
		                concat('http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/',v.path_to_asset,'/',v.vid_name_org) AS local_url_org,
		                concat('http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/',v.path_to_asset,'/',v.vid_name_image) AS local_url_preview
	                <cfelseif application.razuna.api.thedatabase EQ "mssql">
		                'http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/' + v.path_to_asset + '/' + v.vid_name_org AS local_url_org,
		                'http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/' + v.path_to_asset + '/' + v.vid_name_image AS local_url_preview
                    </cfif>
                    FROM #application.razuna.api.prefix["#arguments.api_key#"]#videos v 
					LEFT JOIN #application.razuna.api.prefix["#arguments.api_key#"]#videos_text vt ON v.vid_id = vt.vid_id_r AND vt.lang_id_r = 1
					WHERE v.vid_id IN (<cfif qrylucenevid.recordcount EQ 0>'0'<cfelse><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#valuelist(cattreevid.categorytree)#" list="Yes"></cfif>)
					AND (v.vid_group IS NULL OR v.vid_group = '')
					AND v.host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#application.razuna.api.hostid["#arguments.api_key#"]#">
				</cfif>
				<cfif arguments.show EQ "ALL">
					UNION ALL
				</cfif>
				<!--- Audios --->
				<cfif arguments.show EQ "ALL" OR arguments.show EQ "aud">
					<cfset audc = true>
					SELECT <cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(a.aud_id, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(a.aud_id, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(a.aud_id, '0')</cfif> id, 
					a.aud_name filename, 
					a.folder_id_r folder_id, 
					a.aud_extension extension, 
					'dummy' as video_image,
					a.aud_name_org filename_org, 
					'aud' as kind, 
					a.aud_extension extension_thumb, 
					a.path_to_asset, 
					a.cloud_url, 
					a.cloud_url_org,
					<cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(a.aud_size, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(a.aud_size, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(a.aud_size, '0')</cfif> AS size,
					0 AS width,
					0 AS height,
					aut.aud_description description, 
					aut.aud_keywords keywords,
	                <cfif application.razuna.api.thedatabase EQ "oracle" OR application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">
		                concat('http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/',a.path_to_asset,'/',a.aud_name_org) AS local_url_org,
	                <cfelseif application.razuna.api.thedatabase EQ "mssql">
		                'http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/' + a.path_to_asset + '/' + a.aud_name_org AS local_url_org,
                     </cfif>
					'0' as local_url_thumb
					FROM #application.razuna.api.prefix["#arguments.api_key#"]#audios a 
					LEFT JOIN #application.razuna.api.prefix["#arguments.api_key#"]#audios_text aut ON a.aud_id = aut.aud_id_r AND aut.lang_id_r = 1
					WHERE a.aud_id IN (<cfif qryluceneaud.recordcount EQ 0>'0'<cfelse><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#valuelist(cattreeaud.categorytree)#" list="Yes"></cfif>)
					AND (a.aud_group IS NULL OR a.aud_group = '')
					AND a.host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#application.razuna.api.hostid["#arguments.api_key#"]#">
				</cfif>
				<cfif arguments.show EQ "ALL">
					UNION ALL
				</cfif>
				<!--- Docs --->
				<cfif arguments.show EQ "ALL" OR arguments.show EQ "doc">
					<cfset docc = true>
					SELECT <cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(f.file_id, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(f.file_id, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(f.file_id, '0')</cfif> id, 
					f.file_name filename, 
					f.folder_id_r folder_id, 
					f.file_extension extension, 
					'dummy' as video_image,
					f.file_name_org filename_org, 
					'doc' as kind, 
					f.file_extension extension_thumb, 
					f.path_to_asset, 
					f.cloud_url, 
					f.cloud_url_org,
					<cfif application.razuna.api.thedatabase EQ "oracle">to_char(NVL(f.file_size, 0))<cfelseif application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">cast(ifnull(f.file_size, 0) AS char)<cfelseif application.razuna.api.thedatabase EQ "mssql">isnull(f.file_size, '0')</cfif> AS size, 
					0 AS width,
					0 AS height,
					ft.file_desc description, 
					ft.file_keywords keywords,
	                <cfif application.razuna.api.thedatabase EQ "oracle" OR application.razuna.api.thedatabase EQ "mysql" OR application.razuna.api.thedatabase EQ "h2">
		                concat('http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/',f.path_to_asset,'/',f.file_name_org) AS local_url_org,
	                <cfelseif application.razuna.api.thedatabase EQ "mssql">
		                'http://#cgi.HTTP_HOST#/#application.razuna.api.dynpath#/assets/#application.razuna.api.hostid["#arguments.api_key#"]#/' + f.path_to_asset + '/' + f.file_name_org AS local_url_org,
                    </cfif>
					'0' as local_url_thumb
					FROM #application.razuna.api.prefix["#arguments.api_key#"]#files f 
					LEFT JOIN #application.razuna.api.prefix["#arguments.api_key#"]#files_desc ft ON f.file_id = ft.file_id_r AND ft.lang_id_r = 1
					WHERE f.file_id IN (<cfif qrylucenedoc.recordcount EQ 0>'0'<cfelse><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#valuelist(cattreedoc.categorytree)#" list="Yes"></cfif>)
					AND f.host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#application.razuna.api.hostid["#arguments.api_key#"]#">
				</cfif>
	            GROUP BY id, filename, folder_id, extension, filename_org, path_to_asset, cloud_url, cloud_url_org, size, description, keywords				
				ORDER BY filename 
			</cfquery>
			<!--- If we query for doc only and have a filetype we filter the results --->
			<cfif arguments.show NEQ "all" AND arguments.show EQ "doc" AND arguments.doctype NEQ "">
				<cfquery dbtype="query" name="qry">
				SELECT *
				FROM qry
				<cfswitch expression="#arguments.doctype#">
					<cfcase value="doc">
						WHERE qry.extension = <cfqueryparam value="doc" cfsqltype="cf_sql_varchar">
					</cfcase>
					<cfcase value="xls">
						WHERE qry.extension = <cfqueryparam value="xls" cfsqltype="cf_sql_varchar">
					</cfcase>
					<cfcase value="pdf">
						WHERE qry.extension = <cfqueryparam value="pdf" cfsqltype="cf_sql_varchar">
					</cfcase>
					<cfcase value="other">
						WHERE qry.extension != <cfqueryparam value="pdf" cfsqltype="cf_sql_varchar">
						AND qry.extension != <cfqueryparam value="xls" cfsqltype="cf_sql_varchar">
						AND qry.extension != <cfqueryparam value="xlsx" cfsqltype="cf_sql_varchar">
						AND qry.extension != <cfqueryparam value="doc" cfsqltype="cf_sql_varchar">
						AND qry.extension != <cfqueryparam value="docx" cfsqltype="cf_sql_varchar">
					</cfcase>
				</cfswitch>
				</cfquery>
			</cfif>
			<!--- Set responsecode --->
			<cfif qry.recordcount NEQ 0>
				<cfset rescode = 0>
			<cfelse>
				<cfset rescode = 1>
			</cfif>
			<!--- Add our own tags to the query --->
			<cfset q = querynew("responsecode,totalassetscount,calledwith")>
			<cfset queryaddrow(q,1)>
			<cfset querysetcell(q,"responsecode",rescode)>
			<cfset querysetcell(q,"totalassetscount",qry.recordcount)>
			<cfset querysetcell(q,"calledwith",arguments.searchfor)>
			<!--- Put the 2 queries together --->
			<cfquery dbtype="query" name="thexml">
			SELECT *
			FROM qry, q
			</cfquery>
		<!--- No session found --->
		<cfelse>
			<cfset var thexml = timeout()>
		</cfif>
		<!--- Return --->
		<cfreturn thexml>
	</cffunction>
	
</cfcomponent>