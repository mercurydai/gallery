{*
  Template for IMDB Online browsing
  $Id: trace.tpl,v 1.9 2005/05/20 10:02:25 andig2 Exp $
*}

<table width="100%" class="tablelist" cellspacing="0" cellpadding="0">
<tr><td>
	<div class="content-box">

	<table width="100%" class="tablefilter" cellspacing="5">
	<tr><td width="100%">
		<span class="filterlink">URL: </span><a href="{$url}" target="_blank">{$url}</a>
	</td>
	<td align="right">
		<nobr>{if $fetchtime}<span class="filterlink">{$lang.fetchtime}: </span>{$fetchtime}s{else}&nbsp;{/if}{if $md5} {$md5}{/if}</nobr>
	</td>
	<td align="right">
		<form action="trace.php" method="get">
			<input type="hidden" name="videodburl" value="{$url}"/>
			<input type="hidden" name="videodbreload" value="Y"/>
			<input type="submit" value="Reload" class="button"/>
		</form>
	</td></tr>
	</table>

	</div>
</td></tr>
</table>
{$page}
