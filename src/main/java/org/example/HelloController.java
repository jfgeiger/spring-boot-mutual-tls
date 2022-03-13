package org.example;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

  @GetMapping("hello")
  @PreAuthorize("hasAuthority('ROLE_USER')")
  public String hello() {
    return "Authenticated and authorized!";
  }
}