/*
package xbolt.cmm.framework.util;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Map;

*/
/**
 * MIP API 호출용 간단 유틸.
 * - POST JSON 요청
 * - 응답 JSON을 JSONObject로 반환
 * - 호출 실패 시 Exception throw
 *//*

public class RestTemplateUtil {

    private static RestTemplate restTemplate = new RestTemplate();

    public static <T> T restTemplateWithPostMethod(String apiUrl, Map<String,Object> body, ParameterizedTypeReference<T> typeRef) throws Exception {

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(MediaType.parseMediaTypes("application/json"));

        HttpEntity<Map<String,Object>> requestEntity = new HttpEntity<>(body, headers);

        ResponseEntity<T> response = restTemplate.exchange(
                apiUrl,
                HttpMethod.POST,
                requestEntity,
                typeRef
        );

        if (!response.getStatusCode().is2xxSuccessful()) {
            throw new RuntimeException("HTTP error code : "
                    + response.getStatusCodeValue()
                    + " url: " + apiUrl
                    + " body: " + response.getBody());
        }

        return response.getBody();
    }


    public static <T> T restTemplateWithGetMethod(String apiUrl, Map<String,Object> body, ParameterizedTypeReference<T> typeRef) throws Exception {

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(MediaType.parseMediaTypes("application/json"));

        UriComponentsBuilder uriComponentsBuilder = UriComponentsBuilder.fromHttpUrl(apiUrl);
        if(!body.isEmpty()) body.forEach((k,v) ->{
            if(v != null) uriComponentsBuilder.queryParam(k,v);
        });

        HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

        ResponseEntity<T> response = restTemplate.exchange(
                uriComponentsBuilder.toUriString(),
                HttpMethod.GET,
                requestEntity,
                typeRef
        );

        if (!response.getStatusCode().is2xxSuccessful()) {
            throw new RuntimeException("HTTP error code : "
                    + response.getStatusCodeValue()
                    + " url: " + apiUrl
                    + " body: " + response.getBody());
        }

        return response.getBody();
    }

}*/
