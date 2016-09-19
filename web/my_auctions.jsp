<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entities.User" %>
<%@ page import="entities.Item" %>
<%@ page import="dao.ItemDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%  User sessionUser = (User) request.getSession().getAttribute("user");
    if(sessionUser==null)
        response.sendRedirect("index.jsp");

%>
<script>


    function CountDownTimer(dt, class_name, auction_id)
    {
        var end = new Date(dt);

        var _second = 1000;
        var _minute = _second * 60;
        var _hour = _minute * 60;
        var _day = _hour * 24;
        var timer;

        function showRemaining() {
            var now = new Date();
            var distance = end - now;
            if (distance < 0) {

                clearInterval(timer);
                document.getElementsByClassName(class_name)[0].innerHTML = 'Η Δημοπρασία έληξε!';
//                disableEndedAuction(auction_id);

                return;
            }
            var days = Math.floor(distance / _day);
            var hours = Math.floor((distance % _day) / _hour);
            var minutes = Math.floor((distance % _hour) / _minute);
            var seconds = Math.floor((distance % _minute) / _second);


            if (String(hours).length < 2){
                hours = 0 + String(hours);
            }
            if (String(minutes).length < 2){
                minutes = 0 + String(minutes);
            }
            if (String(seconds).length < 2){
                seconds = 0 + String(seconds);
            }

            var datestr = days + ' days ' +
                    hours + ' hrs ' +
                    minutes + ' mins ' +
                    seconds + ' secs';

            document.getElementsByClassName(class_name)[0].innerHTML = datestr;
        }

        timer = setInterval(showRemaining, 1000);
    }
</script>
<html>
<head>
    <title>Οι Δημοπρασίες Μου</title>

    <!-- Google Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Titillium+Web:400,200,300,700,600' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Roboto+Condensed:400,700,300' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Raleway:400,100' rel='stylesheet' type='text/css'>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/owl.carousel.css">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="css/responsive.css">
    <link rel="stylesheet" href="css/jquery-ui.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">

</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="maincontent-area">
        <div class="zigzag-bottom"></div>
            <div class="container">

                </br><h3>Οι Δημοπρασίες Μου</h3></br>

                <% if (request.getAttribute("auction-creation-success") == "yes") { %>
                    <div class="alert alert-success">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                        <strong>Eπιτυχία! </strong>Η Δημοπρασία σας δημιουργήθηκε!
                    </div>
                <% } %>
                <% if (request.getAttribute("auction-edit-success") == "yes") { %>
                <div class="alert alert-success">
                    <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                    <strong>Eπιτυχία! </strong>Η Δημοπρασία σας τροποποιήθηκε!
                </div>
                <% } %>

                <select id="dropDown">
                    <option value="2">Όλες</option>
                    <option value="1">Δημοσιευμένες</option>
                    <option value="0">Μη Δημοσιευμένες</option>
                    <option value="-1">Ανενεργές</option>
                </select>

                <hr style="border-top: 1px solid #1abc9c">

                <%
                if (sessionUser != null) {
                    String username = sessionUser.getUsername();
                    ItemDAO dao = new ItemDAO(true);

                    // Get the auctions that belong to this user
                    List<Item> userAuctions = dao.getUserAuctions(username);

                    for (int i = 0; i < userAuctions.size(); i++) {%>

                <div class="<%=userAuctions.get(i).getState()%>">

                    <div class="row" >

                        <%--Image Section--%>
                        <div class="col-sm-3 col-xs-3 col-md-3">

                            <%String image = userAuctions.get(i).getImage();

                            // If there is an image uploaded for this item
                            if (image != null) {%>
                                <img class="img-responsive center-block" src="files/<%=image%>" style="height: 200px; width: 200px">
                            <%}
                            // Else use the default image
                            else {%>
                                <img class="img-responsive center-block" src="img/blank.png" style="height: 200px; width: 200px">
                            <%}%>
                        </div>

                        <%--Info Section--%>
                        <div class="col-sm-7 col-xs-7 col-md-7">

                            <table style="table-layout:fixed; word-wrap: break-word;" id="userlist-table" class="table table-hover table-striped table-condensed ">
                                <tbody>
                                <tr>
                                    <th>Τίτλος</th>
                                    <td><%=userAuctions.get(i).getName()%></td>
                                </tr>
                                <tr>
                                    <th>Κατηγορία/ες</th>
                                    <%  List<String> categories = userAuctions.get(i).getCategories();
                                        String total = "";
                                        if (categories != null){
                                            for(int j = 0; j < categories.size(); j++){
                                                if (j == categories.size() - 1)
                                                    total += categories.get(j);
                                                else
                                                    total += categories.get(j) + ",";%>
                                            <%}
                                        }%>
                                    <td><%=total%></td>

                                </tr>
                                <tr>
                                    <th>Τρέχουσα προσφορά</th>
                                    <td><%=userAuctions.get(i).getCurrently()%></td>
                                </tr>
                                <tr>
                                    <th>Τιμή Αγοράς</th>
                                    <%if(userAuctions.get(i).getBuy_price() == null){%>
                                        <td>Δεν έχει οριστεί</td>
                                    <%}else{%>
                                        <td><%=userAuctions.get(i).getBuy_price()%></td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <th>Αρχική Προσφορά</th>
                                    <td><%=userAuctions.get(i).getFirst_bid()%></td>
                                </tr>
                                <tr>
                                    <th>Ημερομηνία/Ώρα Λήξης</th>
                                    <td>
                                        <%
                                            Date end_t = userAuctions.get(i).getEnds();
                                            SimpleDateFormat end_format = new SimpleDateFormat("dd/MM/yyyy hh:mm");
                                            String ended = end_format.format(end_t);
                                        %>
                                        <%=ended%>
                                    </td>
                                </tr>
                                <%--Countdown timer if auction is published--%>
                                <%if (userAuctions.get(i).getState() == 1) {
                                    Date end_time = userAuctions.get(i).getEnds();
                                    SimpleDateFormat endformat = new SimpleDateFormat("MM/dd/yyyy hh:mm");
                                    String end = endformat.format(end_time);

                                    System.out.println("END: " + end);
                                %>
                                    <tr>
                                        <th>Χρόνος που Απομένει</th>
                                        <td>
                                            <div class="countdown-<%=userAuctions.get(i).getId()%>"></div>
                                            <script>
                                                CountDownTimer('<%=end%>', 'countdown-<%=userAuctions.get(i).getId()%>', '<%=userAuctions.get(i).getId()%>');
                                            </script>
                                        </td>
                                    </tr>
                                <%}%>
                                <tr>
                                    <th>Κατάσταση</th>

                                    <% if (userAuctions.get(i).getState() == -1){%>
                                        <td style="color: red">Ανενεργή</td>
                                    <%}else if (userAuctions.get(i).getState() == 0){%>
                                        <td style="color: orange">Μη Δημοσιευμένη</td>
                                    <%}else if (userAuctions.get(i).getState() == 1){%>
                                        <td style="color: green">Δημοσιευμένη</td>
                                    <%}%>

                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <%--Activate Button Section--%>
                        <div class="col-sm-1 col-xs-1 col-md-1">
                            <div class="btn-group btn-group-vertical">
                                <% if (userAuctions.get(i).getState() == -1){%>
                                    <a href="#" class="btn btn-success disabled" role="button">Eνεργοποίηση</a>
                                <%}else if (userAuctions.get(i).getState() == 0){%>
                                    <a href="ActivateAuction?id=<%=userAuctions.get(i).getId()%>" class="btn btn-success" role="button">Eνεργοποίηση</a>
                                <%}else if (userAuctions.get(i).getState() == 1){%>
                                    <a href="#" class="btn btn-success disabled" role="button">Eνεργοποίηση</a>
                                <%}%>
                                <br>

                                <% if (userAuctions.get(i).getState() == -1){%>
                                    <a href="#" class="btn btn-warning disabled" role="button">Τροποποίηση</a>
                                <%}else if (userAuctions.get(i).getState() == 0){%>
                                    <a href="editAuction.jsp?id=<%=userAuctions.get(i).getId()%>" class="btn btn-warning" role="button">Τροποποίηση</a>
                                <%}else if (userAuctions.get(i).getState() == 1 ){
                                    if (userAuctions.get(i).getTotal_offers() == 0){%>
                                        <a href="editAuction.jsp?id=<%=userAuctions.get(i).getId()%>" class="btn btn-warning" role="button">Τροποποίηση</a>
                                    <%}else{%>
                                        <a href="#" class="btn btn-warning disabled" role="button">Τροποποίηση</a>
                                    <%}%>
                                <%}%>
                                <br>

                                <a href="DeleteAuction?id=<%=userAuctions.get(i).getId()%>" onclick="return confirm('Είστε σίγουροι για την διαγραφή της δημοπρασίας?');" class="btn btn-danger" role="button">Διαγραφή</a>
                            </div>

                        </div>
                    </div>

                    <hr style="border-top: 1px solid #1abc9c">
                </div>
                <%}
                }
                %>

                <div class="row">
                    <br>
                    <a href="newauction.jsp" class="btn btn-primary" role="button">Νέα Δημοπρασία</a>
                </div>
            </div>
    </div>


    <jsp:include page="footer.jsp" />


</body>



<!-- jQuery -->
<script src="javascript/jquery-1.10.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<script src="javascript/form.js"></script>
<script src="javascript/bootstrap.min.js"></script>

<!-- jQuery sticky menu -->
<script src="javascript/owl.carousel.min.js"></script>
<script src="javascript/jquery.sticky.js"></script>

<!-- jQuery easing -->
<script src="javascript/jquery.easing.1.3.min.js"></script>

<!-- Main Script -->
<script src="javascript/main.js"></script>

<script type="text/javascript">
    $(document).ready(function() {
        $('#dropDown').change(function () {
            $(this).find("option").each(function () {

                $('.' + this.value).hide();
            });
            $('.' + this.value).show();

            if (this.value == '2')
            {
                $('.' + '0').show();
                $('.' + '1').show();
                $('.' + '-1').show();
            }

        });
    });
</script>


</html>