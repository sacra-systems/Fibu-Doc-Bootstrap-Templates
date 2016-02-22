<!DOCTYPE html>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<c:url value='${url.base}${renderContext.mainResource.node.path}.html' var="linkUrl" />
<jcr:nodeProperty node="${renderContext.mainResource.node}" name="jcr:title" var="title"/>
<jcr:nodeProperty node="${renderContext.mainResource.node}" name="image" var="image" />
<jcr:nodeProperty node="${renderContext.mainResource.node}" name="desc" var="desc"/>
<c:set var="descEscaped" value="${functions:removeHtmlTags(desc.string)}" />



<html lang="${renderContext.mainResourceLocale.language}">

<head>
    <meta charset="utf-8">

  <title>${fn:escapeXml(renderContext.mainResource.node.displayableName)}</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <%-- Modernizr --%>
    <template:addResources type="javascript" resources="modernizr.js"/>

    <%-- google-code-prettify --%>
    <template:addResources type="css" resources="prettify.css"/>
    <template:addResources type="javascript" resources="prettify.js,lang-css.js,"/>

    <%-- HTML5 shim, for IE6-8 support of HTML5 elements --%>
    <template:addResources type="javascript" resources="html5shiv.js" condition="if lt IE 9"/>

    <%-- font-awesome icons --%>
    <template:addResources type="css" resources="font-awesome.css"/>
    

    <%-- Fav and touch icons --%>
    <link rel="shortcut icon" href="/files/live/sites/hlmartin/files/bootstrap/img/favicon.ico" type="image/vnd.microsoft.icon" />
  
    <link href="/files/live/sites/hlmartin/files/lightbox2/css/lightbox.css" rel="stylesheet">
    <link href="/files/live/sites/hlmartin/files/bootstrap/shariff/shariff.min.css" rel="stylesheet">
    
   
    <link rel="apple-touch-icon" href="<c:url value='${url.currentModule}/img/icon/icon-iphone.png'/>"/>
    <link rel="apple-touch-icon" sizes="72x72" href="<c:url value='${url.currentModule}/img/icon/icon-ipad.png'/>"/>
    <link rel="apple-touch-icon" sizes="114x114"
          href="<c:url value='${url.currentModule}/img/icon/jahia-icon-iphone4.png'/>"/>


    <%--tablet and iphone meta--%>
    <meta name='HandheldFriendly' content='True'/>
    <meta name="viewport"
          content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

    <%-- Google fonts--%>
    <c:set var="s" value="${renderContext.request.scheme=='https'?'s':''}"/>
    <link href='http${s}://fonts.googleapis.com/css?family=Scada' rel='stylesheet' type='text/css'>
  
    
   
  
    <meta property="og:title"         content="${title.string}" />
    <meta property="og:type"          content="website" />
    <meta property="og:locale"        content="de_DE" />
    <meta property="og:url"           content="https://heiliger-martin-kaiserslautern.de${linkUrl}" />
    <meta property="og:site_name"     content="Heiliger Martin Kaiserslautern" />
    <c:if test="${! empty image}">
    <meta property="og:image"         content="https://heiliger-martin-kaiserslautern.de${image.node.url}" />
    </c:if>
    <c:if test="${! empty desc}">      
    <meta property="og:description"   content="${descEscaped}" />
    </c:if>
    
</head>

<body>

  
<%-- Les styles old--%>
<template:addResources type="css" resources="jahia-old-responsive.css,jahia-old.css"/>

<template:addResources type="javascript" resources="jquery.min.js" />
<bootstrap:addThemeJS/>
<bootstrap:addCSS/>

<div class="wrapper bodywrapper">

    <header>

        <div id="header-top" class="header-top-content">
            <div class="container-fluid">
                <div class="row-fluid">
                    <div class="span12">
                        <template:area path="bootstrap-header"/>
                    </div>
                </div>
            </div>
        </div>

        <nav id="nav">
            <template:area path="bootstrap-nav"/>
        </nav>

    </header>
    
    <div id="xp"> </div>

    <section id="content" class="content-section">
        <template:area path="pagecontent"/>
    </section>

        <jcr:nodeProperty node="${renderContext.site}" name="displayFooterLinks" var="displayLinks"/>
        <c:set var="displayFooterLinks" value="false"/>
        <c:choose>
            <c:when test="${displayLinks.string == 'home' and renderContext.site.home.path == renderContext.mainResource.node.path}">
                <c:set var="displayFooterLinks" value="true"/>
            </c:when>
            <c:when test="${displayLinks.string == 'all'}">
                <c:set var="displayFooterLinks" value="true"/>
            </c:when>
        </c:choose>
        <c:if test="${displayFooterLinks}">

    <section class="footer-links" id="footer-links">
        <div class="container-fluid">
            <div class="row-fluid">
                <c:forEach items="${jcr:getChildrenOfType(renderContext.site.home, 'jnt:page')}" var="page">
                    <div class="span2"><h4>${page.displayableName}</h4>
                        <ul class="fa-ul">
                            <c:forEach items="${jcr:getChildrenOfType(page, 'jnt:page')}" var="childpage">
                                <li><i class="fa-li fa fa-angle-right"></i>
                                    <a href="<c:url value="${childpage.url}" context="/"/>" title="${childpage.displayableName}">${childpage.displayableName}</a>
                                </li>
                            </c:forEach>
                        </ul><div class="clear"></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section><div class="clear"></div>
    </c:if>
    <footer>
        <section id="copyright" class="copyright">
                <template:area path="footer"/>
        </section>
    </footer>

</div>

<c:if test="${renderContext.editMode}">
    <template:addResources type="css" resources="edit.css" />
</c:if>


<script src="/files/live/sites/hlmartin/files/lightbox2/js/lightbox.js"></script>
<script src="/files/live/sites/hlmartin/files/bootstrap/shariff/shariff.min.js"></script>  

  
<!-- Piwik -->
<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="//heiliger-martin-kaiserslautern.de/piwik/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', 1]);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
  })();
</script>
<noscript><p><img src="//heiliger-martin-kaiserslautern.de/piwik/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript>
<!-- End Piwik Code -->
  
</body>
</html>
