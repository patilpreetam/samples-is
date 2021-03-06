<!--
~ Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
~
~ WSO2 Inc. licenses this file to you under the Apache License,
~ Version 2.0 (the "License"); you may not use this file except
~ in compliance with the License.
~ You may obtain a copy of the License at
~
~    http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing,
~ software distributed under the License is distributed on an
~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~ KIND, either express or implied.  See the License for the
~ specific language governing permissions and limitations
~ under the License.
-->
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.LoggedInSessionBean" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.bean.SSOAgentConfig" %>
<%@ page import="org.wso2.carbon.identity.sso.agent.util.SSOAgentConstants" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Dispatch</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/stylish-portfolio.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<%
    String subjectId = null;
    Map<String, String> saml2SSOAttributes = null;

    final String SAML_SSO_URL = "samlsso";
    final String SAML_LOGOUT_URL = "logout";
    // if web-browser session is there but no session bean set,
    // invalidate session and direct back to login page
    if (request.getSession(false) != null
            && request.getSession(false).getAttribute(SSOAgentConstants.SESSION_BEAN_NAME) == null) {
        request.getSession().invalidate();
%>
<script type="text/javascript">
    location.href = <%=SAML_SSO_URL%>;
</script>
<%
        return;
    }
    SSOAgentConfig ssoAgentConfig = (SSOAgentConfig)getServletContext()
            .getAttribute(SSOAgentConstants.CONFIG_BEAN_NAME);
    LoggedInSessionBean sessionBean = (LoggedInSessionBean) session
            .getAttribute(SSOAgentConstants.SESSION_BEAN_NAME);
    LoggedInSessionBean.AccessTokenResponseBean accessTokenResponseBean = null;
    if(sessionBean != null && sessionBean.getSAML2SSO() != null) {
        subjectId = sessionBean.getSAML2SSO().getSubjectId();
        saml2SSOAttributes = sessionBean.getSAML2SSO().getSubjectAttributes();
        accessTokenResponseBean = sessionBean.getSAML2SSO().getAccessTokenResponseBean();
    } else {
%>
<script type="text/javascript">
    location.href = <%=SAML_SSO_URL%>;
</script>
<%
        return;
    }

%>


<body class="swift">

<nav id="top" class="navbar navbar-inverse navbar-custom-swift">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#"><img src="img/logo.png" height="30"/> Dispatch</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
                <!--<li><button class="btn btn-dark custom-primary-swift btn-login"><strong>Login</strong></button></li>-->
                <li class="dropdown user-name">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img class="img-circle" height="30" width=30" src="img/Admin-icon.jpg"> <span
                            class="user-name"><%=subjectId%><i class="fa fa-chevron-down"></i></span>
                    </a>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href=<%=SAML_LOGOUT_URL%>>Logout</a></li>
                        <li><a href="overview.jsp">Back</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
<!-- About -->
<section id="about" class="about">
    <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center">
                <h2><strong>PickUp Dispatch</strong></h2>
                <p class="lead"><%=subjectId%> User Profile</p>
            </div>
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container -->
</section>
<!--Profile section -->
<section id="allocations" class="services">
    <div class="container">
        <div class="row text-center">
            <div class="col-lg-10 col-lg-offset-1">
                <hr class="small">
                <div class="product-box">
                    <%
                        if(subjectId != null){
                    %>
                    <h6> You are logged in as <%=subjectId%></h6>
                    <%
                        }
                    %>
                    <br>
                    <%
                        if(saml2SSOAttributes != null && !saml2SSOAttributes.isEmpty()) {
                    %>
                    <table class="table table-striped">

                        <thead>
                        <tr>
                            <th>User Claim</th>
                            <th>Value</th>

                        </tr>
                        </thead>
                        <tbody>

                        <%
                            for (Map.Entry<String, String> entry:saml2SSOAttributes.entrySet()) {
                        %>
                        <tr>
                            <td><%=entry.getKey()%></td>
                            <td><%=entry.getValue()%></td>
                        </tr>

                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                    <!-- SAML Bearer grant section -->
                    <%
                        if (subjectId != null) {
                            if(accessTokenResponseBean != null) {
                    %>
                    <div>
                    <h3><b>Your OAuth2 Access Token details</b></h3>
                        <h6>Access Token</h6>
                        <div class="well">
                            <div class="access-token"> <%=accessTokenResponseBean.getAccessToken()%> </div>
                        </div>
                        <br/>
                        <h6 class="token-header">Refress Token</h6>
                        <div class="well">
                            <div class="access-token"> <%=accessTokenResponseBean.getRefreshToken()%></div>
                        </div>
                        <br/>
                    <div>Token Type: <%=accessTokenResponseBean.getTokenType()%> <br/></div>
                    <div>Expiry In: <%=accessTokenResponseBean.getExpiresIn()%> <br/></div>
                    </div>
                    <%
                            } else {
                                if(ssoAgentConfig.isOAuth2SAML2GrantEnabled()){
                    %>
                    <a href="token" class="token-link">Request OAuth2 Access Token</a><br/>
                    <%

                                }
                            }
                        }
                    %>

                </div>
                <!-- /.row (nested) -->
            </div>
            <!-- /.col-lg-10 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container -->
</section>

<!-- Footer section-->
<footer id="footer">
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <a href="http://wso2.com/" target="_blank"><img src="img/wso2logo.svg" height="20"/></a>
                <p>Copyright &copy; <a href="http://wso2.com/" target="_blank">WSO2</a> 2018</p>
            </div>
        </div>
    </div>
</footer>

<!-- jQuery -->
<script src="js/jquery.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="js/bootstrap.min.js"></script>

</body>
</html>
