{*
  IMDB borow request popup
  $Id: borrowask.tpl,v 1.1 2004/10/21 20:08:20 andig2 Exp $
*}
<?xml version="1.0" encoding="{$lang.encoding}"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$langcode}" lang="{$langcode}" dir="ltr">
<head>
  <title>VideoDB</title>
  <meta http-equiv="Content-Type" content="text/html; charset={$lang.encoding}" />
  <link rel="stylesheet" href="{$style}" type="text/css" />
</head>
<body>

  <script language="JavaScript" type="text/javascript">
    //<![CDATA[
    window.focus()
    //]]>
  </script>
  

  <p>
  {if $success}
    {$lang.msg_borrowaskok}
  {else}
    {$lang.msg_borrowaskfail}
  {/if}
  </p>

  <p align="center">[ <a href="javascript:close()">{$lang.okay}</a> ]</p>
</body>
</html>
