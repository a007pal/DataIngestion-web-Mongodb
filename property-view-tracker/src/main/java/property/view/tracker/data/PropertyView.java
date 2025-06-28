package property.view.tracker.data;

import io.micronaut.core.annotation.Introspected;
import io.micronaut.serde.annotation.Serdeable;
import lombok.Data;

@Serdeable.Deserializable
@Data
public class PropertyView {
    private String ip;
    private String propertyId;
    private Integer totalViews;
}
