{*
  The user profile template
  $Id: profile.tpl,v 1.5 2004/12/15 08:29:09 andig2 Exp $
*}

<table width="100%" cellspacing="0" cellpadding="0">
<tr valign="top">
<td width="100%">
	<form method="post" action="profile.php" name="setup">
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
				<div class="channelnavi">
					<a onClick='document.setup.submit()' accesskey="s">{$lang.save}</a>
				</div>
			</div>
		</td>
	</tr>
	</table>
</td>
</tr>
</table>
