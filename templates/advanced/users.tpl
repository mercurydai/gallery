{*
  Template for the user management screen
  $Id: users.tpl,v 1.5 2007/12/03 20:05:27 andig2 Exp $
*}

{if $message}
<table width="100%" class="tablelist" cellpadding="0" cellspacing="0">
<tr><td>
	<table width="100%" class="tablefilter">
	<tr>
      <td align="center" style="text-align:center">
		<br/>{$message}<br/>
      </td>
	</tr>
	</table>
</td></tr>
</table>
{else}
	<div id="topspacer"></div>
{/if}

<table width="100%" class="tableborder">
<tr><td align="center">
	<h3>{$lang.existingusers}</h3>
</td></tr>
<tr><td>

<table width="90%" class="tableborder">
	<tr class="{cycle values="even,odd"}">
		<th>{$lang.username}</th>
		<th>{$lang.permissions}</th>
		<th>{$lang.email}</th>
		<th>{$lang.password}</th>
		<th colspan="3">Action</th>
	</tr>

	{foreach item=user from=$userlist}
	  <tr class="{cycle values="even,odd"}">
	    <form action="users.php" method="post">
	    <input type="hidden" name="id" value="{$user.id}" />
	  <td align="center" style="text-align:center">
	    <input type="text" name="name" value="{$user.name}" />
	  </td>
      <td align="left" style="text-align:left">
      	{html_checkbox style="vertical-align:middle;" name="readflag"  value="1" id="readflag"|cat:$user.name  checked=$user.read label=$lang.perm_readall}&nbsp;&nbsp;
      	{html_checkbox style="vertical-align:middle;" name="writeflag" value="1" id="writeflag"|cat:$user.name checked=$user.write label=$lang.perm_writeall}&nbsp;&nbsp;
      	{html_checkbox style="vertical-align:middle;" name="adultflag" value="1" id="adultflag"|cat:$user.name checked=$user.adult label=$lang.perm_adult}&nbsp;&nbsp;
      	{html_checkbox style="vertical-align:middle;" name="adminflag" value="1" id="adminflag"|cat:$user.name checked=$user.admin label=$lang.perm_admin}
      </td>
      <td align="center" style="text-align:center">
        {if $user.guest}
        <input type="hidden" name="email" value="{$user.email|escape}" />
        {else}
        <input type="text" name="email" value="{$user.email|escape}" />
        {/if}
      </td>
      <td align="center" style="text-align:center">
        {if $user.guest}
        <input type="hidden" name="password" />
        {else}
        <input type="text" name="password" />
        {/if}
      </td>
      <td align="center" style="text-align:center">
        <input type="submit" value="{$lang.update}" class="button" />
      </td>
      </form>
      <td align="center" style="text-align:center">
	    <form action="users.php" method="post">
			<input type="hidden" name="del" value="{$user.id}" />
			{if !$user.guest}
			<input type="submit" value="{$lang.del}" onClick="return confirm('{$lang.really_del|escape:javascript|escape}?')" class="button"/>
			{/if}
        </form>
      </td>
      <td align="center" style="text-align:center"  class="forumheader3">
	    <form action="permissions.php" method="post">
			<input type="hidden" name="from_uid" value="{$user.id}" />
			<input type="submit" value="{$lang.perm}" class="button"/>
        </form>
      </td>
    </tr>
  {/foreach}


	<tr>
		<td colspan="5">
			<br/>
			<h3>{$lang.createuser}</h3>
		</td>
	</tr>
    <tr class="{cycle values="even,odd"}">
		<form action="users.php" method="post">
			<td align="center" style="text-align:center">
				<input type="text" name="newuser" />
			</td>
			<td align="left" style="text-align:left">
				{html_checkbox style="vertical-align:middle;" name="readflag"  value="1" id="readflagNEWUSER"  label=$lang.perm_readall}&nbsp;&nbsp;
				{html_checkbox style="vertical-align:middle;" name="writeflag" value="1" id="writeflagNEWUSER" label=$lang.perm_writeall}&nbsp;&nbsp;
				{html_checkbox style="vertical-align:middle;" name="adultflag" value="1" id="adultflagNEWUSER" label=$lang.perm_adult}&nbsp;&nbsp;
				{html_checkbox style="vertical-align:middle;" name="adminflag" value="1" id="adminflagNEWUSER" label=$lang.perm_admin}
			</td>
			<td align="center" style="text-align:center">
				<input type="text" name="email" />
			</td>
			<td align="center" style="text-align:center">
				<input type="text" name="password"/>
			</td>
			<td align="center" style="text-align:center" colspan="3">
				<input type="submit" value="{$lang.create}" class="button"/>
			</td>
		</form>
	</tr>
</table>

</table>
