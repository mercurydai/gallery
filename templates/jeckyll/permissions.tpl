{*
  Template for the permission management screen
  $Id: permissions.tpl,v 1.3 2005/05/27 13:53:43 chinamann Exp $
*}

{if $message}
<table width="100%" cellpadding="0" cellspacing="0">
<tr><td>
    <table width="100%">
    <tr>
      <td class="center">
        <br/>{$message}<br/>
      </td>
    </tr>
    </table>
</td></tr>
</table>
{else}
    {include file="topspacer.tpl"}
{/if}
<form action="permissions.php" method="post">
<table width="100%">
<tr><td class="center">
    <h3>{$lang.permforuser} {html_options name=from_uid options=$owners selected=$from_uid onchange="submit()"}:</h3>
</td></tr>
<tr><td class="center">
<table width="95%" align="center">
    <tr class="{cycle values="even,odd"}" style="text-align:center">
        <th class="fcaption">{$lang.username}</th>
        <th class="fcaption">{$lang.read}</th>
        <th class="fcaption">{$lang.write}</th>
    </tr>

    {foreach item=perm from=$permlist}
      <input type="hidden" name="newflag_{$perm.to_uid}" id="newflag_{$perm.to_uid}" value="{$perm.newentry}" />
      <tr class="{cycle values="even,odd"}">
      <td class="center">
        {$perm.to_name}
      </td>
      <td class="center">
        <input type="checkbox" name="readflag_{$perm.to_uid}" id="readflag_{$perm.to_uid}" value="1" {if $perm.read}checked="checked"{/if}/>
      </td>
      <td class="center">
        <input type="checkbox" name="writeflag_{$perm.to_uid}" id="writeflag_{$perm.to_uid}" value="1" {if $perm.write}checked="checked"{/if}/>
      </td>
      </tr>
    {/foreach}
    <tr>
    <td class="center" colspan="3">
        <br />
        <input type="submit" name="save" value="{$lang.save}" class="button" accesskey="s" />
        <input type="button" value="{$lang.back}" class="button" onclick="window.location.href='users.php';" accesskey="c" />
    </td>
    </tr>

</table>
</td>
</tr>
</table>
</form>
