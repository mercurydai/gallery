{*
  Template for the borrowing a single disk
  $Id: borrow.tpl,v 1.6 2008/03/09 14:57:22 andig2 Exp $
*}

{if $diskid && $editable}
<table width="100%" class="tablelist" cellspacing="0" cellpadding="0" >
<tr><td>
	<table width="100%" class="tablefilter">
    <tr>
      <td align="center" style="text-align:center">
        <form action="borrow.php" method="post" name="borrow" id="borrow">
          <input type="hidden" name="diskid" id="diskid" value="{$diskid}" />
          {if $who != ''}
            <br /><span class="filterlink">
            {$lang.diskid} {$diskid}
            {$lang.lentto} {$who} ({$dt})</span>
            <br />
            <input type="hidden" name="return" value="1" />
            <input type="submit" value="{$lang.returned}" class="button" />
          {else}
            <br />
           <span class="filterlink"> {$lang.diskid} {$diskid} {$lang.available}
            <br />
            {$lang.borrowto}:</span>
            <input type="text" size="40" maxlength="255" name="who" />
            <input type="submit" value="OK" class="button" />
          {/if}
          <br />
        </form>
      </td>
    </tr>
  </table>
</td></tr>
</table>
{else}
	<div id="topspacer"></div>
{/if}

<br/>
{if $config.multiuser}
<table>
	<tr>
		<td><h3>{$lang.curlentfrom}</h3></td>
		<td><h3><form action="borrow.php">{html_options name=owner options=$owners selected=$owner onchange="submit()"}</form></h3></td>
		<td><h3>:</h3></td>
	</tr>
</table><br/>
{else}
<h3>{$lang.curlent}</h3>
{/if}

{if $borrowlist}
  <table width="90%" class="tableborder">
  	<tr class="{cycle values="even,odd"}">
		<th>{$lang.diskid}</th>
		{if $config.multiuser}<th>{$lang.owner}</th>{/if}
		<th>{$lang.title}</th>
		<th>{$lang.lentto}</th>
		<th>{$lang.date}</th>
		<th></th>
  	</tr>

  	{foreach item=disk from=$borrowlist}
  	  <tr class="{cycle values="even,odd"}">
        <td align="center" style="text-align:center"><a href="search.php?q={$disk.diskid}&amp;fields=diskid&amp;nowild=1">{$disk.diskid}</a></td>
        {if $config.multiuser}
          <td align="center" style="text-align:center">{$disk.owner}</td>
        {/if}
        <td align="center" style="text-align:center">
          <a href="show.php?id={$disk.id}">{$disk.title}</a>
          {if $disk.count > 1} ... {/if}
        </td>
        <td align="center" style="text-align:center">{$disk.who}</td>
        <td align="center" style="text-align:center">{$disk.dt}</td>
        <td align="center" style="text-align:center">
			{if $disk.editable}
			<form action="borrow.php" method="get">
				<input type="hidden" name="diskid" value="{$disk.diskid}" />
				<input type="hidden" name="return" value="1" />
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
