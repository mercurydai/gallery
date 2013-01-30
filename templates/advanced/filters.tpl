{*
  The filters on top of the browse page
  $Id: filters.tpl,v 1.4 2006/11/28 20:06:53 acidity Exp $
*}
<table width="100%" class="tablelist" cellspacing="0" cellpadding="0">
<tr>
	<td>
	<form action="index.php" id="browse" name="browse">
	<table width="100%" class="tablefilter" cellspacing="5">
	<tr>
		<td class="filter">
                        <div align="right">
				<input type="checkbox" name="showtv" id="showtv" value="1" {if $showtv}checked="checked"{/if} onclick="submit()" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_filter_tv}', 'content', '{$lang.tooltip_filter_tv}', 'styleClass', 'niceTitle');"/><label class="filterlink" for="showtv">{$lang.radio_showtv}</label>
                                                     <span onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_filter}', 'content', '{$lang.tooltip_filter}', 'styleClass', 'niceTitle');">
				{html_options name=filter options=$filters selected=$filter label_class="filterlink" onchange="submit()"}
				</span>
			</div>
		</td>
		{if $owners}
		<td class="filter">
			<div align="right">
				<span onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_userselect}', 'content', '{$lang.tooltip_userselect}', 'styleClass', 'niceTitle');">			
				{html_options name=owner options=$owners selected=$owner onchange="submit()"}
				</span>
			</div>
		</td>
		{/if}
		<td align="right">
			<input type="submit" value="OK" name="OK" id="OK" class="button" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_filter_ok}', 'content', '{$lang.tooltip_filter_ok}', 'styleClass', 'niceTitle');"/>
		</td>

		{if $listcolumns AND $moreless}
		<td align="right" valign="middle">
			<div align="center"><span class="filterlink">
			<a href="index.php?listcolumns={math equation="columns+1" columns=$listcolumns}">{$lang.more}</a><br/>
			{if $listcolumns gt 1}<a href="index.php?listcolumns={math equation="columns-1" columns=$listcolumns}">{/if}{$lang.less}{if $listcolumns gt 1}</a>{/if}
			</span></div>
		</td>
		{/if}
	</tr>
	</table>
	</form>
	</td>
</tr>
</table>
