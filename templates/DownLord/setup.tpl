{*
  The configuration template
  $Id: setup.tpl,v 1.9 2010/02/14 12:25:12 andig2 Exp $
*}

<table width="100%" cellspacing="0" cellpadding="0">
<tr valign="top">
<td width="100%">
	<div class="content-box">
		{if $total}
			<br/>
			<span class="filterlink">{$lang.cachesize}: </span>{$total}mb
			<span class="filterlink">{$lang.cacheexpired}: </span>{$expired}mb ({math equation="round(a*100/b)" a=$expired b=$total}%)
			<br/><br/>
		{/if}
	</div>

	<form method="post" action="setup.php" name="setup">
		<input type="hidden" name="save" value="1"/>
		<table class="tableborder">
			{include file="options.tpl"}
		</table>
	</form>
</td>

<td>
	<table cellspacing="1" cellpadding="0" border="0" class="content-tabelle">
	<tr class="reihe0">
		<td>

		<div id="links">
			<form action="setup.php" name="cacheempty">
				<input type="hidden" name="cacheempty" value="1"/>
				<div class="channelnavi">
					<a href="javascript:document.cacheempty.submit()">{$lang.cacheempty}</a>
				</div>
			</form>

			<form action="users.php" name="users">
				<div class="channelnavi">
					<a href="javascript:document.users.submit()">{$lang.help_usermanagern}</a>
				</div>
			</form>

			<div id="links">
				<div class="channelnavi">
					<a href="javascript:document.setup.submit()" accesskey="s">{$lang.save}</a>
					<br/>
				</div>
			</div>
		</div>

		</td>
	</tr>
	</table>
</td>
</tr>
</table>
