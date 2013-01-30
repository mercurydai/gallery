{*
  Template for the borrowing a single disk
  $Id: borrow.tpl,v 1.6 2008/03/09 14:57:23 andig2 Exp $
*}

{if $diskid && $editable}
<table width="95%" cellspacing="2" cellpadding="0" >
<tr><td class="forumheader3">
	<table width="100%">
    <tr>
      <td align="center" style="text-align:center">
        <form action="borrow.php" method="post" name="borrow" id="borrow">
          <input type="hidden" name="diskid" id="diskid" value="{$diskid}" />
          {if $who != ''}
            <br />
            {$lang.diskid} {$diskid}
            {$lang.lentto} {$who} ({$dt})
            <br />
            <input type="hidden" name="return" id="return" value="1" />
            <input type="submit" value="{$lang.returned}" class="button" />
          {else}
            <br />
            {$lang.diskid} {$diskid} {$lang.available}
            <br />
            {$lang.borrowto}:
            <input type="text" size="40" maxlength="255" name="who" id="who" />
            <input type="submit" value="{$lang.okay}" class="button" />
          {/if}
          <br />
        </form>
      </td>
    </tr>
  </table>
</td></tr>
</table>
{/if}

<br/>
{if $config.multiuser}
<table>
	<tr>
		<td class="show_title">{$lang.curlentfrom}</td>
		<td><form action="borrow.php">{html_options name=owner options=$owners selected=$owner onchange="submit()"}</form></td>
		<td>:</td>
	</tr>
</table><br/>
{else}
<h3>{$lang.curlent}</h3>
{/if}

{if $borrowlist}
  <table width="95%">
  	<tr class="{cycle values="even,odd"}">
		<th class="fcaption">{$lang.diskid}</th>
		{if $config.multiuser}<th class="fcaption">{$lang.owner}</th>{/if}
		<th class="fcaption">{$lang.title}</th>
		<th class="fcaption">{$lang.lentto}</th>
		<th class="fcaption">{$lang.date}</th>
		<th class="fcaption"></th>
  	</tr>

  	{foreach item=disk from=$borrowlist}
  	  <tr class="{cycle values="even,odd"}">
        <td align="center" style="text-align:center" class="forumheader3"><a href="search.php?q={$disk.diskid}&fields=diskid&nowild=1">{$disk.diskid}</a></td>
        {if $config.multiuser}
          <td align="center" style="text-align:center" class="forumheader3">{$disk.owner}</td>
        {/if}
        <td align="center" style="text-align:center" class="forumheader3">
          <a href="show.php?id={$disk.id}">{$disk.title}</a>
          {if $disk.count > 1} ... {/if}
        </td>
        <td align="center" style="text-align:center" class="forumheader3">{$disk.who}</td>
        <td align="center" style="text-align:center" class="forumheader3">{$disk.dt}</td>
        <td align="center" style="text-align:center" class="forumheader3">
			{if $disk.editable}
			<form action="borrow.php" method="get">
				<input type="hidden" name="diskid" id="diskid" value="{$disk.diskid}" />
				<input type="hidden" name="return" id="return" value="1" />
				<input type="submit" value="{$lang.returned}" class="button"/>
			</form>
			{/if}
        </td>
      </tr>
    {/foreach}
	</table>
{else}
	{$lang.l_nothing}
	<br/><br/>
{/if}
