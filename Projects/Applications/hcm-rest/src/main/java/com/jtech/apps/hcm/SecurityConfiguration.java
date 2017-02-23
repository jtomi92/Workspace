package com.jtech.apps.hcm;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

  @Autowired
  DataSource dataSource;

  @Autowired
  public void configureGlobalSecurity(AuthenticationManagerBuilder auth) throws Exception {
    auth.inMemoryAuthentication().withUser("jtechWebappHAXX").password("Psmc??.asdl123EW//").roles("ADMIN");
    auth.inMemoryAuthentication().withUser("jtechDeviceHAXX").password("Psmc??.asdl123EW//").roles("ADMIN");
    auth.jdbcAuthentication().dataSource(dataSource).passwordEncoder(new BCryptPasswordEncoder())
            .usersByUsernameQuery("SELECT USER_NAME,USER_PASSWORD, ENABLED FROM USER_PROFILES WHERE ENABLED='Y' AND USER_NAME=?")
            .authoritiesByUsernameQuery("SELECT UP.USER_NAME, G.GROUP_NAME FROM USER_PROFILES UP, GROUPS G WHERE UP.GROUP_ID = G.GROUP_ID AND UP.USER_NAME=?");
  }

  @Override
  protected void configure(HttpSecurity http) throws Exception {

    http.csrf().disable().authorizeRequests().anyRequest().authenticated().and().httpBasic().authenticationEntryPoint(getBasicAuthEntryPoint()).and().sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS);// We don't need sessions to be
                                                                    // created.
  }

  @Bean
  public CustomBasicAuthenticationEntryPoint getBasicAuthEntryPoint() {
    return new CustomBasicAuthenticationEntryPoint();
  }

  /* To allow Pre-flight [OPTIONS] request from browser */
  @Override
  public void configure(WebSecurity web) throws Exception {
    web.ignoring().antMatchers(HttpMethod.OPTIONS, "/**");
  }
}
