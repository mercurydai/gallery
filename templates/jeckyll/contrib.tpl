{*
  Index of the contrib content
  $Id: contrib.tpl,v 1.1 2005/05/24 02:11:59 chinamann Exp $
*}

<table width="95%" class="tablelist" cellspacing="2" cellpadding="0">
<tr valign="top"><td colspab="3" height="20px">&nbsp;</td></tr>
{counter start=0 print=false name=contentcount}
{foreach item=file from=$files}
	{cycle values="even,odd" assign=CLASS print=false}
	<tr class="{$CLASS}" valign="top">

	<td width="10%">
	<td width="80%" align="left">
		<table>
		<tr>
			<td valign="top">
		 			<a href="{$file[0]}">{$file[1]}</a>
			</td>
		</tr>
		</table>
	</td>
	<td width="10%">
	{counter assign=count name=contentcount}
	</tr>	
{/foreach}
<tr valign="top"><td colspab="3" height="20px">&nbsp;</td></tr>


</table>
