package org.whalebank.backend.global.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@OpenAPIDefinition(
    info = @Info(
        title = "WhalE",
        description = "WE API 명세",
        version = "v1"
    )
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
    SecurityRequirement securityRequirement = new SecurityRequirement().addList("JWT");
    Components components = new Components()
        .addSecuritySchemes("JWT", new SecurityScheme()
            .name("JWT")
            .type(SecurityScheme.Type.HTTP)
            .scheme("Bearer")
            .bearerFormat("JWT"));

    return new OpenAPI()
        .addSecurityItem(securityRequirement)
        .components(components)
        .info(new io.swagger.v3.oas.models.info.Info()
            .title("WE API")
            .description("WE API 명세서"));
  }


}
