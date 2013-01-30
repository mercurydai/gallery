{*
  This is the footer which is displayed on bottom of every page
  $Id: footer.tpl,v 1.10 2008/10/19 10:45:28 andig2 Exp $
*}

{$DEBUG}
</td></tr></table>
</div>
</div>

	<div id="footer">
		<p class="footer-links">
			<a href="{$header.help}">{$lang.help}</a>
			&nbsp;
			<a href="http://www.videodb.net">about VideoDB</a>
			&nbsp;
			{if $loggedin}
				<span class="footer-links">{$lang.loggedinas} {$loggedin}</span>
			{/if}

			{if $totalresults}
				<span class="footer-links">
				{if $pageno && $maxpageno}
					{if $pageno != 1}<a href="?pageno={$pageno-1}">&#171;</a>{/if}Page {$pageno} of {$maxpageno}
					{if $pageno != $maxpageno}<a href="?pageno={$pageno+1}">&#187;</a>{/if}
					&nbsp;
				{/if}
				<span id="count">{$totalresults}</span> {$lang.records}.
				</span>
			{/if}
			<a href="http://www.videodb.net" class="splitbrain">v.{$version|strip}</a>
		</p>
	</div>

	<div id="copyright">
		&copy; All trademarks and copyrights are owned by their respective owners
	</div>

</body>
</html>
