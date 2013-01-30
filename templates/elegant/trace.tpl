{*
  Template for IMDB Online browsing
  $Id: trace.tpl,v 1.2 2005/05/21 11:48:44 andig2 Exp $
*}

<!-- {$smarty.template} -->

<div id="actions">
	<h3>URL: </h3><a href="{$url}" target="_blank">{$url}</a>

	<nobr>{if $fetchtime}<span class="filterlink">{$lang.fetchtime}: </span>{$fetchtime}s{else}&nbsp;{/if}{if $md5} {$md5}{/if}</nobr>

	<form action="trace.php" method="get">
		<input type="hidden" name="videodburl" value="{$url}"/>
		<input type="hidden" name="videodbreload" value="Y"/>
		<input type="submit" class="button" value="Reload" />
	</form>
</div>

<div id="content">
	{$page}
</div>
