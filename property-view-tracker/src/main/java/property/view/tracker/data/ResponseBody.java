package property.view.tracker.data;

import io.micronaut.serde.annotation.Serdeable;
import lombok.Builder;
import lombok.Getter;

@Serdeable.Serializable
@Getter
@Builder
public class ResponseBody {
    private String status;
    private String propertyId;
}
