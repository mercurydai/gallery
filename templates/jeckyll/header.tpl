{*
  This is the header which is displayed on top of every page
  $Id: header.tpl,v 1.5 2007/12/29 10:23:18 andig2 Exp $
*}
{include file="xml.tpl"}

<body>
<a name="top"></a>
<div align="center">

<table width="95%" cellpadding="0" cellspacing="2" border="0">
<tr valign="bottom">
	{if $header.browse}<td><div class="divbutton"><a href="{$header.browse}" style="text-decoration: none;">{if $header.active == 'browse'}» {/if}{$lang.browse}</a></div></td>{/if}
	{if $header.trace}<td><div class="divbutton"><a href="{$header.trace}" style="text-decoration: none;">{if $header.active == 'trace'}» {/if}{$lang.imdbbrowser}</a></div></td>{/if}
	{if $header.random}<td><div class="divbutton"><a href="{$header.random}" style="text-decoration: none;">{if $header.active == 'random'}» {/if}{$lang.random}</a></div></td>{/if}
	{if $header.search}<td><div class="divbutton"><a href="{$header.search}" style="text-decoration: none;">{if $header.active == 'search'}» {/if}{$lang.search}</a></div></td>{/if}
	{if $header.new}<td><div class="divbutton"><a href="{$header.new}" style="text-decoration: none;">{if $header.active == 'new'}» {/if}{$lang.n_e_w}</a></div></td>{/if}
	{if $header.active == 'show'}<td><div class="divbutton"><a href="{php}echo $_SERVER['REQUEST_URI'];{/php}" style="text-decoration: none;">» {$lang.view}</a></div></td>{/if}
	{if $header.active == 'edit'}<td><div class="divbutton"><a href="{php}echo $_SERVER['REQUEST_URI'];{/php}" style="text-decoration: none;">» {$lang.edit}</a></div></td>{/if}
	{if $header.borrow}<td><div class="divbutton"><a href="{$header.borrow}" style="text-decoration: none;">{if $header.active == 'borrow'}» {/if}{$lang.borrow}</a></div></td>{/if}
	{if $header.stats}<td><div class="divbutton"><a href="{$header.stats}" style="text-decoration: none;">{if $header.active == 'stats'}» {/if}{$lang.statistics}</a></div></td>{/if}
	{if $header.contrib}<td><div class="divbutton"><a href="{$header.contrib}" style="text-decoration: none;">{if $header.active == 'contrib'}» {/if}{$lang.contrib}</a></div></td>{/if}
	{if $header.setup}<td><div class="divbutton"><a href="{$header.setup}" style="text-decoration: none;">{if $header.active == 'setup'}» {/if}{$lang.setup}</a></div></td>{/if}
	{if $header.profile}<td><div class="divbutton"><a href="{$header.profile}" style="text-decoration: none;">{if $header.active == 'profile'}» {/if}{$lang.profile}</a></div></td>{/if}
	{if $header.help}<td><div class="divbutton"><a href="{$header.help}" style="text-decoration: none;">{if $header.active == 'help'}» {/if}{$lang.help}</a></div></td>{/if}
	{if $header.login}<td><div class="divbutton"><a href="{$header.login}" style="text-decoration: none;">{if $header.active == 'login'}» {/if}{if $loggedin}{$lang.logout}{else}{$lang.login}{/if}</a></div></td>{/if}
</tr>
</table>
