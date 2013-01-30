{*  Search engine popup  $Id: lookup.tpl,v 1.6 2009/04/04 16:21:33 andig2 Exp $*}
{include file="xml.tpl"}

<body>
<script language="JavaScript" type="text/javascript" src="javascript/lookup.js"></script>

<table width="100%" class="tablemenu" cellpadding="0" cellspacing="0">
<tr valign="bottom">
	<td width="100%" align="left" style="text-align:left">
		{foreach key=e item=eng from=$engines}
		<span class="{if $engine == $e}tabActive{else}tabInactive{/if}"><a href="{$eng.url}" style="text-decoration: none;">{$eng.name}</a></span></td>
		{/foreach}
	</td>
</tr>
</table>

<table width="100%" class="tablelist" cellspacing="0" cellpadding="0">
<tr>
	<td>
  	<form action="lookup.php" id="lookup" name="lookup">
		<table width="100%" class="tablefilter" cellspacing="5">
		<tr>
			<td nowrap="nowrap">
				<input type="text" name="find" id="find" value="{$q_find}" size="31" />
                {include file="lookup_engines.tpl"}
				<input type="submit" value="{$lang.l_search}" class="button" />

                <script language="JavaScript" type="text/javascript">
                document.lookup.find.focus();
                </script>
			</td>
		</tr>
		</table>
  	</form>
 	</td>
</tr>
<tr>
	<td>
		<br/>
		{if $http_error}
			<pre>
			{$http_error}
			</pre>
		{/if}
		{if $imdbresults}
			<b>{$lang.l_select}</b>
			{if $searchtype == 'image'}
				{foreach item=match from=$imdbresults}
				<div class="thumbnail">
					<a href="javascript:void(returnImageMine('{$match.coverurl|escape:"javascript"}'));" title="Select image and close Window">
						<img src="{$match.imgsmall}" align="left" width="60" height="90" />
						<br />
						{$match.title}
						</a>
					</div>
				{/foreach}
			{else}
				<ul>
				{foreach item=match from=$imdbresults}
					<li>
						<a href="javascript:void(returnDataMine('{$match.id}','{$match.title|escape:"javascript"}','{$match.subtitle|escape:"javascript"}', '{$engine}'));" title="add ID and close Window">{$match.title}{if $match.subtitle} - {$match.subtitle}{/if}</a>
						{if $match.details or $match.imgsmall}					<br/>
							<font size="-2">
								{if $match.imgsmall}<img src="{$match.imgsmall}" align="left" width="25" height="35" />{/if}
								{$match.details}
							</font>
						{/if}
						<br clear="all" />
					</li>
				{/foreach}
				</ul>
			{/if}
		{else}
			<div align="center">
				<b>{$lang.l_nothing}</b>
			</div>
			<br />
		{/if}
		<br clear="all" />
		<div align="right">
			[ <a href="{$searchurl}" target="_blank">{$lang.l_selfsearch}</a> ]
		</div>
 	</td>
</tr>
</table>
</body>
</html>
