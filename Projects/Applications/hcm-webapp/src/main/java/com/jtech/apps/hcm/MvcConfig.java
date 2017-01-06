package com.jtech.apps.hcm;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
public class MvcConfig extends WebMvcConfigurerAdapter {
	
	@Value("${database.url}")
	private String url;
	@Value("${database.username}")
	private String username;
	@Value("${database.password}")
	private String password;
	
	
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
    	registry.addViewController("/login").setViewName("login");
        registry.addViewController("/console").setViewName("console");
        registry.addViewController("/register").setViewName("register"); 
        registry.addViewController("/myaccount").setViewName("myaccount"); 
        registry.addViewController("/contact").setViewName("contact"); 
        registry.addRedirectViewController("/","console");
        registry.addViewController("/403").setViewName("403");
    }
    @Bean(name = "dataSource")
 public DriverManagerDataSource dataSource() {
     DriverManagerDataSource driverManagerDataSource = new DriverManagerDataSource();
     driverManagerDataSource.setDriverClassName("com.mysql.jdbc.Driver");
     driverManagerDataSource.setUrl(url);
     driverManagerDataSource.setUsername(username);
     driverManagerDataSource.setPassword(password);
 	 
     return driverManagerDataSource;
 }
    @Bean
 public InternalResourceViewResolver viewResolver() {
  InternalResourceViewResolver resolver = new InternalResourceViewResolver();
  resolver.setPrefix("/WEB-INF/jsp/");
  resolver.setSuffix(".jsp");
  return resolver;
 }     
}