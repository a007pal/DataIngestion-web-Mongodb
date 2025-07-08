package property.view.tracker.controller;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.annotation.*;
import lombok.extern.slf4j.Slf4j;
import property.view.tracker.data.PropertyView;
import property.view.tracker.data.ResponseBody;

import static property.view.tracker.constant.OperationStatus.SUCCESS;

@Controller("/property")
@Slf4j
public class PropertyViewController {
    @Post("/view")
    public HttpResponse<ResponseBody> produceViewData(@Body PropertyView propertyView){
        log.info("Property Id {}",propertyView.getPropertyId());
        return HttpResponse.ok(ResponseBody.builder()
                        .propertyId(propertyView.getPropertyId())
                        .status(SUCCESS.getStatusName())
                .build());
    }
}
