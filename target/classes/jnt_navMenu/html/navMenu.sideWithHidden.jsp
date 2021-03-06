<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<c:set var="homeNode" value="${renderContext.site.home.path}"/>
<c:set var="pagePath" value="${fn:substringAfter(renderContext.mainResource.node.path,homeNode)}"/>
<c:set var="paths" value="${fn:split(pagePath,'/')}"/>
<c:set var="startlevel" value="${currentNode.properties['j:startLevel'].string}"/>

<jcr:nodeProperty name="j:styleName" node="${currentNode}" var="styleName"/>

<c:set var="homeChild" value="${jcr:getNodes(renderContext.site.home,'jnt:page')}" />

<c:choose>
    <c:when test="${startlevel<1}">
        <c:set var="rootNode" value="${homeChild[-startlevel]}" />
    </c:when>
    <c:otherwise>
        <jcr:node var="rootNode" path="${homeNode}/${paths[0]}"/>
    </c:otherwise>
</c:choose>

<script type="text/javascript">
    $(document).ready(function () {
        $("#${currentNode.identifier} li > a").each(function (i, el) {
            var $el = $(el);
            var iconClass = "";
            if ($el.parent("li").hasClass("lvl0")) {
                iconClass = "fa fa-chevron-right";
            } else if ($el.parent("li").hasClass("lvl1")) {
                iconClass = "fa fa-caret-right";
            } else {
                return;
            }
            var newContent = "<i class='" + iconClass + "'></i> " + $el.text();
            $el.html(newContent);
        });
    })
</script>

<c:if test="${rootNode.path != renderContext.site.home.path}">
    <template:addCacheDependency path="${renderContext.mainResource.node.parent.path}"/>
    <template:addCacheDependency path="${rootNode}"/>

  <ul class="nav nav-list ${styleName.string}" id="${currentNode.identifier}">
        <c:url var="rootUrl" value="${url.base}${rootNode.path}.html"/>
        <li class="nav-header"><a href="${rootUrl}" title="${rootNode.displayableName}">${rootNode.displayableName}</a>
        </li>
        <c:forEach items="${jcr:getChildrenOfType(rootNode, 'jnt:page,jnt:nodeLink,jnt:navMenuText,jnt:externalLink')}"
                   var="menuElement">
            <c:set var="activeClass" value=""/>
            <c:set var="menuElementPath" value="${menuElement.path}/"/>
            <c:if test="${fn:startsWith(renderContext.mainResource.node.path, menuElementPath) || renderContext.mainResource.node.path eq menuElement.path}">
                <c:set var="activeClass">active</c:set>
            </c:if>
            <c:choose>
                <c:when test="${jcr:isNodeType(menuElement, 'jnt:navMenuText')}">
                    <li class="divider"></li>
                </c:when>
                <c:otherwise>

                    <%-- START: RVT: Added for to hide hidden menu --%>
                    <c:set var="correctType" value="true"/>
                    <c:if test="${!empty menuElement.properties['j:displayInMenuName']}">
                        <c:set var="correctType" value="false"/>
                        <c:forEach items="${menuElement.properties['j:displayInMenuName']}" var="display">
                            <c:if test="${display.string eq currentNode.name}">
                                <c:set var="correctType" value="${correctType || (display.string eq currentNode.name)}"/>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <%-- END: RVT: Added for to hide hidden menu --%>

                    <c:if test="${correctType}"> <%-- RVT: Test if menu should show up --%>
                        <li class="lvl0 ${activeClass}">
                            <c:choose>
                                <c:when test="${jcr:isNodeType(menuElement, 'jnt:nodeLink,jnt:externalLink')}">
                                    <template:module node="${menuElement}"/>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value="${menuElement.url}" context="/"/>">${menuElement.displayableName}</a>
                                    <template:addCacheDependency path="${menuElement.canonicalPath}"/>
                                </c:otherwise>
                            </c:choose>

                            <c:set var="children" value="${jcr:getChildrenOfType(menuElement, 'jnt:page,jnt:nodeLink,jnt:externalLink')}"/>
                            <c:if test="${not empty activeClass and not empty children}">
                                <ul class="nav nav-list">
                                    <c:forEach items="${children}" var="subMenuElement">

                                        <%-- START: RVT: Added for to hide hidden menu --%>
                                        <c:set var="correctType" value="true"/>
                                        <c:if test="${!empty subMenuElement.properties['j:displayInMenuName']}">
                                            <c:set var="correctType" value="false"/>
                                            <c:forEach items="${subMenuElement.properties['j:displayInMenuName']}" var="display">
                                                <c:if test="${display.string eq currentNode.name}">
                                                    <c:set var="correctType" value="${correctType || (display.string eq currentNode.name)}"/>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        <%-- END: RVT: Added for to hide hidden menu --%>

                                        <c:if test="${correctType}"> <%-- RVT: Test if menu should show up --%>
                                            <c:set var="subActiveClass" value=""/>
                                            <c:set var="subMenuElementPath" value="${subMenuElement.path}/"/>
                                            <c:if test="${fn:startsWith(renderContext.mainResource.node.path, subMenuElementPath) || renderContext.mainResource.node.path eq subMenuElement.path}">
                                                <c:set var="subActiveClass">active</c:set>
                                            </c:if>

                                            <li class="lvl1 ${subActiveClass}">
                                                <c:choose>
                                                    <c:when test="${jcr:isNodeType(subMenuElement, 'jnt:nodeLink,jnt:externalLink')}">
                                                        <template:module node="${subMenuElement}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="<c:url value="${subMenuElement.url}" context="/"/>">${subMenuElement.displayableName}</a>
                                                        <template:addCacheDependency path="${subMenuElement.canonicalPath}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </li>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </ul>
</c:if>
