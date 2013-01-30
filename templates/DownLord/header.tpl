{*
  This is the header which is displayed on top of every page
  $Id: header.tpl,v 1.26 2006/11/28 20:10:33 acidity Exp $
*}
{include file="xml.tpl"}

<body>

<script src="templates/DownLord/tools.js" language="JavaScript" type="text/javascript"></script>

<div id="content-outer">
<div id="content">

<table border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 10px">
<tr>
	<td style="width: 170px" valign="top">
		<div id="links">
			<!--
			  <img src="templates/DownLord/images/kino_dvd_navilinie.gif" width="170" height="22" alt="" />
			-->
			<form action="search.php" id="quicksearch" name="quicksearch" method="get">
			<div id="suchbox" align="right">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="padding-right: 6px; font-size: 10px; color: #fff;">{$lang.search}</td>
					<td><input type="text" name="q" /></td>
					<td><!--<input type="image" src="templates/DownLord/images/gobutton.gif" name="submit" style="width: 30; height: 16" alt="{$lang.search}" />--></td>
				</tr>
				</table>
			</div>
			</form>

			<div id="suchbox-unten">
				<a href="{$header.search}" style="text-transform: uppercase;">{$lang.search}</a> &nbsp;
			</div>

			{if $header.active == 'show'}
			<div class="channelnavi">
				<a href="{php}echo $_SERVER['REQUEST_URI'];{/php}" style="text-transform: uppercase; border-top: none">{$lang.view}</a>
			</div>
			{/if}

			{if $header.active == 'edit'}
			<div class="channelnavi">
				<a href="{$header.edit}" style="text-transform: uppercase; border-top: none">{$lang.edit}</a>
			</div>
			{/if}

			<div class="channelnavi">
				<a href="{$header.browse}" style="text-transform: uppercase; border-top: none">{$lang.browse}</a>
				{if $filters}
				<a style="text-transform: uppercase;" href="javascript:toggleElementVisibility(document.getElementById('filternavi'));">Filter &#187;</a>
				<div id="filternavi" style="display: none">
					{foreach key=key item=val from=$filters}
						<a  style="text-transform: uppercase;" href='?filter={$key}'>{if $val == "$filter"}>{else}&nbsp;&nbsp;{/if}&nbsp;{$val}</a>
					{/foreach}
					<a style="text-transform: uppercase;" href="{$header.browse}?filter=showtv{if $showtv}&showtv=0{else}&showtv=1{/if}">{if $showtv}>{$lang.disable}{else}&nbsp;&nbsp;{/if}&nbsp;{$lang.tv_episodes}</a>
					{if $owners}
						<div class="channelnavi"><form action="index.php" id="browse" name="browse"><a>{html_options name=owner options=$owners selected=$owner onchange="submit()"}</a></form></div>
					{/if}
				</div>
				{/if}
			</div>

			<div class="channelnavi">
				<a href="{$header.new}" style="text-transform: uppercase; border-top: none">{$lang.n_e_w}</a>
			</div>

			<div class="channelnavi">
				<a href="{$header.trace}" style="text-transform: uppercase; border-top: none">{$lang.imdbbrowser}</a>
			</div>
			
			{if $header.contrib}
			<div class="channelnavi">
				<a href="{$header.contrib}" style="text-transform: uppercase; border-top: none">{$lang.contrib}</a>
			</div>
			{/if}

			<div class="channelnavi">
				<a href="{$header.borrow}" style="text-transform: uppercase; border-top: none">{$lang.borrow}</a>
			</div>

			<div class="channelnavi">
				<a href="{$header.setup}" style="text-transform: uppercase; border-top: none">{$lang.setup}</a>
			</div>

			{if $header.profile}
			<div class="channelnavi">
				<a href="{$header.profile}" style="text-transform: uppercase; border-top: none">{$lang.profile}</a>
			</div>
			{/if}

			{if $header.login}
			<div class="channelnavi">
				<a href="{$header.login}" style="text-transform: uppercase; border-top: none">{if $loggedin}{$lang.logout}{else}{$lang.login}{/if}</a>
			</div>
			{/if}

			<div id="communitybox">
			<a href="{$header.stats}" style="text-transform: uppercase;"><strong>VideoDB {$lang.statistics}</strong></a><br />

			{php}
				$result = runSQL('SELECT count(*) AS count FROM '.TBL_DATA);
				echo $result[0]['count'];
			{/php} Movies<br/>

			{php}
				$result = runSQL('SELECT count(*) AS count FROM '.TBL_DATA.' WHERE istv = 1');
				echo $result[0]['count'];
			{/php} {$lang.tv_episodes}<br/>
<!--
			<a  style="text-transform: uppercase;" href="{$header.stats}">{$lang.statistics}</a>
-->
			</div>
		</div>
	</td>

	<td style="width: 16px" valign="top">
		<div style="width: 10px">&nbsp;</div>
	</td>

	<td style="width: 100%" valign="top" class="tdcontent">
