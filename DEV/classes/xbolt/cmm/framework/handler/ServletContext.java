package xbolt.cmm.framework.handler;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ServletContext implements ServletContextListener {
	@Override
	public void contextInitialized(ServletContextEvent sce) {
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		 // Deregister all JDBC drivers
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
            } catch (SQLException e) {
                // Do nothing
            }
        }
	}
}
