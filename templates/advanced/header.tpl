{*
  This is the header which is displayed on top of every page
  $Id: header.tpl,v 1.3 2005/05/24 02:12:00 chinamann Exp $
*}
{include file="xml.tpl"}

{*

Icons used are copied from the Crystal SVG Theme for KDE. copyright apply

*}
<body>
<a name="top"></a>
<table width="100%" cellspacing="0" border="0" cellpadding="0" align="left" class="tablemenu" >
<tr align="left" valign="top">
	<td width="44px">
		<table width="100%" cellpadding="0" cellspacing="0">
		{if $header.browse}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'browse'}tabActive{else}tabInactive{/if}">
				<a href="{$header.browse}{if $browseid}#{$browseid}{/if}" accesskey="i" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_browse}', 'content', '{$lang.tooltip_browse}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/domtreeviewer.gif" width="22" height="22" border="0" alt="{$lang.browse}"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.trace}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'trace'}tabActive{else}tabInactive{/if}">
				<a href="{$header.trace}" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_trace}', 'content', '{$lang.tooltip_trace}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/ico-imdb.gif" width="22" height="22" border="0" alt="{$lang.imdbbrowser}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.random}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'random'}tabActive{else}tabInactive{/if}">
				<a href="{$header.random}" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_trace}', 'content', '{$lang.tooltip_random}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/rebuild.gif" width="22" height="22" border="0" alt="{$lang.random}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.search}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'search'}tabActive{else}tabInactive{/if}">
				<a href="{$header.search}" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_search}', 'content', '{$lang.tooltip_search}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/find.gif" width="22" height="22" border="0" alt="{$lang.search}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.new}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'new'}tabActive{else}tabInactive{/if}">
				<a href="{$header.new}" accesskey="n" onmouseover="domTT_activate(this, event, 'statusText', '{$lang.tooltip_new}', 'content', '{$lang.tooltip_new}', 'styleClass', 'niceTitle');">
				<img src="templates/advanced/images/vcs_add.gif" width="22" height="22" border="0" alt="{$lang.n_e_w}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.active == 'show'}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'new'}tabActive{else}tabInactive{/if}">
				<a href="{$header.new}" accesskey="n">
					<img src="templates/advanced/images/imagegallery.gif" width="22" height="22" border="0" alt="{$lang.view}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.active == 'edit'}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'new'}tabActive{else}tabInactive{/if}">
				<a href="{php}echo $_SERVER['REQUEST_URI'];{/php}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_edit}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/edit.gif" width="22" height="22" border="0" alt="{$lang.edit}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.contrib}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'contrib'}tabActive{else}tabInactive{/if}">
				<a href="{$header.contrib}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_contrib}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/tools.gif" width="22" height="22" border="0" alt="{$lang.contrib}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.borrow}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'borrow'}tabActive{else}tabInactive{/if}">
				<a href="{$header.borrow}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_borrow}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/goto.gif" width="22" height="22" border="0" alt="{$lang.borrow}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.stats}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'stats'}tabActive{else}tabInactive{/if}">
				<a href="{$header.stats}" onmouseover="domTT_activate(this, event,'content', '{$lang.tooltip_stats}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/sqrt.gif" width="22" height="22" border="0" alt="{$lang.statistics}" align="middle"/>
				</a>	
			</td>
		</tr>
		{/if}
		{if $header.setup}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'setup'}tabActive{else}tabInactive{/if}">
				<a href="{$header.setup}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_setup}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/configure.gif" width="22" height="22" border="0" alt="{$lang.setup}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.profile}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'profile'}tabActive{else}tabInactive{/if}">
				<a href="{$header.profile}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_profile}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/wizard.gif" width="22" height="22" border="0" alt="{$lang.profile}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.help}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'help'}tabActive{else}tabInactive{/if}">
				<a href="{$header.help}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_help}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/help.gif" width="22" height="22" border="0" alt="{$lang.help}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
		{if $header.login}
		<tr valign="bottom">
			<td width="100%" align="left" style="text-align: center;" class="{if $header.active == 'login'}tabActive{else}tabInactive{/if}">	
				<a href="{$header.login}" onmouseover="domTT_activate(this, event, 'content', '{if $loggedin}{$lang.tooltip_login}{else}{$lang.tooltip_logout}{/if}', 'styleClass', 'niceTitle');">
					<img src="templates/advanced/images/{if $loggedin}encrypted{else}decrypted{/if}.gif" width="22" height="22" border="0" alt="{if $loggedin}{$lang.logout}{else}{$lang.login}{/if}" align="middle"/>
				</a>
			</td>
		</tr>
		{/if}
			
		</table>
</td><td>
