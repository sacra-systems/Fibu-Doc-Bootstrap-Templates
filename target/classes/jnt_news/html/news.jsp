<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="newsImage" type="org.jahia.services.content.JCRPropertyWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<bootstrap:addCSS/>
<template:addResources type="css" resources="bootstrapComponents.css"/>

<c:if test="${!empty jcr:getParentOfType(renderContext.mainResource.node, 'jnt:page')}">
    <c:url value='${url.base}${jcr:getParentOfType(renderContext.mainResource.node, "jnt:page").path}.html' var="action"/>
</c:if>
<c:if test="${empty jcr:getParentOfType(renderContext.mainResource.node, 'jnt:page')}">
    <c:set var="action">javascript:history.back()</c:set>
</c:if>

<jcr:nodeProperty node="${currentNode}" name="jcr:title" var="title"/>
<c:set var="newsTitleEscaped" value="${not empty title ? fn:escapeXml(title.string) : ''}"/>

<jcr:nodeProperty node="${currentNode}" name="desc" var="newsDesc"/>

<jcr:nodeProperty node="${currentNode}" name="imageTitle" var="imageTitle"/>


<jcr:nodeProperty node="${currentNode}" name="jcr:createdBy" var="createdBy"/>
<c:set var="currentUser" value="${user:lookupUser(createdBy.string)}"/>

<jcr:nodeProperty node="${currentNode}" name="date" var="newsDate"/>
<fmt:formatDate value="${newsDate.time}" pattern="MMMM" var="newsMonth"/>
<fmt:formatDate value="${newsDate.time}" pattern="d" var="newsDay"/>
<fmt:formatDate value="${newsDate.time}" pattern="yyyy" var="newsYear"/>


<jcr:nodeProperty var="image" node="${currentNode}" name="image"/>
<c:url value='${url.base}${currentNode.path}.html' var="linkUrl" />

<article class="clearfix">
        
    <div class="media-body">
        <h2 class="media-heading"><a href="${linkUrl}">${title.string}</a></h2>
      
        <span >${newsDay}. ${newsMonth}&nbsp;${newsYear}</span>
        
        <c:if test="${! empty image}">          
               <a href="<c:url value="${image.node.url}" context="/"/>" data-lightbox="photoGallery" data-title="${imageTitle.string}"><img class="img-responsive newsListImage" src="<c:url value="${image.node.url}" context="/"/>" alt="${image.node.displayableName}"></a>          
        </c:if>
        
      
        <%-- <p>${functions:abbreviate(functions:removeHtmlTags(newsDesc.string),500,550,mehr)} </p> --%>
 
      <c:set var="key1" value="*hwl*"/>
      <c:set var="key2" value="*kwl*"/>
  
      <c:set var="mehr" value="... <a href=\"${linkUrl}\">weiterlesen &rarr;</a>"/>
      
       <c:choose>
         <c:when test="${fn:contains(newsDesc.string, key1) }">
           <c:set var="position" value="${fn:indexOf(newsDesc.string, key1)}" />
           <p>${fn:substring(newsDesc.string, 0, position)}${mehr}</p> 
         </c:when>
         
         <c:when test="${fn:contains(newsDesc.string, key2) }">
           <p>${fn:replace(newsDesc.string, key2, '')}</p> 
         </c:when>
         
         <c:otherwise>            
            <p>${functions:abbreviate(newsDesc.string,700,750,mehr)} </p>
         </c:otherwise>
       </c:choose>
      
      <div class="share-buttons">
        <div class="mail">
          <a href="mailto:emailadresse?subject=Interessanter%20Artikel&amp;body=Habe%20einen%20interessanten%20Artikel%20auf%20der%20Website%20der%20Pfarrei%20Heiliger%20Martin%20Kaiserslautern%20gefunden%3A%0A%0Ahttps%3A%2F%2Fheiliger-martin-kaiserslautern.de${linkUrl}%0A%0A"><img  
          class="mailImg" src="/files/live/sites/hlmartin/files/bootstrap/img/per-email-share-button.png" alt="Link zum Artikel per E-Mail versenden" width="87" height="20"/></a> 
        </div>
        <div class="fb-share-button" data-href="${linkUrl}" data-layout="button_count"></div>
      </div>

    </div>
</article>