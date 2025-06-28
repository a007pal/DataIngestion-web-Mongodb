package property.view.tracker.filter;

import io.micronaut.http.HttpRequest;
import io.micronaut.http.MutableHttpResponse;
import io.micronaut.http.annotation.Filter;
import io.micronaut.http.filter.HttpServerFilter;
import io.micronaut.http.filter.ServerFilterChain;
import org.reactivestreams.Publisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Filter("/**")
public class RequestLoggingFilter implements HttpServerFilter {

    private static final Logger LOG = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    public Publisher<MutableHttpResponse<?>> doFilter(HttpRequest<?> request, ServerFilterChain chain) {
        LOG.info("➡️ Request Path: {}", request.getPath());
        LOG.info("➡️ HTTP Method: {}", request.getMethod());
        LOG.info("➡️ Headers: {}", request.getHeaders().asMap());

        // Body log only for POST/PUT (optional)
        if (request.getBody().isPresent()) {
            request.getBody().ifPresent(body -> LOG.info("➡️ Body: {}", body.toString()));
        }
        LOG.info("Complete Request {}", request);

        return chain.proceed(request);
    }
}
