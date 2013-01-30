{*
  This is the footer which is displayed on bottom of every page
  $Id: footer.tpl,v 1.10 2008/10/19 10:45:28 andig2 Exp $
*}

{$DEBUG}

<table width="90%" class="tablefooter">
<tr valign="top">
	<td width="30%"><a href="#top"><img src="images/top.gif" border="0" alt=""/></a></td>
	<td style="text-align:center" width="30%" nowrap="nowrap">
		<span class="version">
		{if $pageno && $maxpageno}

			{if $pageno != 1}<a href="?pageno={$pageno-1}">[<<]</a>{/if}
			{$lang.page} {$pageno} {$lang.of} {$maxpageno}

			{if $pageno != $maxpageno}<a href="?pageno={$pageno+1}">[>>]</a>{/if}&nbsp;{$lang.of}
		{/if}
		<span id="count">{$totalresults}</span> {$lang.records}.
		</span>
	</td>

	<td align="right" style="text-align:right" width="30%" nowrap="nowrap">

		{if $pdf}
			&nbsp;<a href="{$pdf}export=pdf&ext=.pdf" target="_blank"><img src="images/pdfexport.png" border="0" style="float:right"/></a>
		{/if}
		{if $xls}
			&nbsp;<a href="{$xls}export=xls&ext=.xls" target="_blank"><img src="images/xlsexport.png" border="0" style="float:right"/></a>
		{/if}
		{if $xml}
			&nbsp;<a href="{$xml}export=xml" target="_blank"><img src="images/xmlexport.png" border="0" style="float:right"/></a>
		{/if}
		{if $rss}
			&nbsp;<a href="{$rss}export=rss" target="_blank"><img src="images/rssexport.png" border="0" style="float:right"/></a>
		{/if}
		<span class="version"><a href="http://www.videodb.net">v.{$version|strip}</a></span>

		{if $loggedin}
		<span class="version">- {$lang.loggedinas} {$loggedin}</span>
		{/if}

	</td>
</tr>
</table>

{*Table from Header*}
</td>
</tr>
</table>
</body>
</html>
