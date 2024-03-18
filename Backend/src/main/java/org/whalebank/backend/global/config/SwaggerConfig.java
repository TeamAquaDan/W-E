package org.whalebank.backend.global.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@OpenAPIDefinition(
    info = @Info(
        title = "WhalE",
        description = "WE API 명세",
        version = "v1"
    )
)
@SecurityScheme(
    name = "Bearer Authentication",
    type = SecuritySchemeType.HTTP,
    bearerFormat = "JWT",
    scheme = "bearer"
)
@Configuration
public class SwaggerConfig {

  // http://localhost:56142/swagger-ui/index.html

//  @Bean
//  public GroupedOpenApi OpenApi() {
//    return GroupedOpenApi.builder()
//        .group("USER API")
//        .pathsToMatch("/api/user")
//        .build();
//  }

  @Bean
  public OpenAPI openAPI() {
    return new OpenAPI()
        .components(new Components())
        .info(new io.swagger.v3.oas.models.info.Info()
            .title("WE API")
            .description("WE API 명세서"));
  }


}
