{*  Search engine popup  $Id: lookup.tpl,v 1.13 2009/04/04 16:21:33 andig2 Exp $*}
{include file="xml.tpl"}
<body>
<script language="JavaScript" type="text/javascript" src="javascript/lookup.js"></script>

<center>
<table width="95%" cellpadding="0" cellspacing="2">
<tr valign="bottom">
	{foreach key=e item=eng from=$engines}
    <td><div class="divbutton"><a href="{$eng.url}" style="text-decoration: none;">{if $engine == $e}» {/if}{$eng.name}</a></div></td>
	{/foreach}
</tr>
</table>

<form action="lookup.php" id="lookup" name="lookup">
<table width="95%" cellpadding="5" cellspacing="2">
<tr>
    <td nowrap="nowrap" class="forumheader3">
        <input type="text" name="find" id="find" value="{$q_find}" size="31" />
        {include file="lookup_engines.tpl"}
        <input type="submit" value="{$lang.l_search}" class="button" />
        <script language="JavaScript" type="text/javascript">document.lookup.find.focus();</script>
    </td>
</tr>
</table>
</form>

<table width="95%" cellspacing="2" cellpadding="0">
<tr>
    <td class="forumheader3">
	<br/>
	{if $http_error}
		<pre>{$http_error}</pre>
	{/if}
	{if $imdbresults}
	    <b>{$lang.l_select}</b>
	    {if $searchtype == 'image'}
	    <table border="0" cellpadding="0" cellspacing="0" width="100%">
	    <tr>
		{counter assign=count name=castcount start=0}
		{foreach item=match from=$imdbresults}
		{if $count == 3}
		    {counter start=0 print=false name=castcount}
		    </tr>
		    <tr>
		{/if}
		{counter assign=count name=castcount}
		<td align="center" valign="top" width="33%">
		    <table border="0" cellpadding="0" cellspacing="2" width="100%">
		    <tr>
				<td valign="center" height="105" class="forumheader3" style="text-align: center" colspan="2">
					<a href="javascript:void(returnImage('{$match.coverurl|escape:"javascript"}'));" title="Select image and close Window">
					<img src="templates/jeckyll/img.php?img={$match.imgsmall}" align="center" border="0" />
					</a>
				</td>
		    </tr>
		    <tr>
				<td align="center" class="forumheader3" width="100%">
					{$match.title}
				</td>
				<td width="13" class="forumheader3">
					<a href="{$match.coverurl|escape:"javascript"}" target="_new"><img src="templates/jeckyll/images/urlextern.gif" border="0"></a>
				</td>
		    </tr>
		    </table>
		</td>
		{/foreach}
	    </tr>
	    </table>
	    {else}
		<ul>
		{foreach item=match from=$imdbresults}
			<li>
				<a href="javascript:void(returnData('{$match.id}','{$match.title|escape:"javascript"}','{$match.subtitle|escape:"javascript"}', '{$engine}'));" title="add ID and close Window">
				{$match.title}{if $match.subtitle} - {$match.subtitle}{/if}
				</a>
				{if $match.details or $match.imgsmall}
					<br/>
					<font size="-2">
					{if $match.imgsmall}
						<img src="{$match.imgsmall}" align="left" width="25" height="35" />
					{/if}
					{$match.details}
					</font>
				{/if}
				<br clear="all" />
			</li>
	    {/foreach}
	    </ul>
	{/if}
	{else}
	    <div align="center"><b>{$lang.l_nothing}</b></div>
	    <br />
	{/if}
	<br clear="all" />
	<div align="center">
	[ <a href="{$searchurl}" target="_blank">{$lang.l_selfsearch}</a> ]
	</div>
    </td>
</tr>
</table>
<br />

</body>
</html>
