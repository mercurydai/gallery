{*
  Java scripts template for inclusion in page header
  $Id: header_scripts.tpl,v 1.1 2006/03/28 11:49:52 andig2 Exp $
*}
{literal}
    <script language="JavaScript" type="text/javascript">
        var domTT_classPrefix = 'domTTOverlib';
        var domTT_maxWidth = false;

        function returnDataMine(id, title, subtitle, engine)
        {
            parent.document.edi.imdbID.value = id;
            parent.document.edi.engine.value = engine;
            if (!parent.document.edi.title.value)    parent.document.edi.title.value = title;
            if (!parent.document.edi.subtitle.value) parent.document.edi.subtitle.value = subtitle;
            if (parent.document.edi.lookup0.checked) parent.document.edi.lookup1.checked = true;
            //focus();
            //window.close();
        }

        function returnImageMine(imgurl)
        {
            parent.document.edi.imgurl.value = imgurl;
            parent.focus();
            //window.close();
        }
    </script>
{/literal}