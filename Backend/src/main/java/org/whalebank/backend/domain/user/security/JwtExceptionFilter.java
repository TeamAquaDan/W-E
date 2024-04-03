package org.whalebank.backend.domain.user.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.whalebank.backend.global.exception.JwtException;

@Component
public class JwtExceptionFilter extends OncePerRequestFilter {

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
      FilterChain chain) throws ServletException, IOException {
    try {
      chain.doFilter(request, response); // JwtAuthenticationFilter로 이동
    } catch (JwtException ex) {
      // JwtAuthenticationFilter에서 예외 발생하면 바로 setResponse 호출
      setResponse(response, ex.getMessage());
    }
  }

  private void setResponse(HttpServletResponse response, String msg) throws IOException {
    response.setContentType("application/json;charset=UTF-8");
    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    response.getWriter()
        .write("{\"status\":401, \"message\": \"" + msg + "\", \"data\" : \"null\"}");
  }

}
