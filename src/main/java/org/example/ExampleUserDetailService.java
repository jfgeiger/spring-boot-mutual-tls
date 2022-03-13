package org.example;

import java.text.MessageFormat;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
public class ExampleUserDetailService implements UserDetailsService {

  private static final Logger LOGGER = Logger.getLogger(ExampleUserDetailService.class.getName());

  private static final Function<String, Supplier<UsernameNotFoundException>> USERNAME_NOT_FOUND = (String username) -> () -> new UsernameNotFoundException(
      MessageFormat.format("User {0} not found.", username));

  private static final String CLIENT = "client";

  private static final Map<String, User> USERS = Map.of(CLIENT, new User(CLIENT, "",
      AuthorityUtils.commaSeparatedStringToAuthorityList("ROLE_USER")));

  @Override
  public UserDetails loadUserByUsername(final String username) throws UsernameNotFoundException {
    if (LOGGER.isLoggable(Level.INFO)) {
      LOGGER.info(MessageFormat.format("Authorising user {0}", username));
    }

    return Optional.ofNullable(USERS.get(username))
        .orElseThrow(USERNAME_NOT_FOUND.apply(username));
  }
}