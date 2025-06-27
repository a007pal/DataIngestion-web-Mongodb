package property.view.tracker;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.PathVariable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
@Controller("/property")
public class HomeController {
    Logger log = LoggerFactory.getLogger(HomeController.class);
    @Get("/{id}")
    public HttpResponse<String> getId(@PathVariable String id) {
        log.info("The property Id : {}",id);
        return HttpResponse.ok(id);
    }
}
