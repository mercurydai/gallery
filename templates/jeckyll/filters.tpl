{*
  The filters on top of the browse page
  $Id: filters.tpl,v 1.8 2006/11/28 21:26:49 acidity Exp $
*}
<table width="95%" class="tablelist" cellspacing="0" cellpadding="0" border="0">
<tr>
	<td>
	<form action="index.php" id="browse" name="browse">
	<table width="100%" cellspacing="2">
	<tr>
		<td class="forumheader3">
			{* {html_radios name=filter2 options=$filters checked=$filter label_class="version" onclick="submit()"} *}
			<table border="0" cellpadding="0" cellspacing="2">
			<tr>
			    <input type="hidden" name="filter" value="">
			    <td width="7%"><div class="divbutton"><a href="?filter=NUM" style="text-decoration: none;">{if $filter == "NUM"}&raquo;{/if}#</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=ABC" style="text-decoration: none;">{if $filter == "ABC"}&raquo;{/if}ABC</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=DEF" style="text-decoration: none;">{if $filter == "DEF"}&raquo;{/if}DEF</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=GHI" style="text-decoration: none;">{if $filter == "GHI"}&raquo;{/if}GHI</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=JKL" style="text-decoration: none;">{if $filter == "JKL"}&raquo;{/if}JKL</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=MNO" style="text-decoration: none;">{if $filter == "MNO"}&raquo;{/if}MNO</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=PQRS" style="text-decoration: none;">{if $filter == "PQRS"}&raquo;{/if}PQRS</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=TUV" style="text-decoration: none;">{if $filter == "TUV"}&raquo;{/if}TUV</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=WXYZ" style="text-decoration: none;">{if $filter == "WXYZ"}&raquo;{/if}WXYZ</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=all" style="text-decoration: none;">{if $filter == "all"}&raquo;{/if}{$lang.radio_all}</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=unseen" style="text-decoration: none;">{if $filter == "unseen"}&raquo;{/if}{$lang.radio_unseen}</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=new" style="text-decoration: none;">{if $filter == "new"}&raquo;{/if}{$lang.radio_new}</a></div></td>
			    <td width="7%"><div class="divbutton"><a href="?filter=wanted" style="text-decoration: none;">{if $filter == "wanted"}&raquo;{/if}{$lang.radio_wanted}</a></div></td>
			    {if $owners}<td width="6%">{html_options name=owner class="divbutton" options=$owners selected=$owner onchange="submit()"}</td>{/if}
			</tr>
			</table>
{*
			{foreach key=key item=val from=$filters}
			<input type="radio" name="filter" id="filter{$key}" value="{$key}" {if $key == $filter}checked="checked"{/if} onclick="submit()"/><label class="filterlink" for="filter{$key}">{$val}</label>
			{/foreach}
*}
		</td>
		<!--td class="filter" width="100%">
			<div align="right">
				<input type="checkbox" name="showtv" id="showtv" value="1" {if $showtv}checked="checked"{/if} onclick="submit()" /><label class="filterlink" for="showtv">{$lang.radio_showtv}</label>
			</div>
		</td-->
		<!--td align="right">
			<input type="submit" value="{$lang.okay}" name="OK" id="OK" class="button"/>
		</td-->
		{if $listcolumns AND $moreless}
		<!--td align="right" valign="middle" class="forumheader3">
			<div align="center"><span style="font-size:10px; font-weight: bold;">
			<a href="index.php?listcolumns={math equation="columns+1" columns=$listcolumns}">{$lang.more}</a><br/>
			{if $listcolumns gt 1}<a href="index.php?listcolumns={math equation="columns-1" columns=$listcolumns}">{/if}{$lang.less}{if $listcolumns gt 1}</a>{/if}
			</span></div>
		</td-->
		{/if}
	</tr>
	</form>
	</table>
	</td>
</tr>
</table>
