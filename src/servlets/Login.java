package servlets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import dao.UserDAO;
import entities.AppEntities.User;

@WebServlet("/Login")
public class Login extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("error_page.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        // User is already logged in
        if (session.getAttribute("user") != null) {
            response.sendRedirect("error_page.jsp");
            return;
        }

        UserDAO dao = new UserDAO(true);

        // Get user if user exists
        User user = dao.getUser(username,password);

        // User exists
        if (user != null){

            Integer is_validated = user.getValidated();

            // User is not validated (Don't allow login)
            if (is_validated == 0){
                request.setAttribute("login-error","Ο λογαριασμός σας δεν έχει ενεργοποιηθεί. Ευχαριστούμε για την υπομονή σας!");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response);
            }
            // User is validated
            else {
                session.setAttribute("user", user);

                if(user.getRole()==0)
                    response.sendRedirect("adminpanel.jsp");
                else
                    response.sendRedirect("index.jsp");
            }
        }
        // User does not exist
        else{
            request.setAttribute("login-error","Λάθος εισαγωγή στοιχειών. Ξαναπροσπαθήστε.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
