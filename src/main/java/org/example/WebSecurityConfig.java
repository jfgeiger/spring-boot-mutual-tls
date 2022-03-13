package org.example;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.preauth.x509.SubjectDnX509PrincipalExtractor;

@Configuration
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(final HttpSecurity http) throws Exception {
    http.requiresChannel()
        .anyRequest()
        .requiresSecure()
        .and()
        .authorizeRequests()
        .anyRequest()
        .authenticated()
        .and()
        .x509()
        .x509PrincipalExtractor(new SubjectDnX509PrincipalExtractor())
        .userDetailsService(userDetailsService());
  }

  @Bean
  @Override
  public UserDetailsService userDetailsService() {
    return new ExampleUserDetailService();
  }
}