{*
  The user profile template
  $Id: profile.tpl,v 1.4 2005/05/25 21:09:51 andig2 Exp $
*}

<div id="topspacer"></div>

<table width="95%" cellspacing="0" cellpadding="0">
<tr><td>

<form method="post" action="profile.php">
<input type="hidden" name="save" value="1">
<table width="100%">
  {include file="options.tpl"}
</table>

<br/>
<div align="center">
  <input type="submit" value="{$lang.save}" class="button" accesskey="s" />
</div>

</form>

</td></tr>
</table>
<br/>
