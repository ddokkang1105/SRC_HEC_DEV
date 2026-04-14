package xbolt.link.sso.ms.authservlets;

//Copyright (c) Microsoft Corporation. All rights reserved.
//Licensed under the MIT License.

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xbolt.link.sso.ms.helpers.AuthException;
import xbolt.link.sso.ms.helpers.AuthHelper;
import xbolt.link.sso.ms.helpers.Config;
import xbolt.link.sso.ms.helpers.IdentityContextAdapterServlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
* This class defines the endpoint for processing the redirect from AAD MSAL
* Java apps using this sample's paradigm will require this.
*/
@WebServlet(name = "AADRedirectServlet", urlPatterns = "/auth/redirect")
public class AADRedirectServlet extends HttpServlet {
 private static Logger logger = Logger.getLogger(AADRedirectServlet.class.getName());

 @Override
 protected void doGet(final HttpServletRequest req, final HttpServletResponse resp)
         throws ServletException, IOException {
     logger.log(Level.FINE, "Request has come with params {0}", req.getQueryString());
     try {
         AuthHelper.processAADCallback(new IdentityContextAdapterServlet(req, resp));
         logger.log(Level.INFO, "redirecting to home page.");
         resp.sendRedirect(Config.REDIRECT_URL);
     } catch (AuthException ex) {
         logger.log(Level.WARNING, ex.getMessage());
         logger.log(Level.WARNING, Arrays.toString(ex.getStackTrace()));
         logger.log(Level.INFO, "redirecting to error page to display auth error to user.");
         resp.sendRedirect(resp.encodeRedirectURL(String.format(req.getContextPath() + "/auth_error_details?details=%s", ex.getMessage())));
     }
 }

}
