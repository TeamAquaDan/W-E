package org.whalebank.backend.global.config;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import java.util.List;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.whalebank.backend.domain.user.Role;
import org.whalebank.backend.domain.user.security.JwtAuthenticationFilter;
import org.whalebank.backend.domain.user.security.JwtExceptionFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

  private final JwtAuthenticationFilter authenticationFilter;
  private final JwtExceptionFilter jwtExceptionFilter;

  @Bean
  public BCryptPasswordEncoder bCryptPasswordEncoder() {
    return new BCryptPasswordEncoder();
  }

  @Bean
  public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration)
      throws Exception {
    return configuration.getAuthenticationManager();
  }

  @Bean
  public WebSecurityCustomizer webSecurityCustomizer() {
    return (web) -> web.ignoring()
        .requestMatchers("/api/auth/signup", "/api/auth/login", "/api/auth/reissue")
        .requestMatchers(
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/configuration/ui",
            "/configuration/security",
            "/v3/api-docs/**",
            "swagger-resources",
            "/swagger-resources/**",
            "/webjars/**"
        );
  }

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    // csrf disable
    http
        .sessionManagement(
            session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .csrf(AbstractHttpConfigurer::disable)
        .cors((cors) -> cors.configurationSource(corsConfigurationSource()))
        .formLogin(AbstractHttpConfigurer::disable)
        .httpBasic(AbstractHttpConfigurer::disable)
        .authorizeHttpRequests(auth -> auth
                .requestMatchers("/swagger", "/swagger-ui.html", "/swagger-ui/**", "/api-docs",
                    "/api-docs/**", "/v3/api-docs/**")
                .permitAll()
                .requestMatchers("/api/auth/signup", "/api/auth/login", "/api/auth/reissue")
                .permitAll()
//                .requestMatchers("/api/goal", "/api/goal/**").hasRole(Role.CHILD.toString())
//                .requestMatchers
                //.requestMatchers("/api/hello").hasRole(Role.ADULT.toString())
                .anyRequest()
                .authenticated()
        )
        .addFilterBefore(authenticationFilter, UsernamePasswordAuthenticationFilter.class)
        .addFilterBefore(jwtExceptionFilter, authenticationFilter.getClass())
        .exceptionHandling(handler ->
            handler.accessDeniedHandler(accessDeniedHandler())
        );

    return http.build();
  }

  @Bean
  public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration config = new CorsConfiguration();

    config.setAllowCredentials(true);
    config.setAllowedOrigins(List.of("*"));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
    config.setAllowedHeaders(List.of("*"));
    config.setExposedHeaders(List.of("*"));

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", config);
    return source;
  }

  @Bean
  public AccessDeniedHandler accessDeniedHandler() {
    return (request, response, accessDeniedException) -> {

      response.setContentType("application/json;charset=UTF-8");
      response.setStatus(HttpServletResponse.SC_FORBIDDEN);
      response.getWriter()
          .write("{\"status\":403, \"message\": \"" + "접근 권한이 없습니다" + "\", \"data\" : \"null\"}");

    };
  }

}
