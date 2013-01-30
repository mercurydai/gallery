{*
  Template for IMDB Online browsing
  $Id: trace.tpl,v 1.4 2005/05/20 10:02:35 andig2 Exp $
*}

<table width="95%" cellspacing="2" cellpadding="0">
<tr><td class="forumheader3">
	<table width="100%" cellspacing="5">
	<tr><td width="100%">
		<span>URL: </span><a href="{$url}" target="_blank">{$url}</a>
	</td>
	<td align="right">
		<nobr>{if $fetchtime}<span>{$lang.fetchtime}: </span>{$fetchtime}s{else}&nbsp;{/if}{if $md5} {$md5}{/if}</nobr>
	</td>
	<td align="right">
		<form action="trace.php" method="get">
			<input type="hidden" name="videodburl" value="{$url}"/>
			<input type="hidden" name="videodbreload" value="Y"/>
			<input type="submit" value="Reload" class="button"/>
		</form>
	</td></tr>
	</table>
</td></tr>
</table>

<table width="95%" border="0" cellpadding="0" cellspacing="2">
<tr>
<td bgcolor="#FFFFFF" class="imdb">
{$page}
</td>
</tr>
</table>
