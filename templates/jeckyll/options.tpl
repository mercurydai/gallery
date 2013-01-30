{*
  Template to display config options used by setup.tpl and profile.tpl
  $Id: options.tpl,v 1.3 2005/04/22 09:16:34 andig2 Exp $
*}

  {foreach from=$setup item=option}
  <tr>
	{if $option.group}
	<td align="center" style="text-align:center" colspan="2">
		<h3><a name="{$option.group}"></a>{$lang[$option.group]}</h3>
	</td>
	{else}
    <td align="center" style="text-align:center" nowrap="nowrap" class="forumheader3">
      <b>{$option.hl}</b><br />

      {if $option.type == 'text'}
        <input type="text" size="20" name="{$option.name}" id="{$option.name}" value="{$option.set|escape}" style="text-align:center"/>
      {/if}

      {if $option.type == 'boolean'}
        {if $option.set}
          <input type="checkbox" name="{$option.name}" id="{$option.name}" checked="checked" value="1" /><label for="{$option.name}">{$lang.enable}</label>
        {else}
          <input type="checkbox" name="{$option.name}" id="{$option.name}" value="1" /><label for="{$option.name}">{$lang.enable}</label>
        {/if}
      {/if}

      {if $option.type == 'dropdown'}
        {html_options name=$option.name options=$option.data selected=$option.set}
      {/if}

      {if $option.type == 'multi'}
        <select name="{$option.name}[]" size="5" multiple="multiple">
        <option value=""></option>
        {html_options options=$option.data selected=$option.set}
        </select>
      {/if}

      {if $option.type == 'special'}
        {$option.data}
      {/if}

      {if $option.type == 'link'}
        <a href="{$option.data}">{$option.hl}</a>
      {/if}
    </td>
    <td valign="top" class="forumheader3">
      {$option.help}
    </td>
    {/if}
  </tr>
  {/foreach}
