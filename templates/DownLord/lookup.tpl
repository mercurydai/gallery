{*
  Search engine popup
  $Id: lookup.tpl,v 1.17 2009/04/04 16:21:33 andig2 Exp $
*}
{include file="xml.tpl"}

<body>

<script language="JavaScript" type="text/javascript" src="javascript/lookup.js"></script>
<script language="JavaScript" type="text/javascript" src="templates/DownLord/tools.js"></script>

<table width="100%" class="tablemenu" cellpadding="0" cellspacing="0">
<tr valign="top">
<td align="left">
	<div class="content-box">
	<div id="links">

		<div class="channelnavi">
			<a href="javascript:document.lookup.submit()">{$lang.l_search}</a>
		</div>

		<div class="channelnavi">
			<a style="text-transform: uppercase; border-top: none" href="javascript:toggleElementVisibility(document.getElementById('filternavi'));">Engines &#187;</a>
			<div id="filternavi" style="display: none">
				{foreach item=eng from=$engines}
				<a href="{$eng.url}">{$eng.name}</a>
				{/foreach}
			</div>
		</div>
	</div>
</td>

<td width="100%">

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
				<pre>{$http_error}</pre>
			{/if}

			{if $imdbresults}
			<b>{$lang.l_select}</b>
			{if $searchtype == 'image'}
				{foreach item=match from=$imdbresults}
					<div class="thumbnail">
						<a class="list_title" href="javascript:void(returnImage('{$match.coverurl|escape:"javascript"}'));" title="Select image and close Window">
							<img src="{$match.imgsmall}" align="left" width="60" height="90" /><br />
							{$match.title}
						</a>
					</div>
				{/foreach}
			{else}
				<span class="list_info">
				<ul>
				{foreach item=match from=$imdbresults}
					<li>
						<a class="list_title" href="javascript:void(returnData('{$match.id}','{$match.title|escape:"javascript"}','{$match.subtitle|escape:"javascript"}', '{$engine}'));" title="add ID and close Window">{$match.title}{if $match.subtitle} - {$match.subtitle}{/if}</a>
						{if $match.details or $match.imgsmall}
						<br/>
						<font size="-2">
							{if $match.imgsmall}<img src="{$match.imgsmall}" align="left" width="25" height="35" />{/if}
							{$match.details}
						</font>
						{/if}
						<br clear="all" />
					</li>
				{/foreach}
				</ul>
				</span>
			{/if}
			{else}
				<div align="center"><b>{$lang.l_nothing}</b></div>
				<br />
			{/if}

			<br clear="all" />
			<div align="right">
				[ <a href="{$searchurl}" target="_blank">{$lang.l_selfsearch}</a> ]
			</div>

		</td>
	</tr>
	</table>

</td>
</tr>
</table>

</body>
</html>
