<%-- 
    Document   : worksfollowing
    Created on : 5 Nov, 2012, 11:53:54 PM
    Author     : varun
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Works following | Wordsmith</title>
        <link rel="icon" href="images/favicon.gif" type="image/x-icon"/>
        <!--[if lt IE 9]>
        <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
         <![endif]-->
        <link rel="shortcut icon" href="images/favicon.gif" type="image/x-icon"/> 
        <link rel="stylesheet" type="text/css" href="css/styles2.css"/>
    </head>
    <body>
        <%@ page import ="java.sql.*" %>
        <%@ page import ="javax.sql.*" %>
        <%
            String userid="";
            if(null==request.getParameter("userid")){}
            else userid=request.getParameter("userid");
            String user_loggedin="";
            if(null==session.getAttribute("username")){}
            else user_loggedin=session.getAttribute("username").toString();
            Class.forName("com.mysql.jdbc.Driver");
            java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wordsmith", "root", "renderman");
            
            PreparedStatement getUser=con.prepareStatement("select * from user where user_id=?");
            getUser.setString(1,user_loggedin);
            ResultSet userinfo_loggedin=getUser.executeQuery();
            
            PreparedStatement prepStmt1 = con.prepareStatement("select * from user where user_id=?");
            prepStmt1.setString(1,userid);
            ResultSet userinfo;
            String firstname="";
            String lastname="";
            //if(!userid.equals(user_loggedin)){
                userinfo = prepStmt1.executeQuery();
                while(userinfo.next()){
                    firstname=userinfo.getString("first_name");
                    lastname=userinfo.getString("last_name");
                }
            //}
            prepStmt1=con.prepareStatement("select count(*) from users_following where user_id_followed=?");
            prepStmt1.setString(1, userid);
            ResultSet rs2=prepStmt1.executeQuery();
            int num_followers=0;
            if(rs2.next())num_followers=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from users_following where user_id_follower=?");
            prepStmt1.setString(1, userid);
            rs2=prepStmt1.executeQuery();
            int num_users_following=0;
            if(rs2.next())num_users_following=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from works_following where user_id=?");
            prepStmt1.setString(1, userid);
            rs2=prepStmt1.executeQuery();
            int num_works_following=0;
            if(rs2.next())num_works_following=rs2.getInt(1);
            
            prepStmt1=con.prepareStatement("select count(*) from work where user_id=?");
            prepStmt1.setString(1, userid);
            rs2=prepStmt1.executeQuery();
            int num_works=0;
            if(rs2.next())num_works=rs2.getInt(1);
        %>
        <div class="bg">

            <!--start container-->
            <div id="container">
                <header>
                    <!--start header-->
                    <!--start menu-->
                    <nav>
                        <ul>
                            <!--start logo-->
                            <a href="home.jsp" style="color: #B22222;font-size: 30px;font-family:calibri;text-decoration:none;">Word</a>
                            <a href="home.jsp" style="color: #606060;font-size: 30px;font-family:calibri;text-decoration:none;">Smith </a>
                            <!--end logo-->
                            <li><a href="Logout">Logout</a></li><li>|</li>
                            <li><a href="profile.jsp?userid=<%=user_loggedin%>">Profile</a></li><li>|</li>
                            <li><a href="works.jsp?userid=<%=user_loggedin%>">My works</a></li>	<li>|</li>
                            <li><a href="notifications.jsp">Notifications</a></li>	<li>|</li>
                            <li><a href="requests.jsp">Requests</a></li><li>|</li>
                            <li><a href="home.jsp" id="current">Home</a></li>
                            <li id="searchbox" class="searchbox" style="width: 300px;"> <form action="search.jsp" method="get" class="form-wrapper-02"><input type="submit" value="search" id="submit"><input name="query" type="text" id="search" placeholder="Search users, works...">
                                </form></li>
                        </ul>
                    </nav>
                    <!--end menu-->
                    <!--end header-->
                </header>
                <br/>
                <br/>
                <table style="margin-top:15px;">
                    <tr>
                        <td style="width:30%; vertical-align:top;">
                            <div id="wrapper" style="margin-top: 15px;margin-bottom: 0px;"><h1><%=firstname%> <%=lastname%></h1></div>
                            <ul>
                                <li><a href="followers.jsp?userid=<%=userid%>">Followers <%=num_followers%></a></li>
                                <li><a href="following.jsp?userid=<%=userid%>">Users following <%=num_users_following%></a></li>
                                <li><a href="worksfollowing.jsp?userid=<%=userid%>">Works following <%= num_works_following%></a></li>
                                <li><a href="works.jsp?userid=<%=userid%>">Works <%= num_works%></a></li>
                            </ul>
                        </td>
                        <td style="width:70%; padding-left: 20px; padding-right: 20px; pading-bottom: 10px; ">
                            <br/>
        	Below is the list of your followers. Their activity is contantly updated on your home wall. Click on the links to make them unfollow you! or Click on follower's name to go to their profile.
        	<br/><br/>
                            <div id="wrapper"><h1>Works following</h1></div>
                            <section>
        <%
            PreparedStatement prepStmt2 = con.prepareStatement("select work_id from works_following where user_id=?");
            prepStmt2.setString(1,userid);
            ResultSet following=prepStmt2.executeQuery();
            while(following.next()){
                String following_workid=following.getString(1);
                PreparedStatement prepStmt3 = con.prepareStatement("select work_name,user_id from work where work_id=?");
                prepStmt3.setString(1, following_workid);
                ResultSet workinfo=prepStmt3.executeQuery();
                String following_wn="";
                String owner_userid="";
                if(workinfo.next()){
                    following_wn=workinfo.getString(1);
                    owner_userid=workinfo.getString(2);
                }
                PreparedStatement getfollow = con.prepareStatement("select * from works_following where work_id=? and user_id=?");
                getfollow.setString(1, following_workid);
                getfollow.setString(2, user_loggedin);
                ResultSet isFollow = getfollow.executeQuery();
                String button_value = "";
                if (isFollow.next()) {
                    button_value = "Unfollow";
                } else {
                    button_value = "Follow";
                }
        %>
        <form id="link" method="post" action="FollowHandle">
            <a href="work.jsp?workid=<%=following_workid%>" id="follower_name"><%=following_wn%></a>
            <%if(!user_loggedin.equals(owner_userid)){ %>
            <input name="user_or_work" value="work" type="hidden"/><input name="workid" value="<%=following_workid%>" type="hidden"/><input name="action" value="<%=button_value%>" type="hidden"/><input name="asked_page" value="worksfollowing.jsp?userid=<%=userid%>" type="hidden"/><input id="button" type="submit" value="<%=button_value%>"/>
            <% } %>
        </form>
        <%
            }
            con.close();
        %>
        </section>
        </td>
        </tr>
        </table>
	
   </div>
   <!--end container-->
	
   <!--start footer-->
   <footer>
      <div class="container">  
         <div id="FooterTwo"> © 2012 WordSmith team IIT Bombay </div>
      </div>
   </footer>
   <!--end footer-->
   </div>
    </body>
</html>
