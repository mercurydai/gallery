{*
  Template for the user management screen
  $Id: users.tpl,v 1.9 2007/12/03 20:05:32 andig2 Exp $
*}

{if $message}
<table width="95%" cellpadding="0" cellspacing="0" border="0">
<tr><td>
	<table width="100%">
	<tr>
      <td align="center" style="text-align:center">
		<br/>{$message}<br/>
      </td>
	</tr>
	</table>
</td></tr>
</table>
{/if}

<table width="95%" cellpadding="0" cellspacing="2">
<tr><td align="center" colspan="6">
	{$lang.existingusers}
</td></tr>
	<tr>
		<td class="fcaption">{$lang.username}</td>
		<td class="fcaption">{$lang.permissions}</td>
		<td class="fcaption">{$lang.email}</td>
		<td class="fcaption">{$lang.password}</td>
		<td colspan="3" class="fcaption">{$lang.action}</td>
	</tr>

	{foreach item=user from=$userlist}
	  <tr>
	  <form action="users.php" method="post">
	  <input type="hidden" name="id" value="{$user.id}" />
	  <input type="hidden" name="name" value="{$user.name|escape}" />
	  <td align="center" style="text-align:center" class="forumheader3">
	    {$user.name}
	  </td>
      <td align="left" class="forumheader3">
      	{html_checkbox style="vertical-align:middle;" name="readflag" value="1" id="readflag"|cat:$user.name checked=$user.read label=$lang.perm_readall}<br/>
      	{html_checkbox style="vertical-align:middle;" name="writeflag" value="1" id="writeflag"|cat:$user.name checked=$user.write label=$lang.perm_writeall}<br/>
      	{html_checkbox style="vertical-align:middle;" name="adultflag" value="1" id="adultflag"|cat:$user.name checked=$user.adult label=$lang.perm_adult}<br/>
      	{html_checkbox style="vertical-align:middle;" name="adminflag" value="1" id="adminflag"|cat:$user.name checked=$user.admin label=$lang.perm_admin}
      <td align="center" style="text-align:center" class="forumheader3">
        {if $user.guest}
        <input type="hidden" name="email" value="{$user.email|escape}" />
        {else}
        <input type="text" name="email" value="{$user.email|escape}" />
        {/if}
      </td>
      <td align="center" style="text-align:center" class="forumheader3">
        {if $user.guest}
        <input type="hidden" name="password" />
        {else}
        <input type="text" name="password" />
        {/if}
      </td>
      <td align="center" style="text-align:center" class="forumheader3">
        <input type="submit" value="{$lang.update}" class="button" />
      </td>
      </form>
      <td align="center" style="text-align:center" class="forumheader3">
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
		<td colspan="6" align="center">
		{$lang.createuser}
		</td>
	</tr>
    <tr>
		<form action="users.php" method="post">
			<td align="center" style="text-align:center" class="forumheader3">
				<input type="text" name="newuser" />
			</td>
			<td class="forumheader3" style="vertical-align:middle;">
				{html_checkbox style="vertical-align:middle;" name="readflag"  value="1" id="readflagNEWUSER"  label=$lang.perm_readall}<br/>
				{html_checkbox style="vertical-align:middle;" name="writeflag" value="1" id="writeflagNEWUSER" label=$lang.perm_writeall}<br/>
				{html_checkbox style="vertical-align:middle;" name="adultflag" value="1" id="adultflagNEWUSER" label=$lang.perm_adult}<br/>
				{html_checkbox style="vertical-align:middle;" name="adminflag" value="1" id="adminflagNEWUSER" label=$lang.perm_admin}
			</td>
			<td align="center" style="text-align:center" class="forumheader3">
				<input type="text" name="email" />
			</td>
			<td align="center" style="text-align:center" class="forumheader3">
				<input type="text" name="password"/>
			</td>
			<td align="center" style="text-align:center" colspan="3" class="forumheader3">
				<input type="submit" value="{$lang.create}" class="button"/>
			</td>
		</form>
	</tr>
</table>

</td>
</tr>
</table>
